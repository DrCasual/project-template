#!/usr/bin/env bash
# Fill in the template placeholders once, right after creating a repo from this template.
#   bash init.sh <app> <domain> <staging-port> <production-port>
#   bash init.sh sendipity sendipity.be 8091 8090
set -euo pipefail
[ $# -eq 4 ] || { sed -n '2,4p' "$0"; exit 1; }
app="$(tr '[:upper:]' '[:lower:]' <<<"$1")" domain="$2" staging="$3" prod="$4"
grep -rlE '__(APP|DOMAIN|STAGING_PORT|PROD_PORT)__' --exclude=init.sh . --exclude-dir=.git | while read -r f; do
  sed -i.bak -e "s/__APP__/$app/g" -e "s/__DOMAIN__/$domain/g" \
    -e "s/__STAGING_PORT__/$staging/g" -e "s/__PROD_PORT__/$prod/g" "$f" && rm -f "$f.bak"
  echo "filled in: $f"
done
echo "Done. Remove this script: git rm init.sh"
