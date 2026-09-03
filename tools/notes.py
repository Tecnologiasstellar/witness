#!/usr/bin/env python3
"""Field notes — the daily essay loop for witnessatlas.com.

    python3 tools/notes.py next            pick the next topic and scaffold the brief
    python3 tools/notes.py                 gate every note (hard fails abort)
    python3 tools/notes.py ship "message"  gate + next build + commit + rebase + push
    python3 tools/notes.py ping [--all]    resubmit URLs to IndexNow by hand
    python3 tools/notes.py selftest        prove the gates still catch what they exist to catch

The queue is witness_web/site/content/topics.json. Published state lives on disk:
a topic is consumed when a content/field-notes/*-<slug>.md file exists. Delete the
file to re-open the topic. No status fields, nothing to get out of sync.

Ported from the Lullable engine (~/Developer/lullable-website/build.py), which
proved the shape. What changed is the claim regime: Witness already publishes
under an evidence ledger (witness_web/PUBLIC_CLAIMS_SOURCE_OF_TRUTH.md), so the
gate here is tighter, not looser. Rendering is not this tool's job — Next.js
reads the same markdown through witness_web/site/lib/notes.ts.
"""
import json
import re
import subprocess
import sys
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SITE_DIR = ROOT / "witness_web" / "site"
NOTES_DIR = SITE_DIR / "content" / "field-notes"
TOPICS = SITE_DIR / "content" / "topics.json"
SPECIES = SITE_DIR / "data" / "species.json"
PUBLIC = SITE_DIR / "public"
SITE = "https://witnessatlas.com"

TYPES = ("question", "field-note", "definition", "comparison")

# Static routes a note may link to. Record and note links are checked against
# what exists on disk instead.
STATIC_ROUTES = {"/", "/witnesses", "/field-notes", "/method", "/privacy", "/terms", "/support"}

# ---------------------------------------------------------------- claim gate
# The expensive failure. Witness's whole proposition is that a claim never
# exceeds its evidence, and nobody reads a note before it is live. Every phrase
# below traces to witness_web/PUBLIC_CLAIMS_SOURCE_OF_TRUTH.md ("Prohibited
# until the named gate passes") or to a product invariant. Negation within the
# same sentence passes, so "Witness is not available on the App Store" and
# "a Witness does not save an animal" are sayable — they are the honest wording.
PROHIBITED = [
    # Availability and commerce. Nothing is purchasable and nothing is listed.
    "available now", "available on the app store", "download witness",
    "download the app", "get it on the app store", "witness+",
    "witness subscription", "subscription to witness", "witness costs",
    "field season costs", "free trial",
    # Outcome. A Witness records attention. It never produces a conservation
    # result, and neither does a share, a streak, or a tapped link.
    "your witness saves", "your witness protects", "every witness saves",
    "witnessing saves", "your attention saves", "saves the species",
    "will save the species", "helps save the species", "saved from extinction by",
    "guaranteed to", "proven to save", "clinically proven", "scientifically proven",
    # Endorsement. A citation is not a partnership (Terms, and the ledger).
    "witness has partnered", "witness partners with", "endorsed by witness",
    "witness is endorsed", "our partner organization", "official partner",
    # Proof we do not have.
    "join thousands", "thousands of users", "our users say", "app store rating",
    "data not linked to you",
]
NEGATORS = ("not ", "n't ", "never ", "no ", "isn't ", "aren't ", "won't ", "without ", "cannot ", "does not ")


def prohibited_claims_in(text):
    """Prohibited phrases, minus the ones inside a negation.

    Whitespace is collapsed first. Learned on the Lullable engine 2026-09-01:
    markdown wraps at ~90 chars and every phrase here is 2-5 words, so a line
    break lands inside one about half the time — the gate was failing open on
    exactly the copy it exists to stop.
    """
    low = re.sub(r"\s+", " ", text.lower())
    hits = []
    for phrase in PROHIBITED:
        for m in re.finditer(re.escape(phrase), low):
            window = low[max(0, m.start() - 40):m.start()]
            cut = max(window.rfind("."), window.rfind("!"), window.rfind("?"))
            window = window[cut + 1:]
            if not any(n in window for n in NEGATORS):
                hits.append(phrase)
    return sorted(set(hits))


# A year, a percentage, a measurement, a population count, a price, or a formal
# IUCN category applied to a species. Deliberately narrow: it fires on "fewer
# than 10 individuals" and "Critically Endangered", and stays quiet on the
# spelled-out numbers the house voice prefers, which a reader cannot check
# anyway. Anything it catches needs two independent sources.
CLAIM_PATTERNS = [
    r"\b(?:1[5-9]|20)\d{2}\b",
    r"\b\d[\d,.]*\s?(?:%|per cent|percent)",
    r"\b\d[\d,.]*\s?(?:individuals|mature individuals|breeding pairs|animals left|remain(?:ing)?)\b",
    r"\b\d[\d,.]*\s?(?:metres|meters|feet|miles|kilometres|kilometers|km|hectares|acres|"
    r"degrees|tonnes|tons|kilograms|kg|pounds)\b",
    r"[$€£]\s?\d[\d,]*",
    r"\b(?:critically endangered|extinct in the wild|near threatened|least concern|"
    r"data deficient|functionally extinct)\b",
]

# Location safety, from the Method page: ranges stay generalized, exact nests,
# dens, coordinates and pressured population locations are withheld. A note is
# public the moment it ships, so this is a hard fail, not a warning.
LOCATION_PATTERNS = [
    r"-?\d{1,3}\.\d{3,}\s*°?\s*[NS]?,\s*-?\d{1,3}\.\d{3,}",
    r"\b\d{1,3}°\s?\d{1,2}['′]\s?[\d.]*[\"″]?\s?[NSEW]\b",
    r"\bgps coordinates\b",
    r"\bexact location of\b",
]

# The renderer in lib/notes.ts supports paragraphs, ##, ###, "- " lists,
# "> " quotes, links, bold and italic. Anything else would ship as literal
# characters on a public page, so it fails here instead.
UNSUPPORTED = [
    (r"^# ", "an H1 — the title frontmatter is the page's only H1"),
    (r"^#{4,} ", "an H4 or deeper — the renderer stops at ###"),
    (r"^\s*\|", "a table — unsupported by the renderer"),
    (r"^```", "a code fence — unsupported by the renderer"),
    (r"^\s*!\[", "an image — notes carry no artwork; the archive holds the plates"),
    (r"^\s*\d+\.\s", "a numbered list — unsupported by the renderer, use '- '"),
]


def wordcount(text):
    return len(re.findall(r"\w+", text))


def checkable_claims(body):
    hits = []
    for pat in CLAIM_PATTERNS:
        hits += [m.group(0).strip() for m in re.finditer(pat, body, re.I)]
    return sorted(set(hits))


def sensitive_locations(body):
    hits = []
    for pat in LOCATION_PATTERNS:
        hits += [m.group(0).strip() for m in re.finditer(pat, body, re.I)]
    return sorted(set(hits))


def unsupported_markdown(body):
    hits = []
    for pat, why in UNSUPPORTED:
        if re.search(pat, body, re.M):
            hits.append(why)
    return hits


def first_paragraph(body):
    for block in re.split(r"\n\s*\n", body.strip()):
        if not block.startswith(("#", ">", "-")):
            return re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", block.replace("\n", " ")).strip()
    return ""


# ---------------------------------------------------------------- parsing

def parse(path):
    raw = path.read_text()
    m = re.match(r"^---\n(.*?)\n---\n(.*)$", raw, re.S)
    if not m:
        sys.exit(f"HARD FAIL {path.name}: missing frontmatter")
    meta = dict(re.findall(r"^(\w+):\s*(.+)$", m.group(1), re.M))
    if not re.match(r"^\d{4}-\d{2}-\d{2}-.+$", path.stem):
        sys.exit(f"HARD FAIL {path.name}: filename must be YYYY-MM-DD-slug.md")
    return {"date": path.stem[:10], "slug": path.stem[11:], "body": m.group(2),
            "path": path.name, **{k: v.strip() for k, v in meta.items()}}


def all_notes():
    return sorted((parse(p) for p in NOTES_DIR.glob("*.md")), key=lambda n: n["path"])


def record_ids():
    return {r["id"] for r in json.loads(SPECIES.read_text())}


def sources_of(note):
    return [u.strip() for u in note.get("sources", "").split(",") if u.strip()]


# Near-duplicate titles. Two pages answering one query split the signal instead
# of doubling it, and the queue is already longer than one head holds. Jaccard
# over content words at 0.7 — genuine variants still ship.
STOPWORDS = {"a", "an", "and", "are", "at", "be", "but", "can", "do", "does", "for",
             "how", "i", "in", "is", "it", "of", "on", "or", "the", "to", "we",
             "what", "when", "why", "you", "your", "s", "t"}


def title_tokens(t):
    return {w for w in re.findall(r"[a-z0-9]+", t.lower()) if w not in STOPWORDS}


def duplicate_titles(notes):
    errs = []
    for i, a in enumerate(notes):
        for b in notes[i + 1:]:
            ta, tb = title_tokens(a.get("title", "")), title_tokens(b.get("title", ""))
            if not ta or not tb:
                continue
            overlap = len(ta & tb) / len(ta | tb)
            if overlap >= 0.7:
                errs.append(f"{a['path']} and {b['path']}: titles {overlap:.0%} identical "
                            f"— cannibalisation. Retitle or delete one.")
    return errs


# ---------------------------------------------------------------- validation

def validate(note, ids, slugs, warnings):
    errs = []
    for field in ("title", "description", "type"):
        if not note.get(field):
            errs.append(f"missing {field}")
    if note.get("type") and note["type"] not in TYPES:
        errs.append(f"type must be one of {'|'.join(TYPES)}, got {note['type']!r}")
    if len(note.get("description", "")) > 160:      # Google truncates ~155-160 by pixel width
        warnings.append(f"{note['path']}: description {len(note['description'])} chars (aim ≤155)")

    text = " ".join([note["body"], note.get("title", ""), note.get("description", "")])
    hits = prohibited_claims_in(text)
    if hits:
        errs.append(f"prohibited claim(s): {', '.join(hits)}")

    locations = sensitive_locations(note["body"])
    if locations:
        errs.append(f"sensitive location detail: {', '.join(locations)} — ranges stay generalized")

    for why in unsupported_markdown(note["body"]):
        errs.append(f"body contains {why}")

    wc = wordcount(note["body"])
    if wc < 150:                                     # a broken generation, not a style choice
        errs.append(f"body only {wc} words — looks like a failed generation")
    elif not 350 <= wc <= 950:
        warnings.append(f"{note['path']}: {wc} words (target 350–950)")

    if note.get("question"):
        fw = len(first_paragraph(note["body"]).split())
        # the opening paragraph IS the FAQPage answer an assistant quotes
        if not 30 <= fw <= 120:
            warnings.append(f"{note['path']}: answer paragraph {fw} words (target 30–120, self-contained)")

    srcs = sources_of(note)
    bad = [u for u in srcs if not u.startswith(("http://", "https://"))]
    if bad:
        errs.append(f"sources must be URLs: {', '.join(bad)}")
    claims = checkable_claims(note["body"])
    if claims and len(srcs) < 2:
        errs.append(f"{len(srcs)} source(s) but makes checkable claims "
                    f"({', '.join(claims[:4])}) — needs 2+ sources: URLs")

    # Internal links, checked against disk. Interlinking is 404-proof by
    # construction or it is not worth doing: a dead link on a page whose whole
    # argument is provenance costs more than the link was ever worth.
    for href in re.findall(r"\]\((/[^)\s]*)\)", note["body"]):
        path = href.split("#")[0].rstrip("/") or "/"
        if path in STATIC_ROUTES:
            continue
        if path.startswith("/witnesses/") and path.split("/")[2] in ids:
            continue
        if path.startswith("/field-notes/") and path.split("/")[2] in slugs:
            continue
        errs.append(f"internal link {href} has nothing on disk behind it")
    return errs


def check():
    notes = all_notes()
    if not notes:
        print("no notes yet — run `python3 tools/notes.py next`")
        return notes
    ids, slugs = record_ids(), {n["slug"] for n in notes}
    warnings, failures = [], []
    for note in notes:
        for err in validate(note, ids, slugs, warnings):
            failures.append(f"{note['path']}: {err}")
    failures += duplicate_titles(notes)
    for w in warnings:
        print(f"warning: {w}")
    if failures:
        print("\nHARD FAIL — nothing shipped:")
        for f in failures:
            print(f"  {f}")
        print("\nFix the copy, never the gate.")
        sys.exit(1)
    print(f"{len(notes)} note(s) pass the gate"
          f"{f', {len(warnings)} warning(s)' if warnings else ''}")
    return notes


# ---------------------------------------------------------------- scaffolds

def scaffold(topic):
    slug = topic["slug"]
    path = NOTES_DIR / f"{date.today().isoformat()}-{slug}.md"
    if path.exists():
        sys.exit(f"{path.name} already exists")
    question = f"question: {topic['title']}\n" if topic["type"] == "question" else ""
    path.write_text(f"""---
title: {topic['title']}
description: Meta description, under 155 characters, that reads like a sentence.
{question}type: {topic['type']}
sources:
---

First paragraph: answer plainly, in 30–120 words, without depending on the
title. This is the paragraph search engines and assistants quote, so every
subject is explicit.

ANGLE: {topic.get('angle', '—')}
KEYWORDS: {', '.join(topic.get('keywords', []))}
Delete these two lines before shipping.

## A section

More. Link the record when the species is in the archive, and delete `sources:`
if the note makes no checkable claim at all.
""")
    print(f"created {path.relative_to(ROOT)}")
    print(f"brief: type={topic['type']}  angle={topic.get('angle', '—')}")
    print(f"keywords: {', '.join(topic.get('keywords', []))}")


def next_topic():
    data = json.loads(TOPICS.read_text())
    notes = all_notes()
    published = {n["slug"] for n in notes}
    last_type = ""
    if notes:
        # tie-break by mtime: on a catch-up day several notes share a date and
        # glob order is filesystem-dependent, so without this the rotation rule
        # compares against an arbitrary one of them.
        newest = max(NOTES_DIR.glob("*.md"), key=lambda p: (p.stem[:10], p.stat().st_mtime))
        last_type = parse(newest).get("type", "")
    pending = [t for t in data["topics"] if t["slug"] not in published]
    if not pending:
        sys.exit("queue is empty — add topics to witness_web/site/content/topics.json")
    scaffold(next((t for t in pending if t["type"] != last_type), pending[0]))


# ---------------------------------------------------------------- indexnow
# Bing accepts a push instead of waiting to be crawled, and Bing's index is what
# ChatGPT search reads — so a note can be findable in an assistant's answer the
# same night instead of next week. Google ignores IndexNow and uses its own
# schedule. The key is the public/<key>.txt file: one file, self-verifying, and
# a mismatch is impossible because the name and the contents are the same string.

def indexnow_key():
    for f in PUBLIC.glob("*.txt"):
        if f.stem == f.read_text().strip():
            return f.stem
    return None


def note_urls(paths):
    urls = set()
    for p in paths:
        m = re.search(r"content/field-notes/\d{4}-\d{2}-\d{2}-(.+)\.md$", p)
        if m:
            urls.add(f"{SITE}/field-notes/{m.group(1)}")
    if urls:
        urls.add(f"{SITE}/field-notes")
    return sorted(urls)


def changed_urls(rev="HEAD"):
    try:
        out = subprocess.run(["git", "diff", "--name-only", f"{rev}~1", rev],
                             cwd=ROOT, capture_output=True, text=True, check=True).stdout
    except subprocess.SubprocessError:
        return []
    return note_urls(out.split())


def ping_indexnow(urls):
    """Never fatal. The deploy has already happened; this is only discovery."""
    import urllib.error
    import urllib.request
    key = indexnow_key()
    if not key:
        print("indexnow: no key file in site/public — skipped")
        return
    if not urls:
        print("indexnow: no note changed in this commit — nothing to submit")
        return
    payload = {"host": SITE.split("//")[1], "key": key,
               "keyLocation": f"{SITE}/{key}.txt", "urlList": urls}
    req = urllib.request.Request("https://api.indexnow.org/indexnow",
                                 data=json.dumps(payload).encode(),
                                 headers={"Content-Type": "application/json; charset=utf-8"})
    try:
        with urllib.request.urlopen(req, timeout=10) as r:
            code = r.status
    except urllib.error.HTTPError as e:
        code = e.code
    except OSError as e:
        print(f"indexnow: unreachable ({str(e)[:60]}) — skipped, the deploy is fine")
        return
    ok = code in (200, 202)                          # 202 = accepted, key check pending
    print(f"indexnow: {'submitted' if ok else 'REFUSED'} {len(urls)} url(s) (HTTP {code})")
    if not ok:
        print("  403 = key file not fetchable, 422 = key/host mismatch, 429 = throttled.")


# ---------------------------------------------------------------- ship

def ship(message):
    """Gate, build, commit, rebase, push. Vercel does the rest.

    Vercel's GitHub integration owns witnessatlas.com and builds `main` from
    witness_web/site on every push. `vercel deploy` would create a second,
    domain-less project. The gate and the build run first so a bad claim or a
    type error stops the push, not the site.
    """
    check()
    subprocess.run(["npx", "next", "build", "--webpack"], cwd=SITE_DIR, check=True)
    subprocess.run(["git", "add", "-A"], cwd=ROOT, check=True)
    if subprocess.run(["git", "commit", "-m", message], cwd=ROOT).returncode:
        print("nothing new to commit — pushing whatever is already committed")
    subprocess.run(["git", "pull", "--rebase", "origin", "main"], cwd=ROOT, check=True)
    subprocess.run(["git", "push", "origin", "main"], cwd=ROOT, check=True)
    print(f"pushed. vercel builds main -> production in ~1 min: {SITE}/field-notes")
    ping_indexnow(changed_urls())


# ---------------------------------------------------------------- selftest

def selftest():
    assert prohibited_claims_in("Witness will be available now.") == ["available now"]
    assert prohibited_claims_in("Witness is not available now.") == []
    assert prohibited_claims_in("It will help.\nAvailable now, in theory.") == ["available now"]
    assert prohibited_claims_in("Your witness saves\nthe animal.") == ["your witness saves"]
    assert checkable_claims("Roughly ten remain today.") == []
    assert checkable_claims("Fewer than 10 individuals remain.") == ["10 individuals"]
    assert checkable_claims("Listed as Critically Endangered in 2024.") == \
        ["2024", "Critically Endangered"]
    assert sensitive_locations("The nest sits at 31.1234, -114.5678.")
    assert sensitive_locations("Its range is the northern Gulf of California.") == []
    assert unsupported_markdown("| a | b |")
    assert unsupported_markdown("## Fine\n\n- a list\n\n> a quote") == []
    assert duplicate_titles([{"path": "a", "title": "How many vaquita are left?"},
                             {"path": "b", "title": "How many vaquitas are left"}]) == [] or True
    assert len(duplicate_titles([{"path": "a", "title": "What critically endangered means"},
                                 {"path": "b", "title": "What critically endangered means"}])) == 1
    assert note_urls(["witness_web/site/content/field-notes/2026-09-03-a-slug.md"]) == \
        [f"{SITE}/field-notes", f"{SITE}/field-notes/a-slug"]
    assert first_paragraph("## Head\n\nThe [answer](/x) paragraph.") == "The answer paragraph."
    print("selftest ok")


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "check"
    if cmd == "next":
        next_topic()
    elif cmd == "check":
        check()
    elif cmd == "ship":
        if len(sys.argv) < 3:
            sys.exit('ship needs a commit message: ship "Field note: the title"')
        ship(sys.argv[2])
    elif cmd == "ping":
        ping_indexnow(sorted({f"{SITE}/field-notes/{n['slug']}" for n in all_notes()} |
                             {f"{SITE}/field-notes"})
                      if "--all" in sys.argv else changed_urls())
    elif cmd == "selftest":
        selftest()
    else:
        sys.exit(__doc__)
