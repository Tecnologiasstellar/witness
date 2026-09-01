# Mobbin research: Witness menu & paid-product distribution

- **Date:** 2026-09-01
- **Program:** approved query battery S1–S14 (plan of record: `~/.claude/plans/what-if-we-used-modular-dijkstra.md`)
- **Authority:** report only, no code. Every recommendation is scored against D-020 (`docs/DECISIONS.md:156`), `docs/ACCESS_AND_COMMERCE_SOURCE_OF_RECORD.md` §5.3 (language rules) and §9.1 (never a five-level pricing wall), and the UI-test invariant *"Today opens straight into the ritual with no paywall or price."* Anything touching the free-ritual invariant is auto-rejected regardless of evidence.
- **Disposition default:** post-launch backlog. Nothing in this report gates the 2026-09-15 submission.

---

## 1. Executive summary (top 5)

1. **The INDEX / distributed-doors architecture is validated by the evidence** — ACCESS-first and SUPPORT-last ordering, settings-as-sheet, quiet status rows, and money-free settings are the mainstream calm pattern; ship it as designed.
2. **Cabinet locked plates should show full artwork with a small lock chip** — every paid content library observed (6 apps) keeps locked artwork and titles fully legible; ghosting/blur has zero paid-library precedent, and Witness currently dims plates to 35% opacity. Highest impact-per-line change found (R1).
3. **State the Atlas duration arithmetic quietly** — badge-free, default-free, math-free duration pairs are nearly unprecedented (16 of 25 apps badge the longer plan; Paramount+ celebrates a 16% gap, the size of Witness's own); without a per-month line, selections will likely skew to the cheaper 6-month (R2).
4. **The signed maker's-letter register is the strongest calm-commerce pattern in the wild** (one year, timespent, Lumy, Not Boring, DailyArt) — borrow it for the Support surface copy (R3).
5. **Two Witness choices are genuinely off-map and are recorded as founder decisions:** the single fixed $9.99 tip (every observed tip jar is a 3–5 amount ladder, none preselected — AMEND-1) and the 6-month subscription term (zero apps in 28 results sell one — noted, not a change request).

---

## 2. Method

15 research agents ran **56 Mobbin searches** (search_screens ×48, search_flows ×5, search_sections ×3) against the approved S1–S14 battery, examining roughly **430 screens/flows/sections across ~120 distinct apps**. Every observation below was made from the actual screen images, not metadata. Frequencies are counts of distinct apps actually exhibiting a pattern in what was examined.

| # | Query (primary) | Tool | Results examined |
|---|---|---|---|
| S1 | settings screen meditation journaling minimal | screens ×2 | 24 |
| S2 | account subscription status settings | screens ×2 | 22 |
| S3a | per-app settings: Waking Up, Headspace, Calm, Balance, Endel | screens ×12 | 60 |
| S3b | per-app settings: Merlin, Day One, Flighty, Bear, Overcast, Things 3 | screens ×12 | 51 |
| S4 | tab bar with three tabs minimal editorial | screens ×3 | 22 |
| S5 | home screen one featured daily card nature calm | screens ×2 | 24 |
| S6 ★ | subscription paywall annual monthly toggle | screens ×3 | 28 |
| S7 | subscription purchase flow meditation app | flows ×3 | 12 flows |
| S8 | pricing section calm minimal two options (web) | sections ×3 | 34 |
| S9 ★ | one time purchase lifetime unlock | screens ×2 | 25 |
| S10 | book preview sample chapter audio purchase | screens ×2 | 24 |
| S11 | tip jar support the developer | screens ×3 | 36 |
| S12 | locked content library grid blur unlock | screens ×3 | 32 |
| S13 ★ | onboarding flow ending in paywall with free trial | flows ×2 | 8 flows |
| S14 ★ | paywall lifetime + subscription on one screen | screens ×2 | 25 |

**Coverage caveats (honest gaps):**
- **Merlin Bird ID, Day One, and Overcast are not retrievable on Mobbin iOS** (12 query variants; name collisions with unrelated apps). The three most on-thesis comparables contributed nothing. Balance's settings screen is also unretrievable, and Headspace's settings list was partially obscured in its only capture.
- The 14 named benchmark apps did not surface at all in the commerce-heavy cells (S6, S9, S12, S14) — that evidence skews toward streaming/fitness/indie-utility apps whose conversion culture is louder than Witness's category.
- Toggle-state screenshots may reflect Mobbin's capture flow rather than true landing defaults; radio-button preselection was treated as the more reliable default signal.
- **Follow-up (backlog):** a manual on-device screenshot pass of Merlin, Day One, Overcast, and Balance before treating the settings-pattern picture as complete.

The Mobbin MCP exposes search tools only — screens cannot be saved to collections from here. The Appendix lists all keeper URLs grouped by the five planned collections (`witness-nav`, `witness-atlas`, `witness-fieldseason`, `witness-support`, `witness-contrarian`) for a manual save session.

---

## 3. Findings by research question

### RQ-Nav: INDEX structure and ordering (S1, S3a, S3b)

- **ACCESS-first is the majority pattern** (9 apps: 5 Minute Journal, Finch, How We Feel, Ten Percent Happier, ABY Journal, Speak, Pocket, Calm, Xbox) and **support/help-last is reliable** (6 apps). Witness's ACCESS → … → SUPPORT order in [SettingsView.swift](../../WitnessApp/Features/Settings/SettingsView.swift) matches convention exactly.
- **Paid status renders as a quiet fact, not an upsell:** "Subscription / Will renew on Apr 17, 2024" (5 Minute Journal), "Finch Plus — Active" (Finch). Zero of the four retrievable tonal comparables (Calm, Waking Up, Headspace, Endel) show a price or upsell banner anywhere inside settings.
- **Five sections is above the calm norm.** The quietest screens use 2–4 groups (Ten Percent Happier: four groups of exactly two rows; How We Feel: effectively two). **PRIVACY as a standalone section is nearly unprecedented** — in 4 of 5 apps that surface privacy it is a single row inside an App/Legal/Data group; only ABY Journal's "YOUR DATA" group compares.
- **Settings-as-modal-sheet is well precedented** (Things 3, Bear, Mammoth, Brilliant, Suno + 6 more in S4) — INDEX-as-sheet is mechanically mainstream, though every observed sheet is titled literally "Settings"; the name "INDEX" has no precedent (recorded as an identity choice, no change recommended).
- **Counter-evidence, stated honestly:** the genre's best indie utility, Flighty, embeds purple PRO banners *inside* settings subscreens, and Mammoth pins a gold upgrade row at the top of settings — the craft leaders treat settings as a legitimate contextual door. Witness's purchase-neutral INDEX is quieter than even Flighty, which makes the findability of the ACCESS rows load-bearing.

### RQ-Access-status: the ACCESS overview (S2)

- "Active until [date]"-style plain facts are the near-universal status form (10 apps show an explicit date; 11 name the plan in ordinary words). **Nobody shows entitlement IDs or a tier grid in settings** — §9.2 is squarely mainstream.
- Restore Purchases appears as an undecorated row adjacent to Manage Subscription (8 apps); Manage defers to the OS (7 apps). Witness's row anatomy matches Deezer's (the cleanest observed: plan fact / Manage / Restore).
- 16 of 22 active-status screens carry **no upsell at all**; The Atlantic proves the serif-editorial register ("You have Digital access to The Atlantic through August 12, 2025").
- **Gap observed:** Mimo and Kitchen Stories add one matter-of-fact sentence on what lapses after the expiry date. Witness's Atlas footnote covers this pre-purchase but the *active* state shows only the bare status line (→ R6).

### RQ-Tabs: the 3-tab bar and where settings lives (S4)

- All 6 three-tab apps observed label tabs with **title/sentence-case nouns + icons** (Today / Insight / Profile; Streak / Activities / Insights). **All-caps tab labels have zero precedent at the tab-bar level** — caps appear only as settings *section* headers (Substack), which is arguably the register Witness is deliberately borrowing. Recorded as an identity deviation; no change recommended without user-confusion data.
- The **majority pattern spends the third tab on Profile/settings** (Play, CLEAR, Yahoo News); the corner-button route Witness takes is the minority but has a clean precedent (Babbel: 3 content tabs + top-right person icon). FocusFlight additionally shows subscription status as the first block of its settings sheet — direct support for ACCESS-at-top.
- "Today" — not "This Week" — is the standard temporal label (Play, Noom). THIS WEEK is a conscious cadence statement (D-023); no change.

### RQ-Home: commerce on the one-featured-item surface (S5)

- **13 of 22 apps keep the featured hero completely commerce-free** — only editorial badges (duration chips, "New", a live "457 meditating" count). The quiet-door minority is real but small: TIDE's translucent "7 days free trial" pill on its nature hero, and Gentler Streak's low-contrast "Go Premium / 1 week free" row *below* the day's reading.
- Witness's Field Season door on the Today card therefore has precedent but is the minority pattern — and both observed quiet doors lead with *trial length*, which Witness's products can't mimic. Keeping the door small, palette-matched, and price-free (the invariant requires this anyway) is exactly what the two precedents do.
- Counter-evidence: Endel mounts a "Go Premium" card atop its daily Now screen and Balance pins a permanent "SALE - 65% OFF" pill on Today — calm-branded apps demonstrably bet against quietness. Witness is stricter than every comparable observed; that is a taste position, not an industry norm, and it is the doctrine.

### RQ-Atlas: the duration-only chooser (S6 ★, S8)

- **Defaults are genuinely split** (12 longer-preselected vs 12 shorter vs 1 no-default across 25 apps) — but apps that *want* the longer plan actively preselect and badge it.
- **Badging the longer duration is the norm:** 16 of 25 apps ("Best value", "Save 72%", "-16%"…). Witness's conditional "Best value" badge on annual ([AtlasAccessSheet.swift:87](../../WitnessApp/Features/Access/AtlasAccessSheet.swift)) is already mainstream-aligned. (Note: the research plan said "currently no badge" — the code is ahead of the plan.)
- **Per-month reframing splits evenly** (9 reframe, 9 period-only). Paramount+ celebrates exactly a 16% annual saving — the same magnitude as Witness's ~17% per-month gap ($2.50/mo vs $2.08/mo) — so the gap Witness leaves silent is one competitors consider worth naming (→ R2).
- **The 6-month term is unprecedented:** zero of 28 results sell one; every pairing was weekly/monthly/annual/lifetime. Users have no schema for it — the "Renews every 6 months" caption is carrying real weight. Not a change request (D-020 is decided); recorded.
- The badge-free/no-default posture has exactly one shipped precedent each: **"one year"** (typewriter letter, two identical buttons) on iOS and **Fruitful** (segmented duration control, plain "$135 billed every 3 months" note) on the web — both proof it ships, neither proof it converts.

### RQ-Funnel: purchase flow and post-purchase states (S7)

- The observed funnel is: contextual door → single offer surface → **native StoreKit sheet as the only confirmation** (4 apps show the bare "You're all set" alert) → a changed settings row ("Pro — Active", renewal date) as the persistent state. Witness's plan matches stage for stage.
- Post-purchase ceremony splits: none (Waking Up, Ahead), a welcome moment (Headway, TIDE, Headspace), or just the changed row. Persistent chrome badges are rare and read as clutter (MyFitnessPal's header crown).
- **Best transferable idea:** Headspace converts purchase momentum into the notification opt-in ("Remind me / Maybe later") immediately after the sheet — the proven slot for Witness's weekly-reminder ask (→ R7).
- Tide Guide is the model for one-time-beside-subscription in the post-purchase settings state: "Active / Plan: Annual / Renewal: 23/6/26" with "Buy Lifetime — One-time payment." as a calm adjacent row.

### RQ-FieldSeason: permanent purchase beside a subscription (S9 ★, S10)

- **The market default is the opposite of Witness:** 11 of 17 apps merge lifetime into the subscription sheet as a third row, where it anchors the annual price. **Genuine surface separation exists but is rare and indie:** Crouton (two independent product cards, each with its own detail screen, related by a cross-reference line "All features of Crouton Plus and:") and the (Not Boring) apps (lifetime on its own tab, a whisper-quiet "All plans" link). Witness's structure has craft precedent, not category-leader precedent.
- **Permanence lexicon (11 apps):** "Pay once, enjoy forever" / "One time payment, yours forever" / "One-time purchase, lifetime access". The word "permanent" itself is almost never used — the market phrase is **"one-time"** (→ R4).
- **Preview anatomy validated:** cover-dominant stack, sample as an instant-play button (never an inline excerpt), price living *in* the purchase control (Fable's button is the price; Apple Books puts the price pill beside "Sample"), no interstitial paywall for a single item — [FieldSeasonPreviewView.swift](../../WitnessApp/Features/Access/FieldSeasonPreviewView.swift) matches the bookstore cohort closely.
- **Honest tension:** the calm cohort (Waking Up, Spotify, Headway) shows *no price at all* on content surfaces ("Included in Premium"); every inline-price app is a bookstore. Witness is mixing bookstore pricing mechanics into a calm-app tone — no observed app does both, so the combination is an invention. Defensible, but there is no proof either way.

### RQ-Cabinet: locked-plate teaser density (S12)

- **The dominant paid-library treatment is full artwork + a small corner lock chip** (Hatch Sleep, Calm, Mindvalley, Numo, Weverse, Peloton — 6 apps): the lock hides *access*, never *identity*. **Blur appears only in social-reciprocity/secret contexts** (Retro "Post to see", Posh), never paid libraries. Witness's current 35%-opacity ghosting ([ArchiveView.swift:226](../../WitnessApp/Features/Archive/ArchiveView.swift)) is heavier than any paid-library treatment observed (→ R1).
- **Density warning:** every all-locked wall observed belongs to a gamified badge/level system (Me+ "Not obtained", Life Reset "Reach Level 10"). A Cabinet that is mostly locked will read as an achievement wall regardless of styling — mitigated at launch by the small archive, worth rechecking as the archive grows.
- **Tap-through to a contextual sheet (not a full-screen paywall) is the calm norm** (X half-sheet with "Maybe later", Weverse "Product details" sheet, Life Reset's partial-reveal sheet). Cabinet → AtlasAccessSheet already matches.

### RQ-Support: the tip (S11)

- **Every true developer tip jar found (DailyArt, Crouton, Lumy) is a 3–5 amount ladder with none preselected**, anchored low (Crouton: S$0.98 → S$9.98), using escalating warmth (hearts, emoji, filling jars). **A single fixed amount has no precedent anywhere in the sample** — and $9.99 equals the *top* of Crouton's ladder ("Outrageous Tip"). Witness likely forfeits both the $1–3 impulse thank-you and the $30+ patron (→ AMEND-1, founder decision).
- **"Donate" appeared in zero screens** — the observed verbs are support, tip, contribution, sponsor, pledge, participation. §5.3's ban matches the market's own instinct.
- **No app ships a custom tip thank-you** — everyone leans on the StoreKit "You're all set" alert; DailyArt thanks in advance in the pitch copy instead. A quiet editorial thank-you state would put Witness slightly ahead of pattern, not against it (→ R5).
- The quiet-register proof points: Panera's "Never expected. Always appreciated." and Lumy's signed ask ("11 years of Lumy… — RAJA VIJAYARAMAN") — personal attribution by a named solo developer is the lever that fits Witness exactly (→ R3).

### RQ-Contrarian (S13 ★, S14 ★) — see §7 for the plain-language verdict

---

## 4. Pattern inventory (consolidated)

Evidence tiers: **major** ≥5 apps, *niche* 3–4, (thin) ≤2 — thin patterns are used only where the plan's ≥2-example floor for recommendations permits.

| Pattern | Apps | Placement / behavior | Bucket |
|---|---|---|---|
| Access/account group first in settings | **9** | Top of settings; quiet status row, never upsell | witness-nav |
| 2–4 settings groups is the calm norm | **9** | Whole-screen; Ten Percent Happier sparsest | witness-nav |
| Support/help last + version footer | **6** | Final group | witness-nav |
| Privacy is a row, not a section | **5** | Inside App/Legal/Data groups | witness-nav |
| Settings as dismissible modal sheet | **11** | X/Done/drag-handle | witness-nav |
| No upsell inside settings (tonal comparables) | *4/4* | Calm, Waking Up, Headspace, Endel | witness-nav |
| Status = plain sentence + explicit date | **10** | Settings/account | witness-atlas |
| Restore row adjacent to Manage row | **8** | Access/subscription group | witness-atlas |
| No upsell on active-status surfaces | **16/22** | Exceptions: Tomorrow, Tide Guide, ElevenReader | witness-atlas |
| 3-tab bars: title-case nouns + icons, zero caps | **6/6** | Bottom bar | witness-nav |
| Settings via Profile-as-3rd-tab (majority) vs corner button (minority) | *4* | Babbel = corner precedent | witness-nav |
| Featured hero is commerce-free | **13/22** | Quiet-door minority: TIDE, Gentler Streak | witness-fieldseason |
| Savings badge on longer duration | **16/25** | On card/tab of the longer plan | witness-atlas |
| Duration default split 12/12 | **25** | Radio paywalls: 6 long / 5 short / 1 none | witness-atlas |
| Per-month reframe of longer plan | **9/25** | Caption under period price | witness-atlas |
| 6-month subscription term | **0/28** | Unprecedented | — |
| StoreKit sheet/alert as sole purchase confirmation | *4* | No custom receipt screens | witness-atlas |
| Post-purchase changed settings row ("Active", renewal date) | *3* | Tide Guide, Alma, Outlook | witness-atlas |
| Post-purchase notification opt-in | (2) | Headspace (+ Headway welcome-moment family, 3) | witness-atlas |
| Lifetime merged into subscription sheet (market default) | **11/17** | Last row; anchors annual | witness-contrarian |
| Separate product surfaces (Witness's structure) | *3* | Crouton, (Not Boring) ×2 | witness-fieldseason |
| "One-time / pay once, yours forever" lexicon | **11** | Subtitle of the permanent option | witness-fieldseason |
| Sample + purchase as sibling pills, price in the control | **5** | Apple Books, Fable et al. | witness-fieldseason |
| Locked items: full artwork + small lock chip | **6** | Paid libraries; blur = social-secret only | witness-atlas |
| All-locked walls read as gamified progression | **5** | Badge/level systems | witness-contrarian |
| Locked tap → contextual sheet, not takeover | **5** | X, Weverse, Life Reset, Photoroom, Neuecast | witness-atlas |
| Tip jars: 3–5 preset ladder, none preselected | *3/3* | DailyArt, Crouton, Lumy — no single-amount precedent | witness-support |
| "Donate" absent from all support surfaces | **7** | Verbs: support/tip/contribution/sponsor/pledge | witness-support |
| Signed maker's-letter commerce prose | **5** | one year, timespent, Lumy, Not Boring, DailyArt | witness-support |
| Onboarding trial paywall, annual preselected + badged | **5** | All dismissable (soft wall) | witness-contrarian |
| Trust scaffolding on paywalls (reminder promises, charge timeline) | *3* | AllTrails, Calm, Waking Up | witness-contrarian |
| Lapse-consequence sentence beside status | (2) | Mimo, Kitchen Stories | witness-atlas |

---

## 5. Ranked recommendations — doctrine PASS

Each: change → evidence (≥2 Mobbin examples) → impact (1–5, prevalence × conversion proximity) → effort (S = copy/ordering in an existing view) → file. All are invariant-safe and use no §5.3-banned language.

### R1 — Show locked Cabinet plates at full strength with a small lock mark — **Impact 4 · Effort S · PASS**
Replace the 0.35/0.6 opacity ghosting on locked plates with full artwork, legible title, and a compact lock chip in one corner. The lock should hide access, not identity — the plate itself is the Atlas sheet's best advertisement.
**Evidence:** [Hatch Sleep](https://mobbin.com/screens/26213e68-17ef-40f9-a9df-301d82705c9e), [Calm](https://mobbin.com/screens/ef1a6269-491a-47c4-8056-4001889880bd), [Wysa (grayscale contrast + titles legible)](https://mobbin.com/screens/c3aa23c1-0deb-450f-ba3e-82847b14e364), plus Mindvalley, Numo, Weverse, Peloton (6 apps full-artwork).
**File:** `WitnessApp/Features/Archive/ArchiveView.swift` (ArchiveCard, `opacity` at ~226/242).
**Doctrine:** PASS — teaser density; free plates unaffected; no copy change.

### R2 — State the Atlas duration arithmetic in the captions — **Impact 4 · Effort S · PASS**
Add the per-month equivalence to each duration button's caption ("Renews every 6 months · $2.50/month" / "Renews annually · $2.08/month"), keeping the existing conditional "Best value" badge and the "Both durations unlock exactly the same Atlas" line. Evidence says an unexplained pair reads as arbitrary and selections skew to the cheaper option; plain arithmetic is calm, not hype.
**Evidence:** [MyFitnessPal](https://mobbin.com/screens/0ce65583-4e00-4345-825b-b6ef6e0a02fc) ("$8.34 / mo … billed annually"), [Paramount+](https://mobbin.com/screens/dabc3906-4459-4ac1-be05-9c2832b31888) ("You're saving 16% with annual billing" — Witness's own gap size), [Fruitful (web, badge-free)](https://mobbin.com/sites/sections/a3608df7-8dd4-4bb5-a149-ce8276e15175) — 9 iOS apps total reframe per-month.
**File:** `WitnessApp/Features/Access/AtlasAccessSheet.swift` (durationButton captions; one computed per-month string in CommerceModel).
**Doctrine:** PASS — §9.1 bans a tier *grid*, not arithmetic; §5.3 unaffected. Revenue note: annual $24.99 vs 6-month $14.99 — the skew this corrects is worth ~40% per-subscriber-year.

### R3 — Sign the Support ask, in Witness's voice — **Impact 3 · Effort S · PASS**
Add a short first-person, named-and-signed line to the Support surface (the §5.3-approved "Support the work behind Witness" voice, signed by AV) and close in the Panera register ("Never expected. Always appreciated." — write Witness's own line, don't copy). Personal attribution by the named solo maker is the observed lever.
**Evidence:** [Lumy (signed by its solo developer)](https://mobbin.com/screens/55f9ae33-a3bd-498d-a7a2-dcada6dea0f8), [timespent](https://mobbin.com/screens/b00fa672-0e18-4d18-8040-8912c0af8ca7), [(Not Boring) Weather](https://mobbin.com/screens/e24c1d59-86e6-4813-8b68-2ead9c5c5797), [DailyArt](https://mobbin.com/screens/4ac0bdc6-2b23-4675-83cb-a940584c2d44) (5 apps in the letter register).
**File:** `WitnessApp/Features/Access/SupportWitnessView.swift` (copy only).
**Doctrine:** PASS — no banned words; no access/status implication.

### R4 — Say "one-time" at the Field Season decision point — **Impact 3 · Effort S · PASS**
The purchase button's subtitle is currently the bare price; add the market's load-bearing phrase: "One-time purchase" (e.g. subtitle "$19.99 · One-time purchase"). "Permanent" does the doctrinal work elsewhere on the page; "one-time" is the phrase buyers scan for to confirm it isn't a subscription — the exact clarity risk D-020 names as its tradeoff.
**Evidence:** [Crouton](https://mobbin.com/screens/d377dafe-6c91-42c7-b3df-0b1688db4b12) ("One time purchase" as the product-type label), [Orbit](https://mobbin.com/screens/fb696d7b-1e16-4b8f-9494-78be7e7aad5c) ("Pay once and enjoy forever"), + 11-app lexicon (S9).
**File:** `WitnessApp/Features/Access/FieldSeasonPreviewView.swift` (purchaseArea subtitle).
**Doctrine:** PASS.

### R5 — A quiet editorial thank-you state after the tip — **Impact 2 · Effort S · PASS**
After a successful Support purchase, show a Witness-voiced gratitude notice (AccessStateNotice style) in place of relying on the StoreKit alert alone. No badge, no status, no entitlement — gratitude only. This is slightly *ahead* of pattern (no app ships a tip-specific thank-you) but the adjacent evidence is consistent.
**Evidence:** [Craft's custom purchase thank-you](https://mobbin.com/screens/315040b1-e788-4439-84d6-698d4b611e2d), [Letterboxd "undying gratitude" copy](https://mobbin.com/screens/bdc54790-0a70-4fb4-bd6e-3492effb9bde), DailyArt thanks-in-advance (3 reference points).
**File:** `WitnessApp/Features/Access/SupportWitnessView.swift`.
**Doctrine:** PASS — D-020 forbids access/badges/status as Support incentives; a thank-you sentence grants none.

### R6 — One lapse-consequence sentence with the active Atlas status — **Impact 2 · Effort S · PASS**
The pre-purchase Atlas sheet already explains what remains after lapse; the *active* state shows only "Atlas is active. [status]". Reuse the existing footnote sentence in the active branch (and consider the same line under the ATLAS row detail in INDEX) so a paying member never has to guess what the date means.
**Evidence:** [Mimo](https://mobbin.com/screens/d7916dc6-d8cc-4969-8484-b2eb5cc508e5) ("Active until 16 March 2026 — after this date you'll lose access to…"), [Kitchen Stories](https://mobbin.com/screens/3970112e-a924-4510-b117-4c015308fece) (2 examples — at the plan's evidence floor).
**File:** `WitnessApp/Features/Access/AtlasAccessSheet.swift` (active branch).
**Doctrine:** PASS.

### R7 — Post-purchase weekly-reminder opt-in moment — **Impact 3 · Effort M · PASS**
After a successful Atlas or Field Season purchase (StoreKit sheet dismissed, success state visible), offer the weekly reminder if not already enabled — "Remind me / Maybe later" register, plain secondary decline. Converts purchase momentum into the retention loop; the reminder is a free-tier feature so no doctrine tension.
**Evidence:** [Headspace's post-purchase notification ask](https://mobbin.com/flows/ccf14439-4c45-4d56-b031-45173490cafe), [Headway's welcome moment](https://mobbin.com/flows/69e7e5d7-fc79-4263-afbb-a4a2f67acd5a), TIDE (3 apps with a post-purchase moment).
**Files:** `WitnessApp/Features/Access/*` + `ReminderService` wiring. **Blast radius note:** adjacent to purchase-flow state — build post-launch, with tests, per the money-path testing policy.
**Doctrine:** PASS.

### R8 — Consolidate INDEX toward 3–4 sections — **Impact 2 · Effort S · PASS (ranked last deliberately)**
Evidence says fold PRIVACY's rows into CONTENT (or a combined group) to land at 3–4 sections. **Counterargument, recorded:** Witness's PRIVACY section is a trust *statement* ("NO ACCOUNT · NO PERSONAL DATA"), not settings plumbing — a deliberate editorial deviation, like ABY Journal's "YOUR DATA". Recommend deferring until real users report the INDEX as heavy; do not change on convention alone.
**Evidence:** privacy-as-row in [SKIMS](https://mobbin.com/screens/632e1f2f-c313-4715-ae39-bff59efd0537), [Zocdoc](https://mobbin.com/screens/e82fc8af-6d09-407d-b390-7b62188707a0), CapCut, How We Feel (4–5 apps); 2–4 group norm (9 apps).
**File:** `WitnessApp/Features/Settings/SettingsView.swift`.

**Validations requiring no change (evidence-backed):** ACCESS-first/SUPPORT-last order · INDEX-as-sheet mechanics · quiet status-row anatomy (plan fact / Manage / Restore) · no upsell inside INDEX · Field Season preview anatomy (cover → stats → instant-play sample → contents → price-in-button) · Cabinet tap-through to a contextual sheet · StoreKit sheet as sole confirmation + changed ACCESS row as the persistent state · the existing conditional "Best value" badge.

---

## 6. Requires D-020 / §9 amendment — *founder decision required*

These conflict with a quoted doctrine line. They are **not recommended by default**; they are recorded because the evidence is strong enough that the founder should decide consciously.

### AMEND-1 — Tip ladder: 3–5 preset amounts instead of one $9.99
**Conflicts with:** D-020 — *"Offer exactly five user-facing engagement choices"* (`docs/DECISIONS.md:160`); also the D-024 webhook's *"strict allow-list of the four D-020 product IDs"* (`docs/DECISIONS.md:194`) — each preset is a distinct ASC consumable, so this touches products, RevenueCat, and the webhook allow-list (loud blast radius, money path).
**Evidence:** every developer tip jar observed is a ladder with none preselected — [DailyArt (5 heart-graded presets)](https://mobbin.com/screens/4ac0bdc6-2b23-4675-83cb-a940584c2d44), [Crouton (S$0.98 → "Outrageous Tip" S$9.98)](https://mobbin.com/screens/cc35aa1c-f886-4953-977d-fb5624744adc), [Lumy](https://mobbin.com/screens/55f9ae33-a3bd-498d-a7a2-dcada6dea0f8), plus Yuka's pay-what-you-want. A single fixed amount has **zero precedent**, and $9.99 is the top of the observed ladder — the design forfeits small impulse yeses and larger patron gifts.
**If approved:** 3 presets ($2.99 / $9.99 / $29.99, none preselected, no badges) would stay within the observed calm form. Post-launch only; needs support-revenue data first.

### AMEND-2 — A single calm unified access surface (letter + stacked rows)
**Conflicts with:** §9.1 — *"Never show a five-level pricing wall"* / *"The five choices exist across context, not on one overwhelming screen."*
**Evidence:** the S14 contrarian case (below). **Recommendation: keep the doctrine.** The calm-unified evidence is real but comes from single-product-multi-duration apps; none mixed a no-grant tip with access products, and the aggressive drift (Peanut's countdown grid) shows what the doctrine is a guardrail against.

### AMEND-3 — Atlas intro/trial offer in the Waking Up letter register
**Conflicts with:** D-020's source-of-record supersession of *"older `Witness+`, monthly-subscription, trial, and premium-packaging language"* (`docs/DECISIONS.md:163`); trials were retired in ASC/RevenueCat on 2026-08-27.
**Evidence:** [Waking Up's letter paywall](https://mobbin.com/flows/76fb3fc0-a8e4-41b5-904d-1f108dca056e) ("No Payment Due Now", signed, dismissable) and [AllTrails' honest charge timeline](https://mobbin.com/flows/d2659ba4-db35-4ca6-a17b-02040474ca34) ("Day 5: Get a trial reminder") prove trial machinery can be run honestly and calmly. Revisit only with post-launch conversion data; if ever tested, Waking Up is the tonal template.

### AMEND-4 (FLAG-grade) — Cross-reference Field Season's separate permanent purchase on the Atlas sheet
**Gray area under:** §9.1's architecture — the Atlas-only boundary is *"one calm Atlas sheet → 6 Months or Annual"*; the sheet already names Field Season One as included content, but nothing tells an Atlas buyer that a cheaper permanent purchase of that season exists ($14.99–$24.99 vs $19.99 once). Crouton solves the mirror problem with one cross-reference line; Tide Guide co-locates "Buy Lifetime — One-time payment." post-purchase.
**Evidence:** [Crouton](https://mobbin.com/screens/d377dafe-6c91-42c7-b3df-0b1688db4b12), [Tide Guide](https://mobbin.com/screens/e0f3be7d-acf4-4f14-a657-f62d9ea086d3) (2 examples).
**Risk either way:** adding the line edges toward co-presentation; omitting it risks a member discovering post-purchase that a permanent option existed. One quiet sentence ("Field Season One is also available as a separate permanent edition") is defensible under §9.1's own "secondary explanation" allowance for the Field Season preview — founder's call on whether that allowance runs in both directions.

---

## 7. Contrarian findings, stated plainly (S13 ★, S14 ★)

**What the industry default buys, and Witness declines (S13).** Every observed onboarding funnel asks at the moment of maximum motivation — right after the personalization investment — with a free trial removing price risk at decision time, an annual plan preselected and badged, and (the most effective honest element found) explicit trust scaffolding: AllTrails' "Day 5: Get a trial reminder", Calm's "Remind me 2 days before renewal" toggle, Waking Up's money-back promise. Witness gives up peak-moment capture, zero-risk conversion, plan steering, and the reminder-as-reassurance move. Two softenings: every onboarding paywall observed was dismissable (the default is a soft wall — Witness rejects sequencing pressure, not lockouts), and Apple Music demonstrates large-scale monetization with *zero* onboarding interrupt, selling through offer cards in the feed — the closest big-company validation of the contextual-door model. **This pattern remains auto-rejected: it prices the path into the ritual.**

**The best case for a unified paywall (S14).** "one year" (a typewriter letter signed "love, Sam & Alec" above two identical flat buttons) and timespent (a signed note promising "no dark patterns", prices as rubber stamps) prove a unified surface can be the *calmest* money moment in an app — one honest conversation in the maker's own voice instead of doors scattered through the experience, with restore/legal/family-sharing living in one place and the lifetime price anchoring the subscription (13 of 15 apps place lifetime last, unbadged, as a trust signal). What makes those screens calm is fully specifiable: prose instead of checklists, stacked rows instead of column grids, at most one quiet emphasis, no countdowns, ownership language for lifetime. **Two limits keep the doctrine standing:** every calm exemplar sells one product in multiple durations (the evidence most directly endorses the Atlas sheet Witness already has, and only weakly a Field Season + Atlas + tip merge — no observed screen mixes a no-grant tip with access products); and the same pattern's aggressive end (Peanut's "39% off ends in 47:27:13" grid) shows how a unified surface drifts once growth pressure adds badges — §9.1 is partly a guardrail against Witness's future self.

**Smaller honest strikes recorded elsewhere:** all-caps tab labels and the "INDEX" name have zero precedent (identity choices, kept); the Field Season door on the hero is the minority pattern (kept, with TIDE/Gentler Streak as precedent); the badge-free duration pair and the 6-month term are near-unprecedented (addressed by R2's arithmetic, term kept per D-020); the single-amount tip is unprecedented (AMEND-1); benchmark-app absence from commerce queries means the calm-indie evidence base (one year, timespent, Crouton) is Witness's true peer group but thinner than the named benchmark set.

---

## 8. Auto-rejected (free-ritual invariant)

Rejected regardless of evidence strength, per the program's standing rule:

- **Onboarding/trial paywall in any form** (S13, 5 apps) — prices the path into the ritual.
- **Home-surface commerce louder than the existing door:** Endel's "Go Premium" hero card, Balance's persistent "SALE - 65% OFF" pill, Deepstash's docked discount bar, TIDE's trial pill *on* the hero (S3a/S5). The Today card keeps its single quiet, price-free Field Season door and nothing else.
- **Quantity metering of the ritual** (Opal "2 allowed", Liven token counters) — monetizes attention to the ritual itself.

---

## 9. Disposition

**Default: post-launch backlog — nothing here gates the 2026-09-15 submission.** The TestFlight upload remains blocked on the Apple account transition; no build should be respun for this report.

- **If (and only if) a new build is cut before 09-15 for other reasons**, R1 (locked-plate legibility) and R2 (duration arithmetic) are the two changes worth riding along: both PASS, effort-S, invariant-safe, and they sit directly on the two conversion surfaces.
- **Post-launch backlog, in order:** R3, R4, R5, R6 (copy-level), then R7 (needs tests — purchase-flow adjacent), then R8 (only on user evidence).
- **Founder-decision queue (no default action):** AMEND-1 (tip ladder — revisit with 30 days of support-revenue data), AMEND-4 (Atlas↔Field Season cross-reference line), AMEND-2/AMEND-3 (keep doctrine / revisit only with conversion data).
- **Research follow-up:** manual on-device settings pass for Merlin Bird ID, Day One, Overcast, Balance; save the Appendix keepers to the five Mobbin collections (MCP cannot save to collections).

## 10. Verification against the program's own bar

- Every research question has ≥1 evidence-backed finding ✓ (S1–S14 all reported, incl. negative results for the three unretrievable benchmark apps)
- Frequencies stated as actual app counts; patterns below the ≥5/≥3 thresholds are marked thin ✓
- Every recommendation carries a doctrine flag; every FLAG/AMEND cites the exact line ✓
- Contrarian cells S13/S14 run and written up with the case *against* the distributed doctrine stated plainly ✓
- No recommendation touches the free-ritual invariant or uses §5.3-banned language ✓ (nothing here says Premium, Donate, Adopt, Collect, or claims a conservation outcome)
- Report at `docs/research/MOBBIN_NAV_COMMERCE_RESEARCH_2026-09.md` with disposition ✓ — 09-15 submission unaffected ✓

---

## Appendix — keepers for the Mobbin collections

*(Save manually; the MCP has no collection-write capability.)*

### witness-nav
- Ten Percent Happier — settings sparseness benchmark (4 groups × 2 rows) — https://mobbin.com/screens/0d67c88e-600f-4abe-8bb0-cf9a941a4bc1
- How We Feel — serif editorial settings, ~2 groups — https://mobbin.com/screens/f78493e5-c3a5-445e-b6ea-e86861f305ba
- Waking Up — More-tab ordering template, zero upsell — https://mobbin.com/screens/533321e9-ba67-482d-92e2-080ae2856154
- Waking Up — caps section labels, archival register — https://mobbin.com/screens/c8775d08-22d4-4ab0-b94b-a7ff56c294d5
- Waking Up — sparse Notifications & Reminders sub-screen — https://mobbin.com/screens/f356b472-fb46-4c55-a142-07f195b32a3c
- Things 3 — paid-once app's entire settings as one quiet sheet — https://mobbin.com/screens/fe872e1e-90a8-4409-a62f-8360b64d7080
- Flighty — PRIVACY/danger-zone anatomy (EXPORT / DANGER ZONE) — https://mobbin.com/screens/f5f661b5-4b4c-445f-916d-36d25591917c
- Bear — tone ceiling for museum-quiet settings — https://mobbin.com/screens/d6896454-57df-404c-b731-68e51fb1ee6f
- Gentler Streak — canonical calm 3-tab floating pill — https://mobbin.com/screens/874d09cc-a726-4d7a-abab-6686e81c3d5f
- Babbel — 3 content tabs + corner settings icon (Witness's exact structure) — https://mobbin.com/screens/af715e9f-3b74-4de5-b014-55fa6748aa34
- Linear Mobile — INDEX-as-sheet mechanics — https://mobbin.com/screens/dcea67ad-1c09-4964-9ca2-97d04ec16201
- Deezer — cleanest 3-row access-group anatomy — https://mobbin.com/screens/a09b2ebe-d71d-4e29-ad2b-2d4bce5bd613
- Bloom — Manage + Restore as adjacent quiet pair — https://mobbin.com/screens/f5dd019f-7955-4700-a9fe-120a50ce6d4c
- Open — museum-quiet dated daily hero, zero commerce — https://mobbin.com/screens/83844f1f-ff19-4a59-b7b1-3eabba602a02
- Headspace — brand-name price-free daily surface — https://mobbin.com/screens/1cba404f-413c-4a8b-be36-d791e9ca4fed
- Atoms — serif editorial daily card, editorial-only badging — https://mobbin.com/screens/63fd9e06-83a9-4e76-b3f9-760b48a04276

### witness-atlas
- The Atlantic — serif one-sentence access status with date — https://mobbin.com/screens/665d45c6-a8a9-4c5a-9b41-ff129405e14d
- Mimo — literal "Active until [date]" + lapse sentence — https://mobbin.com/screens/d7916dc6-d8cc-4969-8484-b2eb5cc508e5
- 5 Minute Journal — subscription as quiet top-of-settings status row — https://mobbin.com/screens/f0bf1130-b291-4d3c-a6b5-a4480ad40612
- ABY Journal — one-row account status + standalone YOUR DATA group — https://mobbin.com/screens/121ba456-3b84-44f9-87b0-71f03ecfde6f
- Brilliant — "Premium" as unstyled second row, no price in settings — https://mobbin.com/screens/81350243-ef4c-4d4c-aab3-fb272d5f5e83
- Epidemic Sound — flat "No subscription" status + grayed gated row — https://mobbin.com/screens/445b227c-15da-4c62-9ff8-d841bc93ec8b
- Calm — Manage Subscription placement model — https://mobbin.com/screens/fb9cddf4-e65c-4177-b99e-e4d212418b33
- FocusFlight — plan status as first block of settings sheet — https://mobbin.com/screens/c649b8ff-1a08-4c27-a757-e51d748790ce
- one year — badge-free, default-free two-price sheet (the Atlas posture, shipped) — https://mobbin.com/screens/df0d769a-48b0-46b0-beb4-9f8225d4ce5a
- MyFitnessPal — the maximal duration pattern in one clean screen (deviate consciously) — https://mobbin.com/screens/0ce65583-4e00-4345-825b-b6ef6e0a02fc
- Hatch Sleep — trial-length as the quiet duration differentiator — https://mobbin.com/screens/e956459e-49dd-4768-bce7-5bb72d0472e3
- Waking Up — letter-style single-plan funnel, zero ceremony — https://mobbin.com/flows/307fd1cf-7f03-4a87-9192-abd5a3dd704a
- Headspace — complete funnel incl. post-purchase reminder ask — https://mobbin.com/flows/ccf14439-4c45-4d56-b031-45173490cafe
- Alma — post-purchase membership page ("Renews Jan 6, 2026") — https://mobbin.com/flows/25890e1a-e1a2-4421-a941-eb237d5d05d0
- Tide Guide — duration rows + restore on one quiet sheet — https://mobbin.com/screens/ac1f26f9-2a89-4539-9ad2-4388c495269e
- Hatch Sleep — locked/free tiles mixed, full artwork + small chip — https://mobbin.com/screens/26213e68-17ef-40f9-a9df-301d82705c9e
- Wysa — grayscale-not-blur, titles legible, collection-level unlock — https://mobbin.com/screens/c3aa23c1-0deb-450f-ba3e-82847b14e364
- Life Reset — locked tap → calm partial-reveal sheet — https://mobbin.com/screens/2436d96a-56d8-4f73-9b8d-156cdf145174
- Spotify — "Included in Premium" access labeling without price — https://mobbin.com/screens/58e33db7-85c9-41c3-a639-75dd8d4d4b22
- Craft (web) — voice model: "Your pace, your plan", free tier honored — https://mobbin.com/sites/sections/bed3095e-daf9-4f59-b9d9-4455f460f72b
- Fruitful (web) — the only badge-free duration chooser observed — https://mobbin.com/sites/sections/a3608df7-8dd4-4bb5-a149-ce8276e15175

### witness-fieldseason
- Crouton — two separate product cards + cross-reference line — https://mobbin.com/screens/d377dafe-6c91-42c7-b3df-0b1688db4b12
- (Not Boring) Timer — lifetime with its own dignified surface + "All plans" whisper link — https://mobbin.com/screens/1b898d31-140d-4d6c-a7fa-52a56f9fb6bf
- Orbit — "Pay once and enjoy forever" as calm footnote — https://mobbin.com/screens/fb696d7b-1e16-4b8f-9494-78be7e7aad5c
- Fable — sample pill + price-as-button, serif editorial — https://mobbin.com/screens/22f4c7c2-9fb4-43cf-b839-96a403cf4b54
- Apple Books — canonical cover/sample/price anatomy — https://mobbin.com/screens/73c32c36-5261-4083-9c09-67fc2e61bca4
- ElevenReader — chapter list + narration preview bar — https://mobbin.com/screens/ee3ee9ff-e838-471b-a1b9-aec27a2850d1
- Hatch Sleep — illustrated audio story with first-class Preview — https://mobbin.com/screens/41f13604-0ae7-42e0-a4ce-26a230235755
- Weverse — lock-badged content → quiet one-purchase product sheet — https://mobbin.com/screens/20a7b727-eddc-454f-959c-9942c1c941a9
- Tide Guide — one-time beside subscription in post-purchase settings — https://mobbin.com/flows/5bef40b5-8760-4eb3-b232-dfaf5da7b41b
- TIDE — quiet chip on a serene hero (door precedent) — https://mobbin.com/screens/78e35490-363e-4e5b-87f2-48a9fe3459ce
- Gentler Streak — low-contrast door *below* the daily reading — https://mobbin.com/screens/597f67c9-a016-40a8-b3fd-2e0c6cd70bf9
- Apple Music — offer-as-content in the feed, no onboarding interrupt — https://mobbin.com/flows/3afd5e80-566c-4c10-b466-ad3a24c4076f
- Sketch (web) — "Yours to keep, forever" license beside subscription — https://mobbin.com/sites/sections/312580d5-9c82-48fd-9ef4-dbc6275c3768
- (Not Boring) Calculator — "Support Indie" as a stated benefit line — https://mobbin.com/screens/543dba87-6cba-40cf-b62d-a797471ff679

### witness-support
- DailyArt — canonical 5-preset tip jar, none preselected — https://mobbin.com/screens/4ac0bdc6-2b23-4675-83cb-a940584c2d44
- Lumy — poetic ask signed by the named solo developer — https://mobbin.com/screens/55f9ae33-a3bd-498d-a7a2-dcada6dea0f8
- Panera — "Never expected. Always appreciated." — https://mobbin.com/screens/5f5e727c-aae8-498b-81f3-e5982058d3b7
- Substack — dignified verb set + soft decline — https://mobbin.com/screens/3f4dcd74-9b0f-4c34-b9ff-afc5c5702b98
- timespent — "not ready for a paid tier? that's ok." — https://mobbin.com/screens/c9098dc0-df20-49c8-9ff0-3720857cee3a
- (Not Boring) Weather — "100% member supported… Thank you!" — https://mobbin.com/screens/e24c1d59-86e6-4813-8b68-2ead9c5c5797
- Oku (web) — supporter tier sold on gratitude ("our eternal gratitude") — https://mobbin.com/sites/sections/f66ba39e-9d4f-4336-955d-8721fef92d47
- Neuecast — indie sincerity adjacent to the upgrade door — https://mobbin.com/flows/b8d6c477-f6d4-4303-aaec-85707f218e7c
- Endel — comparables give access outward (share free) vs solicit — https://mobbin.com/screens/eab82f69-ad80-4156-beb8-847b0561f073

### witness-contrarian
- one year — the strongest challenge to the no-unified-paywall doctrine (same screen also filed under witness-atlas) — https://mobbin.com/screens/df0d769a-48b0-46b0-beb4-9f8225d4ce5a
- timespent — the anti-paywall paywall ("no dark patterns") — https://mobbin.com/screens/b00fa672-0e18-4d18-8040-8912c0af8ca7
- Plex — calm mainstream unified rows, "Pure Dedication" lifetime — https://mobbin.com/screens/579c0b00-dfb7-434d-a987-c8903866ddfc
- Sunlitt — focus by dimming, not shouting — https://mobbin.com/screens/1be71829-fa39-4b78-a3c9-c2726c2ef26f
- Skillshare — the industry default in its purest form — https://mobbin.com/flows/74cad4ce-4680-4706-a02e-4f49fad5db0b
- Calm — full plan-steering machinery from a calm brand — https://mobbin.com/flows/38549b00-2fe8-4fd1-914b-13c4905db245
- AllTrails — the most honest trial machinery observed — https://mobbin.com/flows/d2659ba4-db35-4ca6-a17b-02040474ca34
- Waking Up — the calm execution of the rejected pattern — https://mobbin.com/flows/76fb3fc0-a8e4-41b5-904d-1f108dca056e
- Paramount+ — celebrates a 16% gap (Witness's own gap size) — https://mobbin.com/screens/dabc3906-4459-4ac1-be05-9c2832b31888
- Brave — badge-the-long / default-the-short shipped combination — https://mobbin.com/screens/e17b023e-d504-4a62-a3d5-539f7647cf7a
- Tomorrow — upsell button above status facts (what §9.2 bans) — https://mobbin.com/screens/ad34e785-3c6d-4863-88b0-8404a935919b
- Endel — Go Premium card atop the daily ritual surface — https://mobbin.com/screens/dd4658c4-f912-411e-b556-03211a8efae4
- Balance — permanent SALE pill on Today — https://mobbin.com/screens/f723838f-c53f-4e9c-9279-9ec2c44a045c
- Deepstash — docked discount bar over a featured-book home — https://mobbin.com/screens/a10dcda9-5a23-49ad-bf3a-23b6b41d567b
- TIDE — trial pill on the hero + membership-card reveal — https://mobbin.com/flows/aa2d8c73-4ce5-462a-b826-dd7d16da5162
- Flighty — PRO banners inside settings subscreens — https://mobbin.com/screens/f80b6972-d5b9-470e-b4ca-c926a8ba000e
- Bloom — lifetime as anchor in a 3-up grid — https://mobbin.com/screens/db6e7f44-adcb-48a5-a585-48df56e93efe
- Crouton — 4-step tip ladder; $9.99 = its top "Outrageous" tier — https://mobbin.com/screens/cc35aa1c-f886-4953-977d-fb5624744adc
- Yuka — pay-what-you-want as the opposite pole — https://mobbin.com/screens/93b2c710-a87f-442d-ada2-c7c80889988d
- Me+ — ghosted all-locked wall reads as achievement system — https://mobbin.com/screens/a6cb8822-c11e-4ca6-add5-546ab69bd494
- Play — Profile-as-third-tab majority pattern — https://mobbin.com/screens/5a796023-ef12-4dc2-bf87-59a9c3c6daf9
- SKIMS — counterexample to ACCESS-first and standalone PRIVACY — https://mobbin.com/screens/632e1f2f-c313-4715-ae39-bff59efd0537
