# Field notes — the daily essay engine

Status: operational
Owner: Witness
Scope: `witnessatlas.com/field-notes`
Started: 2026-09-03

One sourced essay a day at `/field-notes/<slug>`, published from a queue, gated before it
ships, and verified on the live URL. The shape is lifted from the Lullable engine
(`~/Developer/lullable-website/build.py` and its `PRODUCTION.md`), which has been running
this loop long enough to know which parts fail. What is different here is the claim
regime: Witness already publishes under an evidence ledger, so the gate is tighter.

## The loop

```bash
cd /Users/avp/Developer/witness
python3 tools/notes.py next                       # pick the topic, scaffold the file, print the brief
# research, then write the note
python3 tools/notes.py                            # the gate — hard fails abort
(cd witness_web/site && npx next build --webpack)  # the second gate
python3 tools/notes.py ship "Field note: the title"
# then verify the live URL in a browser. A green build is not a rendered page.
```

Unattended, this is the scheduled routine `witness-daily-post`
(`~/.claude/scheduled-tasks/witness-daily-post/SKILL.md`), which runs the same nine steps
and stops rather than improvising whenever the pre-flight, a gate, or the live check
fails.

## The queue

[`witness_web/site/content/topics.json`](../witness_web/site/content/topics.json) — the
rules are embedded in the file so they travel with it. State lives on disk: a topic is
consumed when a `content/field-notes/*-<slug>.md` file exists; delete the file to re-open
the topic. No status fields, nothing to get out of sync.

Four types rotate, and `next` refuses to repeat the previous note's type:

| Type | What it is | Why it is in the mix |
|---|---|---|
| `question` | A long-tail search question answered plainly | The queries people actually type. Carries the FAQPage answer. |
| `field-note` | One species, one verifiable thing | The product in text. Should stay the plurality. |
| `definition` | Category and GEO terms — *critically endangered*, *the Red List*, *functionally extinct* | What an assistant quotes when someone asks what a word means. |
| `comparison` | The commercial SERP nobody serves honestly — apps, donations, adoptions | The only place we describe other products, so it is where credibility is won or lost. |

An `angle` beginning `SERP:` was observed in a real search on the date it names. Every
other angle is an editorial thesis. Inventing a SERP observation would be the exact
failure this site exists to avoid, on the page that argues nobody should.

## The boundary against the archive

`/witnesses` is the app's own catalog, mirrored verbatim: no web-only species, no reworded
story, no added figure. A field note is editorial writing *around* that archive. It may
cite the same sources, and it should link the record, but it never restates the record's
story and never becomes a second, drifting version of it. If the only thing a note has to
say is already in the record, the topic is dead.

Public wording is governed by
[`witness_web/PUBLIC_CLAIMS_SOURCE_OF_TRUTH.md`](../witness_web/PUBLIC_CLAIMS_SOURCE_OF_TRUTH.md).

## The gates

In `tools/notes.py`, run before anything is pushed. Hard failures abort; warnings print
and proceed.

| Failure | Behavior |
|---|---|
| A prohibited claim — availability, price, subscription, downloads, users, ratings, partnership, or a conservation outcome caused by Witness | **Hard fail.** Negation-aware, so "Witness is not available on the App Store" passes. |
| A coordinate, or an exact nest/den location | **Hard fail.** Ranges stay generalized; this is a product invariant, not a style rule. |
| A checkable claim (year, percentage, population count, measurement, price, IUCN category) with fewer than two `sources:` URLs | **Hard fail**, naming the claims it found. |
| Markdown the renderer does not support — tables, code fences, images, H1s, numbered lists | **Hard fail.** It would ship as literal characters on a public page. |
| Body under 150 words | **Hard fail** — a broken generation, not a style choice. |
| An internal link with nothing behind it on disk | **Hard fail.** Interlinking is 404-proof by construction or it is not worth doing. |
| Two titles ≥70% token-identical | **Hard fail.** Two pages answering one query split the signal instead of doubling it. |
| Description over 160 chars, body outside 350–950 words, answer paragraph outside 30–120 | Warning. |
| A type error or broken route | Caught by `next build`, before the push. |
| Build green but page broken | The reason browser verification is a required step, not a suggestion. |

`python3 tools/notes.py selftest` asserts that the gates still catch what they exist to
catch — the negation lookback, the line-wrapped phrase, the coordinate, the duplicate
title. Run it after editing any pattern.

When tuning a threshold, record the reason in the comment beside it. Both source repos'
comments doubled as their decision logs, and it is the practice most worth keeping.

## Distribution

`ship` pings IndexNow with the changed note URLs. Bing accepts a push instead of waiting
to be crawled, and Bing's index is what ChatGPT search reads, so a note can be findable in
an assistant's answer the same night. Google ignores IndexNow and keeps its own schedule.

The key is `witness_web/site/public/<key>.txt`, whose filename and contents are the same
string — one file, self-verifying, nothing to get out of sync. Delete it and the ping
skips itself with a printed note; the deploy is unaffected either way.

## What this is for

Witness is not on the App Store yet, and search indexes take weeks to trust a new section.
The notes exist to be in the index and in assistants' answers before there is anything to
download, and to be the thing that makes the archive findable at all — nobody searches for
an app they have never heard of, and a great many people search for how many vaquita are
left.

The prediction to check against, from the sibling project: the engine is never the
bottleneck. Lullable's manual streak ran five days and then stopped for seventeen with
twenty-six briefs still queued. Scheduled is what ships.
