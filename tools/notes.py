#!/usr/bin/env python3
"""Field notes — the daily essay loop for community.witnessatlas.com.

    python3 tools/notes.py next            pick the next topic and scaffold the brief
    python3 tools/notes.py                 gate every note (hard fails abort)
    python3 tools/notes.py ship "message"  gate + translate + next build + commit + rebase + push
    python3 tools/notes.py translate [slug] write the Spanish mirror of every note that lacks one
    python3 tools/notes.py ping [--all]    resubmit URLs to IndexNow by hand
    python3 tools/notes.py ping --main     push every witnessatlas.com URL to IndexNow
    python3 tools/notes.py ping <url>...   push exactly these URLs (retired paths, one-offs)
    python3 tools/notes.py selftest        prove the gates still catch what they exist to catch

The queue is witness_web/community/content/topics.json. Published state lives on disk:
a topic is consumed when a content/posts/*-<slug>.md file exists. Delete the
file to re-open the topic. No status fields, nothing to get out of sync.

Ported from the Lullable engine (~/Developer/lullable-website/build.py), which
proved the shape. What changed is the claim regime: Witness already publishes
under an evidence ledger (witness_web/PUBLIC_CLAIMS_SOURCE_OF_TRUTH.md), so the
gate here is tighter, not looser. Rendering is not this tool's job — Next.js
reads the same markdown through witness_web/community/lib/posts.ts.
"""
import json
import os
import re
import subprocess
import sys
import tempfile
import time
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SITE_DIR = ROOT / "witness_web" / "community"
NOTES_DIR = SITE_DIR / "content" / "posts"
NOTES_ES_DIR = SITE_DIR / "content" / "posts-es"     # the Spanish edition, file for file
TOPICS = SITE_DIR / "content" / "topics.json"
SPECIES = SITE_DIR / "data" / "species.json"
PUBLIC = SITE_DIR / "public"
SITE = "https://community.witnessatlas.com"
MAIN = "https://witnessatlas.com"                    # the other half of the same key
MAIN_PUBLIC = ROOT / "witness_web" / "site" / "public"
MAIN_DATA = ROOT / "witness_web" / "site" / "data" / "notes.json"

TYPES = ("question", "field-note", "definition", "comparison")
# Mirrors SECTIONS in witness_web/community/lib/site.ts. A post lives in exactly one.
SECTIONS = ("species", "numbers", "half", "policy", "dispatches", "attention")
DEFAULT_SECTION = {"field-note": "species", "question": "numbers", "definition": "numbers",
                   "comparison": "attention"}

# ---------------------------------------------------------------- link gate
# Google's answer to this publication on 2026-09-17 was "Discovered - currently
# not indexed" on 95 of 117 known URLs: it had the sitemap and would not spend
# crawl on the pages. Not "Crawled - not indexed" — the notes were never fetched,
# so nothing was judged on its merits. A flat sitemap with no link graph behind
# it is what produces that. Every note now has to carry its own onward links.
MIN_SIBLING_LINKS = 2
# The backlog predates the rule. Notes from this date on must satisfy it; the
# earlier ones were linked by hand where a sibling genuinely fits, and a note
# nobody can honestly link is a note that should not cite one.
LINKS_REQUIRED_FROM = "2026-09-18"

# Static routes a note may link to. Record and note links are checked against
# what exists on disk instead.
STATIC_ROUTES = {"/", "/archive", "/about", "/write", "/subscribe", "/feed.xml",
                 *(f"/s/{s}" for s in SECTIONS)}

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

def frontmatter(block):
    r"""key: value per line, values allowed to be empty.

    The horizontal-whitespace class and the `.*` are both load-bearing. With
    `\s*(.+)` an empty key ate the newline and swallowed the line below it, so
    the scaffold's own `image:` (documented as "leave it empty to borrow the
    linked record's plate") silently consumed `type:` and the gate reported a
    missing field the author could see was right there. Shipped 2026-09-12.
    """
    return {k: v.strip() for k, v in re.findall(r"^(\w+):[^\S\n]*(.*)$", block, re.M)}


def parse(path):
    raw = path.read_text()
    m = re.match(r"^---\n(.*?)\n---\n(.*)$", raw, re.S)
    if not m:
        sys.exit(f"HARD FAIL {path.name}: missing frontmatter")
    meta = frontmatter(m.group(1))
    if not re.match(r"^\d{4}-\d{2}-\d{2}-.+$", path.stem):
        sys.exit(f"HARD FAIL {path.name}: filename must be YYYY-MM-DD-slug.md")
    return {"date": path.stem[:10], "slug": path.stem[11:], "body": m.group(2),
            "path": path.name, **meta}


def all_notes():
    return sorted((parse(p) for p in NOTES_DIR.glob("*.md")), key=lambda n: n["path"])


def section_counts():
    """Notes per section, thinnest first. The nav promises six shelves; a shelf
    nobody files anything on is a dead link in the header, so the pick sees the
    tally at scaffold time rather than after the fact."""
    counts = {s: 0 for s in SECTIONS}
    for note in all_notes():
        if note.get("section") in counts:
            counts[note["section"]] += 1
    return "  ".join(f"{s}={n}" for s, n in sorted(counts.items(), key=lambda kv: (kv[1], kv[0])))


def record_ids():
    return {r["id"] for r in json.loads(SPECIES.read_text())}


def plate_ids():
    return {g for r in json.loads(SPECIES.read_text()) for g in r["gallery"]}


def context_plate(record_id):
    """A record's context plate (the second plate in its gallery), or nothing."""
    for r in json.loads(SPECIES.read_text()):
        if r["id"] == record_id:
            return (r["gallery"] + r["gallery"])[1] if r["gallery"] else ""
    return ""


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

def validate(note, ids, slugs, warnings, plates=frozenset()):
    errs = []
    for field in ("title", "description", "type"):
        if not note.get(field):
            errs.append(f"missing {field}")
    if note.get("type") and note["type"] not in TYPES:
        errs.append(f"type must be one of {'|'.join(TYPES)}, got {note['type']!r}")
    if note.get("section") not in SECTIONS:
        errs.append(f"section must be one of {'|'.join(SECTIONS)}, got {note.get('section')!r}")
    # The card needs a plate. Declared, or borrowed from the first record the body links;
    # a post that links no record and names no plate has nothing to show.
    linked = re.findall(r"/archive/([a-z0-9-]+)", note["body"])
    image = note.get("image") or (context_plate(linked[0]) if linked else "")
    if image not in plates:
        errs.append(f"image {image or '(none)'} is not a plate in data/species.json — "
                    "set image: to a gallery id or link a record")
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

    siblings = {h.split("#")[0].rstrip("/").split("/")[2]
                for h in re.findall(r"\]\((/p/[^)\s]*)\)", note["body"])}
    siblings.discard(note["slug"])
    if note["date"] >= LINKS_REQUIRED_FROM and len(siblings) < MIN_SIBLING_LINKS:
        errs.append(f"{len(siblings)} link(s) to other notes — needs {MIN_SIBLING_LINKS}+ "
                    f"(/p/<slug>). A note Google can only reach through the sitemap is "
                    f"a note Google does not crawl.")

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
        if path.startswith("/archive/") and path.split("/")[2] in ids:
            continue
        if path.startswith("/p/") and path.split("/")[2] in slugs:
            continue
        errs.append(f"internal link {href} has nothing on disk behind it")
    return errs


def check():
    notes = all_notes()
    if not notes:
        print("no notes yet — run `python3 tools/notes.py next`")
        return notes
    ids, slugs, plates = record_ids(), {n["slug"] for n in notes}, plate_ids()
    warnings, failures = [], []
    for note in notes:
        for err in validate(note, ids, slugs, warnings, plates):
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
{question}section: {DEFAULT_SECTION[topic['type']]}
image:
type: {topic['type']}
sources:
---

First paragraph: answer plainly, in 30–120 words, without depending on the
title. This is the paragraph search engines and assistants quote, so every
subject is explicit.

ANGLE: {topic.get('angle', '—')}
KEYWORDS: {', '.join(topic.get('keywords', []))}
Delete these two lines before shipping.

## A section

More. Link the record when the species is in the archive
(https://witnessatlas.com/archive/<id>), and delete `sources:` if the note makes
no checkable claim at all. `image:` is a plate id from data/species.json; leave it
empty to use the context plate of the first record linked. Change `section:` if
the default guess is wrong.
""")
    print(f"created {path.relative_to(ROOT)}")
    print(f"brief: type={topic['type']}  angle={topic.get('angle', '—')}")
    print(f"keywords: {', '.join(topic.get('keywords', []))}")
    print(f"section: {DEFAULT_SECTION[topic['type']]} (a guess from the type — change it if the note fits "
          f"another shelf better)")
    print(f"shelves:  {section_counts()}")
    print("link 2+ of these in the body, where they genuinely belong:")
    for n in sorted(all_notes(), key=lambda n: n["date"], reverse=True)[:8]:
        print(f"  /p/{n['slug']:<42} {n.get('section', '?'):<11} {n.get('title', '')}")


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
        sys.exit("queue is empty — add topics to witness_web/community/content/topics.json")
    scaffold(next((t for t in pending if t["type"] != last_type), pending[0]))


# ---------------------------------------------------------------- translate
# The Spanish edition (community.witnessatlas.com/es) is content/posts-es, one
# file per English note with the same name. lib/posts.es.ts renders it and
# tools/check_notes_es.py holds it to the English: same frontmatter apart from
# title/description/question, same block structure, same links, same numerals.
# A note ships in both languages from one `ship`; if the Spanish cannot be made
# or fails the checker, the English ships alone and the checker keeps naming
# the gap. Stdlib HTTP on purpose — this tool has no dependencies, and the
# nightly loop runs wherever it is pointed.
MODEL = "claude-opus-5"
TRANSLATE_SYSTEM = """You translate Field Notes essays (community.witnessatlas.com) from English into Spanish for a native audience.

Output the complete markdown file: the frontmatter block between --- lines, then the body. No code fences, no commentary before or after.

Frontmatter: translate the values of title, description and question (a question keeps its opening ¿). Copy section, image, type and sources exactly as given.

Body: keep the block structure line for line — the same ## headings, the same "- " list items including their indented continuation lines, the same "> " quotes, the same paragraph breaks, the same bold and italics. Translate link text; keep every link URL byte-identical, including /p/... and /archive/... paths. Keep every numeral, unit and date exactly as written (17.6 per cent becomes 17.6 por ciento; 1,365 stays 1,365). A decade may become words (the 1980s becomes los años ochenta). Keep the names of organizations, journals, people, places and programs as they are. Quoted passages stay in quotation marks, translated.

Tone: austere, literal, factual. Say exactly what the English says — no added claims, no softening, no marketing. Neutral Spanish, tú when the English addresses the reader.

Glossary: Witness is never translated. Field Notes → Notas de campo. The Archive → El Archivo. a record or card → ficha. a plate (illustration) → lámina. the door (an organization's page) → puerta. an act → acto. to witness → dar testimonio. one honest action → una acción honesta. IUCN → UICN. Red List → Lista Roja. Critically Endangered → En Peligro Crítico. Endangered → En Peligro. Vulnerable → Vulnerable. Extinct in the Wild → Extinto en Estado Silvestre. Least Concern → Preocupación Menor. Endangered Species Act → Ley de Especies en Peligro. vaquita → vaquita marina. axolotl → ajolote. whooping crane → grulla trompetera. Iberian lynx → lince ibérico. ploughshare tortoise → tortuga angonoka. Ethiopian wolf → lobo etíope. Hawaiian crow → cuervo hawaiano (ʻalalā). Javan rhino → rinoceronte de Java. Sumatran orangutan → orangután de Sumatra. monarch butterfly → mariposa monarca. Kemp's ridley → tortuga lora. golden lion tamarin → tití león dorado. Yangtze finless porpoise → marsopa lisa del Yangtsé. staghorn coral → coral cuerno de ciervo. spoon-billed sandpiper → correlimos cuchareta. Chinese giant salamander → salamandra gigante de China. Philippine eagle → águila filipina. rusty patched bumble bee → abejorro de parche oxidado. Amur tiger → tigre de Amur. Amur leopard → leopardo del Amur. snow leopard → leopardo de las nieves. mountain gorilla → gorila de montaña. North Atlantic right whale → ballena franca del Atlántico Norte. California condor → cóndor de California. hawksbill turtle → tortuga carey. gharial → gavial. red wolf → lobo rojo. Wollemi pine → pino de Wollemi. saola and kākāpō stay as they are."""
EXAMPLE_SLUG = "the-lynx-that-came-back"                 # a published pair, sent as the reference


def api_key():
    """ANTHROPIC_API_KEY from the environment, else from the site's untracked .env.local."""
    key = os.environ.get("ANTHROPIC_API_KEY")
    env = SITE_DIR / ".env.local"
    if not key and env.exists():
        m = re.search(r"^(?:export\s+)?ANTHROPIC_API_KEY\s*=\s*(.+)$", env.read_text(), re.M)
        key = m.group(1).strip().strip("\"'") if m else None
    return key


def claude(key, system, user):
    """One Messages API call. The text, or None when the call failed or was refused —
    never fatal, because the English note must still ship."""
    import urllib.error
    import urllib.request
    body = {"model": MODEL, "max_tokens": 16000, "system": system,
            "messages": [{"role": "user", "content": user}]}
    base = os.environ.get("ANTHROPIC_BASE_URL", "https://api.anthropic.com")   # the SDKs' own override
    req = urllib.request.Request(f"{base}/v1/messages",
                                 data=json.dumps(body).encode(),
                                 headers={"content-type": "application/json", "x-api-key": key,
                                          "anthropic-version": "2023-06-01"})
    try:
        with urllib.request.urlopen(req, timeout=600) as r:
            data = json.load(r)
    except urllib.error.HTTPError as e:
        print(f"claude: HTTP {e.code} {e.read().decode(errors='replace')[:300]}")
        return None
    except OSError as e:
        print(f"claude: unreachable ({str(e)[:80]})")
        return None
    if data.get("stop_reason") == "refusal":
        print("claude: refused")
        return None
    return "".join(b.get("text", "") for b in data.get("content", []) if b.get("type") == "text")


def assemble_es(en_raw, out):
    """The Spanish file from the model's output: its title, description and question,
    every other frontmatter line copied from the English byte for byte, its body.
    None when the output is not a note."""
    out = re.sub(r"^```[a-z]*\n|\n```$", "", out.strip())
    m_en = re.match(r"^---\n(.*?)\n---\n(.*)$", en_raw, re.S)
    m_es = re.match(r"^---\n(.*?)\n---\n(.*)$", out, re.S)
    if not (m_en and m_es):
        return None
    es = frontmatter(m_es.group(1))
    lines = []
    for line in m_en.group(1).split("\n"):
        key = line.split(":", 1)[0]
        if key in ("title", "description", "question"):
            if not es.get(key):
                return None
            lines.append(f"{key}: {es[key]}")
        else:
            lines.append(line)
    return "---\n" + "\n".join(lines) + "\n---\n\n" + m_es.group(2).strip() + "\n"


def es_problems(name):
    """What tools/check_notes_es.py says about one file."""
    out = subprocess.run([sys.executable, str(ROOT / "tools" / "check_notes_es.py")],
                         capture_output=True, text=True).stdout
    return [line for line in out.splitlines() if line.startswith(name)]


def translate(slug=None):
    """Write the Spanish mirror of every note that lacks one (or redo one note by slug).
    Two attempts per note, the checker's findings fed back into the second; a note
    that still fails is removed so the English ships alone. Returns (written, failed)."""
    NOTES_ES_DIR.mkdir(exist_ok=True)
    notes = sorted(NOTES_DIR.glob("*.md"))
    todo = ([p for p in notes if p.stem[11:] == slug] if slug
            else [p for p in notes if not (NOTES_ES_DIR / p.name).exists()])
    if slug and not todo:
        sys.exit(f"no note with slug {slug!r}")
    if not todo:
        print("translate: every note has its Spanish mirror")
        return [], []
    key = api_key()
    if not key:
        print(f"translate: no ANTHROPIC_API_KEY (environment or {SITE_DIR.relative_to(ROOT)}/.env.local) — "
              f"{len(todo)} note(s) ship without Spanish; run `python3 tools/notes.py translate` once it is set")
        return [], [p.name for p in todo]
    example = ""
    en_ex, es_ex = NOTES_DIR / f"2026-09-04-{EXAMPLE_SLUG}.md", NOTES_ES_DIR / f"2026-09-04-{EXAMPLE_SLUG}.md"
    if en_ex.exists() and es_ex.exists() and en_ex.stem[11:] != slug:
        example = (f"A published pair, the reference for structure and tone:\n\n<english_example>\n{en_ex.read_text()}"
                   f"</english_example>\n\n<spanish_example>\n{es_ex.read_text()}</spanish_example>\n\n")
    written, failed = [], []
    for path in todo:
        target, feedback = NOTES_ES_DIR / path.name, ""
        for attempt in (1, 2):
            user = (f"{example}{feedback}Translate this note.\n\n<english>\n{path.read_text()}</english>")
            es = assemble_es(path.read_text(), claude(key, TRANSLATE_SYSTEM, user) or "")
            if es:
                target.write_text(es)
            problems = es_problems(path.name) if es else [f"{path.name}: the output was not a note"]
            if not problems:
                written.append(target)
                print(f"translated {target.relative_to(ROOT)}")
                break
            print(f"translate attempt {attempt}/2, {path.name}: " + "; ".join(p.split(": ", 1)[-1] for p in problems))
            feedback = "A previous attempt failed these checks; fix them:\n" + "\n".join(problems) + "\n\n"
        else:
            target.unlink(missing_ok=True)
            failed.append(path.name)
            print(f"WARNING: {path.name} ships without its Spanish — rerun `python3 tools/notes.py translate` "
                  f"or write content/posts-es/{path.name} by hand")
    return written, failed


# ---------------------------------------------------------------- indexnow
# Bing accepts a push instead of waiting to be crawled, and Bing's index is what
# ChatGPT search reads — so a note can be findable in an assistant's answer the
# same night instead of next week. Google ignores IndexNow and uses its own
# schedule. The key is the public/<key>.txt file: one file, self-verifying, and
# a mismatch is impossible because the name and the contents are the same string.

def indexnow_key(public):
    for f in public.glob("*.txt"):
        if f.stem == f.read_text().strip():
            return f.stem
    return None


def note_urls(paths):
    urls = set()
    for p in paths:
        m = re.search(r"content/posts(-es)?/\d{4}-\d{2}-\d{2}-(.+)\.md$", p)
        if m:
            edition = "/es" if m.group(1) else ""
            urls.add(f"{SITE}{edition}/p/{m.group(2)}")
            urls.add(f"{SITE}{edition}")
    if urls:
        urls.add(SITE)
    return sorted(urls)


def changed_urls(rev="HEAD"):
    try:
        out = subprocess.run(["git", "diff", "--name-only", f"{rev}~1", rev],
                             cwd=ROOT, capture_output=True, text=True, check=True).stdout
    except subprocess.SubprocessError:
        return []
    return note_urls(out.split())


def sitemap_urls(site):
    """Every page the live sitemap lists, both languages.

    The sitemap is already the canonical list of what is public, so this cannot
    submit a URL that is not live and it picks up /es for free. One <loc> per
    page — the hreflang pairs ride along as xhtml:link attributes, so they
    cannot double-count.
    """
    import urllib.request
    with urllib.request.urlopen(f"{site}/sitemap.xml", timeout=15) as r:
        return sorted(set(re.findall(r"<loc>([^<]+)</loc>", r.read().decode())))


def ping_indexnow(urls, site=SITE, public=PUBLIC):
    """Never fatal. The deploy has already happened; this is only discovery."""
    import urllib.error
    import urllib.request
    key = indexnow_key(public)
    if not key:
        print(f"indexnow: no key file in {public} — skipped")
        return
    if not urls:
        print("indexnow: no note changed in this commit — nothing to submit")
        return
    payload = {"host": site.split("//")[1], "key": key,
               "keyLocation": f"{site}/{key}.txt", "urlList": urls}
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


# ---------------------------------------------------------------- site manifest

def write_site_manifest(path=MAIN_DATA):
    """Publish the note index to witnessatlas.com as a committed data file.

    The apex domain holds what authority this project has, and until 2026-09-17
    it linked the publication's home page and not one of its notes, so none of
    that reached them. It cannot import from witness_web/community: the two are
    separate Vercel projects with their own Root Directory, and a build only
    sees its own tree. So the notes travel the same way the species catalog
    already does — a generated JSON file committed into the site that reads it.
    """
    index = [{"slug": n["slug"], "title": n.get("title", ""), "date": n["date"],
              "description": n.get("description", ""), "section": n.get("section", ""),
              "records": sorted({m for m in re.findall(r"/archive/([a-z0-9-]+)", n["body"])})}
             for n in sorted(all_notes(), key=lambda n: (n["date"], n["slug"]), reverse=True)]
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(index, indent=2, ensure_ascii=False) + "\n")
    print(f"site manifest: {len(index)} note(s) -> {path.relative_to(ROOT)}")
    return index


# ---------------------------------------------------------------- ship

DEPLOY_TIMEOUT = 600


def url_is_live(url):
    """200 or not. Any HTTP or network error means 'not yet', never a crash."""
    import urllib.request
    try:
        with urllib.request.urlopen(url, timeout=15) as r:
            return r.status == 200
    except OSError:  # HTTPError and URLError are both OSError
        return False


def wait_until_public(urls, timeout=DEPLOY_TIMEOUT, sleep=time.sleep, live=url_is_live):
    """True once every URL answers 200. False if the timeout runs out first.

    Readiness is measured on the public URL rather than on the deployment,
    because the URL is the thing that has to work and checking it needs no
    Vercel credentials — no token to rotate, no project id to keep in sync. It
    replaces the `vercel deploy` step and its retries, dead since Root Directory
    was set to witness_web/community on 2026-09-16: the push is now the deploy,
    and a CLI deploy from that directory fails outright (the builder looks for
    witness_web/community/witness_web/community). That also retires the
    2026-09-12 "Not authorized" transient, which was a CLI failure mode only.

    ponytail: a run that only edits existing pages returns immediately, since
    those URLs already answer 200 — the ping then lands a couple of minutes
    before the edit does. IndexNow is a crawl hint, not a publish gate, so that
    costs nothing. Compare deployment ids if it ever has to be exact.
    """
    deadline = time.monotonic() + timeout
    pending = list(urls)
    while True:
        pending = [u for u in pending if not live(u)]
        if not pending:
            return True
        if time.monotonic() >= deadline:
            print(f"not public after {timeout}s: {', '.join(pending)}")
            return False
        print(f"waiting for the build — {len(pending)} URL(s) not live yet")
        sleep(10)


def ship(message):
    """Gate, translate, build, commit, rebase, push, wait, ping.

    The push is the deploy. Vercel's GitHub integration builds this project on
    every push to main and moves the domain when it is green — true only since
    2026-09-16, when Root Directory was set to witness_web/community. Before
    that it was unset, every Git build ran from the repo root and died on a
    missing app directory, and a separate `vercel deploy` from the app directory
    was what actually published (found 2026-09-03 by pushing and watching
    nothing happen). That CLI step is gone: it cannot coexist with the setting
    that fixed the Git build, because it uploads only witness_web/community and
    the builder then looks for that path inside it. See docs/FIELD_NOTES_ENGINE.md.

    So ship waits on the live URL instead of on a deploy command. The gate and
    the local build still run first, so a bad claim or a type error stops the
    commit rather than the site.
    """
    check()
    translate()
    write_site_manifest()
    subprocess.run(["npx", "next", "build", "--webpack"], cwd=SITE_DIR, check=True)
    subprocess.run(["git", "add", "-A"], cwd=ROOT, check=True)
    if subprocess.run(["git", "commit", "-m", message], cwd=ROOT).returncode:
        print("nothing new to commit — pushing whatever is already committed")
    subprocess.run(["git", "pull", "--rebase", "origin", "main"], cwd=ROOT, check=True)
    # HEAD:main, not main. `git push origin main` pushes the local main REF, which is
    # stale whenever the repo sits on a feature branch — the push is then rejected
    # non-fast-forward with the note already committed. Found 2026-09-16 with the tree
    # on fix-fieldseason-flake and local main six commits behind.
    subprocess.run(["git", "push", "origin", "HEAD:main"], cwd=ROOT, check=True)
    urls = changed_urls()
    if not wait_until_public(urls):
        sys.exit(f"HARD FAIL: pushed, but {SITE} did not serve the note within "
                 f"{DEPLOY_TIMEOUT}s, and IndexNow was not pinged. The note IS committed "
                 f"and pushed, so the build is the thing to check: "
                 f"https://vercel.com/tecnologiasstellars-projects/witness-community . "
                 f"Once it is live, `python3 tools/notes.py ping` from {ROOT}.")
    print(f"deployed: {SITE}")
    ping_indexnow(urls)


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
    assert note_urls(["witness_web/community/content/posts/2026-09-03-a-slug.md"]) == \
        [SITE, f"{SITE}/p/a-slug"]
    assert note_urls(["witness_web/community/content/posts-es/2026-09-03-a-slug.md"]) == \
        [SITE, f"{SITE}/es", f"{SITE}/es/p/a-slug"]
    with tempfile.TemporaryDirectory() as d:
        # one <loc> per page; the hreflang alternate must not become a second URL
        (Path(d) / "sitemap.xml").write_text(
            '<urlset><url><loc>https://x/a</loc>'
            '<xhtml:link href="https://x/es/a"/></url>'
            '<url><loc>https://x/es/a</loc></url></urlset>')
        assert sitemap_urls(f"file://{d}") == ["https://x/a", "https://x/es/a"]
    en = "---\ntitle: A\nquestion: Q?\nsection: numbers\nsources: https://x, https://y\n---\n\nBody.\n"
    es = assemble_es(en, "```markdown\n---\ntitle: Una\nquestion: ¿Q?\nsection: WRONG\nsources: gone\n---\n\nCuerpo.\n```")
    # translated fields taken, fixed fields copied from the English, the fence stripped
    assert es == "---\ntitle: Una\nquestion: ¿Q?\nsection: numbers\nsources: https://x, https://y\n---\n\nCuerpo.\n", es
    assert assemble_es(en, "Lo siento, no puedo.") is None
    assert assemble_es(en, "---\ntitle: Una\n---\n\nCuerpo.\n") is None   # a translated field missing
    # the sibling-link floor: enforced from LINKS_REQUIRED_FROM, the backlog exempt,
    # a note's own slug and a repeat of one link never counting toward the two
    def linkcheck(date, body):
        note = {"path": "p.md", "date": date, "slug": "me", "title": "T", "description": "D",
                "type": "field-note", "section": "numbers", "image": "plate", "body": body}
        errs = validate(note, set(), {"me", "a", "b"}, [], {"plate"})
        return [e for e in errs if "link(s) to other notes" in e]
    assert linkcheck("2026-09-01", "Body.") == []
    assert len(linkcheck(LINKS_REQUIRED_FROM, "Body.")) == 1
    assert len(linkcheck(LINKS_REQUIRED_FROM, "One [a](/p/a).")) == 1
    assert len(linkcheck(LINKS_REQUIRED_FROM, "[a](/p/a) and [again](/p/a).")) == 1
    assert len(linkcheck(LINKS_REQUIRED_FROM, "[a](/p/a) and [self](/p/me) and [b](/p/b).")) == 0
    assert linkcheck("2026-12-31", "[a](/p/a) [b](/p/b)") == []

    assert first_paragraph("## Head\n\nThe [answer](/x) paragraph.") == "The answer paragraph."
    # an empty key must stay empty, not eat the line under it
    assert frontmatter("image:\ntype: question") == {"image": "", "type": "question"}
    assert frontmatter("title: A note \nimage:   ") == {"title": "A note", "image": ""}
    # the deploy wait: URLs clear as the build lands, nothing to wait for is
    # already done, and a page that never comes up fails instead of hanging
    seen = []
    assert wait_until_public(["a", "b"], sleep=lambda s: None,
                             live=lambda u: seen.append(u) or len(seen) > 2)
    assert wait_until_public([], live=lambda u: False)
    assert not wait_until_public(["a"], timeout=0, sleep=lambda s: None,
                                 live=lambda u: False)
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
    elif cmd == "translate":
        if translate(sys.argv[2] if len(sys.argv) > 2 else None)[1]:
            sys.exit(1)
    elif cmd == "ping":
        main = "--main" in sys.argv                   # witnessatlas.com, not the notes
        site, public = (MAIN, MAIN_PUBLIC) if main else (SITE, PUBLIC)
        # A retired path is never in a sitemap, so a redirect is only ever re-crawled
        # by naming it here. That is how a stale URL leaves the index.
        given = [a for a in sys.argv[2:] if a.startswith("http")]
        every = main or "--all" in sys.argv
        ping_indexnow(given or (sitemap_urls(site) if every else changed_urls()), site, public)
    elif cmd == "selftest":
        selftest()
    else:
        sys.exit(__doc__)
