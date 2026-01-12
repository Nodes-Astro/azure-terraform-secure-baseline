#!/usr/bin/env bash
set -euo pipefail

# === AYARLA ===
LOCATION="${LOCATION:-northeurope}"
STATE_RG="${STATE_RG:-rg-tfstate-devops}"
STATE_SA="${STATE_SA:-sttfstate$RANDOM$RANDOM}"   # unique olsun diye random
STATE_CONTAINER="${STATE_CONTAINER:-tfstate}"
STATE_KEY="${STATE_KEY:-infra.tfstate}"

echo "Using:"
echo "  LOCATION=$LOCATION"
echo "  STATE_RG=$STATE_RG"
echo "  STATE_SA=$STATE_SA"
echo "  STATE_CONTAINER=$STATE_CONTAINER"
echo "  STATE_KEY=$STATE_KEY"

az group create -n "$STATE_RG" -l "$LOCATION" -o none

# Storage account (LRS, Standard) - düşük maliyet
az storage account create \
  -n "$STATE_SA" \
  -g "$STATE_RG" \
  -l "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false \
  -o none

# Container
ACCOUNT_KEY="$(az storage account keys list -g "$STATE_RG" -n "$STATE_SA" --query '[0].value' -o tsv)"
az storage container create \
  --name "$STATE_CONTAINER" \
  --account-name "$STATE_SA" \
  --account-key "$ACCOUNT_KEY" \
  -o none

cat > backend.hcl <<EOF
resource_group_name  = "$STATE_RG"
storage_account_name = "$STATE_SA"
container_name       = "$STATE_CONTAINER"
key                  = "$STATE_KEY"
EOF

echo
echo "✅ Created backend.hcl in bootstrap/ directory."
echo "Now copy it into infra/backend.hcl:"
echo "  cp bootstrap/backend.hcl infra/backend.hcl"
