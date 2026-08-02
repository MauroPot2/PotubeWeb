# Potube Web

Potube Web è un converter web upload-first: trasforma file audio/video caricati direttamente dall'utente in MP3 tramite FFmpeg.

> Non contiene un downloader YouTube pubblico e non accetta URL di piattaforme di streaming.

## Fase 1 — Validation MVP

La prima versione pubblica è volutamente limitata per validare traffico e interesse senza esporre il progetto a costi Cloud Run imprevedibili.

### Free beta

- 3 conversioni ogni 24 ore per utente/IP, best-effort
- massimo 25 MB per file
- MP3 a 128 o 192 kbps
- normalizzazione volume opzionale
- metadata opzionali
- file temporanei eliminati dopo la risposta
- nessun account e nessuna persistenza utente
- spazi advertising solo placeholder finché AdSense/CMP non sono pronti

I bitrate 256/320 kbps e limiti superiori sono riservati alla futura evoluzione Pro.

## Stack

- Jaspr 0.23.x in modalità server (SSR)
- jaspr_router
- Firebase Hosting come edge/router
- Cloud Run per il frontend Jaspr
- FastAPI + FFmpeg su un secondo servizio Cloud Run
- GA4 opzionale e caricato soltanto dopo consenso
- Search Console configurabile tramite meta verification runtime

## Struttura

```text
PotubeWeb/
├── lib/                       # Jaspr SSR
├── web/                       # CSS, JS privacy/analytics, favicon, SEO assets
├── backend/                   # FastAPI + FFmpeg
├── scripts/deploy_safe.sh     # deploy Cloud Run con limiti costi
├── Dockerfile                 # Cloud Run frontend
├── firebase.json              # /api/** -> backend, ** -> Jaspr
├── DEPLOY.md                  # checklist produzione
└── .github/workflows/         # build/test automatici
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

Test rapido:

```bash
curl -F "file=@/percorso/video.mp4" \
  -F "quality=192" \
  -F "metadata=yes" \
  -F "rights_confirmed=yes" \
  http://localhost:8081/api/convert \
  --output output.mp3
```

## Protezioni costi e abuso

Il backend espone configurazioni tramite environment variables:

```text
MAX_UPLOAD_BYTES=26214400
CONVERSION_TIMEOUT_SECONDS=35
MAX_DAILY_CONVERSIONS=3
RATE_LIMIT_WINDOW_SECONDS=86400
MAX_RATE_BUCKETS=5000
MAX_FREE_BITRATE=192
```

Il rate-limit dell'MVP è in-memory: riduce gli abusi ma può azzerarsi quando l'istanza Cloud Run scala a zero. I bucket scaduti vengono ripuliti globalmente e il numero di client mantenuti in memoria è limitato a 5.000, così il dizionario non può crescere senza limite durante traffico prolungato.

La protezione economica reale è data anche dai limiti infrastrutturali del deploy.

Lo script:

```bash
bash scripts/deploy_safe.sh
```

forza per il converter:

- `min-instances=0`
- `max-instances=1`
- `concurrency=1`
- 1 vCPU
- 512 MiB RAM
- timeout richiesta Cloud Run: 60 secondi
- timeout FFmpeg applicativo: 35 secondi
- request-based CPU throttling

Il margine tra 35 e 60 secondi lascia tempo a upload, parsing e consegna della risposta senza aumentare la capacità massima del servizio.

Il frontend usa anch'esso `min-instances=0` e `max-instances=1`.

Lo script interrompe il deploy se il progetto gcloud attivo non è `potube-web-mauro`.

## Analytics e Search Console

Nessun ID viene salvato nel repository. Il server Jaspr legge a runtime:

```text
GA_MEASUREMENT_ID
GOOGLE_SITE_VERIFICATION
```

Se `GA_MEASUREMENT_ID` non è configurato, Google Analytics non viene caricato. Quando è presente, viene mostrata una scelta privacy e GA4 viene caricato solo dopo consenso esplicito.

Esempio di configurazione futura:

```bash
gcloud run services update potube-web \
  --project potube-web-mauro \
  --region europe-west1 \
  --update-env-vars="GA_MEASUREMENT_ID=G-XXXXXXXXXX,GOOGLE_SITE_VERIFICATION=TOKEN"
```

Gli spazi AdSense restano disattivati durante la validazione iniziale. Prima di attivare advertising per utenti SEE va adottata una CMP adeguata e aggiornata la documentazione privacy.

## SEO

Asset inclusi:

- `robots.txt`
- `sitemap.xml`
- SSR Jaspr
- meta description e robots
- guida `/guide/mp3-bitrate`

URL Firebase previsto:

```text
https://potube-web-mauro.web.app
```

Se verrà aggiunto un dominio custom, `robots.txt` e `sitemap.xml` andranno aggiornati al dominio canonico.

## Test

Frontend:

```bash
dart analyze
jaspr build
```

Backend:

```bash
python -m unittest discover -s backend/tests -v
```

GitHub Actions esegue automaticamente build Jaspr, compile check Python e test backend sulle pull request.

## Deploy

La procedura completa e i controlli pre-produzione sono in [DEPLOY.md](DEPLOY.md).
