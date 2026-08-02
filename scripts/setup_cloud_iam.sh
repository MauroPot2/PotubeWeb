#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="${PROJECT_ID:-potube-web-mauro}"
BUILD_SA_NAME="${BUILD_SA_NAME:-potube-build}"
RUNTIME_SA_NAME="${RUNTIME_SA_NAME:-potube-runtime}"
BUILD_SA_EMAIL="${BUILD_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
RUNTIME_SA_EMAIL="${RUNTIME_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
ACTIVE_PROJECT="$(gcloud config get-value project 2>/dev/null || true)"
ACTIVE_ACCOUNT="$(gcloud config get-value account 2>/dev/null || true)"

if [[ "$ACTIVE_PROJECT" != "$PROJECT_ID" ]]; then
  echo "❌ Progetto gcloud attivo: ${ACTIVE_PROJECT:-nessuno}"
  echo "   Atteso: $PROJECT_ID"
  exit 1
fi

if [[ -z "$ACTIVE_ACCOUNT" || "$ACTIVE_ACCOUNT" == "(unset)" ]]; then
  echo "❌ Nessun account gcloud attivo. Esegui: gcloud auth login"
  exit 1
fi

ensure_service_account() {
  local name="$1"
  local email="$2"
  local display_name="$3"
  if gcloud iam service-accounts describe "$email" --project="$PROJECT_ID" >/dev/null 2>&1; then
    echo "✅ Service account già presente: $email"
  else
    gcloud iam service-accounts create "$name" \
      --display-name="$display_name" \
      --project="$PROJECT_ID"
    echo "✅ Creato: $email"
  fi
}

ensure_service_account "$BUILD_SA_NAME" "$BUILD_SA_EMAIL" "Potube Cloud Build"
ensure_service_account "$RUNTIME_SA_NAME" "$RUNTIME_SA_EMAIL" "Potube Cloud Run Runtime"

# Google raccomanda roles/run.builder per il service account usato dalle build
# dei deploy Cloud Run da sorgente. Il runtime account non riceve ruoli di
# progetto: al momento Potube non deve accedere ad altre API Google Cloud.
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:$BUILD_SA_EMAIL" \
  --role="roles/run.builder" \
  --quiet >/dev/null

# Il deployer deve poter usare esplicitamente i due service account.
for service_account in "$BUILD_SA_EMAIL" "$RUNTIME_SA_EMAIL"; do
  gcloud iam service-accounts add-iam-policy-binding "$service_account" \
    --member="user:$ACTIVE_ACCOUNT" \
    --role="roles/iam.serviceAccountUser" \
    --project="$PROJECT_ID" \
    --quiet >/dev/null
done

echo ""
echo "✅ IAM Potube configurato con principio di privilegio minimo."
echo "   deployer:   $ACTIVE_ACCOUNT"
echo "   build SA:   $BUILD_SA_EMAIL  (roles/run.builder)"
echo "   runtime SA: $RUNTIME_SA_EMAIL (nessun ruolo di progetto aggiuntivo)"
echo ""
echo "Ora puoi eseguire: bash scripts/deploy_safe.sh"
