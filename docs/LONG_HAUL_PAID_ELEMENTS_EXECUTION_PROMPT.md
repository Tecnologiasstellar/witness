# Exact long-haul execution prompt: Witness paid elements

Version: 1.0  
Date: 2026-08-26  
Purpose: paste this prompt into a repository-aware coding agent with `/Users/avp/Documents/CODEX/Witness` open.

---

You are the principal engineer and long-haul product operator for Witness. Work as a senior native iOS engineer, backend architect, database and security engineer, product designer, accessibility lead, content-systems architect, QA lead, and App Store release operator. Optimize for a world-class product that a solo founder can actually maintain.

## Long-haul goal

Transform the existing Witness repository into the next complete paid-enabled iOS app version while preserving the free ethical ritual and the app's quiet, minimal character.

The final engineering output must be an updated, installable, release-candidate version of the Witness iOS app that comprehensively implements:

1. **Witness** - complete free access; not an IAP.
2. **Field Season** - permanent non-consumable purchase.
3. **Atlas - 6 Months** - auto-renewable subscription.
4. **Atlas - Annual** - auto-renewable subscription with exactly the same access as the six-month product.
5. **Support Witness** - repeatable consumable tip that grants no entitlement.

The final output is not a plan, a prototype paywall, or empty commerce scaffolding. It is the updated app version with its provider-neutral access domain, contextual purchase experience, RevenueCat integration, StoreKit test configuration, Supabase database and secure functions, premium-content authorization, Field Season and Atlas content structures, offline behavior, privacy and accessibility work, automated tests, release documentation, and independently stated release gates.

Do not claim the goal is complete until the Definition of Done at the end of this prompt is satisfied. When an external account, credential, rights-cleared asset, reviewed content item, physical device, or founder approval is required, complete every safe local task first, record the exact blocker, and request only the missing action. Never replace missing evidence with a mock readiness claim.

## Persistent goal-driven operating mode

If the environment supports persistent goals, create or adopt exactly one active goal with this objective:

> Deliver Witness 0.2.0 as a paid-enabled iOS release candidate implementing free Witness access, permanent Field Season ownership, one Atlas entitlement with six-month and annual billing, and a no-entitlement Support Witness consumable, together with the secure backend, content gates, accessibility, privacy, tests, and release evidence defined in `docs/ACCESS_AND_COMMERCE_SOURCE_OF_RECORD.md`.

Do not create a duplicate goal if one already exists. Do not mark the goal complete because a plan was written, code compiled, or one purchase worked.

Create and continuously maintain `docs/PAID_ELEMENTS_EXECUTION_STATUS.md` as the restart-safe execution ledger. It must contain:

- objective and non-negotiables;
- current phase and one current vertical outcome;
- completed work with dated evidence;
- files and migrations changed;
- test commands and exact results;
- external environments actually verified;
- privacy, rights, and data changes;
- open defects and risks;
- blockers requiring founder action;
- rollback notes; and
- the single next highest-leverage action.

On every continuation or after context compaction:

1. read `docs/PAID_ELEMENTS_EXECUTION_STATUS.md`;
2. inspect current git status and preserve all user work;
3. verify the last claimed evidence before relying on it;
4. resume the current vertical outcome rather than restarting; and
5. continue while safe in-scope work remains.

Maintain a plan with at most one phase in progress. Finish and validate a vertical slice before expanding breadth. Do not stop after producing the initial plan.

## Repository and required reading

Work in `/Users/avp/Documents/CODEX/Witness`.

Before changing anything, read completely:

- `AGENTS.md`
- `README.md`
- `docs/ACCESS_AND_COMMERCE_SOURCE_OF_RECORD.md`
- `docs/ARCHITECTURE.md`
- `docs/DECISIONS.md`
- `docs/PRODUCT_STRATEGY.md`
- `docs/MVP_SPEC.md`
- `docs/FOUR_WEEK_EXECUTION_PLAN.md`
- `docs/COMPETITION_AND_RELEASE_GATES.md`
- `docs/CONTENT_TRUST_AND_RIGHTS.md`
- `docs/IMPLEMENTATION_STATUS.md`
- `docs/MASTER_BUILD_PROMPT.md`
- `docs/VISUAL_REFERENCE_AUDIT.md` before any presentation change

Then inspect:

- `project.yml` and the checked-in Xcode project;
- `WitnessApp`, `WitnessCore`, tests, resources, and current schemas;
- all existing purchase, network, catalog, persistence, configuration, privacy, and analytics code;
- current git status, including untracked files; and
- the availability of XcodeGen, Xcode, simulators, connected devices, Supabase tooling, and existing local configuration without revealing secrets.

`project.yml` is the editable Xcode project source of truth. Preserve the current `WitnessApp -> WitnessCore` dependency direction. Never clean, overwrite, reset, or absorb unrelated user changes. Preserve the existing untracked `witness_web/` directory unless the founder explicitly changes its scope.

## Start-of-run response

Before implementation, provide a concise evidence-backed audit containing:

1. current app and repository state;
2. dirty/untracked work being preserved;
3. confirmed architecture and current working vertical slice;
4. conflicts between older documents and the commerce source of record;
5. the phase plan and first vertical outcome;
6. files and systems likely affected;
7. required acceptance evidence;
8. principal product, security, and data risks;
9. rollback for the first slice; and
10. external actions that will require explicit founder approval.

After this audit, begin safe local implementation immediately. Do not wait for general confirmation of the plan. Ask only when a missing decision would materially alter the product or when an action is external, destructive, paid, public, credential-dependent, or irreversible.

## Authoritative product model

There are five user-facing engagement choices but only three authorization concepts:

```text
free content
permanent ownership of the first Field Season edition
active Atlas access
```

Support Witness is a transaction, not an access state. Atlas billing duration is purchase metadata, not a second entitlement.

Required authorization policy:

```text
free content       -> everyone
field_season_1     -> owns Field Season permanently OR Atlas is active
atlas content      -> Atlas is active
support purchase   -> never changes access
```

Never implement five ranked tiers, a generic role hierarchy, supporter levels, virtual currency, points, completion mechanics, public badges, a donor roll, or a commerce tab.

## Product configuration

Current bundle ID: `com.avp.witness`.

Use these local/test identifiers and treat them as proposed immutable production IDs until the founder explicitly confirms creation in App Store Connect:

| Product | Type | Product ID |
|---|---|---|
| Field Season | Non-consumable | `com.avp.witness.fieldseason1` |
| Atlas - 6 Months | Auto-renewable subscription | `com.avp.witness.atlas.sixmonth` |
| Atlas - Annual | Auto-renewable subscription | `com.avp.witness.atlas.annual` |
| Support Witness | Consumable | `com.avp.witness.support.once` |

Subscription group:

- reference name: `Witness Atlas Access`;
- display name: `Witness Atlas`;
- one subscription level;
- both Atlas products at that same level;
- six-month and one-year durations;
- identical content and entitlement;
- no public free trial at launch.

RevenueCat mapping:

| Object | Identifier | Products |
|---|---|---|
| Entitlement | `field_season_1_access` | Field Season |
| Entitlement | `atlas_access` | Both Atlas subscriptions |
| Offering | `witness_access_v1` | All purchasable products |
| Package | `field_season_1` | Field Season |
| Package | `atlas_six_month` | Atlas - 6 Months |
| Package | `atlas_annual` | Atlas - Annual |
| Package | `support_once` | Support Witness; no entitlement |

Never hardcode production prices, currency, renewal dates, savings, or eligibility. Display localized StoreKit/RevenueCat values. Calculate any equivalent-value statement from the current decimal price and duration. Show `Best value` only when mathematically true in the current storefront.

## Product and ethical non-negotiables

- Keep Today, the complete public record, sources, Witness action, honest count, credible action, private local record/reflection, and basic share free.
- Do not show payment, sign-in, or notification permission before the first complete Witness ritual.
- Monetization appears only at a real premium-value boundary or in the Index/Access area.
- Field Season is a finite permanent digital edition. It is not ownership of an animal, a conservation result, or access to every future season.
- Active Atlas includes the released Field Season and the complete Atlas library only while Atlas remains entitled.
- Six-month and annual Atlas products provide identical access and differ only by billing duration and price.
- Support Witness is an optional repeatable tip to the developer/editorial operation. It unlocks nothing and confers no recognition.
- Do not use `donation`, `tax-deductible`, `adopt`, `save this animal by paying`, `prove you care`, `collect them all`, or equivalent claims.
- No fear manipulation, guilt, tragedy porn, confetti, fabricated urgency, artificial scarcity, completion pressure, moral ranking, or competitive progress.
- Do not add a visible account, public profile, public UGC, social feed, following, messaging, leaderboard, or live chat.
- Private reflections remain on-device and never enter analytics, logs, network payloads, crash breadcrumbs, or shares.
- Field trips and physical experiences are out of scope for this app version.
- Do not change the current daily/weekly content cadence as part of commerce work; cadence requires a separate decision.
- No exact sensitive-species locations.
- No live IUCN API use without an appropriate commercial agreement.
- No content or media ships without source provenance, commercial-rights status, review state, and last-verified data.
- Preserve `PENDING` and null. Fail closed rather than upgrading incomplete evidence to approval.

## Required final app experience

Do not create a five-choice pricing wall. Implement contextual entry points:

```text
Today and public species record
  -> complete free ritual

Field Season preview
  -> contents, deliverables, sample chapter/audio, permanence, live price
  -> purchase or restore

Atlas-only content boundary
  -> one calm sheet
  -> six-month or annual selection
  -> identical access, live price and renewal language

Index / Access
  -> free promise
  -> Field Season ownership state
  -> Atlas state and verified date
  -> Restore Purchases
  -> Manage Subscription
  -> Support Witness
```

Required commerce states:

- loading products;
- products unavailable;
- ready;
- purchasing;
- user cancelled;
- Ask to Buy or other pending state;
- verified purchase;
- successful purchase awaiting entitlement reconciliation;
- failed with retry;
- restore with changes;
- restore with nothing found;
- offline;
- permanent ownership active or revoked;
- subscription active, cancelled but active, grace period, billing retry, expired, revoked, or unknown; and
- repeated Support purchase.

Unknown state must preserve free access and fail safely. Never unlock from a button tap before verified provider state.

## Architecture requirements

Preserve:

```text
WitnessApp
  SwiftUI and presentation
  composition root
  RevenueCat and StoreKit adapters
  Supabase/network adapters
  Keychain and local-file adapters
        |
        v
WitnessCore
  stable domain models
  content-access policy
  provider-neutral protocols
  catalog validation
  deterministic tests
```

Rules:

- `WitnessCore` must not import SwiftUI, StoreKit, RevenueCat, Supabase, or a vendor analytics SDK.
- Add narrow protocols only with their first concrete use.
- No SDK calls from SwiftUI views and no global service locator.
- Keep the working `FileWitnessRepository` unless a demonstrated requirement justifies migration.
- Keep local stores versioned, atomic, migration-tested, and independently reversible.
- Use a single typed product allow-list and provider-neutral `AccessSnapshot`.
- Map RevenueCat `CustomerInfo` to domain state at the adapter boundary.
- Use a Debug/test-only StoreKit harness behind `PurchaseService`; production purchase execution uses RevenueCat.
- Configure RevenueCat once in the composition root using only the public Apple SDK key.
- Do not add generic vendor paywall UI unless separately approved; preserve the Witness design language.
- Release builds must reject Test Store keys and active local StoreKit configuration.
- The reviewed bundled catalog remains the offline fallback. Invalid remote content never replaces the last known-good catalog.
- Premium media uses private storage, server authorization, short-lived signed URLs, checksums, and explicit cache policy.
- Atlas expiry locks Atlas-only cached media but never deletes user-authored notes or permanent Field Season access.

## Identity, backend, and database requirements

Do not build a visible profile. Separate:

1. local preferences and private journal data;
2. a random pseudonymous service identity stored securely for idempotency and backend authorization; and
3. Apple/RevenueCat purchase identity and restore behavior.

Use silent Supabase anonymous authentication only if required for secure RLS-protected access. If used, document reinstall, restore, transfer, retention, and future identity-linking behavior. Do not imply that invisible infrastructure is a social account.

Implement migration-controlled Supabase/Postgres structures defined in `docs/ACCESS_AND_COMMERCE_SOURCE_OF_RECORD.md`, including:

- catalog releases;
- content items;
- content collections and ordered items;
- media assets and rights metadata;
- idempotent Witness events;
- server-derived Witness aggregates;
- redacted RevenueCat purchase events;
- current entitlement snapshots; and
- Support events that never drive access or recognition.

Security requirements:

- RLS enabled and deny-by-default on every client-accessible table.
- Public reads limited to released free content and safe aggregates.
- Premium content and signed media require current server-verified entitlement.
- Mobile clients cannot write purchase events, entitlement snapshots, support events, aggregate counts, editorial approval, or rights approval.
- Witness submission occurs through a rate-limited idempotent function/RPC and returns the authoritative aggregate.
- RevenueCat webhook validates its authorization value and HMAC over untouched raw request bytes, checks timestamp tolerance with constant-time comparison, allow-lists products, separates sandbox/production, and deduplicates provider event IDs.
- Webhook retries are safe and idempotent.
- A secure, rate-limited server reconciliation path may refresh provider state after a new purchase; never trust a client Boolean as proof.
- Service-role keys, webhook secrets, receipts, tokens, and signing material remain server-side and out of logs/source control.
- Premium assets live in private storage and are downloaded only from short-lived signed URLs.
- Add migration, function, RLS allow/deny, webhook replay, environment-isolation, and unauthorized-media tests.

## Paid content required before production availability

Do not expose a production purchase for an empty promise.

Field Season must contain all deliverables defined in the source of record, including:

- opening field letter;
- eight complete premium species chapters built on free public records;
- rights-approved narration and transcripts for every promised narrated chapter;
- two sourced system interludes;
- one generalized, accessible ecosystem plate;
- closing synthesis;
- permanent attributed field album/export where rights permit; and
- one scheduled return-note contract.

Atlas must have real continuing value before subscriptions become available, including:

- all released Field Seasons while active;
- full released archive and restrained search/filtering;
- curated thematic paths;
- premium narration and transcripts;
- extended field notes and system explainers;
- Return Desk corrections and updates;
- a functioning monthly Field Dispatch production workflow with at least one real released dispatch; and
- offline access and storage controls.

Every production sentence maps to a source. Every action, asset, narration, transcript, illustration, export, and map has the required provenance, commercial-rights, attribution, review, accessibility, and last-verified state. No AI output is treated as a factual source or automatic approval. Rights-pending or editorial-pending content remains unavailable and blocks any paywall promise that depends on it.

## Required execution phases

Execute these phases in order unless the audit proves a safer dependency order. Each phase must end in a working, reviewable vertical outcome with evidence.

### Phase 0 - reconcile and baseline

- Audit the working tree, code, tests, current evidence, SDKs, and configuration.
- Adopt the source of record in the execution ledger.
- Find and reconcile conflicting `Witness+`, monthly, trial, archive-window, and navigation language.
- Record architecture decisions for purchases, identity, database, premium delivery, and environment separation.
- Establish the initial test baseline before changing code.
- Do not modify external services.

### Phase 1 - provider-neutral access domain

- Implement access requirements, Atlas states, access snapshot, commerce products, purchase outcomes, restore outcomes, product allow-list, access policy, `PurchaseService`, and access cache protocol.
- Implement fake/test services covering every state.
- Add deterministic access-matrix, lapse, revocation, unknown-state, and migration tests.
- Prove no forbidden provider import enters `WitnessCore`.

### Phase 2 - local commerce vertical slice

- Create the local StoreKit configuration with four products and one subscription group.
- Add Debug/test-only StoreKit execution behind `PurchaseService`.
- Implement the Index access overview, Field Season preview, Atlas purchase sheet, Support screen, Restore, and Manage Subscription route.
- Integrate the surfaces contextually without a new tab.
- Implement all purchase/loading/offline/pending/expiry states.
- Add VoiceOver, Dynamic Type, Reduce Motion, contrast, touch-target, and UI-test support.
- Automate StoreKitTest scenarios before adding a live provider.

### Phase 3 - RevenueCat production adapter

- Add a pinned RevenueCat SPM dependency through `project.yml`, regenerate the project, and inspect the diff.
- Configure Test Store, Sandbox, and Release/App Store environments separately.
- Map offerings and `CustomerInfo` into provider-neutral domain state.
- Refresh on launch, foreground, purchase, restore, provider callback, and explicit retry.
- Prove both Atlas products produce the same entitlement.
- Prove Field Season persistence and Support repeatability/no-entitlement behavior.
- Add Release safeguards against test configuration.
- Capture Test Store evidence without treating it as Sandbox evidence.

### Phase 4 - Supabase foundation and honest community count

- Add committed migrations, RLS policies, local seed fixtures, functions, redacted environment templates, and setup documentation.
- Implement secure pseudonymous identity if required.
- Implement idempotent Witness submission, authoritative aggregates, and a durable offline outbox with retry/backoff/reconciliation.
- Implement released catalog manifests and last-known-good fallback.
- Prove unauthorized access fails and duplicate events do not increment.

### Phase 5 - webhook and premium delivery

- Implement the authenticated, HMAC-verified, replay-resistant RevenueCat webhook.
- Ingest and project purchase lifecycle state idempotently.
- Handle initial purchase, renewal, crossgrade/product change, cancellation, uncancellation, billing issue, expiration, refund/revocation, transfer, and consumable events.
- Separate sandbox and production.
- Implement premium manifest and short-lived media authorization.
- Prove clients cannot self-grant access or download premium media without current entitlement.

### Phase 6 - one complete Field Season chapter

- Extend the content contracts without breaking current canonical IDs.
- Build one production-quality premium chapter end to end with approved sources, media rights, narration, transcript, evidence, safe location, offline download, access restoration, and export proof where permitted.
- Test on a physical iPhone before scaling the content model.
- Do not sell Field Season yet.

### Phase 7 - complete paid inventory and solo-founder operations

- Complete every Field Season deliverable.
- Complete enough Atlas material and the first actual dispatch to make every subscription claim true.
- Create repeatable content templates, validation tooling, correction/withdrawal behavior, rights-revocation behavior, and an editorial operations runbook.
- Keep production products unavailable while any promised deliverable is missing or pending.

### Phase 8 - privacy, accessibility, support, and release quality

- Implement accurate privacy manifest and App Privacy mapping for every SDK, identifier, purchase field, backend transfer, analytic event, and diagnostic.
- Wire live privacy, terms, support, and correction routes after approval.
- Implement export/delete/reset of local user-authored data without deleting purchases.
- Complete simulator and direct-human accessibility verification.
- Test locale/currency, offline/slow network, timezone, relaunch, upgrade/migration, storage pressure, fresh install, and supported devices.
- Write purchase support, data retention/deletion, incident response, and App Review instructions.

### Phase 9 - external product configuration and Sandbox

- Request approval before creating or editing App Store Connect, RevenueCat, Supabase production, signing, TestFlight, or public records.
- After approval, configure one environment at a time and keep secrets out of source control.
- Verify App Store Connect product metadata, subscription group, prices, review screenshots, and reviewer access.
- Verify RevenueCat production mapping and webhook environment.
- Test physical-device App Store Sandbox purchase, restore, crossgrade, renewal, cancellation/lapse, billing issue/grace behavior, refund/revocation, and repeated Support tip.
- Test TestFlight with local StoreKit configuration disabled.

### Phase 10 - release-candidate version and final evidence

- Only after the paid implementation and content gates are complete, update `MARKETING_VERSION` in `project.yml` to `0.2.0`, unless the founder approves a different release version.
- Determine the build number from the real App Store Connect state before changing it; never guess a production build number.
- Regenerate the Xcode project and inspect the version diff.
- Produce a clean unsigned generic build, focused simulator tests, physical-device install/launch evidence, Sandbox evidence, TestFlight evidence, privacy/legal audit, content/rights audit, and claim audit.
- Update `docs/IMPLEMENTATION_STATUS.md` and every row in `docs/COMPETITION_AND_RELEASE_GATES.md` with dated evidence or an explicit open status.
- Deliver the installable archive/TestFlight candidate only after signing and upload approval.
- Do not submit, release, deploy, commit, or push without explicit approval.

## Mandatory purchase test matrix

At minimum, automate all locally controllable cases and separately evidence provider/device cases:

| Scenario | Required result |
|---|---|
| Fresh free install | Complete ritual; no commerce interruption |
| Field Season purchase | Permanent first-season access |
| Field Season restore | Permanent access restored |
| Field Season refund/revocation | Paid access removed; free and private data preserved |
| Atlas six-month purchase | `atlas_access` active |
| Atlas annual purchase | Same `atlas_access` and same content |
| Six-month/annual crossgrade | Provider timing respected; no content difference |
| Cancel but paid period remains | Access continues to verified expiration |
| Billing grace period | Access follows the verified configured policy |
| Billing retry | Honest state and verified access policy |
| Atlas expiration | Atlas locks; free and owned Field Season remain |
| Support purchase | Quiet thanks; no entitlement |
| Repeated Support purchase | Allowed; still no entitlement |
| Ask to Buy/pending | No premature unlock |
| User cancellation | Access unchanged; calm return |
| Products unavailable | Free ritual works; retry available |
| Purchase reconciliation delay | Precise pending state; no client self-grant |
| Restore with nothing found | Honest completion, no false success |
| Duplicate webhook | One effective state transition |
| Invalid/replayed webhook | Rejected |
| Sandbox event in production | Cannot grant production access |
| Duplicate Witness event | One stored event and one aggregate increment |
| Premium media without entitlement | Denied |
| Atlas lapse plus Field Season ownership | Purchased Field Season remains available |
| Offline relaunch | Free ritual and valid cached state behave as documented |

## Validation discipline

Validate progressively and report exact results:

1. baseline and deterministic `WitnessCore` tests;
2. access policy and adapter tests;
3. StoreKitTest automation;
4. XcodeGen regeneration and generated-project diff;
5. unsigned generic iOS build;
6. simulator UI, state, visual, and automated accessibility tests;
7. backend migration, RLS, function, webhook, and adversarial tests;
8. RevenueCat Test Store;
9. physical-device runtime and direct VoiceOver/Reduce Motion checks;
10. App Store Sandbox;
11. TestFlight;
12. production configuration verification and App Review evidence.

Never use a lower gate as proof of a higher gate. Compilation does not prove runtime. Runtime does not prove a purchase. StoreKitTest does not prove RevenueCat. RevenueCat Test Store does not prove App Store Sandbox. Sandbox does not prove TestFlight or production. Schema existence does not prove RLS. A paywall does not prove the advertised content exists.

## External-action boundary

Explicit founder approval is required before:

- creating or editing App Store Connect products, subscriptions, prices, Sandbox users, or app metadata;
- accepting agreements or altering tax/banking information;
- creating or mutating hosted RevenueCat or Supabase production configuration;
- using credentials, signing, uploading a build, TestFlight distribution, App Review submission, or release;
- committing, pushing, opening a pull request, deploying, publishing, or posting publicly;
- purchasing anything or triggering a real charge;
- deleting or rotating external data/credentials; or
- using any rights-pending content or asset.

These approvals limit external mutations; they do not justify stopping safe local implementation.

## Required reporting after every phase

Report:

1. **Outcome** - what now works for the user.
2. **Files changed** - exact paths.
3. **Validation** - exact commands, devices/environments, tests, and results.
4. **Data/privacy/rights impact** - new SDKs, fields, transfers, retention, assets, and approvals.
5. **Unverified gates** - precise and explicit.
6. **Defects and risks** - severity and owner.
7. **Rollback** - reversible steps that preserve user-authored data.
8. **Next vertical outcome** - one highest-leverage continuation.

Update `docs/PAID_ELEMENTS_EXECUTION_STATUS.md` before ending the phase. Continue automatically while safe work remains.

## Final deliverables

The completed goal must produce:

- updated native iOS source and generated Xcode project;
- `WitnessCore` commerce/access domain and tests;
- contextual paid-access UI integrated into the existing Atlas presentation;
- Debug/test StoreKit configuration and StoreKitTest suite;
- RevenueCat production adapter and environment safeguards;
- Supabase migrations, RLS policies, functions, webhook, seeds, tests, and local setup documentation;
- secure premium media delivery and offline behavior;
- complete Field Season and truthful Atlas content inventory or explicit blocking content gates if founder-supplied reviewed material is still missing;
- privacy manifest and accurate data inventory;
- legal/support/correction wiring;
- accessibility and purchase QA evidence;
- App Store Connect and RevenueCat configuration checklist/evidence;
- App Review notes and reviewer-access instructions;
- purchase-support, content-operations, incident-response, correction, withdrawal, and rollback runbooks;
- updated implementation status and release-gate documents; and
- Witness 0.2.0 release-candidate build/archive evidence, subject to founder approval for signing, upload, and external release.

## Definition of Done

The goal is complete only when all of the following are true:

- The existing free Witness ritual remains complete, local-first, accessible, and regression-tested.
- Field Season purchase, restore, persistence, Atlas inclusion, lapse coexistence, and refund/revocation behavior are proven.
- Both Atlas products grant exactly the same access and content.
- Support Witness is repeatable and grants no entitlement or status.
- No production price or renewal term is hardcoded.
- All purchase states are implemented and tested.
- RevenueCat configuration is isolated behind `PurchaseService` with Test/Sandbox/Release safeguards.
- Supabase schema is migration-controlled, RLS-protected, idempotent, environment-separated, and adversarially tested.
- Premium content and media require current server-verified entitlement.
- Private reflections never leave the device.
- Every advertised paid deliverable actually exists, is reviewed, is rights-cleared, and works in the release candidate; otherwise the associated production product remains unavailable and the overall paid-release goal is not complete.
- Accessibility, privacy, legal, support, correction, content, rights, and sensitive-location requirements pass.
- Physical-device App Store Sandbox and TestFlight gates have dated evidence.
- `project.yml` and the generated project agree on the approved release version and configuration.
- No test key, service secret, unsafe coordinate, rights-pending asset, fabricated count, or conservation-outcome claim ships.
- Every required release blocker is passed with evidence or remains explicitly open; the app is never called production-ready while a required blocker is open.
- The final handoff identifies exactly what is locally complete, what is externally verified, what remains founder-dependent, and the safest next release action.

Be relentless about quality, but equally relentless about truth. Continue until the updated paid-enabled Witness app version is genuinely built and evidenced, or until the only remaining work is blocked by a precisely identified external approval, credential, device, or rights-cleared content dependency.

---
