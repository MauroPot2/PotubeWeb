# Potube Web

Potube Web è la versione web, upload-first, di Potube: converte file audio/video caricati direttamente dall'utente in MP3 tramite FFmpeg.

> Non contiene un downloader YouTube pubblico e non accetta URL di piattaforme di streaming.

## Stack

- Jaspr 0.23.x in modalità server (SSR)
- jaspr_router
- Firebase Hosting come edge/router
- Cloud Run per il frontend Jaspr
- FastAPI + FFmpeg su un secondo servizio Cloud Run
- spazi pubblicitari predisposti come placeholder, da attivare solo dopo approvazione e CMP/privacy complete

## Struttura

```text
PotubeWeb/
├── lib/                       # Jaspr SSR
├── web/                       # CSS, favicon, SEO assets
├── backend/                   # FastAPI + FFmpeg
├── Dockerfile                 # Cloud Run frontend
├── firebase.json              # /api/** -> backend, ** -> Jaspr
└── .github/workflows/         # build/check automatici
```

## Avvio frontend

```bash
dart pub global activate jaspr_cli
dart pub get
jaspr serve
```

Il sito sarà normalmente disponibile su `http://localhost:8080`.

## Avvio backend

Richiede FFmpeg installato localmente.

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8081
```

Per testare il backend direttamente:

```bash
curl -F "file=@/percorso/video.mp4" \
  -F "quality=192" \
  -F "metadata=yes" \
  -F "rights_confirmed=yes" \
  http://localhost:8081/api/convert \
  --output output.mp3
```

Durante lo sviluppo il form Jaspr usa `/api/convert`. Per un test locale completo puoi usare un reverse proxy, oppure modificare temporaneamente l'action del form verso `http://localhost:8081/api/convert`.

## Limiti MVP

- upload massimo MVP: 25 MB (`MAX_UPLOAD_BYTES`)
- timeout conversione MVP: 50 secondi (`CONVERSION_TIMEOUT_SECONDS`)
- formati consentiti: MP3, M4A, AAC, WAV, FLAC, OGG, MP4, MOV, MKV, WEBM, AVI, M4V
- file temporanei eliminati dopo il download o in caso di errore
- nessuna persistenza utente
- nessun URL remoto

## Deploy Google Cloud

Sostituisci `YOUR_PROJECT_ID`.

### 1. Backend

```bash
gcloud run deploy potube-converter-api \
  --source backend \
  --project YOUR_PROJECT_ID \
  --region europe-west1 \
  --allow-unauthenticated \
  --memory 1Gi \
  --cpu 1 \
  --timeout 60 \
  --max-instances 2 \
  --set-env-vars MAX_UPLOAD_BYTES=26214400,CONVERSION_TIMEOUT_SECONDS=50
```

### 2. Frontend Jaspr

```bash
gcloud run deploy potube-web \
  --source . \
  --project YOUR_PROJECT_ID \
  --region europe-west1 \
  --allow-unauthenticated \
  --min-instances 0 \
  --max-instances 2
```

### 3. Firebase Hosting

```bash
jaspr build
firebase use YOUR_PROJECT_ID
firebase deploy --only hosting
```

## Prima della produzione

1. Sostituire `potube.example` in `robots.txt` e `sitemap.xml`.
2. Completare Privacy Policy e Termini con i dati reali del titolare.
3. Implementare CMP/cookie consent prima di analytics o advertising che lo richiedano.
4. Inserire AdSense solo dopo l'approvazione, mantenendo gli annunci chiaramente separati dal pulsante di conversione/download.
5. Valutare rate limiting, Cloud Armor e budget alert prima di aprire il servizio al traffico pubblico.
6. Per superare 25–30 MB, passare a upload diretto su Cloud Storage + job asincroni: Cloud Run HTTP/1 ha un limite di 32 MiB per richiesta e le rewrite dinamiche Firebase Hosting hanno timeout di 60 secondi.

## Monetizzazione

Gli `AdSlot` nel frontend sono solo placeholder grafici. Non contengono publisher ID, script o unità pubblicitarie reali.

Una possibile evoluzione:

- Free: limite file + advertising
- Pro: file più grandi, batch conversion, no ads, preset audio, metadata editor
