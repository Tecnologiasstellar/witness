# Witness public claims source of truth

Status: canonical for public website wording  
Owner: Witness  
Last reconciled: 2026-08-27  
Scope: Homepage, Archive, Method, Privacy, Terms, Support, metadata, deployment notes

## Authority order

When sources conflict, use this order and narrow the public wording until the conflict is resolved:

1. `../docs/COMPETITION_AND_RELEASE_GATES.md` for production and release evidence.
2. `../docs/DECISIONS.md` for accepted product and rights decisions.
3. `../docs/ACCESS_AND_COMMERCE_SOURCE_OF_RECORD.md` for the proposed commerce model. This is not approved commerce evidence.
4. `../Packages/WitnessCore/Sources/WitnessCore/Resources/catalog/*.json` for species content.
5. `../docs/PAID_ELEMENTS_EXECUTION_STATUS.md` and implementation files for code-complete versus externally verified state.
6. This ledger for the exact public wording allowed by those sources.

Code, a build, a simulator run, a catalog pass, a staging service, a Test Store purchase, an App Store Sandbox purchase, App Review, and public availability are separate gates.

## Public claim ledger

| Area | Evidence-backed public wording | Evidence | State | Last verified |
|---|---|---|---|---|
| Product | A native SwiftUI iOS MVP exists. | `../docs/COMPETITION_AND_RELEASE_GATES.md`; app source | Confirmed locally | 2026-08-27 |
| Availability | Witness is not yet available on the App Store. | Release gates: App Review and public US availability `PENDING` | Confirmed | 2026-08-27 |
| Catalog | 30 bundled species records have approved editorial and media states. | Release gates: Catalog integrity and Media and data rights `PASS (2026-08-25)`; `site/data/species.json` | Confirmed | 2026-08-27 |
| Catalog scope | Catalog approval does not prove public app release or production services. | Release-gate definitions | Confirmed | 2026-08-26 |
| Core promise | The featured story, sources, Witness action, count or explicit unavailable state, credible action, and private reflection are intended to remain free. | `../docs/ACCESS_AND_COMMERCE_SOURCE_OF_RECORD.md` section 5.1 | Proposed product doctrine; safe as intent | 2026-08-26 |
| Cadence | Witness presents one featured species. | `../docs/DECISIONS.md`; commerce source notes cadence conflict | Confirmed neutral wording | 2026-08-26 |
| Count | A future production count represents reconciled Witness events only. | Backend architecture and release gates | Implemented architecture; production proof pending | 2026-08-26 |
| Count availability | No public production count is claimed today. | Backend count integrity `PENDING` | Confirmed | 2026-08-26 |
| Impact | A Witness records attention, not a conservation outcome. | Project invariant and release gates | Confirmed | 2026-08-26 |
| Reflections | Private reflections are designed to stay on device. | Product guardrails and implementation | Implemented design; release-candidate backup/deletion proof pending | 2026-08-26 |
| Accounts | No social account or public user memory is planned for v1. | Product guardrails | Confirmed scope | 2026-08-26 |
| Commerce | Field Season, Atlas, and Support Witness are the proposed access choices. | Commerce source of record v1.1 | Proposed, founder approval pending | 2026-08-26 |
| Purchases | Nothing can be purchased through Witness today. | RevenueCat Test Store and App Store Sandbox gates `PENDING` | Confirmed | 2026-08-26 |
| Website privacy | The current website has no analytics, cookies, email capture, advertising, or account. | Repository audit | Confirmed locally | 2026-08-27 |
| App privacy | The final App Store privacy label, retention, deletion, and SDK disclosures are pending. | Privacy gate `PENDING` | Confirmed | 2026-08-26 |
| Artwork | Featured visuals are original AI-assisted illustrations, not documentary photography. | D-013 and per-asset rights files | Confirmed | 2026-08-26 |
| Artwork rights | The five web assets have exact generation IDs, commercial-use confirmation, and species-accuracy review. | `../docs/DECISIONS.md` D-013; `../docs/media/*-plates-rights.md` | Confirmed | 2026-08-26 |
| Locations | Public ranges stay generalized and exact sensitive locations are withheld. | Product guardrails and record metadata | Confirmed | 2026-08-26 |
| Partners | A citation does not imply partnership or endorsement. | Terms and project guardrails | Confirmed | 2026-08-26 |

## Prohibited until the named gate passes

- “Available now,” “Download,” or an App Store badge before approved public listing evidence.
- A live collective number before backend count integrity passes in production.
- “Witness+” or any superseded monthly product language.
- A price, trial, purchase, restore, or subscription claim before founder approval and matching StoreKit, RevenueCat, Sandbox, and release evidence.
- “Data not linked to you” or any final privacy-label wording before the production privacy audit.
- Any claim that a Witness, share, streak, link open, or payment produced a conservation outcome.
- Any testimonial, partner, press, user total, rating, or download count without dated evidence.

## Web artwork manifest

| Web derivative | Source job | Rights record | SHA-256 |
|---|---|---|---|
| `site/public/images/species/whooping-crane-context.jpg` | `a107fddb-7749-44e4-b1e8-42102b67e623` | `../docs/media/whooping-crane-plates-rights.md` | `35416b102cda4f31874c5fb6cf0b26a22b2eca41bcf7f1c488fae86aee6d5869` |
| `site/public/images/species/ploughshare-tortoise.jpg` | `94082d5b-aba7-4e1c-b13a-b41873d9283b` | `../docs/media/ploughshare-tortoise-plates-rights.md` | `a7851d3432dbb1619e0fc562ebbc06887d9f6360420f495ff70f0dbc22d3b69a` |
| `site/public/images/species/red-wolf.jpg` | `ff50c0a2-a439-4589-8b66-a6606706ab0b` | `../docs/media/red-wolf-plates-rights.md` | `b9e68d62ac94474ffd27232a79f60941fab25b0104fa5ab02d270f2e701f6423` |
| `site/public/images/species/amur-tiger.jpg` | `62bf19b1-32eb-4aff-a572-0c4042c56d32` | `../docs/media/amur-tiger-plates-rights.md` | `16dcbe90c08a0e058fdf1525058743d4eacf22182023c1a37661945c5aeead17` |
| `site/public/images/species/philippine-eagle-detail.jpg` | `e05461dc-d5c4-487f-9152-e59670da2ae1` | `../docs/media/philippine-eagle-plates-rights.md` | `5638c6355b5a3b7bc0cd8f0f0f8287619e2215c1b5a748a6f7c3f62917ad2669` |

The source PNG files remain outside the web repository. The checked-in JPEGs are web derivatives only.

## Reconciliation checklist

Before a deployment, search all public code for superseded or release-sensitive wording:

```bash
rg -n "Witness\\+|available now|download|App Store privacy label|collective count is real|subscription works|one bundled|Record 001" site/app site/components site/lib
```

Then compare every changed claim against this ledger and the higher-authority repository source.
