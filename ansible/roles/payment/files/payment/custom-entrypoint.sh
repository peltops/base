#!/bin/bash
set -e

echo "Starting PostgreSQL in the background..."
docker-entrypoint.sh postgres -c config_file=/etc/postgresql/postgresql.conf -c log_min_messages=fatal &

# Wait for Postgres to be ready
until pg_isready -U postgres -h localhost; do
  echo "Waiting for Postgres to be ready..."
  sleep 2
done

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

# Wait for postgres to keep running
wait