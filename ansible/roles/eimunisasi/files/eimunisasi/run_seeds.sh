#!/bin/bash
set -e

echo "Running seeds..."
for f in /db/seeds/*.sql; do
  echo "Applying $f..."
  psql -U postgres -d "$POSTGRES_DB" -f "$f"
done
 