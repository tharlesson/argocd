#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <source_env> <target_env>"
  exit 1
fi

SOURCE_ENV="$1"
TARGET_ENV="$2"
SOURCE_FILE="apps/sample-api/overlays/${SOURCE_ENV}/kustomization.yaml"
TARGET_FILE="apps/sample-api/overlays/${TARGET_ENV}/kustomization.yaml"

if [[ ! -f "$SOURCE_FILE" || ! -f "$TARGET_FILE" ]]; then
  echo "missing overlay file"
  exit 1
fi

TAG=$(awk '/newTag:/ {print $2}' "$SOURCE_FILE" | tr -d '"')
if [[ -z "$TAG" ]]; then
  echo "could not determine tag from ${SOURCE_FILE}"
  exit 1
fi

sed -i.bak -E "s#(newTag:[[:space:]]*).+#\\1\"${TAG}\"#" "$TARGET_FILE"
rm -f "${TARGET_FILE}.bak"

echo "Promoted ${TAG} from ${SOURCE_ENV} to ${TARGET_ENV}"
