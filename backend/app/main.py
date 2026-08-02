from __future__ import annotations

import os
import re
import shutil
import subprocess
import tempfile
from pathlib import Path

from fastapi import FastAPI, File, Form, HTTPException, UploadFile
from fastapi.responses import FileResponse
from starlette.background import BackgroundTask

app = FastAPI(title="Potube Converter API", version="0.1.0")

MAX_UPLOAD_BYTES = int(os.getenv("MAX_UPLOAD_BYTES", str(25 * 1024 * 1024)))
CONVERSION_TIMEOUT_SECONDS = int(os.getenv("CONVERSION_TIMEOUT_SECONDS", "50"))
ALLOWED_EXTENSIONS = {
    ".mp3", ".m4a", ".aac", ".wav", ".flac", ".ogg",
    ".mp4", ".mov", ".mkv", ".webm", ".avi", ".m4v",
}
ALLOWED_QUALITIES = {"128", "192", "256", "320"}


def _safe_stem(filename: str | None) -> str:
    stem = Path(filename or "audio").stem
    cleaned = re.sub(r"[^\w\-. ]+", "", stem, flags=re.UNICODE).strip(" .")
    return cleaned[:100] or "audio"


def _cleanup(path: str) -> None:
    shutil.rmtree(path, ignore_errors=True)


@app.get("/api/health")
def health() -> dict[str, object]:
    return {
        "ok": True,
        "ffmpeg": shutil.which("ffmpeg") is not None,
        "max_upload_mb": round(MAX_UPLOAD_BYTES / 1024 / 1024),
    }


@app.post("/api/convert")
async def convert(
    file: UploadFile = File(...),
    quality: str = Form("192"),
    normalize: str | None = Form(None),
    metadata: str | None = Form(None),
    rights_confirmed: str = Form(...),
):
    if rights_confirmed != "yes":
        raise HTTPException(status_code=400, detail="Devi confermare di poter elaborare il file.")

    if quality not in ALLOWED_QUALITIES:
        raise HTTPException(status_code=400, detail="Qualità MP3 non supportata.")

    suffix = Path(file.filename or "").suffix.lower()
    if suffix not in ALLOWED_EXTENSIONS:
        raise HTTPException(status_code=415, detail="Formato file non supportato.")

    if shutil.which("ffmpeg") is None:
        raise HTTPException(status_code=503, detail="FFmpeg non disponibile sul server.")

    temp_dir = tempfile.mkdtemp(prefix="potube-")
    source_path = Path(temp_dir) / f"source{suffix}"
    output_name = f"{_safe_stem(file.filename)}.mp3"
    output_path = Path(temp_dir) / output_name

    total = 0
    try:
        with source_path.open("wb") as destination:
            while chunk := await file.read(1024 * 1024):
                total += len(chunk)
                if total > MAX_UPLOAD_BYTES:
                    raise HTTPException(status_code=413, detail="File troppo grande.")
                destination.write(chunk)

        command = [
            "ffmpeg",
            "-hide_banner",
            "-loglevel", "error",
            "-y",
            "-i", str(source_path),
            "-vn",
            "-codec:a", "libmp3lame",
            "-b:a", f"{quality}k",
        ]

        if normalize == "yes":
            command += ["-af", "loudnorm=I=-16:TP=-1.5:LRA=11"]

        if metadata == "yes":
            command += ["-map_metadata", "0", "-id3v2_version", "3"]
        else:
            command += ["-map_metadata", "-1"]

        command.append(str(output_path))

        try:
            subprocess.run(
                command,
                check=True,
                timeout=CONVERSION_TIMEOUT_SECONDS,
                capture_output=True,
                text=True,
            )
        except subprocess.TimeoutExpired as exc:
            raise HTTPException(status_code=408, detail="Conversione scaduta per timeout.") from exc
        except subprocess.CalledProcessError as exc:
            detail = (exc.stderr or "Errore FFmpeg").strip()[-500:]
            raise HTTPException(status_code=422, detail=f"Conversione non riuscita: {detail}") from exc

        if not output_path.exists() or output_path.stat().st_size == 0:
            raise HTTPException(status_code=422, detail="FFmpeg non ha prodotto un file valido.")

        return FileResponse(
            path=output_path,
            filename=output_name,
            media_type="audio/mpeg",
            background=BackgroundTask(_cleanup, temp_dir),
        )
    except HTTPException:
        _cleanup(temp_dir)
        raise
    except Exception as exc:
        _cleanup(temp_dir)
        raise HTTPException(status_code=500, detail="Errore interno durante la conversione.") from exc
    finally:
        await file.close()
