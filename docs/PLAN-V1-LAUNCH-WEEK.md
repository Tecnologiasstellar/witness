# Witness V1.0 launch week — plan of record

## Day 2 outcome (Tuesday 2026-09-01) — TestFlight upload BLOCKED

**Done:** export-compliance key (`ITSAppUsesNonExemptEncryption: NO`)
added via an XcodeGen `info:` block, version/build kept sourced from
build settings, build bumped to **1.0.0 (4)** (commit `fbe2597`).
WitnessCore 65/65 and app unit tests 13/13 green. Release archive built
and verified (key present, team L5R9XW45B6) — saved permanently in
Xcode Organizer (`~/Library/Developer/Xcode/Archives/2026-09-01/`).

**Blocked:** the upload itself. The founder's Apple Distribution
certificates are frozen by an Apple developer account transition — no
"iOS Distribution" cert can be created until it clears. When it does:
Xcode → Window → Organizer → select Witness 1.0.0 (4) → Distribute App
→ App Store Connect → Upload (defaults). No rebuild needed.

**Consequently deferred:** Block 2 purchase matrix (runs on the
TestFlight build) and submission. **The account transition is now the
critical path to the 09-15 target** — check its status daily.

**Doable while blocked:** demo video shot list, optional webhook
deploy, tip-IAP screenshot check, Annual-row glitch check.

## Day 1 outcome (Monday 2026-08-31, wrapped) — pickup Tuesday 2026-09-01

**Done today, all pushed and verified:**
- Block 1 complete: truthfulness pass on every commerce string, version
  1.0.0 (build 3), witnessatlas.com links, all tests green, founder
  walkthrough build installed and reviewed on the founder's iPhone 12.
- Paid-surface redesign shipped (slices A+B): Field Season page is a
  book cover (season plate, computed stats 12/8/75min, playable letter
  narration sample, real contents with plate thumbnails); contextual
  chapter door on the Today card (kākāpō → chapter 02).
- App Store record V1 drafted and **the full ASC paste session is done**:
  name **Witness-Endangered Species**, subtitle "Take action &
  help:once a week", privacy label (Data Not Linked to You), age 4+,
  URLs, description, keywords, screenshots (final 1284×2778 set in
  docs/appstore/screenshots/final), review notes, manual release
  selected, all four IAPs metadata-complete with review screenshots
  (docs/appstore/iap-review). "Prepare for Submission" on products is
  the normal resting state in current ASC — they attach at submission.
- Icon confirmed final (shipped arcs-and-dot, 98ca3e0). Server
  notifications already point at RevenueCat. Content Rights set.

**Tuesday 2026-09-01, in order:**
1. **Block 4 first — TestFlight.** Claude adds
   `ITSAppUsesNonExemptEncryption: NO` to Info.plist keys (kills the
   export-compliance question), regenerates, tests, then joint archive +
   upload with founder signing. Internal TestFlight to the founder.
2. **Block 2 on the TestFlight build** (joint, ~1h): restore purchases
   (delete/reinstall/restore), Atlas six-month sandbox purchase (never
   exercised), Ask to Buy if sandbox allows, accelerated renewal/expiry
   → confirm fail-closed (D-022).
3. **Shipathon demo video shot list** (Claude drafts; founder shoots).
4. If time: production webhook deploy (founder-gated secrets; optional).
Then **submit for review** — buffer remains before 09-15.

**Small opens:** verify the tip IAP's review screenshot actually saved;
the double-rendered Annual row in the Atlas group listing is a display
glitch if both rows open the same record (do not delete anything).


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
