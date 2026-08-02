#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="${PROJECT_ID:-potube-web-mauro}"
REGION="${REGION:-europe-west1}"
ACTIVE_PROJECT="$(gcloud config get-value project 2>/dev/null || true)"

if [[ "$ACTIVE_PROJECT" != "$PROJECT_ID" ]]; then
  echo "❌ Progetto gcloud attivo: ${ACTIVE_PROJECT:-nessuno}"
  echo "   Atteso: $PROJECT_ID"
  echo "   Attiva prima la configurazione corretta:"
  echo "   gcloud config configurations activate potube-web"
  exit 1
fi

echo "🔒 Deploy Potube Web con limiti conservativi"
echo "   project: $PROJECT_ID"
echo "   region:  $REGION"

# Abilitare le API non avvia istanze né crea costi fissi.
gcloud services enable \
  run.googleapis.com \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  --project="$PROJECT_ID"

# Converter: una sola istanza, una sola conversione contemporanea.
gcloud run deploy potube-converter-api \
  --source backend \
  --project="$PROJECT_ID" \
  --region="$REGION" \
  --allow-unauthenticated \
  --min-instances=0 \
  --max-instances=1 \
  --concurrency=1 \
  --cpu=1 \
  --memory=512Mi \
  --timeout=50s \
  --cpu-throttling \
  --set-env-vars="MAX_UPLOAD_BYTES=26214400,CONVERSION_TIMEOUT_SECONDS=50,MAX_DAILY_CONVERSIONS=3,MAX_FREE_BITRATE=192"

# Frontend SSR: scala a zero, una sola istanza massima.
gcloud run deploy potube-web \
  --source . \
  --project="$PROJECT_ID" \
  --region="$REGION" \
  --allow-unauthenticated \
  --min-instances=0 \
  --max-instances=1 \
  --concurrency=20 \
  --cpu=1 \
  --memory=512Mi \
  --cpu-throttling

echo "✅ Cloud Run deploy completato."
echo "   Controlla sempre Billing → Budgets prima di aprire il traffico pubblico."
