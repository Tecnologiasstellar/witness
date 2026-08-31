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
| Name | `Witness` |
| Subtitle (30 max) | `One species. Every week.` |
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
- Everything else: **not collected**. Purchases run through Apple /
  RevenueCat; Witness never receives payment details, so "Purchase
  History" stays **not collected**.

Resulting label: *Data Not Linked to You* — Identifiers, Usage Data.

## 4. Support and marketing URLs

| Field | Value |
|---|---|
| Support URL | `https://witnessatlas.com/support` |
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

No intro offers at launch. App Store Server Notifications URL: set only
after the production webhook deploy (Tuesday item; not a launch blocker).

## 7. Review notes (App Review information)

> Witness requires no account and no sign-in. All purchases are standard
> App Store in-app purchases (one non-consumable, one subscription group
> with two durations, one consumable tip).
>
> To review paid content: Index (top-right) → ACCESS → FIELD SEASON →
> "Keep Field Season permanently" purchases the complete edition; ATLAS
> offers the two subscription durations. Purchased content appears under
> "Open the edition." The weekly ritual (Today tab) is fully usable
> without any purchase.
>
> Private reflections are stored only on device. The collective witness
> count uses an anonymous install identifier; no personal data is
> collected.

Demo account: none needed (state this explicitly in the field).

## 8. Screenshots (deferred, deliberately)

Required sets: 6.9" (iPhone 17 Pro Max class) and 6.3" (iPhone 17 Pro
class), from the simulator. Shot list per the plan: the shelf, a chapter
with narration, a doors block, the plate/synthesis, the album export.

**Deferred until after the paid-surface design pass** (founder direction
2026-08-31): three of the five shots feature exactly the surfaces being
redesigned; producing them now would mean producing them twice.

## 9. Still open (decisions, not paste-work)

- App icon (see `docs/ICON_DESIGN_BRIEF.md`).
- Whether any Atlas intro offer exists at launch (current record: none).
