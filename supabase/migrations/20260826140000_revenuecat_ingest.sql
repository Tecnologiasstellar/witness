-- Atomic ingest for verified RevenueCat webhook events. The Edge Function
-- (supabase/functions/revenuecat-webhook) authenticates the request and maps
-- the event; this function makes the write idempotent (event-ID primary key)
-- and the entitlement projection monotonic (an older event can never
-- overwrite a newer snapshot). Only service_role may execute.
-- Rollback: drop function public.ingest_revenuecat_event.

create or replace function public.ingest_revenuecat_event(
    p_event_id text,
    p_app_user_id uuid,
    p_product_id text,
    p_event_type text,
    p_environment text,
    p_transaction_id_hash text,
    p_occurred_at timestamptz,
    p_payload_redacted jsonb,
    p_entitlement_id text,
    p_is_active boolean,
    p_expires_at timestamptz,
    p_will_renew boolean,
    p_support_key text
) returns text
language plpgsql
security definer
set search_path = public
as $$
begin
    insert into purchase_events (
        provider_event_id, app_user_id, product_id, event_type,
        environment, transaction_id_hash, occurred_at, payload_redacted
    ) values (
        p_event_id, p_app_user_id, p_product_id, p_event_type,
        p_environment, p_transaction_id_hash, p_occurred_at,
        coalesce(p_payload_redacted, '{}'::jsonb)
    )
    on conflict (provider_event_id) do nothing;

    if not found then
        return 'duplicate';
    end if;

    if p_support_key is not null then
        -- Support tip: recorded for gratitude/accounting, never an entitlement.
        insert into support_events (
            provider_transaction_key, app_user_id, product_id, environment, occurred_at
        ) values (
            p_support_key, p_app_user_id, p_product_id, p_environment, p_occurred_at
        )
        on conflict (provider_transaction_key) do nothing;
    elsif p_entitlement_id is not null and p_app_user_id is not null then
        insert into entitlement_snapshots as s (
            app_user_id, entitlement_id, is_active, product_id,
            expires_at, will_renew, environment, provider_updated_at
        ) values (
            p_app_user_id, p_entitlement_id, coalesce(p_is_active, false),
            p_product_id, p_expires_at, p_will_renew, p_environment, p_occurred_at
        )
        on conflict (app_user_id, entitlement_id, environment) do update
        set is_active = excluded.is_active,
            product_id = excluded.product_id,
            expires_at = excluded.expires_at,
            will_renew = excluded.will_renew,
            provider_updated_at = excluded.provider_updated_at,
            updated_at = now()
        where s.provider_updated_at <= excluded.provider_updated_at;
    end if;

    return 'recorded';
end
$$;

revoke execute on function public.ingest_revenuecat_event from public, anon, authenticated;
grant execute on function public.ingest_revenuecat_event to service_role;
