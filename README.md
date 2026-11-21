# Potube Web

Applicazione web per convertire file audio e video caricati dall'utente in MP3. L'elaborazione avviene tramite FFmpeg; il servizio non accetta link a piattaforme di streaming e non fornisce un downloader pubblico.

## Architettura

- Frontend server-rendered con Dart e Jaspr
- Backend FastAPI con FFmpeg
- Cloud Run per frontend e conversione
- Firebase Hosting come punto d'ingresso e instradamento delle richieste

Il codice Jaspr è in `lib/` e `web/`; il servizio Python in `backend/`. La configurazione operativa è descritta in [DEPLOY.md](DEPLOY.md).

## Limiti dell'MVP

- File fino a 25 MB
- Fino a tre conversioni ogni 24 ore per IP, con limitazione best-effort
- MP3 a 128 o 192 kbps
- Normalizzazione opzionale e gestione metadata
- File temporanei non conservati dopo la risposta
- Nessun account e nessuna archiviazione persistente degli upload

Il rate limiting è mantenuto in memoria: non sostituisce un controllo distribuito degli abusi.

## Avvio locale

Frontend:

~~~bash
dart pub get
dart run jaspr_cli:jaspr serve
~~~

Backend (richiede FFmpeg installato):

~~~bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8081
~~~

## Test

~~~bash
dart analyze
dart run jaspr_cli:jaspr build
python -m unittest discover -s backend/tests -v
~~~

## Distribuzione e costi

Gli script in `scripts/` verificano il progetto Google Cloud e applicano limiti conservativi a risorse, concorrenza e numero di istanze. Prima di distribuire è necessario controllare anche budget e fatturazione del progetto.

~~~bash
bash scripts/deploy_safe.sh
~~~

Per la procedura completa, incluse le autorizzazioni IAM, consultare [DEPLOY.md](DEPLOY.md). Lo script non elimina il rischio di costi imprevisti: il monitoraggio del billing rimane necessario.

## Privacy e diritti

Il frontend può abilitare Analytics solo quando configurato e dopo il consenso previsto. L'uso del convertitore deve riguardare file che l'utente ha il diritto di elaborare. Prima di un'apertura al pubblico vanno verificati privacy, gestione degli abusi e termini del servizio.
