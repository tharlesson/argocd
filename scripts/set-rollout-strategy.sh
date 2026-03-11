#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <canary|bluegreen>"
  exit 1
fi

STRATEGY="$1"
PROD_DIR="apps/sample-api/overlays/prod"
CURRENT_FILE="${PROD_DIR}/kustomization.yaml"

if [[ ! -f "${CURRENT_FILE}" ]]; then
  echo "missing file: ${CURRENT_FILE}"
  exit 1
fi

CURRENT_IMAGE="$(awk '/newName:/ {print $2}' "${CURRENT_FILE}" | head -n 1)"
CURRENT_TAG="$(awk '/newTag:/ {print $2}' "${CURRENT_FILE}" | head -n 1 | tr -d '"')"

if [[ -z "${CURRENT_IMAGE}" || -z "${CURRENT_TAG}" ]]; then
  echo "could not determine newName/newTag from ${CURRENT_FILE}"
  exit 1
fi

apply_image_values() {
  sed -i.bak -E "s#(newName:[[:space:]]*).+#\\1${CURRENT_IMAGE}#g" "${CURRENT_FILE}"
  sed -i.bak -E "s#(newTag:[[:space:]]*).+#\\1\"${CURRENT_TAG}\"#g" "${CURRENT_FILE}"
  rm -f "${CURRENT_FILE}.bak"
}

case "$STRATEGY" in
  canary)
    cp "${PROD_DIR}/kustomization.canary.yaml" "${PROD_DIR}/kustomization.yaml"
    apply_image_values
    echo "Switched prod rollout strategy to canary."
    ;;
  bluegreen)
    cp "${PROD_DIR}/kustomization.bluegreen.yaml" "${PROD_DIR}/kustomization.yaml"
    apply_image_values
    echo "Switched prod rollout strategy to bluegreen."
    ;;
  *)
    echo "invalid strategy: ${STRATEGY} (expected canary or bluegreen)"
    exit 1
    ;;
esac
