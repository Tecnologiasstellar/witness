#!/bin/sh
# Runs the adversarial RLS/idempotency suite against the local Supabase stack.
# Requires: supabase start (Docker). Applies no permanent changes (the suite
# rolls back).
set -eu
cd "$(dirname "$0")/../.."

DB_CONTAINER=$(docker ps --format '{{.Names}}' | grep '^supabase_db_' | head -1)
if [ -z "$DB_CONTAINER" ]; then
    echo "Local Supabase database container not found. Run 'supabase start' first." >&2
    exit 1
fi

docker exec -i "$DB_CONTAINER" psql -U postgres -d postgres -v ON_ERROR_STOP=1 \
    < supabase/tests/rls_and_idempotency_test.sql
