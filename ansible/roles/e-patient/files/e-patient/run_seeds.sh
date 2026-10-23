#!/bin/bash
set -e

echo "Running seeds..."
for f in /db/seeds/*.sql; do
  if [ -f "$f" ]; then
    echo "Applying $f..."
    psql -U postgres -d "$POSTGRES_DB" -f "$f"
  fi
done
 