# Devpost submission — RevenueCat Shipaton 2026

Paste-ready. Every sentence here is checked against
`witness_web/PUBLIC_CLAIMS_SOURCE_OF_TRUTH.md`: no conservation-outcome
claim, no user or download number, no rating, no testimonial, no price on
any public web surface. Prices appear here only because Devpost asks how
the app makes money.

Deadline: **2026-09-30, 11:45pm PDT.**

---

## Tagline (short, for the submission header)

> One vanishing species a week, told truthfully — and a way to pay attention that doesn't lie to you.

---

## Text description

> **Witness** is a weekly ritual built around a single question: can you give
> one vanishing species your full attention this week?
>
> Each week the app features one species — a drawn plate, a short sourced
> story, and the honest record: what threatens it, what is still uncertain,
> and what is actually being done. Every factual claim maps to a public
> source. Where something isn't verified, the app says so plainly instead of
> guessing. That rule is enforced in the content pipeline, not just promised
> in a design doc.
>
> You witness the species — one deliberate act, once a week — and see a
> deduplicated count of everyone who witnessed it alongside you. You can write
> a private reflection that never leaves your device. Then you're offered one
> credible action: a real organization, one honest sentence about what
> supporting it does, and a direct door to it.
>
> **What Witness refuses to do** is the point of the product. It will not
> claim your tap saved an animal. It will not gamify your attention with
> points, streaks or flames. There is no feed, no account, no sign-in, no
> third-party analytics, and no advertising SDK. Reflections are on-device.
> The App Store privacy label is "Data Not Linked to You."
>
> **The free ritual is the complete moral act, and it stays free.** Paid
> access sells depth and continuity, never the ability to care:
>
> - **Field Season One** — a finite, complete edition: an opening field
>   letter, eight species chapters with premium dossiers, two interludes, a
>   closing synthesis, and the season plate. Every piece narrated, about
>   seventy-five minutes of audio, with a one-tap keepsake field album. Bought
>   once, permanently yours. Deliberately *not* a subscription.
> - **The Atlas** — the living library: the full archive of every featured
>   week beyond the free window, plus every released field season while
>   membership is active, narration included. Six-month or annual, identical
>   access either way.
> - **Support Witness** — a one-time tip that unlocks nothing at all. It grants
>   no content and confers no status, because support shouldn't buy rank.
>
> Native SwiftUI, iPhone, iOS 17+. Monetization is powered end to end by the
> RevenueCat SDK.

---

## Category blurbs

### RevenueCat Peace Prize — *social good*

> Witness is built against the grain of the attention economy it lives in.
> Conservation apps routinely tell users a tap planted a tree or saved an
> animal. That's a lie that feels good, and it trades a person's genuine
> concern for a dopamine hit — leaving them satisfied instead of informed.
>
> Witness makes the opposite bet: that people can hold a hard, true thing for
> one minute a week if you respect them enough to tell it straight. A Witness
> records attention. It does not record a conservation outcome, and the app
> says so in those words.
>
> The discipline is structural, not aspirational. Every claim maps to a public
> primary source, and unverified facts are labelled unverified rather than
> rounded into confidence. Species locations are deliberately generalized — a
> minimum 25 km radius, area only, no centre mark, no exact coordinate, no
> third-party range dataset — because precise ranges of critically endangered
> animals are a poaching risk, and a map is not worth an animal. Citing an
> organization never implies it endorses us.
>
> The benefit claimed here is modest and real: sustained, honest attention on
> species most people will never otherwise read a true sentence about, and one
> credible action offered without the pretense that taking it is heroic.

### RevenueCat Design Award — *craft*

> Witness is drawn, not templated. The visual language is a naturalist's field
> record: aged-paper grounds, a hand-drawn plate per species, scale studies
> that place the animal beside a human silhouette so its size lands
> physically rather than as a number.
>
> Where to look:
>
> - **The paid surfaces open as books, not as paywalls.** Field Season One
>   opens on a *cover* — title, edition, season plate — and you turn into the
>   contents. The Atlas opens on its own cover. A price appears where a
>   colophon would, not as an interstitial demanding payment before you've
>   seen anything.
> - **THIS WEEK → INDEX.** The index is the app's spine: a printed
>   table of contents rather than a settings screen, with THE WORKS sitting in
>   it the way a publisher's list sits in the back of a book.
> - **The chapter reader.** Serif body, an 11pt type floor, synchronized
>   narration, and a keepsake field album composited on one tap.
> - **Restraint as the design.** No badges, no streak counter, no progress
>   ring, no confetti. The single strongest interaction in the app is a button
>   that says I BEAR WITNESS and then quietly does nothing celebratory.
> - Full VoiceOver support, including announcements through the purchase flow.

### HAMM Award — *monetization strategy*

> The strategy answers a specific question: how do you sell depth to people
> who came for a free moral act, without making the moral act feel like bait?
>
> **The product model.** Three offers with genuinely different shapes. A
> finite non-consumable edition that is explicitly *not* a subscription and
> never expires — for people who resent recurring billing and will pay more
> once. A subscription with two durations and byte-identical access, so
> duration is billing metadata rather than a tier, and nobody is punished for
> paying monthly-ish. And a tip that deliberately grants nothing, which keeps
> support from becoming status. The free ritual is never degraded to make the
> paid tier look better — that's the only rule the whole thing rests on.
>
> **The implementation.** All four products live behind one RevenueCat
> offering (`witness_access_v1`) resolving to two entitlements
> (`field_season_1_access`, `atlas_access`). The app's authorization model is
> deliberately smaller than its price list: two durable facts — do you own the
> season, and what state is Atlas access in — because five purchase options
> must not become five user tiers.
>
> The SDK sits behind a `PurchaseService` protocol, so the domain layer never
> sees a RevenueCat type and the whole purchase surface is testable without a
> store session. RevenueCat's entitlement facts are mapped explicitly into
> grace period, billing retry and expired states, so a failed credit card
> degrades gently instead of slamming a door on a paying reader.
> Verified access is cached, so the library still opens on a plane. App Store
> Server Notifications are wired to RevenueCat, making the server the source
> of truth rather than the client.

---

## Built with

Swift · SwiftUI · **RevenueCat** · StoreKit 2 · Supabase · XcodeGen · Next.js (witnessatlas.com)

---

## Demo video — shot list

Under 2:00 hard. Shoot on device, portrait, no music with an unclear
licence. Judges are not required to watch past two minutes, so the
monetization has to be on screen well before then.

| Time | Shot | Note |
|---|---|---|
| 0:00–0:10 | Cold open on the weekly card: plate, species name, scale study. No logo animation. | Lead with the art. Do not open on a title card. |
| 0:10–0:25 | Scroll the free record: story, threats, the honest "what's uncertain" line, sources list. | Land that sources are real and visible. |
| 0:25–0:35 | Tap **I BEAR WITNESS**. Show the count. Say aloud: this records attention, not an outcome. | The thesis of the whole app. |
| 0:35–0:45 | One credible action, then a private reflection being typed. Say: never leaves the device. | |
| 0:45–1:05 | INDEX → THE WORKS → **Field Season One cover** → contents → a chapter with narration playing. | This is the design case. Let the cover breathe ~2s. |
| 1:05–1:30 | **The purchase.** Real StoreKit sheet, real confirmation, content unlocking immediately. | The hackathon requirement. Must be on screen, unfaked. |
| 1:30–1:45 | The Atlas cover, two durations on one page, identical access. Mention the tip grants nothing. | |
| 1:45–2:00 | Close on the weekly card. One line: the ritual is free and stays free. | |

Notes: capture a real purchase against a sandbox account, not a mock, and
don't cut away mid-sheet — judges are watching for exactly that. Keep the
narration honest; no "help save" phrasing anywhere in the voiceover.

---

## Submission field checklist

| Field | State |
|---|---|
| App Store URL, fully published | **BLOCKING** — must be live by 09-30, not merely in review |
| RevenueCat SDK powers ≥1 IAP | Done — verified against the live offerings API |
| Text description | Above |
| Demo video, <2 min, public on YouTube/Vimeo | Shot list above; not yet shot |
| 1024×1024 icon | `docs/icons/icon-final-light-1024.png` |
| Screenshot 1179×2556, no device frame | `docs/appstore/devpost/` |
| Promo codes for judges | **Required** — no product has a free trial, so codes are the only route. Generate in ASC after approval; judges need Field Season *and* an Atlas offer code. |
| Categories entered | Peace Prize, Design Award, HAMM |

Not eligible for the Grand Prize, which is judged on post-release growth —
there's no launch history to show. Not eligible for Next Gen (student-only),
Best Game, or Catvertising (no RevenueCat Ads).
