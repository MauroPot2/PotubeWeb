#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="${PROJECT_ID:-potube-web-mauro}"
REGION="${REGION:-europe-west1}"
BUILD_SA_EMAIL="${BUILD_SA_EMAIL:-potube-build@${PROJECT_ID}.iam.gserviceaccount.com}"
RUNTIME_SA_EMAIL="${RUNTIME_SA_EMAIL:-potube-runtime@${PROJECT_ID}.iam.gserviceaccount.com}"
ACTIVE_PROJECT="$(gcloud config get-value project 2>/dev/null || true)"

if [[ "$ACTIVE_PROJECT" != "$PROJECT_ID" ]]; then
  echo "❌ Progetto gcloud attivo: ${ACTIVE_PROJECT:-nessuno}"
  echo "   Atteso: $PROJECT_ID"
  echo "   Attiva prima la configurazione corretta:"
  echo "   gcloud config configurations activate potube-web"
  exit 1
fi

for service_account in "$BUILD_SA_EMAIL" "$RUNTIME_SA_EMAIL"; do
  if ! gcloud iam service-accounts describe "$service_account" --project="$PROJECT_ID" >/dev/null 2>&1; then
    echo "❌ Service account mancante: $service_account"
    echo "   Esegui prima: bash scripts/setup_cloud_iam.sh"
    exit 1
  fi
done

echo "🔒 Deploy Potube Web con limiti conservativi"
echo "   project:  $PROJECT_ID"
echo "   region:   $REGION"
echo "   build SA: $BUILD_SA_EMAIL"
echo "   run SA:   $RUNTIME_SA_EMAIL"

# Abilitare le API non avvia istanze né crea costi fissi.
gcloud services enable \
  run.googleapis.com \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  --project="$PROJECT_ID"

# Converter: una sola istanza, una sola conversione contemporanea.
# FFmpeg ha 35s di timeout applicativo; Cloud Run resta a 60s per lasciare
# margine a upload, parsing e consegna della risposta senza aumentare la scala.
gcloud run deploy potube-converter-api \
  --source backend \
  --build-service-account="projects/$PROJECT_ID/serviceAccounts/$BUILD_SA_EMAIL" \
  --service-account="$RUNTIME_SA_EMAIL" \
  --project="$PROJECT_ID" \
  --region="$REGION" \
  --allow-unauthenticated \
  --min-instances=0 \
  --max-instances=1 \
  --concurrency=1 \
  --cpu=1 \
  --memory=512Mi \
  --timeout=60s \
  --cpu-throttling \
  --set-env-vars="MAX_UPLOAD_BYTES=26214400,CONVERSION_TIMEOUT_SECONDS=35,MAX_DAILY_CONVERSIONS=3,MAX_FREE_BITRATE=192,MAX_RATE_BUCKETS=5000"

# Frontend SSR: scala a zero, una sola istanza massima.
gcloud run deploy potube-web \
  --source . \
  --build-service-account="projects/$PROJECT_ID/serviceAccounts/$BUILD_SA_EMAIL" \
  --service-account="$RUNTIME_SA_EMAIL" \
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
