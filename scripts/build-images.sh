#!/usr/bin/env bash
set -euo pipefail
IMG_BASE="ghcr.io/EnmanuelMejia/devops-superlab"
SERVICES=(api-gateway node-express go-chi dotnet-minimal spring-boot web-frontend)
for s in "${SERVICES[@]}"; do
  echo "==> building $s"
  docker build -t "$IMG_BASE/$s:dev" "$HOME/devops-superlab/services/$s"
done
