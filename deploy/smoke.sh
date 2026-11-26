#!/usr/bin/env bash
# CI smoke test: start the freshly built image ($IMAGE) with its database,
# using deploy/compose.yaml, and check that /health answers.
set -euo pipefail
: "${IMAGE:?IMAGE is required}"
dir="$(mktemp -d)"
cp deploy/compose.yaml "$dir/compose.yaml"
cat > "$dir/compose.override.yaml" <<YAML
services:
  app:
    image: $IMAGE
YAML
cat > "$dir/.env" <<ENV
COMPOSE_PROJECT_NAME=smoke
POSTGRES_PASSWORD=smoke-test-only
APP_PORT=18090
ENV
cd "$dir"
trap 'docker compose logs --tail 50 app || true; docker compose down -v >/dev/null 2>&1 || true' EXIT
docker compose up -d
for _ in $(seq 1 40); do
  if curl -fsS http://127.0.0.1:18090/health; then echo; echo "Smoke test passed"; exit 0; fi
  sleep 3
done
echo "::error::App did not become healthy"
exit 1
