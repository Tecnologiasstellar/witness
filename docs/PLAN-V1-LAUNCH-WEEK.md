# Witness V1.0 launch week — plan of record

Written 2026-08-27 (Wednesday night wrap). Pickup: **Monday 2026-08-31**.
Goal: **V1.0 MVP submitted to the App Store**, ahead of the RevenueCat
Shipathon submission (2026-09-15) and Devpost deadline (2026-09-30).

## Where we stand tonight (all pushed, all verified)

- **Content is DONE.** Field Season One edition complete: 12 pieces
  (opening letter, 8 chapters, 2 interludes, closing synthesis), all
  founder-approved, all narrated by Ruth (~80 min, rights records on
  file), every piece with verified take-action doors and share copy.
  Season plate "The Counted Few" drawn and bundled. Field album PDF
  export shipped and smoke-tested.
- **Commerce is LIVE in sandbox.** Four products in ASC + RevenueCat at
  approved prices; entitlements and offering wired; founder-executed
  sandbox purchases verified (Field Season, Atlas annual, tip).
  Decision log fully closed (D-001–D-025 all accepted).
- **Engineering green.** 65 core tests + app tests passing; repo
  relocated out of iCloud; production content pipeline proven
  (markdown → approval gate → JSON → narration → bundle).

## Monday 2026-08-31 — the busy day (in order)

### Block 1 — Truth and version (Claude solo, founder ratifies) ~1h
1. **Truthfulness pass on every commerce/preview string.** The Field
   Season preview still says wording from the "not yet on sale" era —
   now false. Audit every user-facing claim against reality (8 chapters
   → now 12 pieces; "chapters arrive as free updates" → season complete).
2. **Version bump to 1.0.0** (MARKETING_VERSION in project.yml), build
   number discipline for TestFlight.
3. Full test suite + device build to the founder's iPhone for a
   walkthrough of the finished edition (letter → doors → album export).

### Block 2 — Purchase matrix remainder (joint dashboard session) ~1h
Founder on device + ASC, Claude guiding one step at a time:
4. **Restore purchases** flow (delete app, reinstall, restore).
5. **Atlas six-month** sandbox purchase (never yet exercised).
6. **Ask to Buy** (deferred purchase) if the sandbox account allows.
7. Accelerated renewal/expiry observation on the sandbox subscription;
   confirm the app fails closed at expiry (D-022 behavior).

### Block 3 — App Store record (joint, founder types, Claude drafts) ~2h
8. **App metadata**: name, subtitle, description, keywords, categories —
   Claude drafts from the season's real voice, founder ratifies/pastes.
9. **Privacy**: App Privacy questionnaire (purchases via RevenueCat =
   "Purchases" data type; no tracking), privacy policy page on the new
   official domain (witness_web — coordinate with the parallel session's
   domain work).
10. **Screenshots**: 6.7" and 6.1" sets from the simulator — the shelf,
    a chapter with narration, a doors block, the plate/synthesis, the
    album export. Claude produces, founder approves.
11. Age rating, review notes (sandbox demo account instructions).

### Block 4 — TestFlight ~1h
12. Archive, upload, internal TestFlight to the founder's iPhone.
13. Founder end-to-end pass on the TestFlight build (purchases in
    sandbox, narration, album, doors).

## Tuesday–Wednesday
- **Demo video** (<2 min) for the Shipathon — needs founder's hands and
  voice decisions; Claude writes the shot list Monday night.
- **Webhook to production** (founder-gated secrets): deploy Supabase Edge
  Function, set RC_WEBHOOK_AUTH, point RevenueCat webhook at it, replay
  the adversarial suite against prod. (Not a launch blocker — the app is
  StoreKit-truth on device — but it is built and tested; an hour together
  finishes it.)
- **Submit for App Store review.** Buffer days remain before 09-15.

## Parking lot (not launch blockers, tracked)
- Ritual first-tap UI flake (task chip open); StoreKitTest CLI blocker
  (documented); delete retired `~/Documents/CODEX` after reboot; set up
  Time Machine (no backup destination configured — flagged 08-27);
  legacy `backend/` vs `supabase/` consolidation; premium signed-URL
  audio path (post-revenue); Field Season 2 uses the proven pipeline.

## Ground rules that got us here (keep)
- Founder approvals are formal even when informal — log same day.
- Backups before anything destructive.
- Content ships only through the approval-gated pipeline.
- Every claim sourced; every door verified; every date honest.
