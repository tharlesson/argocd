#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <overlay_env> <image_tag>"
  exit 1
fi

ENV_NAME="$1"
IMAGE_TAG="$2"
TARGET_FILE="apps/sample-api/overlays/${ENV_NAME}/kustomization.yaml"

if [[ ! -f "$TARGET_FILE" ]]; then
  echo "missing overlay file: ${TARGET_FILE}"
  exit 1
fi

sed -i.bak -E "s#(newTag:[[:space:]]*).+#\\1\"${IMAGE_TAG}\"#" "$TARGET_FILE"
rm -f "${TARGET_FILE}.bak"

echo "Updated ${TARGET_FILE} with ${IMAGE_TAG}"
