#!/usr/bin/env bash
set -euo pipefail
IMG_BASE="ghcr.io/EnmanuelMejia/devops-superlab"
SERVICES=(api-gateway node-express go-chi dotnet-minimal spring-boot web-frontend)
echo "Login to GHCR if needed: echo $CR_PAT | docker login ghcr.io -u EnmanuelMejia --password-stdin"
for s in "${SERVICES[@]}"; do
  echo "==> buildx + push $s"
  docker buildx build --platform linux/amd64 -t "$IMG_BASE/$s:latest" "$HOME/devops-superlab/services/$s" --push
done
