# Deploy checklist — Fase 1

Project ID previsto: `potube-web-mauro`.

## 1. Sicurezza costi prima del deploy

- [ ] configurazione gcloud `potube-web` attiva
- [ ] progetto attivo `potube-web-mauro`
- [ ] billing collegato
- [ ] budget progetto configurato
- [ ] Spend Cap Cloud Run configurato, se disponibile sul billing account

Verifica sempre:

```bash
gcloud config list
```

## 2. Firebase sullo stesso progetto

Non creare un secondo progetto Firebase. Aggiungi Firebase al progetto Google Cloud esistente e inizializza Hosting.

```bash
firebase login
firebase projects:addfirebase
firebase use potube-web-mauro
```

Se Hosting non è ancora inizializzato:

```bash
firebase init hosting
```

Mantieni il `firebase.json` presente nel repository: `/api/**` viene instradato a `potube-converter-api`, tutto il resto a `potube-web`.

## 3. IAM dedicato per build e runtime

I progetti Google Cloud recenti possono usare il Compute Engine default service account per Cloud Build senza i permessi necessari al deploy da sorgente. Potube evita di ampliare i privilegi dell'account predefinito e usa due identità dedicate:

- `potube-build@potube-web-mauro.iam.gserviceaccount.com`: riceve solo `roles/run.builder`
- `potube-runtime@potube-web-mauro.iam.gserviceaccount.com`: nessun ruolo di progetto aggiuntivo per l'MVP

Configurazione una tantum:

```bash
bash scripts/setup_cloud_iam.sh
```

Lo script verifica progetto/account attivi, crea i service account se mancanti e concede al deployer solo il permesso di usarli.

## 4. Deploy Cloud Run con limiti conservativi

Usa lo script versionato nel repository:

```bash
bash scripts/deploy_safe.sh
```

Lo script blocca il deploy se il progetto gcloud attivo non è `potube-web-mauro`, verifica che i service account dedicati esistano e forza:

### Converter

- build service account dedicato `potube-build`
- runtime service account dedicato `potube-runtime`
- min instances: 0
- max instances: 1
- concurrency: 1
- CPU: 1
- RAM: 512 MiB
- timeout richiesta Cloud Run: 60 s
- timeout FFmpeg applicativo: 35 s
- max upload applicativo: 25 MB
- max 3 conversioni / 24h per IP, best-effort
- massimo 5.000 bucket client mantenuti in memoria
- bitrate Free massimo: 192 kbps

Il timeout Cloud Run è volutamente superiore a quello FFmpeg per lasciare margine a upload, parsing e consegna della risposta. Il rate limiter ripulisce globalmente i bucket scaduti e applica anche un limite assoluto alla propria memoria.

### Frontend

- build service account dedicato `potube-build`
- runtime service account dedicato `potube-runtime`
- min instances: 0
- max instances: 1
- concurrency: 20
- CPU: 1
- RAM: 512 MiB

## 5. Verifica backend

Recupera l'URL del servizio:

```bash
gcloud run services describe potube-converter-api \
  --project potube-web-mauro \
  --region europe-west1 \
  --format='value(status.url)'
```

Poi:

```bash
curl "$(gcloud run services describe potube-converter-api --project potube-web-mauro --region europe-west1 --format='value(status.url)')/api/health"
```

## 6. Analytics e Search Console

Lascia GA4 disattivato fino a quando non hai creato la property. Il frontend non carica Analytics se `GA_MEASUREMENT_ID` è assente e, anche quando configurato, lo carica soltanto dopo consenso.

Quando avrai gli ID:

```bash
gcloud run services update potube-web \
  --project potube-web-mauro \
  --region europe-west1 \
  --update-env-vars="GA_MEASUREMENT_ID=G-XXXXXXXXXX,GOOGLE_SITE_VERIFICATION=TOKEN_SEARCH_CONSOLE"
```

## 7. Firebase Hosting

Dopo che i due servizi Cloud Run esistono:

```bash
jaspr build
firebase use potube-web-mauro
firebase deploy --only hosting
```

URL atteso del sito predefinito:

```text
https://potube-web-mauro.web.app
```

## 8. Prima di aprire al traffico

- [ ] `/api/health` risponde correttamente
- [ ] `conversion_timeout_seconds` vale 35
- [ ] `max_rate_buckets` vale 5000
- [ ] conversione reale con file piccolo riuscita
- [ ] file >25 MB rifiutato
- [ ] quarta conversione nella finestra di 24h riceve HTTP 429, salvo reset istanza
- [ ] budget e notifiche billing attivi
- [ ] `max-instances=1` verificato sui due servizi
- [ ] build e runtime usano i service account Potube dedicati
- [ ] Privacy/Terms ricontrollati con i dati reali del titolare
- [ ] AdSense ancora disattivato finché sito, privacy e CMP non sono pronti
