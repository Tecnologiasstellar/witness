# Witness access and commerce source of record

Status: recommended final direction; proposed for founder approval  
Version: 1.1  
Date: 2026-08-26  
Owner: Witness  
Applies to: iOS app, App Store Connect products, RevenueCat configuration, Supabase services, premium editorial production, QA, and App Review preparation

## 1. Purpose and authority

This document is the proposed canonical source of record for the next Witness development phase: adding sustainable commerce without weakening the free ethical promise or making the app feel like a storefront. It becomes approved direction when the founder accepts Decision D-013 and the product identifiers in Section 8.

It defines:

- the five user-facing ways to engage;
- the much smaller authorization model that must exist in code;
- exact App Store Connect product candidates and RevenueCat mappings;
- what each choice includes, excludes, means, and does not mean;
- how each choice appears inside and outside the app;
- the identity, local storage, backend, database, security, privacy, and content architecture;
- the required delivery sequence and acceptance gates; and
- a complete long-haul implementation prompt for Claude Code or an equivalent repository-aware coding agent.

This document supersedes the old `Witness+` monthly/annual commerce proposal in `PRODUCT_STRATEGY.md`, `MVP_SPEC.md`, and Decision D-004 only where product naming, billing duration, or premium packaging conflict. It preserves the underlying D-004 principle: the complete moral act remains free and paid access sells depth and continuity.

It does not itself prove that products exist in App Store Connect, that RevenueCat or Supabase is configured, that any purchase works, that production content is rights-cleared, or that the app is ready for release. Those remain separate evidence gates.

## 2. Goal

Build a calm, credible commerce system that:

1. lets every person meet, understand, Witness, and act for the featured species without paying;
2. offers one accessible permanent purchase for a finite premium work;
3. offers one continuing membership with two billing durations and exactly the same access;
4. permits a one-time tip without turning support into status or conservation theater;
5. remains comprehensible in seconds;
6. works offline wherever the app promises offline access;
7. protects private reflections and sensitive species information;
8. gives a solo founder an operable editorial and technical system; and
9. creates recurring revenue only by delivering recurring value.

## 3. Assumptions

- The current app remains native SwiftUI, iPhone-first, and iOS 17+.
- `project.yml` remains the XcodeGen source of truth.
- `WitnessCore` remains independent of SwiftUI, StoreKit, RevenueCat, Supabase, and analytics SDKs.
- RevenueCat must power at least one real purchase for the Shipathon requirement.
- Supabase is the planned hosted backend for idempotent Witness events, aggregate counts, released content manifests, and a purchase-state mirror.
- The reviewed bundled catalog remains the offline fallback. Remote failure must not blank the free ritual.
- Private reflections remain on-device in this phase. There is no public profile, social feed, chat, leaderboard, or public user-generated content.
- A silent pseudonymous installation identity may exist for idempotency and service authorization. It is not presented as a social account.
- Prices are intentionally not set in this document. The app must always display localized StoreKit/App Store prices, never hardcoded prices.
- The current repository describes a daily cadence while the founder's broader product concept has also considered a weekly release. Commerce work must not silently change cadence. Record a separate decision before changing scheduling logic.

## 4. The decisive simplification

Witness offers five engagement choices, but it must not implement five hierarchical user tiers.

| User-facing choice | Store type | Authorization effect |
|---|---|---|
| Witness | Free app access; not an IAP | Free content is always available |
| Field Season | Non-consumable IAP | Permanently owns the first Field Season edition |
| Atlas - 6 Months | Auto-renewable subscription | Activates `atlas_access` |
| Atlas - Annual | Auto-renewable subscription | Activates the same `atlas_access` |
| Support Witness | Consumable IAP | No content entitlement |

The code therefore needs only these durable access facts:

```text
ownsFieldSeasonOne: Bool
atlasAccess: inactive | active | gracePeriod | billingRetry | expired | revoked | unknown
```

Free access is the default, not an entitlement record. Support Witness is a completed transaction, not a user rank. Atlas billing duration is purchase metadata, not an access level.

Content authorization is equally small:

```text
free content                     -> everyone
Field Season                     -> ownsFieldSeasonOne OR atlasAccess grants access
Atlas library and services       -> atlasAccess grants access
```

Do not add a generic tier-ranking engine, role hierarchy, points, currencies, supporter badges, or five-option onboarding screen.

## 5. Product doctrine

### 5.1 What may never be paywalled

Every featured public species record must include, for free:

- the complete core image or approved depiction;
- the complete short sourced story;
- status wording and generalized range;
- the deliberate Witness action;
- the honest reconciled collective count or an explicit unavailable/cached state;
- one credible species-relevant action;
- evidence, credits, correction route, and last-verified date;
- private on-device retention of the witnessed record;
- a private on-device reflection;
- an honest share card; and
- basic reminder controls.

No user should need to pay to understand the danger, be counted as a Witness, see the source, take the core action, or preserve their private record.

### 5.2 What paid access sells

Paid access sells editorial depth, durable ownership, organized discovery, narration, return visits, and ongoing production. It does not sell moral worth, compassion, proximity to suffering, or a claim of having saved an animal.

### 5.3 Language rules

Use:

- `Unlock the complete field season`
- `Enter the Atlas`
- `Keep Field Season permanently`
- `Support the work behind Witness`
- `Your Witness remains free`
- `Supports research, fact-checking, illustration, accessibility, and operation of the app`

Do not use:

- `Prove you care`
- `Save this animal by subscribing`
- `Adopt`, unless there is a real, legally reviewed adoption program
- `Donate`, `donation`, or `tax-deductible`
- `Premium Witness`
- `Become a better Witness`
- `Collect them all`
- `Rare drop`, `limited animal`, or manufactured scarcity
- any claim that revenue reaches conservation unless a formal audited program exists

## 6. The five engagement choices

### 6.1 Witness - free access

#### What it means

Witness is the complete public ritual and the foundation of the community. It is not a demo, crippled trial, or moral teaser. A free user is a full participant in the act of attention.

#### It includes

- the complete current public species record;
- source and media-credit access;
- one credible action;
- the Witness action and reconciled aggregate count;
- the user's private on-device Witness archive;
- private on-device reflections;
- basic share output;
- basic reminders after the first completed ritual;
- corrections and safety updates to content already received; and
- contextual previews of Field Season and Atlas when the user deliberately approaches those bodies of work.

#### It does not include

- the complete Field Season premium dossier;
- the full historical Atlas library;
- premium narration, thematic paths, extended field notes, or monthly dispatches;
- cloud sync of private reflections in this phase;
- public posting, messaging, leaderboards, badges, or status; or
- field-trip tickets or physical experiences.

#### Inside the app

- Today opens directly into the free ritual.
- No sign-in, notification request, paywall, or commerce choice appears before the first complete Witness.
- Free content is never visually marked as inferior.
- A premium preview appears only at a real value boundary, such as opening a complete Field Season dossier or Atlas archive search.

#### Outside the app

- The App Store listing states that the core ritual is free.
- Public communications lead with species, evidence, and the ritual, not with monetization.
- Free users receive support, corrections, and privacy protections equal to paying users.

#### What it does not mean

Free does not mean temporary access, lower moral standing, advertising inventory, or permission to harvest personal data.

### 6.2 Field Season - permanent non-consumable

#### What it means

Field Season is a finite, authored digital edition: a coherent premium editorial work about one ecological edge, its species, pressures, uncertainties, and possible forms of attention. The purchase permanently unlocks the first released Field Season edition for the purchaser's Apple account, subject to normal App Store restoration and refund/revocation rules.

This is the accessible first paid step: own one exceptional work without starting a subscription.

#### Required launch deliverables

Field Season must not be sold until the following finished, reviewed deliverables exist in the production build:

1. **Opening field letter** - an original 500-900 word editorial introduction defining the region, the scope of the season, what is known, what remains uncertain, and why precise sensitive locations are withheld.
2. **Eight species chapters** - each chapter contains the complete free public record plus a clearly distinct premium dossier. The dossier should include 600-1,200 additional words across concise sections, a threat chain, an evidence-backed timeline, known/unknown notes, sources, credits, and one reflective prompt.
3. **Narrated edition** - human or properly licensed narration for every premium chapter, with transcript, duration, download size, playback state, and audio rights record. If narration is not ready for every chapter, do not promise a complete narrated edition.
4. **Two system interludes** - visual/editorial explanations of pressures that cross species, such as bycatch, habitat fragmentation, warming, trade, pollution, or governance. Each needs sources and explicit limits.
5. **One generalized ecosystem plate** - a rights-cleared, accessible visual showing relationships without exact sensitive coordinates. It must have alt text and must not masquerade as a precise field map.
6. **Closing synthesis** - an original 800-1,500 word conclusion connecting the season without claiming that attention is an ecological outcome.
7. **Permanent field album** - an in-app assembled reading/listening sequence and a rights-safe, accessible PDF export or equivalent durable personal edition. Export must preserve required attribution.
8. **One scheduled return note** - a dated follow-up released after the season closes. Corrections and safety updates remain available permanently and do not count as a second season.

Every claim and asset must carry canonical IDs, provenance, rights status, review status, and last-verified dates. `PENDING` or `null` is a release blocker where the content contract requires approval.

#### It includes

- permanent in-app access to the released Field Season edition;
- future corrections, accessibility fixes, and safety updates to that edition;
- offline download of the season's text, approved images, transcripts, and audio within documented storage limits;
- restoration through the App Store purchase history;
- the permanent field album export if rights permit it; and
- access whether or not the person later subscribes to Atlas.

#### It does not include

- any future Field Season;
- the full Atlas archive, search, thematic paths, or monthly dispatches;
- permanent ownership of all future edits that materially create a new edition or new season;
- live chat, public community, direct access to researchers, or moderation services;
- a field trip, travel booking, physical product, conservation donation, tax benefit, or conservation outcome; or
- exact animal locations, nests, migration points, dens, or other sensitive coordinates.

#### Inside the app

- A free preview explains the season's scope, table of contents, sample audio, deliverables, download size, rights/credit model, and permanent nature.
- The purchase button uses the live localized App Store price.
- The purchase confirmation says what is unlocked, not what the payment supposedly accomplishes in nature.
- An Atlas member can read the season while Atlas is active. If Atlas lapses, permanent Field Season access remains only if the non-consumable was separately purchased.
- Do not confront an active Atlas member with a second purchase in the ordinary reading flow. A secondary `Permanent access` route may exist in Access settings if user research shows demand.

#### Outside the app

- Field Season can be described as a permanent digital edition.
- The public page may show its contents and editorial process but must use App Store-compliant purchase routing for digital access.
- Any physical print edition would be a separate physical product, priced and fulfilled outside IAP, and must not silently unlock app content.

#### What it does not mean

The purchaser does not own an animal, a conservation claim, the underlying third-party media rights, or future Witness products. `Permanent` means access to the purchased digital edition for as long as Witness and the App Store mechanisms can lawfully deliver it; user-facing terms must avoid impossible guarantees about eternal service availability.

### 6.3 Atlas - 6 Months - auto-renewable subscription

#### What it means

This is one billing option for Atlas. It provides the exact same Atlas access as the annual product and automatically renews every six months unless cancelled. It is intentionally more expensive on an equivalent monthly basis in exchange for a shorter commitment.

#### It includes while active

- every released Field Season, including the first Field Season edition, for in-app use;
- the complete released species archive beyond the free window;
- Atlas search and restrained filters by habitat, threat system, geography at a safe level, status, and editorial theme;
- curated thematic paths that are editorial sequences, not completion games;
- all released premium narration and transcripts;
- extended field notes and evidence-aware system explainers;
- the Return Desk: dated corrections, material status changes, and editorial return notes;
- a monthly Field Dispatch with at least one substantial new editorial deliverable during every paid period;
- offline downloads for entitled content, with clear storage controls;
- an enhanced private field journal only where enhancements can remain local and private; and
- every future Atlas release made available during the active term.

#### It does not include

- permanent ownership of Atlas-only content after expiration;
- more content or better treatment than the annual option;
- priority in the community count, public status, badges, influence over facts, or moral recognition;
- guaranteed access to every future physical event;
- field-trip tickets, travel, lodging, insurance, permits, or partner fees;
- a donation or conservation outcome; or
- a hidden obligation to post, share, review, or take additional actions to receive paid access.

#### Renewal, cancellation, and lapse

- Auto-renewal and cancellation are managed by Apple.
- Cancelling stops the next renewal; access ordinarily continues through the paid period.
- On expiration, Atlas-only content and downloads become locked.
- Free public records, private local Witness history, private reflections, and any separately purchased Field Season remain available.
- Billing retry and grace-period behavior must follow verified StoreKit/RevenueCat state and App Store configuration. The app must not invent access dates.

### 6.4 Atlas - Annual - auto-renewable subscription

#### What it means

This is the second billing option for the same Atlas service. It provides exactly the same access as Atlas - 6 Months and automatically renews annually unless cancelled. It is the better equivalent monthly value because the person commits for a longer period.

#### It includes and excludes

Everything under Atlas - 6 Months, with no difference in content, community treatment, feature priority, support quality, or access rights. Only duration, localized price, renewal date, and introductory-offer eligibility may differ.

#### Presentation rule

The app may label Annual `Best value` only when that statement is calculated from current localized StoreKit prices and is mathematically true. Never hardcode savings or compare currencies incorrectly. Do not preselect annual in a deceptive way, hide the renewal term, or make the six-month choice visually illegible.

### 6.5 Support Witness - consumable tip

#### What it means

Support Witness is a voluntary, repeatable one-time tip to the developer and editorial operation. Apple permits apps to use IAP currencies/products to enable tipping. It is not a donation to a conservation organization and does not unlock content.

#### Launch recommendation

Use one fixed consumable product at launch. This keeps the five-choice model literal and avoids turning Support into another price ladder. Add multiple tip amounts later only if there is measured demand; they remain sub-options of one Support program, never additional status levels.

#### It includes

- a normal Apple purchase sheet;
- a quiet confirmation and thanks;
- a plain explanation that support helps fund research, fact-checking, illustration, narration, accessibility, hosting, and continued app operation; and
- repeat purchase capability because the product is consumable.

#### It does not include

- any entitlement, premium content, subscription credit, virtual currency, badge, public label, streak protection, influence, or preferential treatment;
- a tax receipt;
- a promise that funds are transferred to conservation;
- a quantified ecological result; or
- emotionally coercive placement beside an animal's danger, a failed action, or a distressing statistic.

#### Inside the app

- Place Support Witness only in the Index/Settings access area and optionally at the end credits of a completed premium season.
- Do not place it in onboarding, directly after tapping Witness, beside the free conservation action, or as an interstitial.
- After success, return the person to the prior context. Do not start a supporter progression.
- Failed, pending, and cancelled purchases receive calm, precise states with no guilt copy.

#### Outside the app

- Describe it as a tip that supports the production of Witness.
- Do not market it as charitable giving.
- Do not publish a donor roll unless a future privacy-reviewed opt-in system is separately approved.

## 7. Access matrix

| Capability | Witness | Field Season owner | Active Atlas | Support tipper |
|---|---:|---:|---:|---:|
| Complete current public record | Yes | Yes | Yes | Yes |
| Sources, Witness, count, action | Yes | Yes | Yes | Yes |
| Private local record/reflection | Yes | Yes | Yes | Yes |
| Field Season premium edition | No | Permanent | While active | No change |
| All released Field Seasons | No | Purchased season only | While active | No change |
| Full Atlas archive/search/paths | No | No | While active | No change |
| Monthly Field Dispatch | No | No | While active | No change |
| Premium offline downloads | No | Season I | While active | No change |
| Public badge or rank | No | No | No | No |
| Field trip included | No | No | No | No |

Field Season ownership and Atlas access may coexist. Support never changes this matrix.

## 8. App Store Connect source of truth

The following are proposed identifiers and metadata. Product IDs are immutable and cannot be reused after creation, so verify the final bundle ID and spelling before creating them in App Store Connect.

Current app bundle ID in `project.yml`: `com.avp.witness`.

### 8.1 Products

| Choice | App Store type | Reference name (internal) | Product ID candidate | Customer display name | Description candidate |
|---|---|---|---|---|---|
| Field Season | Non-Consumable | Witness Field Season 1 v1 | `com.avp.witness.fieldseason1` | `Field Season` | `Permanent access to Field Season.` |
| Atlas 6 Months | Auto-Renewable Subscription | Witness Atlas 6 Months v1 | `com.avp.witness.atlas.sixmonth` | `Atlas - 6 Months` | `Full Atlas access, renewed every 6 months.` |
| Atlas Annual | Auto-Renewable Subscription | Witness Atlas Annual v1 | `com.avp.witness.atlas.annual` | `Atlas - Annual` | `Full Atlas access, renewed annually.` |
| Support Witness | Consumable | Support Witness One-Time Tip v1 | `com.avp.witness.support.once` | `Support Witness` | `A one-time tip supporting Witness.` |

`Witness` free access is not created as an IAP.

Apple currently permits IAP display names of 2-30 characters and descriptions up to 45 characters. Reference names may be up to 64 characters. Product IDs may be up to 100 permitted characters, cannot be edited after saving, and cannot be reused in the app. Revalidate these rules immediately before production setup.

### 8.2 Subscription group

| Field | Value |
|---|---|
| Subscription Group Reference Name | `Witness Atlas Access` |
| Subscription Group Display Name | `Witness Atlas` |
| Subscription level | Both products at the same level |
| Level meaning | Same service and access; different duration only |
| Six-month duration | `6 Months` |
| Annual duration | `1 Year` |

Use one subscription group. Apple states that customers can hold only one product in a group at a time and permits equal-content products with different durations at the same subscription level. This is exactly the Witness model.

### 8.3 Trial and introductory-offer decision

Do not launch with a public free trial.

Reasons:

- the complete free ritual already demonstrates the app's quality and ethics;
- Field Season has a free editorial preview and sample audio;
- a thin early Atlas library would make a trial feel like a tour of an unfinished product;
- no-trial launch reduces entitlement, expiry, messaging, and support complexity; and
- conversion should be earned by visible deliverables, not by obscuring a renewal event.

The architecture must support an introductory offer later without a code rewrite. Consider a seven-day annual trial only after Atlas contains enough finished material for a new user to experience multiple distinct benefits in one week and cancellation/expiry messaging has passed testing.

For App Review and Shipathon judges, use an approved offer code, promotional access, sandbox/Test Store configuration, or other documented reviewer mechanism rather than enabling a public trial solely for reviewers.

### 8.4 App Review notes must explain

- the free ritual is complete and never requires purchase;
- Field Season is one permanent digital editorial edition;
- both Atlas products unlock the same ongoing service and differ only by billing duration;
- Support Witness is an optional consumable tip with no entitlement;
- where each purchase entry point, Restore Purchases, and Manage Subscription control can be found;
- how reviewers access premium material;
- that field trips and physical services are not sold through these IAPs; and
- how to test without exposing production credentials.

### 8.5 Official Apple references

- [In-App Purchase types](https://developer.apple.com/help/app-store-connect/reference/in-app-purchases-and-subscriptions/in-app-purchase-types/)
- [In-App Purchase information and metadata limits](https://developer.apple.com/help/app-store-connect/reference/in-app-purchases-and-subscriptions/in-app-purchase-information/)
- [Auto-renewable subscription information](https://developer.apple.com/help/app-store-connect/reference/in-app-purchases-and-subscriptions/auto-renewable-subscription-information)
- [Offer auto-renewable subscriptions](https://developer.apple.com/help/app-store-connect/manage-subscriptions/offer-auto-renewable-subscriptions/)
- [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [StoreKit testing in Xcode](https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode/)
- [Testing IAP with Sandbox](https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases_with_sandbox)

## 9. Experience architecture

### 9.1 Never show a five-level pricing wall

The five choices exist across context, not on one overwhelming screen.

```text
Today / public record
  -> always free

Field Season preview
  -> permanent purchase
  -> secondary explanation that it is included while Atlas is active

Atlas-only boundary
  -> one calm Atlas sheet
  -> 6 Months or Annual

Index / Access
  -> current access summary
  -> Restore Purchases
  -> Manage Subscription
  -> Support Witness
```

### 9.2 Required screens and states

#### Access overview in Index

Show only:

- `Witness - Free` as the standing promise;
- `Field Season: Owned` or a contextual route to its preview;
- `Atlas: Active until [localized date]`, `Renews [date]`, `Expires [date]`, or `Not active` based on verified data;
- `Restore Purchases`;
- `Manage Subscription` when applicable; and
- `Support Witness` as a separate quiet row.

Do not show raw entitlement IDs, RevenueCat terminology, transaction history, or a tier comparison grid.

#### Field Season preview

Show:

- scope and finite deliverables;
- what is immediately available;
- sample chapter and sample audio;
- permanent access language;
- live price;
- Restore Purchases;
- terms/privacy links; and
- a clear statement that the public Witness ritual remains free.

#### Atlas sheet

Show:

- one concise service definition;
- 4-6 concrete ongoing deliverables that actually exist;
- two equal-access duration choices;
- live localized prices and renewal terms;
- dynamically calculated equivalent monthly value if shown;
- Restore Purchases, Manage Subscription, terms, and privacy; and
- a plain close control.

#### Purchase states

Every purchase surface must support:

- products loading;
- products unavailable;
- ready;
- purchasing;
- pending approval/Ask to Buy;
- user-cancelled;
- successful and verified;
- successful but awaiting entitlement reconciliation;
- failed with retry;
- restored with changes;
- restore completed with nothing found;
- offline;
- refunded/revoked; and
- subscription active, grace period, billing retry, cancelled but active, expired, or unknown.

Unknown must fail safely and explain retry. It must not silently grant or remove permanent access based only on UI state.

## 10. Physical experiences and field trips

Field encounters may become a valuable members-adjacent program, but they are not part of these five digital access choices and are out of scope for this build.

If introduced later:

- use a separate `Field Encounters` program;
- sell physical attendance using Apple Pay or card because it is consumed outside the app;
- make partner, guide, permit, accessibility, safety, insurance, age, cancellation, refund, travel, and environmental-impact responsibilities explicit;
- never promise a wildlife sighting;
- never reveal sensitive locations before necessary participant vetting;
- do not imply Atlas includes the ticket unless a specific event explicitly says so;
- Atlas may receive early notice or member booking windows only after legal and operational review; and
- avoid building inventory, booking, waivers, travel operations, and IAP entitlement logic into the commerce phase.

## 11. Technical architecture

### 11.1 Dependency rule

Preserve the repository's current rule:

```text
WitnessApp
  SwiftUI features
  composition root
  RevenueCat adapter
  StoreKit presentation helpers
  Supabase/network adapters
  Keychain and file-system adapters
        |
        v
WitnessCore
  stable access models
  content access policy
  provider-neutral protocols
  catalog validation
  local ritual logic
  deterministic tests
```

`WitnessCore` must not import SwiftUI, StoreKit, RevenueCat, Supabase, or a vendor analytics SDK.

### 11.2 Required domain types

Add provider-neutral types only when their first concrete use is implemented:

```swift
enum ContentAccessRequirement: String, Codable, Sendable {
    case free
    case oceanEdgeSeasonOne
    case atlas
}

struct AccessSnapshot: Codable, Equatable, Sendable {
    var ownsFieldSeasonOne: Bool
    var atlas: AtlasAccessState
    var source: AccessSource
    var verifiedAt: Date?
}

enum AtlasAccessState: Codable, Equatable, Sendable {
    case inactive
    case active(expiration: Date?, willRenew: Bool?)
    case gracePeriod(expiration: Date?)
    case billingRetry(expiration: Date?)
    case expired(Date?)
    case revoked(Date?)
    case unknown
}

struct CommerceProduct: Equatable, Sendable {
    let id: String
    let kind: CommerceProductKind
    let localizedTitle: String
    let localizedDescription: String
    let localizedPrice: String
    let duration: BillingDuration?
}
```

Do not copy vendor objects into views. Map them at the adapter boundary.

### 11.3 Required protocols

```swift
protocol PurchaseService: Sendable {
    func products() async throws -> [CommerceProduct]
    func accessSnapshot(forceRefresh: Bool) async throws -> AccessSnapshot
    func purchase(productID: String) async throws -> PurchaseOutcome
    func restorePurchases() async throws -> RestoreOutcome
}

protocol AccessRepository: Sendable {
    func cachedSnapshot() async -> AccessSnapshot?
    func save(_ snapshot: AccessSnapshot) async throws
}

protocol ContentAccessPolicy: Sendable {
    func canAccess(_ requirement: ContentAccessRequirement, with snapshot: AccessSnapshot) -> Bool
}

protocol InstallationIdentityStore: Sendable {
    func identifier() async throws -> UUID
}

protocol RemoteWitnessEventService: Sendable {
    func submit(_ event: PendingWitnessEvent) async throws -> ReconciledWitnessCount
}
```

The exact signatures may evolve after compile-time feedback, but the responsibilities and dependency direction may not collapse into a global service locator or feature-view SDK calls.

### 11.4 RevenueCat boundary

Recommended configuration:

| RevenueCat object | Identifier | Mapping |
|---|---|---|
| Entitlement | `field_season_1_access` | Field Season non-consumable |
| Entitlement | `atlas_access` | Both Atlas subscription products |
| Offering | `witness_access_v1` | Current purchasable digital products |
| Package | `field_season_1` | Field Season product |
| Package | `atlas_six_month` | Atlas six-month product |
| Package | `atlas_annual` | Atlas annual product |
| Package | `support_once` | Support consumable; no entitlement |

Rules:

- Configure RevenueCat once in the composition root using only the public Apple SDK key.
- Use the core RevenueCat SDK behind the Witness-designed purchase surface. Do not add RevenueCatUI or a remotely replaceable generic paywall without a separate design and dependency decision.
- Debug/Test Store and App Store/Release configuration must be explicitly separated.
- Never ship a RevenueCat secret key or Supabase service-role key in the app.
- `CustomerInfo` is the client purchase-state source mapped into `AccessSnapshot`.
- Both Atlas products map to one entitlement.
- Support maps to no entitlement.
- The backend mirror exists for operations, analytics, and server-side content authorization. It does not let the client grant itself access.
- If a just-completed purchase has not yet reached the webhook mirror, a rate-limited server reconciliation path may fetch current provider state using a server-held credential. It must never accept a client Boolean as proof of access.
- Webhooks must verify the configured authorization value and HMAC signature over the untouched raw request body, enforce timestamp tolerance, and deduplicate by RevenueCat event ID.
- A webhook is processed idempotently; retries must be safe.
- Release builds must not contain Test Store keys or an active local StoreKit configuration.

Official RevenueCat references:

- [iOS installation](https://www.revenuecat.com/docs/getting-started/installation/ios)
- [CustomerInfo and entitlement status](https://www.revenuecat.com/docs/customers/customer-info)
- [Webhooks and HMAC verification](https://www.revenuecat.com/docs/integrations/webhooks)

### 11.5 Identity and profile decision

Do not build a visible user profile or require account creation in this phase.

Implement three separate concepts:

1. **Local experience profile** - preferences, reminder intent, appearance choices, onboarding state, download settings, and private journal metadata. Stored locally; no name, avatar, bio, followers, or public status.
2. **Pseudonymous service identity** - a random installation or anonymous-auth UUID used for witness-event idempotency and optional backend authorization. Persisted securely in Keychain. Never displayed publicly.
3. **Apple purchase identity** - managed by StoreKit/App Store and represented through RevenueCat. Restore Purchases must work without creating a Witness social account.

If silent Supabase anonymous auth is needed for RLS-protected functions, use its random `auth.users.id` as the RevenueCat app user ID and persist the session securely. Treat it as infrastructure, not a user-facing account. Document reinstall and transfer behavior.

Future optional cross-device private sync may add Sign in with Apple. That future phase must include identity linking, merge conflict rules, data export, in-app account deletion, retention rules, and privacy disclosures. Do not prebuild its UI or database writes now.

## 12. Local data architecture

Keep the current validated `FileWitnessRepository` and its data unless a measured requirement proves it inadequate. Do not introduce SwiftData or another database merely to say the app has a database.

Use small versioned stores with atomic writes:

| Local store | Contents | Location | Backup rule |
|---|---|---|---|
| Witness archive | Witness records and private reflections | Application Support | Backed up unless policy changes |
| Preferences | onboarding, reminders, appearance, download choices | Application Support/UserDefaults as appropriate | Non-sensitive |
| Installation identity | random service identifier/session material | Keychain | Accessibility class documented |
| Access cache | last verified provider-neutral access snapshot | Application Support | No secrets |
| Event outbox | idempotent unsent Witness events | Application Support | Retry-safe |
| Catalog | reviewed bundle plus last validated remote release | Bundle/Application Support | Retain known-good fallback |
| Premium media | entitled downloaded audio/images/transcripts | Application Support or Caches by retention promise | Exclude or include in backup intentionally |

Rules:

- Every file format has an explicit schema version and migration tests.
- Atomic replacement prevents partial writes.
- Never delete private records because a subscription expires.
- Locked premium downloads may remain encrypted/cached temporarily, but authorization controls use; define purge policy and storage UI.
- A remote catalog becomes active only after schema validation, checksum verification, review-state validation, rights validation, and safe-location validation.
- If validation fails, retain the last known-good catalog.
- Private reflections never enter analytics, logs, share cards, crash breadcrumbs, or backend requests.

## 13. Supabase/Postgres data architecture

### 13.1 Database responsibility

Postgres stores released operational truth and aggregate community infrastructure. It is not the authority for App Store billing and must not become a public social database.

Use migrations committed to the repository under a backend folder chosen after audit, for example `supabase/migrations`. Never edit production schema manually without a matching migration.

### 13.2 Required tables

#### `catalog_releases`

| Column | Type | Rule |
|---|---|---|
| `id` | uuid PK | server-generated |
| `version` | text unique | immutable semantic release ID |
| `schema_version` | integer | positive |
| `manifest` | jsonb | content IDs, checksums, sizes, URLs |
| `status` | text | draft, reviewed, released, withdrawn |
| `released_at` | timestamptz nullable | set only for released |
| `created_at` | timestamptz | server default |

Public clients may read only `released` rows. Draft/reviewed rows are never public.

#### `content_items`

| Column | Type | Rule |
|---|---|---|
| `id` | text PK | canonical stable content ID |
| `content_type` | text | species_record, field_letter, dossier, interlude, synthesis, dispatch, return_note |
| `access_requirement` | text | free, field_season_1, atlas |
| `payload` | jsonb | schema-validated domain payload |
| `payload_checksum` | text | SHA-256 or approved equivalent |
| `editorial_state` | text | prototype, pending, approved, rejected, withdrawn |
| `rights_state` | text | pending, approved, rejected, not_applicable |
| `sensitive_location_state` | text | pending, approved, rejected, not_applicable |
| `last_verified_at` | date nullable | required before release where applicable |
| `published_at` | timestamptz nullable | release gate |
| `updated_at` | timestamptz | server-managed |

The public API must expose only approved, rights-safe, location-safe, published content. Preserve `PENDING`/null rather than coercing incomplete review into approval.

#### `content_collections`

| Column | Type | Rule |
|---|---|---|
| `id` | text PK | e.g. `field_season_1` |
| `title` | text | localized later |
| `kind` | text | field_season, atlas_path, dispatch_series |
| `access_requirement` | text | enforced server-side and client-side |
| `status` | text | draft, reviewed, released, withdrawn |
| `metadata` | jsonb | description, cover, order policy |

#### `content_collection_items`

| Column | Type | Rule |
|---|---|---|
| `collection_id` | text FK | composite PK |
| `content_item_id` | text FK | composite PK |
| `position` | integer | unique per collection, nonnegative |
| `available_at` | timestamptz nullable | release timing |

#### `media_assets`

| Column | Type | Rule |
|---|---|---|
| `id` | text PK | canonical asset ID |
| `content_item_id` | text FK nullable | owner/context |
| `storage_path` | text | never a secret key |
| `media_type` | text | image, audio, transcript, pdf |
| `byte_size` | bigint | nonnegative |
| `checksum` | text | integrity |
| `creator` | text nullable | preserve unknown as null/PENDING |
| `rights_holder` | text nullable | required where applicable |
| `license_id` | text nullable | explicit |
| `source_url` | text nullable | provenance |
| `required_attribution` | text nullable | rendered where required |
| `commercial_use_state` | text | pending, approved, rejected |
| `verified_at` | date nullable | required for approved |
| `access_requirement` | text | mirrors content gate |

#### `witness_events`

| Column | Type | Rule |
|---|---|---|
| `id` | uuid PK | client event UUID |
| `species_id` | text | released species only |
| `assigned_period` | text | canonical day/week key from scheduling policy |
| `installation_subject` | uuid | pseudonymous; never public |
| `event_version` | integer | positive |
| `occurred_at` | timestamptz | client event time |
| `received_at` | timestamptz | server default |
| `idempotency_key` | text unique | deterministic duplicate protection |

The submit function inserts idempotently and returns the authoritative aggregate. The client never writes or increments an aggregate directly.

#### `witness_aggregates`

| Column | Type | Rule |
|---|---|---|
| `species_id` | text | composite PK |
| `assigned_period` | text | composite PK |
| `witness_count` | bigint | nonnegative, server-maintained |
| `updated_at` | timestamptz | server-maintained |

Expose only aggregates. Consider minimum-threshold or delayed display if low counts could create privacy or safety risks.

#### `purchase_events`

| Column | Type | Rule |
|---|---|---|
| `provider_event_id` | text PK | RevenueCat webhook event ID |
| `app_user_id` | uuid nullable | pseudonymous subject |
| `product_id` | text | allow-listed product |
| `event_type` | text | normalized lifecycle event |
| `environment` | text | sandbox, production |
| `transaction_id_hash` | text nullable | avoid exposing raw IDs unless operationally required |
| `occurred_at` | timestamptz | provider time |
| `received_at` | timestamptz | server default |
| `payload_redacted` | jsonb | only approved fields; no indiscriminate raw payload retention |

#### `entitlement_snapshots`

| Column | Type | Rule |
|---|---|---|
| `app_user_id` | uuid | composite PK |
| `entitlement_id` | text | composite PK, allow-listed |
| `is_active` | boolean | webhook-derived only |
| `product_id` | text nullable | provider value |
| `expires_at` | timestamptz nullable | null for permanent |
| `will_renew` | boolean nullable | subscription only |
| `environment` | text | never mix sandbox and production |
| `provider_updated_at` | timestamptz | ordering/conflict control |
| `updated_at` | timestamptz | server default |

Only a service-role webhook path may write this table. The mobile client may read only its own row through an authenticated function or restrictive RLS.

#### `support_events`

| Column | Type | Rule |
|---|---|---|
| `provider_transaction_key` | text PK | idempotent normalized key |
| `app_user_id` | uuid nullable | pseudonymous |
| `product_id` | text | Support allow-list only |
| `environment` | text | sandbox, production |
| `occurred_at` | timestamptz | provider time |

This table supports accounting and fraud/refund reconciliation only. It must not drive a badge, public list, access flag, or impact count.

### 13.3 Row-level security and function rules

- Enable RLS on every client-accessible table.
- Public/anonymous reads are limited to released free content and aggregate counts.
- Premium content metadata and signed media URLs require a verified current entitlement snapshot.
- A user can access only rows tied to the authenticated pseudonymous subject.
- Mobile clients cannot insert or update purchase events, entitlement snapshots, support events, aggregate counts, editorial approval, or rights approval.
- Witness submission occurs through a rate-limited Edge Function or RPC that validates species, period, subject, event schema, and idempotency.
- RevenueCat webhooks use a dedicated public endpoint only because the provider must reach it; the function authenticates the authorization header and HMAC itself before any write.
- Service-role keys exist only in server secrets.
- Sandbox and production rows are separated by constraint and query policy. Sandbox can never grant production access.
- Logs redact receipts, tokens, full webhook bodies, private reflections, and unnecessary identifiers.
- Add indexes for released catalog lookup, collection order, witness idempotency, aggregate lookup, provider event deduplication, and current entitlement lookup.
- Add migration tests and RLS tests proving both allowed and denied cases.

### 13.4 Premium media delivery

- Keep rights-approved free media in the reviewed bundle or public release path as appropriate.
- Store premium media in a private storage bucket.
- Issue short-lived signed URLs only from a server path that checks the caller's entitlement.
- Never ship long-lived premium URLs, bucket service keys, or predictable unauthenticated paths in the app.
- Verify checksum after download.
- Cache only according to the user's offline choice and the access policy.
- On Atlas expiry, block playback/opening of Atlas-only cached media and offer storage cleanup. Do not delete user-authored notes.
- Field Season owners retain access to their season cache after Atlas expiry.

## 14. Analytics and community boundaries

Collect the minimum events needed to understand product health:

- premium preview viewed;
- paywall viewed by context;
- product selected;
- purchase started, cancelled, failed, pending, succeeded;
- restore started and outcome;
- Atlas content opened while entitled;
- Field Season chapter completed, if measurement is disclosed and privacy-safe;
- Support screen viewed and tip outcome; and
- content download started/completed/failed.

Do not collect reflection text, exact sensitive location, reading selections that reveal sensitive personal traits, public supporter identity, or conservation-outcome claims.

Keep metric vocabulary distinct:

- `attention`: a reconciled Witness event;
- `engagement`: reading, return, action open, share, purchase funnel;
- `self_report`: a user's unverified statement; and
- `outcome`: only independently or partner-verified real-world evidence.

## 15. Delivery plan

### Phase 0 - reconcile decisions and protect the current app

Deliver:

- repository audit and dirty-tree report;
- decision-log update adopting this source of record;
- exact cadence decision noted without silently changing it;
- product ID approval checklist before external creation;
- architecture decision records for RevenueCat, Supabase, anonymous identity, local storage, and premium delivery; and
- rollback plan.

Gate: documentation agrees with current code; no external system is mutated without approval.

### Phase 1 - provider-neutral commerce domain

Deliver:

- access models, content access policy, purchase protocol, local cache protocol;
- product allow-list in one typed configuration location;
- deterministic tests for every access combination;
- fake purchase service for previews/UI tests; and
- no RevenueCat import in `WitnessCore`.

Gate: core tests prove the access matrix and no existing ritual behavior regresses.

### Phase 2 - local StoreKit experience

Deliver:

- local StoreKit configuration with the four IAP products and one subscription group;
- Access overview, Field Season preview, Atlas sheet, Restore, Manage Subscription, and Support screens;
- contextual placement only;
- all loading/pending/cancel/failure/restore/expiry states;
- accessibility identifiers and focused UI tests; and
- no hardcoded production price.

Gate: automated StoreKit tests cover purchase, restore, repurchase of consumable, renewal, crossgrade, expiration, revocation/refund, Ask to Buy, billing retry, grace period, failure, and interruption.

### Phase 3 - RevenueCat integration

Deliver:

- pinned RevenueCat SPM dependency recorded in `project.yml`;
- adapter in `WitnessApp`, configuration validation, and environment separation;
- Test Store offering, packages, and entitlement mappings;
- CustomerInfo-to-domain mapping tests;
- delegate/update handling and foreground refresh;
- purchase/restore telemetry with no private content; and
- Release assertion preventing test configuration.

Gate: controlled RevenueCat Test Store success, cancel, failure, restore, renewal, expiry, and consumable-repeat evidence. Compile is not this gate.

### Phase 4 - Supabase foundation and witness aggregation

Deliver:

- committed migrations, seed fixtures, RLS policies, function code, environment templates, and local setup instructions;
- secure pseudonymous identity;
- idempotent witness submission and authoritative aggregate response;
- offline event outbox with retry/backoff and reconciliation;
- content release manifest endpoint; and
- production secrets only in the host secret store.

Gate: duplicate submissions do not increment; unauthorized reads/writes fail; offline queue survives relaunch; remote failure leaves the bundled ritual working.

### Phase 5 - purchase mirror and premium authorization

Deliver:

- authenticated, HMAC-verified, replay-resistant RevenueCat webhook;
- idempotent purchase event ingestion;
- current entitlement snapshot projection;
- server-side premium manifest/signed URL authorization;
- sandbox/production isolation; and
- refund, revocation, transfer, product change, cancellation, renewal, billing issue, and expiration handling.

Gate: adversarial tests cannot self-grant access, replay a webhook, use a sandbox event in production, or fetch premium media without current entitlement.

### Phase 6 - Field Season production vertical slice

Deliver:

- complete content schema extensions;
- one finished free record plus its premium dossier, narration, transcript, media, sources, and rights record;
- collection ordering and offline download;
- accessible season preview and one complete chapter flow;
- export proof of concept with attribution; and
- content gate that refuses `PENDING`, null-required, unsafe-location, or rights-incomplete material.

Gate: one chapter is production-complete on a physical device. Do not sell the season yet.

### Phase 7 - complete paid inventory

Deliver:

- all Field Season launch deliverables in Section 6.2;
- enough Atlas-only ongoing value to make the subscription description true;
- at least one published monthly dispatch production workflow;
- content operations runbook for one solo founder; and
- correction/withdrawal process.

Gate: every advertised deliverable exists, passes rights/editorial/accessibility validation, and can be maintained at the promised cadence.

### Phase 8 - privacy, legal, accessibility, and operational readiness

Deliver:

- privacy manifest and App Privacy answers matching every SDK and backend field;
- privacy policy, terms, support, corrections, refund/support explanation, and accountless-data behavior;
- local data export/delete/reset behavior;
- VoiceOver, Dynamic Type, Reduce Motion, contrast, touch target, keyboard/switch-control where relevant, and captions/transcripts;
- data retention and deletion runbook; and
- incident response and purchase-support runbook.

Gate: direct human accessibility review and policy-to-implementation audit pass.

### Phase 9 - App Store Sandbox and release evidence

Deliver:

- approved App Store Connect metadata and review screenshots;
- physical-device Sandbox purchase, restore, renewal, crossgrade, lapse, refund/revocation, and repeat Support evidence;
- TestFlight verification with StoreKit local configuration disabled;
- RevenueCat production offering and webhook verification;
- premium reviewer access instructions;
- claim audit; and
- dated release-gate updates.

Gate: each environment is independently proven. No Test Store result substitutes for Sandbox; no Sandbox result substitutes for production release.

## 16. Risks and controls

| Risk | Control |
|---|---|
| Five choices feel like five status tiers | Implement three authorization facts and contextual entry points |
| Pay-to-care backlash | Keep complete ritual/action free; sell depth and production |
| Collecting trivializes extinction | Use archive, field record, cabinet, return, and path language; no completion percentage or rarity |
| Subscription lacks ongoing value | Do not sell until recurring editorial cadence is operational |
| Field Season and Atlas confuse users | Explain permanent one-season ownership versus all-library access while active |
| Support looks like charity | Call it a tip; state operational uses; no outcome or tax claim |
| Account scope explodes | No visible account/profile; local private data and pseudonymous infrastructure only |
| Premium media leaks | Private bucket, server entitlement check, short-lived signed URLs, checksums |
| Webhook grants false access | HMAC, timestamp tolerance, allow-list, idempotency, sandbox separation |
| Purchases fail offline | Honest cached state, retry, Restore, bundled free ritual; never fabricate verification |
| Rights or facts block content | Fail-closed content validator; preserve PENDING/null; per-file ledger |
| Solo founder cannot sustain cadence | Lock deliverable templates and publish less, better material |
| Existing working ritual regresses | Additive seams, focused tests, no rewrite without a demonstrated defect |

## 17. Simple version and ambitious version

### Simple version - recommended release path

- No visible account.
- Free Witness ritual remains local-first.
- One permanent Field Season.
- One Atlas entitlement with six-month and annual billing.
- One fixed Support consumable.
- RevenueCat behind `PurchaseService`.
- Supabase only for aggregate counts, released manifests, webhook mirror, and premium media authorization.
- Private reflections stay local.
- No trial, public UGC, cloud journal sync, field-trip booking, donor recognition, or large CMS.

### More ambitious version - only after the simple version is stable

- Optional Sign in with Apple and encrypted cross-device private journal sync.
- Additional permanent Field Seasons.
- Spanish localization of content and metadata.
- Partner-led Field Encounters with separate physical checkout and operational controls.
- A lightweight editorial console driven by the same validation schema.
- Family Sharing only after entitlement behavior and content economics are explicitly evaluated.
- Introductory or win-back offers based on measured retention and conversion.

Do not build ambitious-version foundations speculatively unless they are required for a current vertical slice.

## 18. Long-haul coding-agent implementation prompt

Copy the prompt below into Claude Code or an equivalent coding agent with the Witness repository open.

---

You are the principal iOS engineer, backend architect, security engineer, product designer, content-systems architect, QA lead, App Store release operator, and pragmatic solo-founder partner for Witness.

Your long-haul goal is to implement the Witness access and commerce phase end to end without weakening the existing ritual, bloating the interface, fabricating readiness, or creating an operation that one founder cannot sustain.

### Mission

Deliver the smallest world-class system that supports exactly five user-facing engagement choices:

1. Witness - free access, not an IAP.
2. Field Season - permanent non-consumable IAP.
3. Atlas - 6 Months - auto-renewable subscription.
4. Atlas - Annual - auto-renewable subscription.
5. Support Witness - repeatable consumable tip with no entitlement.

These are not five authorization tiers. Implement only:

- free content, always available;
- permanent ownership of the first Field Season edition;
- one active/inactive Atlas entitlement shared by both subscription durations; and
- Support transactions that never alter access.

### Required reading before any change

Read completely:

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
- `docs/VISUAL_REFERENCE_AUDIT.md` before presentation work
- `docs/IMPLEMENTATION_STATUS.md`
- `docs/MASTER_BUILD_PROMPT.md`

Inspect the repository, `project.yml`, checked-in Xcode project, package sources, tests, current git status, untracked files, and existing user changes. Do not overwrite or clean user work. Treat `project.yml` as the editable Xcode project source of truth.

### Start-of-run output

Before implementation, report:

1. current confirmed runtime and evidence state;
2. dirty/untracked files that will be preserved;
3. conflicts between this source of record and older documents/code;
4. the first vertical outcome you will deliver;
5. files and external systems likely affected;
6. acceptance evidence required;
7. principal security/product risk;
8. rollback; and
9. actions that require founder approval.

Then proceed with safe local work. Ask only when a decision would materially change scope or when an action is external, destructive, paid, public, irreversible, or credential-dependent.

### Non-negotiable product rules

- Keep the app simple, quiet, minimal, and understandable in seconds.
- Never show a five-level pricing wall.
- Never paywall the complete public story, sources, Witness action, honest count, credible action, private local record/reflection, or basic share.
- No pay-to-care language, guilt, tragedy porn, fabricated urgency, confetti, scarcity, completion pressure, supporter rank, or collection game.
- Field Season is a finite permanent digital edition, not ownership of an animal.
- Both Atlas products grant exactly the same `atlas_access` entitlement and sit at the same level in one App Store subscription group.
- Support Witness is a consumable tip with no entitlement, badge, public recognition, tax claim, conservation claim, or subscription credit.
- No public UGC, profile, comments, messages, follower graph, donor roll, leaderboard, or live community feed.
- No visible account requirement. Private reflections remain local.
- Field trips, physical goods, and physical-event checkout are out of scope.
- No exact sensitive-species locations.
- No live IUCN API use without an appropriate commercial license or written permission.
- No asset or content ships without provenance, rights status, review status, and last-verified data.
- Preserve PENDING/null and fail closed. Never turn incomplete evidence into approval.
- Prices, periods, renewal dates, savings, and offer eligibility come from StoreKit/RevenueCat data, never hardcoded production values.
- No test key, service-role key, webhook secret, signing material, or private receipt enters source control or Release builds.

### Architecture rules

- `WitnessApp` may depend on `WitnessCore`; never the reverse.
- `WitnessCore` must not import SwiftUI, StoreKit, RevenueCat, Supabase, or vendor analytics.
- Add narrow provider-neutral protocols with their first real use case; do not create empty speculative scaffolding.
- Concrete SDK adapters and app composition belong in `WitnessApp`.
- Keep current `FileWitnessRepository` and validated ritual behavior unless a demonstrated defect requires change.
- Avoid a global service locator and avoid SDK calls from SwiftUI views.
- Use one typed product allow-list and one content-access policy.
- Treat UI state as presentation, not authorization.
- Use RevenueCat CustomerInfo mapped to domain access state for client access decisions.
- Use RevenueCat webhooks as an idempotent backend mirror, not as a client-writable entitlement database.
- Use a reviewed bundled catalog and last-known-good remote catalog. Remote failure never blanks Today.
- Use private storage and short-lived signed URLs for premium media.
- Keep private reflections out of network calls, logs, analytics, and shares.

### Product configuration to implement

App bundle ID currently recorded in `project.yml`: `com.avp.witness`.

Product ID candidates, pending founder confirmation before App Store creation:

- `com.avp.witness.fieldseason1` - non-consumable.
- `com.avp.witness.atlas.sixmonth` - six-month auto-renewable subscription.
- `com.avp.witness.atlas.annual` - annual auto-renewable subscription.
- `com.avp.witness.support.once` - consumable.

Subscription group:

- reference name `Witness Atlas Access`;
- display name `Witness Atlas`;
- both products at the same subscription level;
- durations six months and one year.

RevenueCat:

- entitlement `field_season_1_access` for the non-consumable;
- entitlement `atlas_access` for both subscriptions;
- no entitlement for Support Witness;
- offering `witness_access_v1`;
- packages `field_season_1`, `atlas_six_month`, `atlas_annual`, and `support_once`.

Do not configure a public free trial. Keep future introductory-offer support compatible but dormant.

### Required content-access behavior

- `free` is always authorized.
- `field_season_1` is authorized if the user permanently owns the season OR Atlas is active.
- `atlas` is authorized only while Atlas access is active under verified grace/expiration policy.
- Atlas expiry must never delete free history, private reflections, or permanent Field Season ownership.
- Support purchase success changes no content-access state.
- A refund or revocation updates access according to verified provider state.
- Unknown entitlement state fails safely, preserves the free ritual, and offers refresh/restore where appropriate.

### Implementation sequence

Work in vertical phases. For every phase: define acceptance first, implement, run focused tests, inspect behavior, update documentation/evidence, and report exact gaps. Do not mark a phase complete from code existence or compilation alone.

#### Phase 0: decision reconciliation

- Adopt this document in the decision log.
- Identify old `Witness+`, monthly, trial, archive-window, and navigation language that conflicts.
- Resolve documentation without silently changing the core content cadence.
- Confirm final immutable product IDs before any App Store Connect creation.
- Record ADRs for purchase boundary, silent identity, backend schema, and premium delivery.

#### Phase 1: domain and test doubles

- Add minimal domain access requirements, access snapshot/state, commerce product, purchase outcome, restore outcome, and access-policy logic.
- Add `PurchaseService` and `AccessRepository` contracts.
- Add deterministic unit tests for every combination of permanent ownership, Atlas state, content requirement, lapse, revocation, and unknown state.
- Add a fake purchase service supporting success, cancel, pending, failure, restore, expiration, and refund for previews/tests.
- Prove `WitnessCore` has no forbidden provider dependency.

#### Phase 2: StoreKit-local UI vertical slice

- Create a local StoreKit configuration matching the four products and one subscription group.
- Use a Debug/test-only local StoreKit implementation or harness behind `PurchaseService`; it is deterministic test infrastructure, not a second production commerce system. Production purchase execution remains the RevenueCat adapter.
- Ensure it is active only in explicit local test schemes and never in Release/TestFlight.
- Build the Index access overview, Field Season preview, Atlas choice sheet, Support Witness screen, Restore Purchases, and Manage Subscription route.
- Keep entry contextual; do not add a new commerce tab.
- Show live localized product names/prices and exact renewal period.
- Calculate value comparisons from decimal StoreKit prices and periods, not localized strings.
- Add calm states for loading, unavailable products, pending, cancelled, error, verified success, reconciliation delay, restore nothing found, and offline.
- Add VoiceOver labels, focus order, Dynamic Type, Reduce Motion, contrast, 44-point targets, and UI identifiers.
- Use StoreKitTest automation for purchase, restore, consumable repurchase, subscription renewal, crossgrade, cancellation, expiry, revocation/refund, Ask to Buy, interruption, billing retry, grace period, and injected failure.

#### Phase 3: RevenueCat adapter

- Add the pinned iOS SDK through the XcodeGen project specification, regenerate, and inspect the project diff.
- Configure once in the app composition root.
- Separate Debug Test Store, Sandbox, and Release App Store configuration.
- Validate required configuration at startup without crashing the free ritual.
- Map offerings/packages/products into provider-neutral models.
- Map CustomerInfo into the access snapshot and update on purchase, restore, delegate callback, foreground, and explicit refresh.
- Make every transaction result explicit; never optimistically unlock from a button tap.
- Prove Support is repeatable and grants no entitlement.
- Add a release-time test/assertion that rejects test keys and active local StoreKit config.
- Capture RevenueCat Test Store evidence for each supported state.

#### Phase 4: Supabase backend

- Add migration-controlled Postgres schema for catalog releases, content items/collections, media rights, witness events/aggregates, purchase events, entitlement snapshots, and support events as defined in this source of record.
- Enable RLS and deny by default.
- Use silent pseudonymous identity only if required. Persist it securely and document reinstall/restore behavior.
- Add an idempotent, rate-limited witness submission function returning the authoritative aggregate.
- Add a durable client outbox, exponential backoff with jitter, reconciliation, and no optimistic aggregate increments.
- Add released-catalog manifest retrieval and last-known-good fallback.
- Add local development instructions and redacted environment templates.
- Write tests proving unauthorized writes/reads fail and duplicate Witness events do not increment.

#### Phase 5: webhook and premium authorization

- Build a dedicated RevenueCat webhook endpoint.
- Validate authorization and HMAC over raw request bytes before parsing.
- Reject stale/replayed/invalid requests using timestamp tolerance, constant-time comparison, event-ID idempotency, environment checks, and product allow-lists.
- Redact stored payloads to operationally necessary fields.
- Project verified events into current entitlement snapshots.
- Handle initial purchase, renewal, product change/crossgrade, cancellation, uncancellation, billing issue, expiration, refund/revocation, transfer, and non-renewing/consumable events.
- Never allow mobile clients to write purchase or entitlement rows.
- Issue short-lived premium storage URLs only after current entitlement verification.
- Prove sandbox events cannot grant production access and non-entitled users cannot fetch premium media.

#### Phase 6: Field Season content vertical

- Extend the catalog with canonical collection/item/access metadata while preserving existing IDs and validators.
- Implement one complete production-quality Field Season chapter: free base record, premium dossier, sources, rights-approved image, narration, transcript, threat chain, timeline, known/unknown, reflection prompt, offline download, and return-note contract.
- Make depiction type and attribution visible.
- Validate safe generalized location.
- Build season preview, chapter navigation, playback/transcript, download/storage, and permanent-access restoration.
- Prototype the attributed field-album export without claiming rights that do not exist.
- Refuse release for pending/null-required editorial, rights, location, or verification state.
- Test on a physical iPhone before scaling content.

#### Phase 7: paid inventory and operations

- Complete all eight Field Season chapters, opening letter, two interludes, ecosystem plate, closing synthesis, narrated edition, field album, and scheduled return note.
- Create enough Atlas-only archive, paths, narration, Return Desk material, and at least one monthly dispatch to make every paywall promise true.
- Create repeatable templates, validation tooling, and a solo-founder editorial runbook.
- Implement correction, withdrawal, replacement, and rights-revocation behavior.
- Keep products unavailable in production until every advertised deliverable exists and passes the release validator.

#### Phase 8: release quality

- Implement accurate privacy manifest/App Privacy mapping for RevenueCat, Supabase, analytics, identifiers, purchases, and diagnostics.
- Publish and wire privacy, terms, support, and correction URLs.
- Implement export/delete/reset for local user-authored data without deleting App Store purchases.
- Perform direct VoiceOver traversal, Dynamic Type extremes, Reduce Motion observation, contrast, offline/slow network, locale/currency, timezone, device, storage pressure, relaunch, fresh install, and upgrade/migration tests.
- Add purchase support and incident-response runbooks.
- Write App Review notes that explain the five choices and exact reviewer path.

#### Phase 9: external environments and release gates

- Stop and request approval before creating or mutating App Store Connect, RevenueCat, Supabase, signing, TestFlight, production, or public records.
- After approval, configure one environment at a time and record exact identifiers without committing secrets.
- Test App Store Sandbox on a physical device: purchase, restore, renewal, crossgrade, cancellation/lapse, refund/revocation, and repeated Support tip.
- Test TestFlight with local StoreKit configuration disabled.
- Verify the production RevenueCat offering, webhook environment, signed media path, and legal URLs.
- Update `docs/IMPLEMENTATION_STATUS.md` and `docs/COMPETITION_AND_RELEASE_GATES.md` with dated evidence only.
- Do not call the app production-ready until every blocker has evidence.

### Database and security acceptance requirements

- All schema changes are migrations in source control.
- All client-accessible tables have RLS enabled and tested.
- Public clients see released free content and aggregates only.
- Premium media requires current server-verified access.
- Clients cannot self-grant entitlements or write purchase state.
- RevenueCat webhooks are authenticated, HMAC-verified, replay-resistant, environment-separated, allow-listed, and idempotent.
- Witness events are idempotent and counts are server-derived.
- No private reflection reaches the backend.
- Sensitive species coordinates are absent.
- Secrets are server-only and redacted from logs.
- Data retention, deletion, and backup behavior are documented.

### Purchase test matrix

At minimum, automate what can be automated and separately evidence what requires external environments:

| Scenario | Expected result |
|---|---|
| Fresh free install | Complete free ritual; no paywall interruption |
| Field Season purchase | First season permanent access only |
| Field Season restore | Permanent access restored |
| Field Season refund/revocation | Access removed after verified update; free data preserved |
| Atlas six-month purchase | `atlas_access` active |
| Atlas annual purchase | Same `atlas_access` active |
| Crossgrade six-month to annual | Same content; provider timing respected |
| Cancel but paid period remains | Access continues through verified expiry |
| Grace period | Access follows configured verified policy |
| Billing retry | Honest state; access follows verified policy |
| Atlas expires | Atlas locks; free and owned season remain |
| Support purchase | Quiet thanks; no entitlement |
| Support repurchase | Allowed; still no entitlement |
| Ask to Buy/pending | No premature unlock; resumable state |
| User cancellation | No error theater; access unchanged |
| Network failure | Free ritual works; precise retry state |
| Restore finds nothing | Calm confirmation, no false success |
| Sandbox webhook in production | Rejected/no production access |
| Duplicate webhook | Exactly-once effective projection |
| Duplicate Witness event | One event and one aggregate increment |
| Premium URL without entitlement | Denied |
| Atlas lapse with Field Season ownership | The purchased Field Season remains available |

### Content truth acceptance requirements

- Every production sentence maps to a source.
- Every action has scope, source, reviewer, and last-verified date.
- Every asset has creator, rights holder, source, license, attribution, commercial-use status, verification evidence, and depiction type.
- Every sensitive location passes explicit generalization review.
- AI output is never treated as a factual source or automatic approval.
- Corrections are dated and do not erase provenance.
- A premium gate never hides the evidence required to understand the free record.
- A `PENDING`, missing, null-required, rejected, withdrawn, or rights-revoked record fails closed.

### Validation discipline

Use the narrowest relevant validation first, then broaden in proportion to risk:

1. deterministic `WitnessCore` tests;
2. purchase/access adapter tests;
3. StoreKitTest automation;
4. XcodeGen regeneration and project diff when project configuration changes;
5. unsigned generic iOS build;
6. focused simulator UI tests and visual/accessibility inspection;
7. backend migration/RLS/function tests;
8. RevenueCat Test Store;
9. physical-device runtime;
10. App Store Sandbox;
11. TestFlight;
12. production verification.

Never report a lower gate as proof of a higher gate. A successful build is not a successful purchase. A Test Store transaction is not an App Store Sandbox pass. A Sandbox pass is not production availability. A database migration is not proof that RLS denies attacks. An implemented screen is not proof that its paid content exists.

### External-action boundary

Do not, without explicit founder approval:

- create or edit App Store Connect products or subscription groups;
- accept agreements, alter tax/banking, or create Sandbox users;
- create or mutate RevenueCat or Supabase production projects;
- upload a build, submit to review, release, deploy, publish, commit, push, or open a pull request;
- purchase anything or trigger a real customer charge;
- rotate credentials or delete remote data; or
- use rights-pending media.

Complete safe local code, fixtures, migrations, tests, and checklists while waiting for external access.

### Required phase report

End every meaningful phase with:

1. **Outcome** - what now works in user terms.
2. **Files changed** - exact paths.
3. **Validation** - exact commands/environments and exact results.
4. **Data/rights/privacy impact** - new fields, SDKs, transfers, retention, and approvals.
5. **Unverified gates** - explicit, with no optimistic language.
6. **Rollback** - how to remove the change without losing user-authored data.
7. **Next vertical outcome** - one highest-leverage continuation.

Continue phase by phase while safe work remains. When blocked, name the exact missing approval, credential, device, content, rights record, or external state. Do not fill the gap with a mock readiness claim.

### Definition of done

This long-haul goal is complete only when:

- the free ritual remains complete, offline-capable, and regression-tested;
- all four IAP products and one subscription group match approved metadata;
- both Atlas products grant the same entitlement and same content;
- Field Season permanence, Atlas lapse, restore, refund/revocation, pending, and Support repeat-purchase behavior are proven;
- the backend is migration-controlled, RLS-protected, idempotent, environment-separated, and adversarially tested;
- premium media is server-authorized and rights-approved;
- every paid deliverable advertised in the app exists in the released build;
- privacy, legal, accessibility, support, and App Review materials match implementation;
- physical-device Sandbox and TestFlight gates have dated evidence;
- no secret, rights-pending asset, unsafe location, fabricated count, or conservation-outcome claim ships; and
- every release blocker in `docs/COMPETITION_AND_RELEASE_GATES.md` is either passed with evidence or explicitly remains open. Do not call the app production-ready while any required blocker remains open.

---

## 19. Next actions today

1. Approve the immutable product ID candidates before anyone creates App Store Connect products.
2. Approve `Witness Atlas` as the subscription group display name and both Atlas products at the same level.
3. Confirm the launch decision of no public free trial and one fixed Support tip.
4. Record whether the public content cadence remains daily or changes to weekly in a separate decision; do not mix this with commerce implementation.
5. Begin Phase 1 locally: provider-neutral access policy, fake purchase service, and tests.
6. In parallel as product work, lock the Field Season production template and complete one rights-cleared premium chapter before scaling to eight.
7. Do not create products, activate subscriptions, or expose a production paywall until the underlying paid deliverables are real.

## 20. Final recommendation

Ship the simple version first and make it extraordinary.

The defensible Witness model is not a ladder from uncaring to caring. It is a free public ritual surrounded by two honest ways to buy deeper work and one quiet way to support its production:

```text
Witness freely
Own one field season permanently
Enter the living Atlas for as long as membership is active
Tip the work without receiving status
```

That model is legible to users, clean in code, compatible with App Store product types, feasible for a solo founder, and aligned with the trust Witness must earn.
