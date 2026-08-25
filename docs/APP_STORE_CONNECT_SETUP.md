# App Store Connect — initial setup

Status: 2026-08-25. Bundle ID `com.avp.witness` and the app record already exist in ASC per AV. This is the checklist for everything else in the app record, with content ready to paste where the content itself (not an account action) is the blocker. Every item below is something only AV can click — none of it can be done from this session, since it all lives behind Apple ID sign-in.

## 1. App Information tab

| Field | Value |
|---|---|
| Name | `Witness` |
| Subtitle (30 char max) | `One species. Every day.` |
| Primary category | Education (matches `LSApplicationCategoryType` already set in the app — `public.app-category.education`) |
| Secondary category | Lifestyle |
| Content rights | Does not contain, show, or access third-party content that requires clearance — leave unchecked (the card art is AI-generated and owned, per `docs/media/*-rights.md`; facts are sourced but not "content" in Apple's sense) |
| Age rating | Complete the questionnaire with all "None" — no objectionable content, no gambling, no user-generated content, no unrestricted web access. Should resolve to **4+**. |

## 2. Privacy

| Field | Value |
|---|---|
| Privacy Policy URL | `https://witness-rho.vercel.app/privacy` |
| Privacy Choices URL | leave blank (no tracking, nothing to opt out of) |

### App Privacy questionnaire (Data collected)

The live privacy policy states exactly this, so the questionnaire must match it word for word — Apple checks:

- **Identifiers** → collected: yes. Type: "Device ID" (the anonymous install UUID). Used for: **App Functionality**. Linked to user's identity: **No**. Used for tracking: **No**.
- **Usage Data** → collected: yes. Type: "Product Interaction" (witness events, `ritual_completed`/`share_created`-style event names with coarse metadata). Used for: **App Functionality**. Linked to identity: **No**. Used for tracking: **No**.
- Everything else (Contact Info, Health, Financial Info, Location, Browsing History, Search History, Photos/Videos, Contacts, User Content) → **not collected**. Purchases go through Apple directly — Witness never receives payment details, so "Purchase History" is also **not collected**.

Resulting label: *"Data Not Linked to You"* — identifiers, usage data only. This is the exact sentence already published on the privacy page, so the ASC label and the site will agree.

## 3. Support and marketing URLs

| Field | Value |
|---|---|
| Support URL | `https://witness-rho.vercel.app/support` (built and deployed this session — was missing before) |
| Marketing URL | `https://witness-rho.vercel.app` (optional, but the site is ready) |

## 4. App Store listing copy (v1)

Promotional text (170 char, editable anytime without a new build):
> Every day, one endangered species — its story, its sources, one honest action. No feed, no doom-scroll, no fake impact claims. Just attention, paid daily.

Description:
> Witness is a one-minute daily ritual built around a single question: can you give one endangered species your full attention today?
>
> Each morning, Witness shows you one species — a full portrait, a short sourced story, and the honest facts: population, trend, threats, and what's actually being done. Every claim in the app is mapped to a public primary source; where something isn't verified, the app says so plainly instead of guessing.
>
> Witness once — a deliberate act, not a "like" — and see a real, deduplicated count of everyone who witnessed this species with you. Then take one credible action: a specific, sourced link to something you can actually do, from an organization actually doing the work.
>
> What Witness will never do: claim a tap saved an animal, gamify your streak with points or flames, show you a feed, or ask for an account. Private reflections you write stay on your device — always.
>
> Witness+ unlocks the full archive of every species that's appeared, for readers who want to go back. The daily ritual itself is, and stays, free.

Keywords (100 char, comma-separated, no spaces needed):
> `endangered,species,wildlife,conservation,nature,extinction,biodiversity,daily,ritual,animals`

Copyright:
> `2026 Alberto Villalpando`

## 5. Monetization — Witness+ subscriptions

RevenueCat is already wired (entitlement `plus`, products `witness_plus_monthly` $2.99 / `witness_plus_annual` $19.99, offering `default`). Confirm in ASC → Monetization → Subscriptions that both product IDs exist and are **Ready to Submit**, in the same subscription group, with:

- Monthly: $2.99/month, no intro offer needed.
- Annual: $19.99/year, **7-day free trial** intro offer — this is the one AV item still flagged pending in the release-gates doc (`docs/COMPETITION_AND_RELEASE_GATES.md`) and the day-four decision log.
- App Store Server Notifications URL (Monetization → App Store Server Notifications) — must point at the Supabase Edge Function or RevenueCat's webhook endpoint (RevenueCat's own docs give the exact URL to paste; it's account-specific).

## 6. Build

Once the TestFlight build is uploaded (see the Xcode section AV is doing in parallel), go to **TestFlight** tab first — it doesn't require the full listing to be finished, so internal testing can start immediately. **App Store** tab build selection can wait until the listing above is filled in.

## 7. What's still genuinely open (not a click-through, a decision)

- App icon (see `docs/ICON_DESIGN_BRIEF.md` — not picked yet).
- Whether the Witness+ annual intro offer is 7 days as planned or something else.
- Confirming the RevenueCat/Higgsfield commercial-terms question noted in the day-four decision log.
