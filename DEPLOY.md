# Deploy checklist

## Cloud project

- [ ] crea/seleziona progetto Google Cloud
- [ ] abilita Cloud Run, Cloud Build, Artifact Registry
- [ ] inizializza Firebase Hosting sullo stesso progetto
- [ ] configura billing budget e alert

## Backend

```bash
gcloud run deploy potube-converter-api \
  --source backend \
  --project YOUR_PROJECT_ID \
  --region europe-west1 \
  --allow-unauthenticated \
  --memory 1Gi \
  --cpu 1 \
  --timeout 60 \
  --max-instances 2
```

Verifica:

```bash
curl https://BACKEND_URL/api/health
```

## Frontend

```bash
gcloud run deploy potube-web \
  --source . \
  --project YOUR_PROJECT_ID \
  --region europe-west1 \
  --allow-unauthenticated \
  --min-instances 0 \
  --max-instances 2
```

## Hosting

Assicurati che i serviceId in `firebase.json` coincidano con i nomi Cloud Run.

```bash
jaspr build
firebase deploy --only hosting
```
