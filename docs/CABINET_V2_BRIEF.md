# Cabinet v2 — structure and development plan

Owner direction, 2026-08-24 (recorded from AV's brief, with the Opal / Ten Percent Happier / Klarna grid references): the Cabinet becomes the **personal collection** — only species the user has actually witnessed — with a richer per-animal detail view (where it lives, current status, protection efforts) and a path from witnessing to **Helping**: a space where conservation initiatives (and eventually paying sponsors) appear, and where a user marks active engagement with a specific animal.

## Information architecture

```
CABINET (tab)
├─ Segments: WITNESSED · HELPING · ARCHIVE
├─ WITNESSED  → large image-led rows (Opal-style): plate artwork,
│               name, "WITNESSED · <date>", helping badge when active
├─ HELPING    → same rows filtered to animals the user marked as helping,
│               showing "HELPING SINCE · <date>"
├─ ARCHIVE    → the previous featured-day history (every past plate,
│               including missed days); stays the Witness+ surface —
│               free window 7 days, `plus` unlocks all (preserves D-016)
└─ Row tap → COLLECTION DETAIL
    ├─ Hero artwork + status chip + name
    ├─ Witnessed date · private note shortcut
    ├─ Live witness count
    ├─ WHERE IT LIVES (GeneralizedRangeMap — reused)
    ├─ CURRENT STATUS (status wording + trend + threats, from stats)
    ├─ HELP & PROTECTION
    │   ├─ Verified conservation programs (org, initiative, summary, link)
    │   └─ "I'M HELPING" — records local helping state + helping_started event
    └─ Sources footer
```

**Why the ARCHIVE segment survives:** if the Cabinet were witnessed-only, Witness+ (full archive back to day one, D-016) would have no surface. The personal witnessed collection is free forever — you earned it by showing up; the complete featured-plate archive (including missed days) remains the paid depth.

## Grid design (from the reference screenshots)

Opal's milestone list is the model: one column of large rows, each with a
prominent square plate image (~110pt), then eyebrow (date line, technical
caps), name (serif display), and a quiet status line; helping rows carry a
sage accent, mirroring how Opal highlights the unlocked reward. Larger
imagery per AV; names and dates always visible.

## The "sponsor" model — honest by construction

- Schema: `ConservationProgram { id, organization, title, summary, url, kind, sourceIDs, lastVerified }` on the species record. `kind` is `"program"` (a real initiative by an established conservation actor, editorially selected, unpaid) or `"sponsor"` (a disclosed commercial partner). **v1 ships only `program` entries**; the `sponsor` kind exists so paid partnerships later require no schema change — and when they arrive they are labeled "SPONSOR" in the UI, never mixed silently with editorial picks (trust policy: no disguised ads).
- Every program URL is live-verified at carding time and carries `lastVerified`.
- "I'M HELPING" records intent honestly: measurement stays `self_reported`/`opened` per the action policy — the UI never claims a conservation outcome from tapping a button.
- Helping state is stored on-device (like witnesses) and emits a `helping_started` analytics event (name + species only).

## Schema & backend changes

1. Core: `ConservationProgram` + `programs: [ConservationProgram]?` on `SpeciesRecord`; validator: URLs https, sourceIDs subset, `lastVerified` ISO date.
2. Core: `FileHelpingStore` — durable on-device record `{speciesID, startedAt}`, idempotent per species, same atomic-file pattern as witnesses.
3. Analytics: `helping_started` event (existing events table; no migration).
4. No new backend tables for v1. Later (post-MVP): aggregate helping counts view, mirroring witness counts.

## Development phases

- **Phase 1 (now):** brief + schema + Cabinet grid v2 (three segments, Opal-style rows, dates, helping badges) + Collection Detail with map, status, programs, and the I'M HELPING flow. Vaquita ships with two verified programs (Sea Shepherd vaquita campaign; VaquitaCPR); other species gain programs as their v2 content lands.
- **Phase 2 (with catalog v2 rollout):** programs for all species; helping date on share cards ("helping since …" stays private-by-default).
- **Phase 3 (post-MVP):** aggregate helping counts; sponsor kind activated only when a real, disclosed partnership exists; per-program deep engagement (updates feed from partners).
