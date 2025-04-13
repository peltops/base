#!/bin/bash
set -e

echo "Running migrations..."
for f in /db/migrations/*.sql; do
  echo "Applying $f..."
  psql -U postgres -d "$POSTGRES_DB" -f "$f"
done

echo "Running seeds..."
for f in /db/seeds/*.sql; do
  echo "Applying $f..."
  psql -U postgres -d "$POSTGRES_DB" -f "$f"
done
