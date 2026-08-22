# Competition and release gates

Last verified: 2026-08-20

## Confirmed Shipathon requirements

- First public eligible-store release must occur within the submission period.
- The app must run on iOS, iPadOS, macOS, or Android and be accessible in the United States.
- RevenueCat must power at least one in-app or web purchase, or RevenueCat Ads must be used.
- The project must be publicly released on an eligible store before the deadline for the main Peace Prize category.
- Submission requires an English text description, a public YouTube/Vimeo device demo under two minutes, a store URL, a 1024×1024 icon, and at least one 1179×2556 screenshot without a device frame.
- Judges need free-trial access or a promo code for premium functionality.
- Peace Prize submission text must describe how the app benefits individuals, communities, or society.
- Peace Prize judging criteria are **Impact** and **Feasibility**.
- Shipathon deadline: September 30, 2026 at 11:45 p.m. PDT.

Official sources:

- https://revenuecat-shipaton-2026.devpost.com/
- https://revenuecat-shipaton-2026.devpost.com/rules
- https://revenuecat-shipaton-2026.devpost.com/details/dates

## Release blockers

Each gate needs dated evidence. `PASS` means the production candidate was tested; a mock, local test, compile, simulator run, or staging result cannot substitute for a different gate.

| Gate | Status | Required evidence |
|---|---|---|
| Eligibility and registration | PENDING | Devpost registration and entrant eligibility confirmed |
| Apple Developer/App Store Connect | PENDING | Active membership, agreements, tax, banking, app record |
| Original public release date | PENDING | App Store version publicly released within window |
| Core ritual | PENDING | Physical-device recording of full production flow |
| Catalog integrity | PENDING | Validator passes every published species/action/source/media record |
| Media and data rights | PENDING | Per-file rights ledger and no incompatible data source |
| Sensitive species safety | PENDING | Location/generalization review |
| Backend count integrity | PENDING | Idempotency, RLS/authorization, aggregate-only exposure, offline retry tests |
| RevenueCat Test Store | PENDING | Controlled success/fail/cancel/restore/expiry tests |
| App Store Sandbox purchase | PENDING | Physical-device purchase, entitlement, restore, cancellation/expiry evidence |
| Release keys/config | PENDING | No test keys, secrets, or sandbox StoreKit configuration in Release |
| Accessibility | PENDING | VoiceOver, Dynamic Type, Reduce Motion, contrast, touch targets |
| Privacy | PENDING | Policy, nutrition label, manifests, retention/deletion behavior match implementation |
| Legal/support | PENDING | Live privacy, terms, support, and correction URLs |
| App Review | PENDING | Approved production build |
| Public US availability | PENDING | Store listing downloadable from US storefront |
| Submission assets | PENDING | Icon, screenshot, demo, description, testing instructions, premium access |
| Claim audit | PENDING | Every impact, count, source, feature, and demo claim matches public build/evidence |

## App Store policy constraints that shape v1

- Public user-generated content would require filtering, reporting, blocking, contact information, and timely moderation. Therefore public Memory Bank contributions are deferred.
- A subscription must deliver ongoing value and clearly state what the user receives.
- If account creation is later added, in-app account-deletion initiation is required.
- App privacy disclosures must include relevant third-party SDK data practices.
- Direct charitable fundraising has additional restrictions; Witness v1 does not collect donations.

Apple sources:

- https://developer.apple.com/app-store/review/guidelines/
- https://developer.apple.com/app-store/app-privacy-details/
- https://developer.apple.com/support/offering-account-deletion-in-your-app/

## Competition narrative test

Before submission, the team must answer with evidence:

### Impact

- Who specifically benefits?
- What changes for them after one session and after one week?
- Which metrics are attention, which are engagement, and which—if any—are real outcomes?
- What user or advisor feedback changed the product?

### Feasibility

- Does the public app work reliably and offline where promised?
- Are content and action production repeatable for a solo operator?
- Is the count trustworthy and privacy-preserving?
- Is the revenue model capable of funding ongoing editorial work without restricting the social-good core?

