# Purchase matrix — build 5, TestFlight sandbox

Run in this order. The order is deliberate: each step proves something a
later purchase would hide. Once you buy Field Season you cannot un-buy it,
so everything that needs a locked state comes first.

Expected results below come from `StandardContentAccessPolicy` and
`CommerceModel`, not from guesswork.

**Sandbox facts worth knowing**
- TestFlight in-app purchases are **free** and run in the sandbox. Your normal
  Apple ID works; no sandbox account needed.
- Subscription durations are accelerated: six-month ≈ **30 min**, annual ≈ **1 hr**.
  They auto-renew 6 times, then stop.
- Manage/cancel a sandbox subscription: Settings → App Store → Sandbox Account → Manage.
- A non-consumable can't be re-bought. Tapping buy again should *restore*, not charge.

Where things live: **THIS WEEK → INDEX → THE WORKS** → FIELD SEASON, THE ATLAS,
SUPPORT WITNESS. Restore is on the INDEX page and on each paid page.

---

## 0 · Before any purchase

| # | Do | Expect | Report |
|---|---|---|---|
| 0.1 | Open the app fresh from TestFlight | Weekly card loads, free ritual works | |
| 0.2 | INDEX → THE WORKS → FIELD SEASON | Cover page opens. **A real localized price shows ($19.99)** | |
| 0.3 | INDEX → THE WORKS → THE ATLAS | Both durations show real prices ($14.99 / $24.99) | |
| 0.4 | SUPPORT WITNESS | Real price shows ($9.99) | |

**This is the biggest remaining risk.** If any page says *"This product is not
available right now"* or shows no price, StoreKit isn't returning products —
stop and report. That's an App Store Connect condition (products not in a
loadable state, or the Paid Apps agreement not active), not a code bug.

---

## 1 · Cancel is silent

| # | Do | Expect | Report |
|---|---|---|---|
| 1.1 | Field Season → buy → **Cancel** in the Apple sheet | Returns to the page quietly. **No error banner, no "purchase failed"** | |
| 1.2 | Nothing unlocked | Field Season still locked | |

A red failure message here is a bug. Cancelling is not an error.

---

## 2 · The tip grants nothing

Do this **while everything is still locked** — that's the only moment it proves anything.

| # | Do | Expect | Report |
|---|---|---|---|
| 2.1 | SUPPORT WITNESS → complete the purchase | A thank-you state. No unlock language | |
| 2.2 | Go back to FIELD SEASON | **Still locked** | |
| 2.3 | Go to THE ATLAS | **Still locked** | |
| 2.4 | Tip again | Allowed — it's repeatable, grants nothing | |

If tipping unlocked anything, stop and report. That breaks the product's core promise.

---

## 3 · Field Season grants the season only

| # | Do | Expect | Report |
|---|---|---|---|
| 3.1 | FIELD SEASON → complete the purchase | Unlocks. Contents open | |
| 3.2 | Open a chapter | Reader opens, narration plays | |
| 3.3 | **Go to THE ATLAS** | **Still locked** | |

3.3 is the real assertion. Owning the season must **not** grant Atlas. The rule
is one-directional.

---

## 4 · Atlas grants both

| # | Do | Expect | Report |
|---|---|---|---|
| 4.1 | THE ATLAS → six-month → complete | Unlocks. Archive opens | |
| 4.2 | Browse past weeks beyond the free window | Accessible | |
| 4.3 | Field Season still open | Yes — Atlas grants it too (`ownsFieldSeason OR atlasActive`) | |

---

## 5 · It survives

| # | Do | Expect | Report |
|---|---|---|---|
| 5.1 | Force-quit, reopen | Both still unlocked, no re-purchase prompt | |
| 5.2 | **Airplane Mode**, force-quit, reopen | Still unlocked — access is cached | |
| 5.3 | Back online, reopen | Still unlocked | |

---

## 6 · Failure speaks plainly

This is the bug I fixed this session — worth confirming on a real device.

| # | Do | Expect | Report |
|---|---|---|---|
| 6.1 | Airplane Mode on → try to buy anything | A readable sentence about the network/store | |
| 6.2 | Read the message closely | **Must NOT say "The operation couldn't be completed. (RevenueCat.ErrorCode error N.)"** | |

---

## 7 · Restore

| # | Do | Expect | Report |
|---|---|---|---|
| 7.1 | Delete the app, reinstall from TestFlight | Everything locked again | |
| 7.2 | INDEX → RESTORE PURCHASES | Both unlock | |
| 7.3 | Tap Restore again with nothing new | A calm "nothing to restore", not an error | |

---

## 8 · Proof RevenueCat actually powered it

**This is the hackathon requirement made visible.**

| # | Do | Expect | Report |
|---|---|---|---|
| 8.1 | RevenueCat dashboard → **Customers** | A customer appeared, created at your purchase time | |
| 8.2 | Open it | `field_season_1_access` and `atlas_access` both showing **active** | |
| 8.3 | Transactions list | The sandbox purchases listed against the right product IDs | |

If purchases succeeded in-app but no customer appears here, the SDK isn't
reaching RevenueCat and nothing else in this document matters.

---

## 9 · What App Review will check

| # | Do | Expect | Report |
|---|---|---|---|
| 9.1 | Foot of FIELD SEASON page | Terms of Use **and** Privacy Policy links present, both open | |
| 9.2 | Foot of THE ATLAS page | Same | |
| 9.3 | Restore reachable without buying | Yes — INDEX and each paid page | |
| 9.4 | Atlas page | Duration, price and renewal terms legible before purchase | |

3.1.2 rejections come from 9.1/9.2 being absent.

---

## Optional, only if time allows

- **Annual duration** — needs a second sandbox account since you'll already own
  six-month. Both map to the same entitlement and that's unit-tested, so this is
  low value.
- **Renewal and expiry** — wait ~30 min for the six-month to renew, then cancel
  in Settings and watch it lapse. Confirms Atlas locks while **Field Season stays
  owned**. Genuinely interesting, and it's the one path unit tests can only
  simulate.

---

## Report back

Fastest useful format: the step number and what actually happened, for anything
that didn't match. "All green except 3.3 — Atlas opened after buying Field
Season" tells me everything I need.

Also grab screen recording during **step 3 or 4** — the Apple sheet through to
content unlocking, uncut. That's the 1:05–1:30 beat of the demo video, and
re-shooting it later means re-running sandbox state.
