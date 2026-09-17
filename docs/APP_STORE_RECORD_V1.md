# App Store record — V1.0 (paste-ready)

Status: drafted 2026-08-31 for the V1.0 submission (Block 3 of
`PLAN-V1-LAUNCH-WEEK.md`). Supersedes `APP_STORE_CONNECT_SETUP.md`, which
predates the weekly cadence (D-023), the Witness+ retirement, the four
D-020 products, and the `witnessatlas.com` domain cutover.

Every value below is drafted from the shipped app as it exists today —
no claim appears here that the build does not make true. AV pastes;
nothing here can be entered from this session.

## 1. App Information

| Field | Value |
|---|---|
| Name | `Witness-Endangered Species` *(founder-final, entered in ASC 2026-08-31)* |
| Subtitle (30 max) | `Take action & help:once a week` *(founder-final; exactly 30 chars, no space after the colon)* |
| Primary category | Education |
| Secondary category | Lifestyle |
| Content rights | Contains no third-party content requiring clearance (art is original/owned per `docs/media/*-rights.md`; facts are sourced, not reproduced) |
| Copyright | `2026 Alberto Villalpando` |

## 2. Age rating

Questionnaire: all "None" — no objectionable content, no gambling, no
user-generated public content (reflections are private and on-device),
no unrestricted web access (external links open in the browser, not an
in-app browser). Expected result: **4+**.

## 3. Privacy

| Field | Value |
|---|---|
| Privacy Policy URL | `https://witnessatlas.com/privacy` |
| Privacy Choices URL | leave blank (no tracking, nothing to opt out of) |

App Privacy questionnaire (must match the live policy word for word):

- **Identifiers → Device ID**: collected (anonymous install UUID for
  deduplicating the collective witness count). App Functionality only.
  Linked to identity: **No**. Tracking: **No**.
- **Usage Data → Product Interaction**: collected (witness events with
  coarse metadata). App Functionality only. Linked: **No**. Tracking: **No**.
- **Purchases → Purchase History**: collected. Not because Witness sees a
  payment — it never does — but because the embedded RevenueCat SDK
  declares `NSPrivacyCollectedDataTypePurchaseHistory` in its own privacy
  manifest, and Apple aggregates embedded manifests and checks them against
  these answers. **App Functionality** only; Analytics is deliberately not
  selected, which keeps the policy's "no third-party analytics SDK"
  sentence true. Linked: **No** (anonymous RevenueCat IDs). Tracking: **No**.
- Everything else: **not collected**.

Resulting label: *Data Not Linked to You* — Identifiers, Usage Data,
Purchases. Published in ASC 2026-09-16.

## 4. Support and marketing URLs

| Field | Value |
|---|---|
| Support URL | `https://witnessatlas.com/support` *(since 2026-09-04 a permanent redirect to `/contact`; the URL in ASC stays valid)* |
| Marketing URL | `https://witnessatlas.com` |

## 5. Listing copy

Promotional text (170 max, editable without a new build):

> Each week, one species on the edge of disappearance — its true story,
> its sources, one honest action. No feed. No account. No false promises.

Description:

> Witness is a weekly ritual built around one question: can you give a
> single vanishing species your full attention this week?
>
> Each week, Witness features one species — a drawn plate, a short
> sourced story, and the honest record: what threatens it, what is
> uncertain, and what is actually being done. Every factual claim maps
> to a public source; where something is not verified, the app says so
> plainly instead of guessing.
>
> Witness the species — a deliberate act, once per week — and see a
> real, deduplicated count of everyone who witnessed it with you. Write
> a private reflection that never leaves your device. Then take one
> credible action: a real organization, one honest sentence about what
> support does, and a direct door to it.
>
> FIELD SEASON ONE — a complete, finite edition: an opening field
> letter, eight species chapters with premium dossiers, two interludes,
> a closing synthesis, and the season plate. Every piece narrated —
> seventy-five minutes of audio — with a one-tap keepsake field album.
> Buy it once and it is permanently yours; it is not a subscription.
>
> ATLAS — the living library: the complete archive of every featured
> week beyond the free window, and every released field season while
> membership is active, narration included.
>
> What Witness will never do: claim a tap saved an animal, gamify your
> attention with points or flames, show you a feed, or ask for an
> account. The weekly ritual is free and stays free.
>
> SUBSCRIPTION DETAILS
> The Atlas is an auto-renewing subscription, offered in two durations
> with identical access:
> • Witness Atlas Six Month — $14.99 USD for 6 months
> • Witness Atlas Annual — $24.99 USD for 1 year
> Payment is charged to your Apple ID account at confirmation of
> purchase. The subscription renews automatically unless auto-renew is
> turned off at least 24 hours before the end of the current period.
> Your account is charged for renewal within 24 hours before the end of
> the current period, at the price of the plan you chose. You can manage
> or cancel your subscription in your Apple ID account settings after
> purchase. Prices are in USD; prices in other regions may vary.
>
> Field Season One ($19.99) and Support Witness ($9.99) are one-time
> purchases, not subscriptions.
>
> Terms of Use (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
> Privacy Policy: https://witnessatlas.com/privacy

Why the tail block exists: the 2026-09-17 rejection (3.1.2, Business:
Payments – Subscriptions) was metadata-only — the description carried no
Terms of Use (EULA) link. Witness uses Apple's standard EULA, so the link
goes in the description text; no custom EULA is set in ASC, and no new
build was needed.

Keywords (100 max, comma-separated):

> `endangered,species,wildlife,extinction,conservation,nature,biodiversity,weekly,ritual,animals`

(97 characters.)

## 6. Monetization (must be Ready to Submit in ASC)

Subscription group: one group, two durations, identical access (D-020).

| Product ID | Type | Price |
|---|---|---|
| `com.avp.witness.fieldseason1` | Non-consumable | $19.99 |
| `com.avp.witness.atlas.sixmonth` | Auto-renew, 6 months | $14.99 |
| `com.avp.witness.atlas.annual` | Auto-renew, 1 year | $24.99 |
| `com.avp.witness.support.once` | Consumable | $9.99 |

No intro offers at launch. App Store Server Notifications: **already
configured** (verified in ASC 2026-08-31) — production and sandbox URLs
point at RevenueCat's apple-server-to-server endpoints. The Supabase
webhook deploy remains a separate, optional Tuesday item.

## 7. Review notes (App Review information)

> Witness requires no account, no sign-in, and no demo credentials. Every
> purchase is a standard StoreKit in-app purchase: one non-consumable
> (Field Season One), one subscription group with two durations (the
> Atlas), and one consumable tip (Support).
>
> WHERE THE PURCHASES ARE
> Open INDEX from the THIS WEEK tab. Under THE WORKS: FIELD SEASON (the
> non-consumable), THE ATLAS (the subscription group — both durations sit
> on one page), SUPPORT WITNESS (the tip). RESTORE PURCHASES is on that
> same INDEX page, and the Field Season and Atlas pages each carry their
> own restore row beside the price. Terms of Use and Privacy Policy links
> sit at the foot of both paid pages.
>
> WHAT THE ATLAS UNLOCKS, AND HOW TO SEE IT
> An Atlas membership includes Field Season One in full — the same twelve
> narrated chapters sold separately as the non-consumable — plus the
> complete weekly archive, which grows by one species every week.
>
> To reach the archive: CABINET tab → ARCHIVE. Plates from the current and
> previous ISO week open free by design; older plates carry a lock and open
> only with an Atlas membership. After purchase, ENTER THE LIBRARY on the
> Atlas page lands directly on that archive. Each unlocked plate opens a
> full species record — sourced text, range map, five commissioned plates,
> conservation programmes, and the citation list.
>
> The weekly cadence began 21 August 2026, so the archive is deliberately
> small at review time and gains one entry every week. The subscription's
> value is the continuing record plus the included Field Season, not a
> fixed number of screens.
>
> PRIVACY
> Private reflections are stored only on the device and are never
> transmitted. The collective witness count and in-app usage events use a
> random installation identifier; no personal data, no location, and no
> payment details are collected. The binary carries a privacy manifest
> declaring exactly this; the policy is at witnessatlas.com/privacy.

Demo account: none needed (state this explicitly in the field).

## 8. Screenshots (reshot 2026-09-16, founder approval pending)

The 2026-08-31 set is **superseded and must not be submitted.** It was
taken before nine commits redesigned the exact screens it showed —
`95d244f` alone turned Field Season into a book cover, made the reader
serif, and raised the type floor to 11pt, and `e7f249a` replaced the
archive's detail screen with the species dossier. Shipping it would have
been a Guideline 2.3.3 mismatch. The old files stay in
`docs/appstore/screenshots/final/` as a record; the current set is:

`docs/appstore/screenshots/2026-09/` — `6.9/` (1320×2868, iPhone 17 Pro
Max) and `6.3/` (1206×2622, iPhone 17 Pro), clean 9:41 status bar, full
battery, **seven candidates each.** Apple allows up to 10 per size;
founder picks and orders the final set.

1. `01-this-week` — the weekly card: hero plate, status, hook, stats
2. `02-archive-grid-locks` — the archive with ATLAS locks on three plates;
   shows what the subscription opens, without a word of sales copy
3. `03-atlas-dossier-monarch` — the species dossier the Atlas unlocks
4. `04-atlas-pricing` — the Atlas cover, its holdings, and both durations
5. `05-fieldseason-cover` — the edition's cover, price, and stats row
6. `06-edition-contents` — the twelve pieces with read and listen times
7. `07-chapter-reader-narration` — the serif reader with the synthetic
   voice disclosure visible

All prices are **real** (`$19.99`, `$14.99`, `$24.99`), read from the
store rather than from the test service: `FakePurchaseService` returns
`$0.00` for every product, which is right for tests and would have been a
misleading price on a store listing. Shots 1–5 were taken with commerce
on the normal path. Only 6 and 7 used the fake service, to reach the
owned state — neither screen shows a price, so no `$0.00` reaches the
listing. No real or sandbox purchase was involved.

The species is the true current week (monarch butterfly) throughout, so
the card, the archive grid and the dossier agree with each other; the old
set's kākāpō hero disagreed with its own archive.

## 9. App icon (already decided — brief is stale)

The icon shipped 2026-08-25 (`98ca3e0`): founder-approved arcs-and-dot
mark, light/dark/tinted variants wired in
`WitnessApp/Assets.xcassets/AppIcon.appiconset`. `ICON_DESIGN_BRIEF.md`
predates this. Three fresh alternatives (C "The Counted", D "Dusk
Plate", E "The Tally") exist in `docs/icons/` for comparison only —
swapping is optional, not a blocker.

## 10. Still open (decisions, not paste-work)

- Whether any Atlas intro offer exists at launch (current record: none).
