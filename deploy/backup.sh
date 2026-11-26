#!/usr/bin/env bash
# Runs in the deploy folder on the server before every deploy.
# Dumps the database into backups/; the pipeline keeps the newest 14 files.
set -euo pipefail
if [ -z "$(docker compose ps --status running -q db 2>/dev/null)" ]; then
  echo "Database not running yet (first deploy); no backup."
  exit 0
fi
file="backups/db-$(date +%F-%H%M%S).sql.gz"
# user and database name come from the db container's own environment
# shellcheck disable=SC2016
docker compose exec -T db sh -c 'pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB"' | gzip > "$file"
echo "Backup written: $file ($(du -h "$file" | cut -f1))"
