#!/usr/bin/env bash
set -euo pipefail

require_bin() {
  command -v "$1" >/dev/null 2>&1 || { echo "missing binary: $1"; exit 1; }
}

require_bin kustomize
require_bin kubeconform

echo "[validate] validating overlays"
for env in dev stage prod; do
  echo "[validate] environments/${env}"
  kustomize build "environments/${env}" | kubeconform -strict -summary -ignore-missing-schemas

done

echo "[validate] done"
