#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <base-domain>"
  echo "example: $0 platform.example.com"
  exit 1
fi

BASE_DOMAIN="$1"

set_host() {
  local file="$1"
  local pattern="$2"
  local replacement="$3"
  sed -i.bak -E "s#${pattern}#${replacement}#g" "$file"
  rm -f "${file}.bak"
}

set_host "platform/argocd/base/argocd-cm.yaml" "url:[[:space:]]*https://argocd\\.[^[:space:]]+" "url: https://argocd.${BASE_DOMAIN}"
set_host "platform/argocd/base/argocd-notifications-cm.yaml" "argocdUrl:[[:space:]]*https://argocd\\.[^[:space:]]+" "argocdUrl: https://argocd.${BASE_DOMAIN}"
set_host "platform/argocd/base/argocd-server-ingress.yaml" "host:[[:space:]]*argocd\\.[^[:space:]]+" "host: argocd.${BASE_DOMAIN}"
set_host "platform/argo-rollouts/base/dashboard-ingress.yaml" "host:[[:space:]]*rollouts\\.[^[:space:]]+" "host: rollouts.${BASE_DOMAIN}"

set_host "apps/sample-api/overlays/dev/patch-ingress.yaml" "host:[[:space:]]*sample-api-dev\\.[^[:space:]]+" "host: sample-api-dev.${BASE_DOMAIN}"
set_host "apps/sample-api/overlays/stage/patch-ingress.yaml" "host:[[:space:]]*sample-api-stage\\.[^[:space:]]+" "host: sample-api-stage.${BASE_DOMAIN}"
set_host "apps/sample-api/overlays/prod/patch-ingress.yaml" "host:[[:space:]]*sample-api\\.[^[:space:]]+" "host: sample-api.${BASE_DOMAIN}"

set_host ".github/workflows/smoke-test.yaml" "https://sample-api-dev\\.[^\\\"]+" "https://sample-api-dev.${BASE_DOMAIN}"
set_host ".github/workflows/smoke-test.yaml" "https://sample-api-stage\\.[^\\\"]+" "https://sample-api-stage.${BASE_DOMAIN}"
set_host ".github/workflows/smoke-test.yaml" "https://sample-api\\.[^\\\"]+" "https://sample-api.${BASE_DOMAIN}"

echo "Updated platform and app hosts to base domain: ${BASE_DOMAIN}"
