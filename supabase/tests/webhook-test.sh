#!/bin/sh
# Adversarial test suite for the RevenueCat webhook doorman (D-024).
# Requires: supabase start (Docker). Serves the function locally, attacks it
# over HTTP, and verifies database effects directly. Cleans up its own rows.
set -eu
cd "$(dirname "$0")/../.."

FN_URL="http://127.0.0.1:54321/functions/v1/revenuecat-webhook"
ENV_FILE="supabase/functions/.env"
DB_CONTAINER=$(docker ps --format '{{.Names}}' | grep '^supabase_db_' | head -1)
if [ -z "$DB_CONTAINER" ]; then
    echo "Local Supabase database container not found. Run 'supabase start' first." >&2
    exit 1
fi

# Local-only secret; created once, gitignored, never printed.
if [ ! -f "$ENV_FILE" ]; then
    printf 'RC_WEBHOOK_AUTH=%s\n' "$(openssl rand -hex 32)" > "$ENV_FILE"
fi
SECRET=$(sed -n 's/^RC_WEBHOOK_AUTH=//p' "$ENV_FILE" | head -1)

psql_q() {
    docker exec -i "$DB_CONTAINER" psql -U postgres -d postgres -tA -v ON_ERROR_STOP=1 -c "$1"
}

cleanup_rows() {
    psql_q "delete from public.entitlement_snapshots where app_user_id in ('11111111-1111-4111-8111-111111111111','22222222-2222-4222-8222-222222222222');" >/dev/null
    psql_q "delete from public.support_events where provider_transaction_key like 'event:wtest-%' or app_user_id = '11111111-1111-4111-8111-111111111111';" >/dev/null
    psql_q "delete from public.purchase_events where provider_event_id like 'wtest-%';" >/dev/null
}

SERVE_PID=""
finish() {
    cleanup_rows || true
    [ -n "$SERVE_PID" ] && kill "$SERVE_PID" 2>/dev/null || true
}
trap finish EXIT

supabase functions serve --env-file "$ENV_FILE" --no-verify-jwt \
    > /tmp/witness-webhook-serve.log 2>&1 &
SERVE_PID=$!

# Wait until the function itself answers (a TEST ping returns 200); Kong
# returns 404/502 while the edge worker is still compiling.
i=0
while :; do
    code=$(curl -s -o /dev/null -w '%{http_code}' -X POST \
        -H "Authorization: dummy" -H 'Content-Type: application/json' \
        -d '{"event":{"id":"warmup","type":"TEST"}}' "$FN_URL" 2>/dev/null || echo 000)
    [ "$code" = "401" ] && break
    i=$((i+1))
    if [ "$i" -gt 120 ]; then
        echo "Function never came up; see /tmp/witness-webhook-serve.log" >&2
        exit 1
    fi
    sleep 1
done

cleanup_rows

PASS=0
FAIL=0
check() {
    desc=$1; expected=$2; actual=$3
    if [ "$expected" = "$actual" ]; then
        PASS=$((PASS+1)); echo "ok   $desc"
    else
        FAIL=$((FAIL+1)); echo "FAIL $desc (expected '$expected', got '$actual')" >&2
    fi
}

status_of() {
    # $1 = auth header value ("" for none), $2 = body
    if [ -n "$1" ]; then
        curl -s -o /tmp/witness-webhook-body.json -w '%{http_code}' -X POST \
            -H "Authorization: $1" -H 'Content-Type: application/json' \
            -d "$2" "$FN_URL"
    else
        curl -s -o /tmp/witness-webhook-body.json -w '%{http_code}' -X POST \
            -H 'Content-Type: application/json' -d "$2" "$FN_URL"
    fi
}

NOW_MS=$(($(date +%s) * 1000))
FUTURE_EXP_MS=$((NOW_MS + 15552000000))   # ~180 days out
USER_A="11111111-1111-4111-8111-111111111111"

event_json() {
    # $1 id, $2 type, $3 product, $4 env, $5 ts_ms, $6 extra (comma-led or empty)
    printf '{"api_version":"1.0","event":{"id":"%s","type":"%s","product_id":"%s","environment":"%s","event_timestamp_ms":%s,"app_user_id":"%s"%s}}' \
        "$1" "$2" "$3" "$4" "$5" "$USER_A" "$6"
}

# --- The doorman refuses what it must refuse -------------------------------

check "GET is refused" "405" "$(curl -s -o /dev/null -w '%{http_code}' "$FN_URL")"
check "no Authorization header -> 401" "401" \
    "$(status_of "" "$(event_json wtest-noauth INITIAL_PURCHASE com.avp.witness.atlas.sixmonth SANDBOX "$NOW_MS" '')")"
check "wrong secret -> 401" "401" \
    "$(status_of "definitely-wrong-secret" "$(event_json wtest-badauth INITIAL_PURCHASE com.avp.witness.atlas.sixmonth SANDBOX "$NOW_MS" '')")"
check "garbage JSON -> 400" "400" "$(status_of "$SECRET" '{not json')"
check "future-dated event -> 400" "400" \
    "$(status_of "$SECRET" "$(event_json wtest-future INITIAL_PURCHASE com.avp.witness.atlas.sixmonth SANDBOX $((NOW_MS + 3600000)) '')")"
check "unknown environment -> 400" "400" \
    "$(status_of "$SECRET" "$(event_json wtest-env INITIAL_PURCHASE com.avp.witness.atlas.sixmonth STAGING "$NOW_MS" '')")"
check "TEST ping acknowledged" "200" \
    "$(status_of "$SECRET" '{"event":{"id":"wtest-ping","type":"TEST"}}')"
check "retired witness_plus product ignored (200)" "200" \
    "$(status_of "$SECRET" "$(event_json wtest-oldplus INITIAL_PURCHASE witness_plus_monthly PRODUCTION "$NOW_MS" '')")"
check "retired product stored nothing" "0" \
    "$(psql_q "select count(*) from public.purchase_events where provider_event_id='wtest-oldplus';")"

# --- A genuine purchase is recorded exactly once ---------------------------

GRANT_BODY="$(event_json wtest-grant-1 INITIAL_PURCHASE com.avp.witness.atlas.sixmonth SANDBOX "$NOW_MS" ",\"expiration_at_ms\":$FUTURE_EXP_MS,\"transaction_id\":\"tx-1\",\"store\":\"APP_STORE\",\"period_type\":\"NORMAL\"")"
check "valid Atlas purchase -> 200" "200" "$(status_of "$SECRET" "$GRANT_BODY")"
check "purchase event stored once" "1" \
    "$(psql_q "select count(*) from public.purchase_events where provider_event_id='wtest-grant-1';")"
check "atlas snapshot active (sandbox)" "t" \
    "$(psql_q "select is_active from public.entitlement_snapshots where app_user_id='$USER_A' and entitlement_id='atlas_access' and environment='sandbox';")"
check "raw transaction id is not stored" "0" \
    "$(psql_q "select count(*) from public.purchase_events where provider_event_id='wtest-grant-1' and (transaction_id_hash = 'tx-1' or payload_redacted::text like '%tx-1%');")"

check "replayed event -> 200" "200" "$(status_of "$SECRET" "$GRANT_BODY")"
check "replay reported as duplicate" "duplicate" \
    "$(grep -o '"result":"[a-z]*"' /tmp/witness-webhook-body.json | cut -d'"' -f4)"
check "replay stored no second row" "1" \
    "$(psql_q "select count(*) from public.purchase_events where provider_event_id='wtest-grant-1';")"

# --- Sandbox never unlocks production --------------------------------------

check "sandbox row grants nothing in production deployment" "f" \
    "$(psql_q "set role authenticated; set request.jwt.claims = '{\"sub\":\"$USER_A\",\"role\":\"authenticated\"}'; select public.has_current_entitlement('atlas_access');" | tail -1)"

# --- Expiration flips access off; stale replays cannot flip it back --------

EXPIRE_BODY="$(event_json wtest-expire-1 EXPIRATION com.avp.witness.atlas.sixmonth SANDBOX $((NOW_MS + 60000)) ",\"expiration_at_ms\":$NOW_MS")"
check "expiration accepted" "200" "$(status_of "$SECRET" "$EXPIRE_BODY")"
check "atlas snapshot now inactive" "f" \
    "$(psql_q "select is_active from public.entitlement_snapshots where app_user_id='$USER_A' and entitlement_id='atlas_access' and environment='sandbox';")"

STALE_BODY="$(event_json wtest-stale-1 RENEWAL com.avp.witness.atlas.sixmonth SANDBOX $((NOW_MS - 86400000)) ",\"expiration_at_ms\":$FUTURE_EXP_MS")"
check "older replayed grant accepted (recorded)" "200" "$(status_of "$SECRET" "$STALE_BODY")"
check "older grant cannot resurrect access" "f" \
    "$(psql_q "select is_active from public.entitlement_snapshots where app_user_id='$USER_A' and entitlement_id='atlas_access' and environment='sandbox';")"

# --- Field Season is permanent; refunds revoke -----------------------------

FS_BODY="$(event_json wtest-fs-1 NON_RENEWING_PURCHASE com.avp.witness.fieldseason1 SANDBOX "$NOW_MS" ",\"transaction_id\":\"tx-fs\"")"
check "Field Season purchase -> 200" "200" "$(status_of "$SECRET" "$FS_BODY")"
check "Field Season snapshot active, no expiry" "true|" \
    "$(psql_q "select is_active || '|' || coalesce(expires_at::text,'') from public.entitlement_snapshots where app_user_id='$USER_A' and entitlement_id='field_season_1_access' and environment='sandbox';")"

FS_REFUND="$(event_json wtest-fs-refund CANCELLATION com.avp.witness.fieldseason1 SANDBOX $((NOW_MS + 120000)) ",\"cancel_reason\":\"CUSTOMER_SUPPORT\"")"
check "Field Season refund -> 200" "200" "$(status_of "$SECRET" "$FS_REFUND")"
check "refund revoked Field Season" "f" \
    "$(psql_q "select is_active from public.entitlement_snapshots where app_user_id='$USER_A' and entitlement_id='field_season_1_access' and environment='sandbox';")"

# --- The tip is gratitude, never an unlock ---------------------------------

TIP_BODY="$(event_json wtest-tip-1 NON_RENEWING_PURCHASE com.avp.witness.support.once SANDBOX "$NOW_MS" '')"
check "support tip -> 200" "200" "$(status_of "$SECRET" "$TIP_BODY")"
check "tip recorded in support_events" "1" \
    "$(psql_q "select count(*) from public.support_events where provider_transaction_key='event:wtest-tip-1';")"
check "tip created no entitlement" "0" \
    "$(psql_q "select count(*) from public.entitlement_snapshots where app_user_id='$USER_A' and product_id='com.avp.witness.support.once';")"

echo
if [ "$FAIL" -eq 0 ]; then
    echo "ALL WEBHOOK TESTS PASSED ($PASS checks)"
else
    echo "$FAIL WEBHOOK TESTS FAILED ($PASS passed)" >&2
    exit 1
fi
