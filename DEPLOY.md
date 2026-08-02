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

## 3. Deploy Cloud Run con limiti conservativi

Usa lo script versionato nel repository:

```bash
bash scripts/deploy_safe.sh
```

Lo script blocca il deploy se il progetto gcloud attivo non è `potube-web-mauro` e forza:

### Converter

- min instances: 0
- max instances: 1
- concurrency: 1
- CPU: 1
- RAM: 512 MiB
- timeout: 50 s
- max upload applicativo: 25 MB
- max 3 conversioni / 24h per IP, best-effort
- bitrate Free massimo: 192 kbps

### Frontend

- min instances: 0
- max instances: 1
- concurrency: 20
- CPU: 1
- RAM: 512 MiB

## 4. Verifica backend

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

## 5. Analytics e Search Console

Lascia GA4 disattivato fino a quando non hai creato la property. Il frontend non carica Analytics se `GA_MEASUREMENT_ID` è assente e, anche quando configurato, lo carica soltanto dopo consenso.

Quando avrai gli ID:

```bash
gcloud run services update potube-web \
  --project potube-web-mauro \
  --region europe-west1 \
  --update-env-vars="GA_MEASUREMENT_ID=G-XXXXXXXXXX,GOOGLE_SITE_VERIFICATION=TOKEN_SEARCH_CONSOLE"
```

## 6. Firebase Hosting

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

## 7. Prima di aprire al traffico

- [ ] `/api/health` risponde correttamente
- [ ] conversione reale con file piccolo riuscita
- [ ] file >25 MB rifiutato
- [ ] quarta conversione nella finestra di 24h riceve HTTP 429, salvo reset istanza
- [ ] budget e notifiche billing attivi
- [ ] `max-instances=1` verificato sui due servizi
- [ ] Privacy/Terms ricontrollati con i dati reali del titolare
- [ ] AdSense ancora disattivato finché sito, privacy e CMP non sono pronti
