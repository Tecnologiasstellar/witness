// RevenueCat webhook doorman (Phase 5, D-024).
//
// RevenueCat does not cryptographically sign webhook payloads; its security
// model is a shared-secret Authorization header configured in the RevenueCat
// dashboard. This function therefore:
//   1. accepts POST only,
//   2. compares the Authorization header against RC_WEBHOOK_AUTH in constant
//      time (fails closed if the secret is unset),
//   3. rejects future-dated events (clock tricks),
//   4. accepts only the four approved product IDs (D-020) — anything else,
//      including the retired witness_plus products, is acknowledged and
//      ignored so RevenueCat stops retrying but nothing is stored,
//   5. writes through ingest_revenuecat_event, which is idempotent per
//      event ID and monotonic per entitlement snapshot, and keeps
//      sandbox/production rows strictly separated.
//
// Secrets: RC_WEBHOOK_AUTH lives only in Edge Function secrets
// (supabase/functions/.env locally, `supabase secrets set` in production).
// It is never in the repo or the app.

import { createClient } from "npm:@supabase/supabase-js@2";

const FIELD_SEASON_PRODUCT = "com.avp.witness.fieldseason1";
const ATLAS_PRODUCTS = [
  "com.avp.witness.atlas.sixmonth",
  "com.avp.witness.atlas.annual",
];
const SUPPORT_PRODUCT = "com.avp.witness.support.once";
const KNOWN_PRODUCTS = [FIELD_SEASON_PRODUCT, ...ATLAS_PRODUCTS, SUPPORT_PRODUCT];

const GRANT_EVENTS = [
  "INITIAL_PURCHASE",
  "RENEWAL",
  "UNCANCELLATION",
  "PRODUCT_CHANGE",
  "SUBSCRIPTION_EXTENDED",
  "NON_RENEWING_PURCHASE",
];

const FUTURE_TOLERANCE_MS = 5 * 60 * 1000;

function json(status: number, body: Record<string, unknown>): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json" },
  });
}

async function sha256Hex(value: string): Promise<string> {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(value),
  );
  return Array.from(new Uint8Array(digest))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

// Constant-time comparison via fixed-length digests: hashing first removes
// any length leak, and the byte loop never exits early.
async function secretsMatch(presented: string, expected: string): Promise<boolean> {
  const a = new Uint8Array(
    await crypto.subtle.digest("SHA-256", new TextEncoder().encode(presented)),
  );
  const b = new Uint8Array(
    await crypto.subtle.digest("SHA-256", new TextEncoder().encode(expected)),
  );
  let diff = 0;
  for (let i = 0; i < a.length; i++) diff |= a[i] ^ b[i];
  return diff === 0;
}

function parseUUID(value: unknown): string | null {
  if (typeof value !== "string") return null;
  const uuid =
    /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
  return uuid.test(value) ? value.toLowerCase() : null;
}

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return json(405, { error: "method_not_allowed" });
  }

  const expectedAuth = Deno.env.get("RC_WEBHOOK_AUTH") ?? "";
  if (expectedAuth.length < 16) {
    // Fail closed: an unset or trivially short secret means the door stays shut.
    console.error("RC_WEBHOOK_AUTH is unset or too short; rejecting all events");
    return json(503, { error: "webhook_not_configured" });
  }
  const presentedAuth = req.headers.get("authorization") ?? "";
  if (!(await secretsMatch(presentedAuth, expectedAuth))) {
    return json(401, { error: "unauthorized" });
  }

  let body: unknown;
  try {
    body = await req.json();
  } catch {
    return json(400, { error: "invalid_json" });
  }
  const event = (body as { event?: Record<string, unknown> })?.event;
  if (!event || typeof event !== "object") {
    return json(400, { error: "missing_event" });
  }

  const eventType = typeof event.type === "string" ? event.type : "";
  if (eventType === "TEST") {
    return json(200, { handled: false, reason: "test_event" });
  }

  const eventID = typeof event.id === "string" ? event.id : "";
  const productID = typeof event.product_id === "string" ? event.product_id : "";
  const rawEnvironment =
    typeof event.environment === "string" ? event.environment.toLowerCase() : "";
  const occurredMs =
    typeof event.event_timestamp_ms === "number" ? event.event_timestamp_ms : NaN;

  if (!eventID || !eventType || !rawEnvironment || Number.isNaN(occurredMs)) {
    return json(400, { error: "malformed_event" });
  }
  if (rawEnvironment !== "sandbox" && rawEnvironment !== "production") {
    return json(400, { error: "unknown_environment" });
  }
  if (occurredMs > Date.now() + FUTURE_TOLERANCE_MS) {
    return json(400, { error: "future_dated_event" });
  }
  if (!KNOWN_PRODUCTS.includes(productID)) {
    // Acknowledge so RevenueCat stops retrying, but store nothing: unknown
    // and retired products never touch the mirror.
    console.warn(`ignored event ${eventID} for unknown product ${productID}`);
    return json(200, { handled: false, reason: "unknown_product" });
  }

  const appUserID = parseUUID(event.app_user_id);
  const occurredAt = new Date(occurredMs).toISOString();
  const expiresAt =
    typeof event.expiration_at_ms === "number"
      ? new Date(event.expiration_at_ms).toISOString()
      : null;
  const cancelReason =
    typeof event.cancel_reason === "string" ? event.cancel_reason : null;
  const transactionID =
    typeof event.transaction_id === "string" ? event.transaction_id : null;
  const transactionHash = transactionID ? await sha256Hex(transactionID) : null;

  // Projection mapping. null entitlement = record the event, change nothing.
  let entitlementID: string | null = null;
  let isActive: boolean | null = null;
  let willRenew: boolean | null = null;
  let snapshotExpiresAt: string | null = null;
  let supportKey: string | null = null;

  if (productID === SUPPORT_PRODUCT) {
    if (GRANT_EVENTS.includes(eventType)) {
      supportKey = transactionHash ?? `event:${eventID}`;
    }
  } else if (productID === FIELD_SEASON_PRODUCT) {
    entitlementID = "field_season_1_access";
    if (GRANT_EVENTS.includes(eventType)) {
      isActive = true;
      willRenew = false;
      snapshotExpiresAt = null; // permanent (D-020)
    } else if (eventType === "CANCELLATION" && cancelReason === "CUSTOMER_SUPPORT") {
      isActive = false; // refund
    } else {
      entitlementID = null;
    }
  } else {
    entitlementID = "atlas_access";
    if (GRANT_EVENTS.includes(eventType)) {
      isActive = true;
      willRenew = true;
      snapshotExpiresAt = expiresAt;
    } else if (eventType === "CANCELLATION") {
      if (cancelReason === "CUSTOMER_SUPPORT") {
        isActive = false; // refund: access ends now
      } else {
        // Auto-renew turned off: access continues until the paid-through
        // date; the server check enforces expires_at.
        isActive = true;
        willRenew = false;
        snapshotExpiresAt = expiresAt;
      }
    } else if (eventType === "EXPIRATION") {
      isActive = false;
      willRenew = false;
      snapshotExpiresAt = expiresAt;
    } else {
      // BILLING_ISSUE, TRANSFER, and anything unrecognized: record only.
      // Access lapses naturally at expires_at (fail closed, D-022).
      entitlementID = null;
    }
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    { auth: { persistSession: false } },
  );

  const { data, error } = await supabase.rpc("ingest_revenuecat_event", {
    p_event_id: eventID,
    p_app_user_id: appUserID,
    p_product_id: productID,
    p_event_type: eventType,
    p_environment: rawEnvironment,
    p_transaction_id_hash: transactionHash,
    p_occurred_at: occurredAt,
    p_payload_redacted: {
      type: eventType,
      store: typeof event.store === "string" ? event.store : null,
      period_type: typeof event.period_type === "string" ? event.period_type : null,
      cancel_reason: cancelReason,
    },
    p_entitlement_id: entitlementID,
    p_is_active: isActive,
    p_expires_at: snapshotExpiresAt,
    p_will_renew: willRenew,
    p_support_key: supportKey,
  });

  if (error) {
    console.error(`ingest failed for event ${eventID}: ${error.message}`);
    return json(500, { error: "ingest_failed" });
  }

  return json(200, { handled: true, result: data });
});
