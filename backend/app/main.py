from __future__ import annotations

import os
import re
import shutil
import subprocess
import tempfile
import threading
import time
from pathlib import Path

from fastapi import FastAPI, File, Form, HTTPException, Request, UploadFile
from fastapi.responses import FileResponse
from starlette.background import BackgroundTask

app = FastAPI(title="Potube Converter API", version="0.2.1")

MAX_UPLOAD_BYTES = int(os.getenv("MAX_UPLOAD_BYTES", str(25 * 1024 * 1024)))
CONVERSION_TIMEOUT_SECONDS = int(os.getenv("CONVERSION_TIMEOUT_SECONDS", "35"))
MAX_DAILY_CONVERSIONS = int(os.getenv("MAX_DAILY_CONVERSIONS", "3"))
RATE_LIMIT_WINDOW_SECONDS = int(os.getenv("RATE_LIMIT_WINDOW_SECONDS", str(24 * 60 * 60)))
MAX_RATE_BUCKETS = int(os.getenv("MAX_RATE_BUCKETS", "5000"))
MAX_FREE_BITRATE = int(os.getenv("MAX_FREE_BITRATE", "192"))

ALLOWED_EXTENSIONS = {
    ".mp3", ".m4a", ".aac", ".wav", ".flac", ".ogg",
    ".mp4", ".mov", ".mkv", ".webm", ".avi", ".m4v",
}
ALLOWED_QUALITIES = {"128", "192", "256", "320"}

_rate_lock = threading.Lock()
_rate_buckets: dict[str, list[float]] = {}


def _safe_stem(filename: str | None) -> str:
    stem = Path(filename or "audio").stem
    cleaned = re.sub(r"[^\w\-. ]+", "", stem, flags=re.UNICODE).strip(" .")
    return cleaned[:100] or "audio"


def _cleanup(path: str) -> None:
    shutil.rmtree(path, ignore_errors=True)


def _client_key(request: Request) -> str:
    forwarded = request.headers.get("x-forwarded-for", "")
    if forwarded:
        return forwarded.split(",", 1)[0].strip() or "unknown"
    if request.client is not None and request.client.host:
        return request.client.host
    return "unknown"


def _prune_rate_buckets_locked(cutoff: float) -> None:
    """Remove expired attempts for every client while the rate lock is held."""
    empty_keys: list[str] = []
    for key, attempts in _rate_buckets.items():
        active = [stamp for stamp in attempts if stamp > cutoff]
        if active:
            _rate_buckets[key] = active
        else:
            empty_keys.append(key)

    for key in empty_keys:
        _rate_buckets.pop(key, None)


def _evict_oldest_rate_bucket_locked(client_key: str) -> None:
    """Keep the in-memory limiter bounded even under many distinct client keys."""
    if client_key in _rate_buckets or len(_rate_buckets) < MAX_RATE_BUCKETS:
        return

    oldest_key = min(
        _rate_buckets,
        key=lambda key: _rate_buckets[key][-1] if _rate_buckets[key] else float("-inf"),
    )
    _rate_buckets.pop(oldest_key, None)


def _consume_rate_limit(client_key: str, now: float | None = None) -> tuple[int, int]:
    """Consume one free conversion and return (remaining, reset_seconds).

    This limiter is intentionally in-memory for the validation MVP. Cloud Run is
    capped to one instance, so it provides useful abuse resistance without
    adding a paid database. The counter can reset when the instance scales to
    zero; the hard cost protections remain the Cloud Run instance cap and the
    project billing limits.
    """
    current = time.time() if now is None else now
    cutoff = current - RATE_LIMIT_WINDOW_SECONDS

    with _rate_lock:
        _prune_rate_buckets_locked(cutoff)
        _evict_oldest_rate_bucket_locked(client_key)

        attempts = list(_rate_buckets.get(client_key, []))
        if len(attempts) >= MAX_DAILY_CONVERSIONS:
            oldest = min(attempts)
            retry_after = max(1, int(RATE_LIMIT_WINDOW_SECONDS - (current - oldest)))
            _rate_buckets[client_key] = attempts
            raise HTTPException(
                status_code=429,
                detail="Hai raggiunto il limite gratuito di conversioni. Riprova più tardi.",
                headers={
                    "Retry-After": str(retry_after),
                    "X-RateLimit-Limit": str(MAX_DAILY_CONVERSIONS),
                    "X-RateLimit-Remaining": "0",
                },
            )

        attempts.append(current)
        _rate_buckets[client_key] = attempts
        remaining = max(0, MAX_DAILY_CONVERSIONS - len(attempts))
        reset_seconds = RATE_LIMIT_WINDOW_SECONDS
        return remaining, reset_seconds


def _reset_rate_limits_for_tests() -> None:
    with _rate_lock:
        _rate_buckets.clear()


@app.middleware("http")
async def add_security_headers(request: Request, call_next):
    response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
    if request.url.path.startswith("/api/"):
        response.headers["Cache-Control"] = "no-store"
    return response


@app.get("/api/health")
def health() -> dict[str, object]:
    return {
        "ok": True,
        "ffmpeg": shutil.which("ffmpeg") is not None,
        "max_upload_mb": round(MAX_UPLOAD_BYTES / 1024 / 1024),
        "conversion_timeout_seconds": CONVERSION_TIMEOUT_SECONDS,
        "max_daily_conversions": MAX_DAILY_CONVERSIONS,
        "max_rate_buckets": MAX_RATE_BUCKETS,
        "max_free_bitrate": MAX_FREE_BITRATE,
    }


@app.post("/api/convert")
async def convert(
    request: Request,
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

    if int(quality) > MAX_FREE_BITRATE:
        raise HTTPException(
            status_code=403,
            detail=f"La versione gratuita supporta fino a {MAX_FREE_BITRATE} kbps.",
        )

    suffix = Path(file.filename or "").suffix.lower()
    if suffix not in ALLOWED_EXTENSIONS:
        raise HTTPException(status_code=415, detail="Formato file non supportato.")

    if shutil.which("ffmpeg") is None:
        raise HTTPException(status_code=503, detail="FFmpeg non disponibile sul server.")

    remaining, reset_seconds = _consume_rate_limit(_client_key(request))

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
            headers={
                "Cache-Control": "no-store",
                "X-RateLimit-Limit": str(MAX_DAILY_CONVERSIONS),
                "X-RateLimit-Remaining": str(remaining),
                "X-RateLimit-Reset": str(reset_seconds),
            },
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
