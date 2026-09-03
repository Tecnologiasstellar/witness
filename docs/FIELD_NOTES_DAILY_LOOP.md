# Field notes — the daily loop, step by step

The procedure the scheduled routine `witness-daily-post` follows every night at 21:00.
It lives here, in git, so the routine stays a thin pointer at it: `docs/FIELD_NOTES_ENGINE.md`
holds the reasoning, this file holds the steps, and the schedule holds neither.

You are running the Witness field-note loop. Work inside `/Users/avp/Developer/witness`
(run every command from the repo root; the site itself lives in `witness_web/site`).
Nobody reads the note before it goes live, so the gates in `tools/notes.py` and the live
check in Step 8 are the only review it gets. **Never weaken a gate to get a draft
through.** A skipped day is cheap. A public claim that exceeds its evidence is the one
thing this project cannot afford — the product's entire proposition is that it does not
do that.

The reasoning behind the loop lives in `docs/FIELD_NOTES_ENGINE.md`. This file is the
procedure; read that one when you need the *why*.

## Step 1 — Pre-flight (REQUIRED, do not skip)

```
cd /Users/avp/Developer/witness
echo "dirty files: [$(git status --porcelain)]"
echo "today's note: [$(ls witness_web/site/content/field-notes/ | grep "^$(date +%F)-")]"
echo "tracked:     [$(git ls-files witness_web/site/content/field-notes/$(date +%F)-*.md)]"
```

Four cases. Read all four before acting:

- **Today's note exists and is tracked** — it was committed, so it is published. Report
  "already published today" and stop. This is the idempotency guard; a second run must
  never double-post.
- **Today's note exists, is untracked, and still contains `ANGLE:` or `Delete these two
  lines`** — a previous run scaffolded it and died before writing. Do not ship it. Pick up
  at Step 3 and finish it.
- **Today's note exists, is untracked, is finished prose, and every dirty path is under
  `witness_web/site/content/field-notes/`** — a human drafted it ahead and reviewed it.
  This is a supported workflow, not an error. Skip Steps 2–4, run the Step 5 self-critique
  over it as written, then gate, build and ship it. Say in the report that you shipped a
  staged draft rather than writing a new one.
- **Any dirty path outside `witness_web/site/content/field-notes/`** — this repository
  holds the iOS app as well as the site, so an in-progress Xcode change, a regenerated
  project file or a stray build artifact is normal and is not yours to commit. `ship` runs
  `git add -A`. STOP and report, without writing anything.

## Step 2 — Pick the topic

```
python3 tools/notes.py next
```

Applies the rotation rule (the pick must differ in `type` from the most recent note),
scaffolds `witness_web/site/content/field-notes/<today>-<slug>.md`, and prints the brief:
`type`, `angle`, `keywords`. Keep that brief. The angle is the thesis; the keywords go
into the prose naturally or not at all.

If it exits with `queue is empty`, STOP and report that
`witness_web/site/content/topics.json` needs topics.

## Step 3 — Research BEFORE writing (REQUIRED)

Never write a year, a population figure, a measurement, a price or an IUCN category from
memory. `tools/notes.py` hard-fails any note containing a checkable claim with fewer than
two `sources:` URLs, and the point of the gate is that a fabrication becomes visible.

**Start with the catalog.** `witness_web/site/data/species.json` carries, for all 30
bundled species, the sources the app already fact-checked, with the date each was last
accessed. For a catalog species those are free, and they are the same sources the record
page shows.

What works and what does not, learned by running it:

- **Fetches cleanly:** NOAA Fisheries, the IUCN SSC specialist groups (`iucn-csg.org` and
  siblings), US FWS, national park and agency pages, most conservation NGOs' own reports.
- **Returns 403 to WebFetch:** `iwc.int`, `seafoodsource.com`. Some publisher sites too.
  Do not quote a page you could not read — find the primary report instead.
- **PDFs** often come back unreadable through WebFetch. The fetch saves the file locally
  and prints the path; extract the text yourself if the numbers matter.
- **`iucnredlist.org`** is JavaScript-heavy. Cite the species page (a human can open it),
  but take the facts from a page you actually read, such as the specialist group's.
- Prefer the organisation that *did the work* over the outlet that reported it. On
  2026-09-03 the trade press and the aggregators disagreed with each other about the same
  vaquita survey; the survey team's own page settled it.

If a widely-repeated figure is not in the source you actually read, leave it out.

## Step 4 — Write the note

Fill the scaffolded file to the voice contract (`docs/FIELD_NOTES_ENGINE.md` is the
authority; this is the checklist):

- **Frontmatter**: `title`, `description` (≤155 chars), `type`, `question:` when the note
  answers a search question, and `sources:` (comma-separated URLs on ONE line).
- **First paragraph answers the question standalone in 30–120 words.** It becomes the
  FAQPage answer an assistant quotes, so no "this" without a noun and no dependence on
  the title.
- **House voice**: flat, unhurried, concrete, no spectacle. Extinction is not a thriller
  and a reader is not to be scolded. Give the ending away rather than withholding it. No
  listicle framing, no "here's the fascinating part". Read
  `witness_web/site/content/field-notes/2026-09-03-how-many-vaquita-are-left.md` as the
  model.
- **350–950 words.** Markdown limited to `##`, `###`, `- ` lists, `> ` quotes, links,
  bold and italic — the renderer supports nothing else and the gate enforces it.
- **Never restate a catalog record's story.** A note is the reading *around* the archive.
  Link `/witnesses/<id>` when the species is in the catalog.
- **Never** claim availability, price, downloads, users, ratings, partnership, or any
  conservation outcome produced by Witness. **Never** publish a coordinate, nest, den or
  exact location, even when a source prints one.

## Step 5 — Self-critique pass (REQUIRED, before the gate)

Re-read the draft and check all six. Fix in the file; do not rationalise past one:

1. **Accuracy** — every figure still matches the source you actually fetched, including
   the parts that undercut the story. Report a survey at its real precision: a range with
   a confidence attached stays a range.
2. **Dates on numbers** — every population figure says when it was measured. An undated
   number is the failure mode this whole section exists to correct.
3. **Prohibited phrases** — check the `PROHIBITED` list at the top of `tools/notes.py`.
4. **Title cannibalisation** — the title must not be ≥70% token-identical to an existing
   note (`ls witness_web/site/content/field-notes/`).
5. **Internal links** — every `/witnesses/<id>` and `/field-notes/<slug>` exists. The gate
   checks this against disk, but fix it before you see the error.
6. **Lengths** — description ≤155, body 350–950, answer paragraph 30–120 words.

## Step 6 — The gate

```
python3 tools/notes.py
cd witness_web/site && npx next build --webpack && cd ../..
```

The first command hard-fails on prohibited claims, sensitive locations, unsupported
markdown, a body under 150 words, a checkable claim with fewer than two sources, a dead
internal link, and near-duplicate titles. Warnings (length drift) are fine to ship on.
The build is the second gate: a type error or a broken route stops the deploy here rather
than on production.

**If either fails, fix the copy — never the gate.** If you cannot fix it honestly, STOP
and report the exact message.

## Step 7 — Ship

```
python3 tools/notes.py ship "Field note: <the title>"
```

Re-runs the gate and the build, commits, `git pull --rebase origin main`, pushes, runs
`vercel deploy --prod` from `witness_web/site`, and pings IndexNow with the changed note
URLs. The CLI deploy is not optional and not a mistake: this project has **no Vercel
GitHub integration**, so a push publishes nothing on its own. If the deploy step fails
(an expired CLI login is the likely cause), STOP and report it — the note is committed and
pushed but not public, and the fix is `npx vercel login` by a human.

If the rebase hits a genuine conflict it stops the deploy on purpose. STOP and report it;
do not merge around it.

## Step 8 — Verify it is actually live (REQUIRED)

A successful build is not a rendered page. Do all three:

```
URL="https://witnessatlas.com/field-notes/<slug>"
for i in $(seq 1 20); do C=$(curl -s -o /tmp/note.html -w "%{http_code}" -A "Mozilla/5.0" "$URL"); echo "$i: $C"; [ "$C" = "200" ] && break; sleep 15; done
```

1. **200** on the new URL (poll — Vercel takes a minute or so).
2. **It renders.** Open it with the browser tools and read it: title, the answer
   paragraph, the Sources block, the records rail, no console errors. `get_page_text` and
   `find` are more reliable than screenshots when the browser pane is hidden.
3. **No dead links.** Every internal link on the page returns 200:

```
for u in $(python3 -c "import re;print('\n'.join(sorted(set(re.findall(r'href=\"(/[^\"#]*)\"',open('/tmp/note.html').read())))))"); do printf "%s -> " "$u"; curl -s -o /dev/null -w "%{http_code}\n" -A "Mozilla/5.0" "https://witnessatlas.com$u"; done
```

If the page 404s after 20 attempts, or renders broken, STOP and report. The rollback is:

```
git revert --no-edit HEAD && python3 tools/notes.py ship "Revert: <the title>"
```

## Step 9 — Report

Keep it short and factual:

- The live URL, confirmed by the 200 + render + link checks.
- Title, type, word count, commit SHA.
- The sources used, and anything you deliberately left out because you could not verify
  it.
- Any warnings the gate printed.
- If you stopped at any step: which step, the exact failure, and what a human needs to do.
  Stop rather than improvise — a skipped day is recoverable, a bad published claim is not.
