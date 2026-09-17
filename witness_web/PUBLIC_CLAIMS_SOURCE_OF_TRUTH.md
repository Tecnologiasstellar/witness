# Witness public claims source of truth

Status: canonical for public website wording  
Owner: Witness  
Last reconciled: 2026-09-16  
Scope: Homepage, Archive, Map, Method, Privacy, Terms, Contact, metadata, deployment notes

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
| Availability | Witness is published on the App Store at `https://apps.apple.com/app/id6804311122` (Apple ID from App Store Connect). The site links to it as "Download on the App Store". | Founder direction 2026-09-04: the site is written for the released app | Founder-approved wording | 2026-09-04 |
| Catalog | 30 bundled species cards are published in full on the site, with all five plates each, as the verbatim mirror of the app catalog. | `site/data/species.json`; `tools/export_web_plates.sh` | Confirmed | 2026-09-04 |
| Catalog scope | Catalog approval does not prove public app release or production services. | Release-gate definitions | Confirmed | 2026-08-26 |
| Core promise | The featured story, sources, Witness action, count or explicit unavailable state, credible action, and private reflection are intended to remain free. | `../docs/ACCESS_AND_COMMERCE_SOURCE_OF_RECORD.md` section 5.1 | Proposed product doctrine; safe as intent | 2026-08-26 |
| Cadence | Witness presents one featured species. | `../docs/DECISIONS.md`; commerce source notes cadence conflict | Confirmed neutral wording | 2026-08-26 |
| Count | A future production count represents reconciled Witness events only. | Backend architecture and release gates | Implemented architecture; production proof pending | 2026-08-26 |
| Count availability | No public production count is claimed today. | Backend count integrity `PENDING` | Confirmed | 2026-08-26 |
| Impact | A Witness records attention, not a conservation outcome. | Project invariant and release gates | Confirmed | 2026-08-26 |
| Reflections | Private reflections are designed to stay on device. | Product guardrails and implementation | Implemented design; release-candidate backup/deletion proof pending | 2026-08-26 |
| Accounts | No social account or public user memory is planned for v1. | Product guardrails | Confirmed scope | 2026-08-26 |
| Commerce | Field Season One (one-time), the Atlas (six-month or annual subscription), and the Support tip exist as in-app purchases processed by Apple. The site names them and shows no price. | `../docs/APP_STORE_RECORD_V1.md` §6; founder decision 2026-09-04 (no prices on the web) | Confirmed | 2026-09-04 |
| Purchases | Purchases happen only inside the app, through Apple. The website sells nothing. | Site audit | Confirmed | 2026-09-04 |
| Website privacy | The website uses Vercel Analytics. It uses no account, email capture, advertising, or cookies. The map page requests its base-map tiles from openfreemap.org, as it would images from any host. | `site/app/(en)/layout.tsx` and `site/app/es/layout.tsx` (`<Analytics />`); the `/privacy` page | Confirmed | 2026-09-16 |
| App privacy | The App Store privacy label is "Data Not Linked to You: Identifiers, Usage Data, Purchases"; no tracking, no third-party analytics or ad SDK. Purchases is there because the embedded RevenueCat SDK declares Purchase History in its own privacy manifest; it is recorded for App Functionality only, not Analytics. | `../docs/APP_STORE_RECORD_V1.md` §3; published in ASC 2026-09-16 | Confirmed | 2026-09-16 |
| Artwork | Featured visuals are original AI-assisted illustrations, not documentary photography. | D-013 and per-asset rights files | Confirmed | 2026-08-26 |
| Artwork rights | All 151 web plates are derivatives of approved catalog assets with rights records and commercial-use confirmation. | `../docs/DECISIONS.md` D-013; `../docs/media/*-rights.md`; `tools/export_web_plates.sh` | Confirmed | 2026-09-04 |
| Locations | Public ranges stay generalized and exact sensitive locations are withheld. | Product guardrails and record metadata; `../docs/evidence/map-safety-review-2026-09.md` | Confirmed | 2026-09-16 |
| Map | The site draws each card's generalized range regions at `/map` and `/es/map`: the same circles the app shows, at least 25 km in radius, area only with no centre mark, on a pan-and-zoom map whose base tiles come from OpenFreeMap (OpenStreetMap data) in a style with no roads or buildings, zoom capped at 7; without JavaScript, over public-domain Natural Earth outlines. No exact location, no organisation pin, no third-party range dataset, no key, no account, no cookie. | `site/data/species.json` habitatRegions; `../docs/evidence/map-safety-review-2026-09.md`; D-030 | Confirmed | 2026-09-16 |
| Partners | A citation does not imply partnership or endorsement. | Terms and project guardrails | Confirmed | 2026-08-26 |
| Audio sample | The site plays the Field Season opening letter, free in the app too, with the synthetic-voice disclosure and a transcript. | `../docs/media/fs1-letter-audio-rights.md`; `site/data/letter-transcript.txt` | Confirmed | 2026-09-04 |
| Field notes | The site publishes sourced editorial essays at `/field-notes`. They are Witness's own writing about species and extinction, not catalog records, and they cite third parties without implying partnership. | `../docs/FIELD_NOTES_ENGINE.md`; the gates in `../tools/notes.py` | Confirmed | 2026-09-03 |

## Prohibited until the named gate passes

- A live collective number before backend count integrity passes in production.
- “Witness+” or any superseded monthly product language.
- A price on the website. Prices live in the app, where StoreKit localizes them (founder decision 2026-09-04).
- Any claim that a Witness, share, streak, link open, or payment produced a conservation outcome.
- Any testimonial, partner, press, user total, rating, or download count without dated evidence.
- A field note that restates a catalog record's story, publishes a population figure or IUCN category without two independent sources, or prints a coordinate or exact location. The gates in `../tools/notes.py` enforce all three.
- A coordinate, a centre marker, a pin for a species or an organisation, a map zoom finer than the record's own generalisation, or a map layer drawn from IUCN, WDPA, Restor or any third-party range dataset.

## Web artwork manifest

Every plate under `site/public/images/plates/` is a WebP derivative of an approved
asset in `WitnessApp/Assets.xcassets`, produced by `tools/export_web_plates.sh`
(`cwebp -q 80`, no resize). The source PNGs and their rights records
(`../docs/media/*-rights.md`) remain the authority; re-run the script after any
asset change. The five earlier JPEG derivatives were removed on 2026-09-04.

## Reconciliation checklist

Before a deployment, search all public code for superseded or release-sensitive wording:

```bash
rg -n -i "Witness\\+|in development|not yet|github|preview|interface study|\\$[0-9]" site/app site/components site/lib
```

Then compare every changed claim against this ledger and the higher-authority repository source.
