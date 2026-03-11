#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-dev}"
TF_DIR="terraform/environments/${ENVIRONMENT}"

echo "[bootstrap] environment=${ENVIRONMENT}"
cd "${TF_DIR}"
terraform init
terraform apply -var-file=terraform.tfvars

echo "[bootstrap] waiting Argo CD API resources..."
kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd || true

echo "[bootstrap] current applications:"
kubectl -n argocd get applications || true

echo "[bootstrap] done"
