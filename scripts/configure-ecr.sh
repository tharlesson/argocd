#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <ecr-image-name>"
  echo "example: $0 123456789012.dkr.ecr.us-east-1.amazonaws.com/sample-api"
  exit 1
fi

ECR_IMAGE="$1"

for file in \
  "apps/sample-api/overlays/dev/kustomization.yaml" \
  "apps/sample-api/overlays/stage/kustomization.yaml" \
  "apps/sample-api/overlays/prod/kustomization.yaml" \
  "apps/sample-api/overlays/prod/kustomization.canary.yaml" \
  "apps/sample-api/overlays/prod/kustomization.bluegreen.yaml"
do
  sed -i.bak -E "s#(newName:[[:space:]]*).+#\\1${ECR_IMAGE}#g" "$file"
  rm -f "${file}.bak"
done

echo "Updated ECR image in all overlays: ${ECR_IMAGE}"
