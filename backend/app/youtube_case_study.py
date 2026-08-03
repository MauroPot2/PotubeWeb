from __future__ import annotations

import hmac
import os
import shutil
import subprocess
import tempfile
from pathlib import Path
from urllib.parse import urlparse

from fastapi import APIRouter, Form, HTTPException, Request
from fastapi.responses import FileResponse
from starlette.background import BackgroundTask

from app.main import _cleanup, _client_key, _consume_rate_limit

router = APIRouter()

CASE_STUDY_KEY = os.getenv("YOUTUBE_CASE_STUDY_KEY", "")
CASE_STUDY_TIMEOUT_SECONDS = int(os.getenv("YOUTUBE_CASE_STUDY_TIMEOUT_SECONDS", "50"))
CASE_STUDY_MAX_DURATION_SECONDS = int(os.getenv("YOUTUBE_CASE_STUDY_MAX_DURATION_SECONDS", "900"))
CASE_STUDY_MAX_SOURCE_MB = int(os.getenv("YOUTUBE_CASE_STUDY_MAX_SOURCE_MB", "25"))
CASE_STUDY_QUALITIES = {"128", "192"}
ALLOWED_YOUTUBE_HOSTS = {
    "youtube.com",
    "www.youtube.com",
    "m.youtube.com",
    "music.youtube.com",
    "youtu.be",
}


def _is_allowed_youtube_url(value: str) -> bool:
    try:
        parsed = urlparse(value.strip())
    except ValueError:
        return False

    return (
        parsed.scheme in {"http", "https"}
        and parsed.hostname in ALLOWED_YOUTUBE_HOSTS
        and parsed.username is None
        and parsed.password is None
    )


@router.post("/api/lab/youtube-audio")
def youtube_audio_case_study(
    request: Request,
    url: str = Form(...),
    quality: str = Form("192"),
    case_study_key: str = Form(...),
    rights_confirmed: str = Form(...),
):
    # The feature is intentionally disabled unless a secret is configured on
    # Cloud Run. The secret must never be committed to the repository.
    if not CASE_STUDY_KEY:
        raise HTTPException(status_code=404, detail="Case study non disponibile.")

    if not hmac.compare_digest(case_study_key, CASE_STUDY_KEY):
        raise HTTPException(status_code=403, detail="Chiave case study non valida.")

    if rights_confirmed != "yes":
        raise HTTPException(
            status_code=400,
            detail="Devi confermare di avere il diritto o il permesso di elaborare il contenuto.",
        )

    if quality not in CASE_STUDY_QUALITIES:
        raise HTTPException(status_code=400, detail="Qualità MP3 non supportata nel case study.")

    clean_url = url.strip()
    if not _is_allowed_youtube_url(clean_url):
        raise HTTPException(status_code=400, detail="Inserisci un URL YouTube valido.")

    yt_dlp_path = shutil.which("yt-dlp")
    if yt_dlp_path is None:
        raise HTTPException(status_code=503, detail="yt-dlp non disponibile sul server.")

    if shutil.which("ffmpeg") is None:
        raise HTTPException(status_code=503, detail="FFmpeg non disponibile sul server.")

    remaining, reset_seconds = _consume_rate_limit(_client_key(request))

    temp_dir = tempfile.mkdtemp(prefix="potube-youtube-lab-")
    output_template = str(Path(temp_dir) / "case-study.%(ext)s")
    output_path = Path(temp_dir) / "case-study.mp3"

    command = [
        yt_dlp_path,
        "--ignore-config",
        "--no-playlist",
        "--max-downloads",
        "1",
        "--match-filter",
        f"!is_live & duration <= {CASE_STUDY_MAX_DURATION_SECONDS}",
        "--max-filesize",
        f"{CASE_STUDY_MAX_SOURCE_MB}M",
        "--socket-timeout",
        "10",
        "--retries",
        "1",
        "--fragment-retries",
        "1",
        "--no-progress",
        "--no-warnings",
        "--no-cache-dir",
        "--force-overwrites",
        "--extract-audio",
        "--audio-format",
        "mp3",
        "--audio-quality",
        f"{quality}K",
        "--output",
        output_template,
        clean_url,
    ]

    try:
        result = subprocess.run(
            command,
            check=False,
            timeout=CASE_STUDY_TIMEOUT_SECONDS,
            capture_output=True,
            text=True,
        )

        if result.returncode != 0:
            detail = (result.stderr or result.stdout or "Download non riuscito.").strip()[-500:]
            raise HTTPException(status_code=422, detail=f"Case study non riuscito: {detail}")

        if not output_path.exists() or output_path.stat().st_size == 0:
            raise HTTPException(status_code=422, detail="Il case study non ha prodotto un MP3 valido.")

        return FileResponse(
            path=output_path,
            filename="potube-case-study.mp3",
            media_type="audio/mpeg",
            headers={
                "Cache-Control": "no-store",
                "X-RateLimit-Remaining": str(remaining),
                "X-RateLimit-Reset": str(reset_seconds),
            },
            background=BackgroundTask(_cleanup, temp_dir),
        )
    except subprocess.TimeoutExpired as exc:
        _cleanup(temp_dir)
        raise HTTPException(status_code=408, detail="Il case study ha superato il timeout previsto.") from exc
    except HTTPException:
        _cleanup(temp_dir)
        raise
    except Exception as exc:
        _cleanup(temp_dir)
        raise HTTPException(status_code=500, detail="Errore interno nel case study.") from exc
