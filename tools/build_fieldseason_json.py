#!/usr/bin/env python3
"""Convert approved Field Season markdown into the bundled edition JSON
consumed by FieldSeasonLoader. Chapters 1-2 keep their shipped section
arrays (patched with any new Take-action / Share-copy blocks from their
markdown); chapters 3-8 and every supporting piece (letter, interludes,
synthesis) are generated from markdown so the in-app text always matches
the approved files verbatim.

Only pieces whose frontmatter says `status: approved` ship. A draft piece
is simply absent from the JSON — the review binder is where drafts live.

Usage: python3 tools/build_fieldseason_json.py
Edits  Packages/WitnessCore/Sources/WitnessCore/Resources/fieldseason/field-season-1.json
Audio durations default to 0 and are patched by the caller after render.
"""
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
CONTENT = ROOT / "content/field-season-1"
EDITION = ROOT / "Packages/WitnessCore/Sources/WitnessCore/Resources/fieldseason/field-season-1.json"

CHAPTERS = [
    ("chapter-03-javan-rhino.md", "javan-rhino-plate-01", "chapter-03-javan-rhino-ruth"),
    ("chapter-04-red-wolf.md", "red-wolf-plate-01", "chapter-04-red-wolf-ruth"),
    ("chapter-05-alala.md", "hawaiian-crow-plate-01", "chapter-05-alala-ruth"),
    ("chapter-06-wollemi-pine.md", "wollemi-pine-plate-01", "chapter-06-wollemi-pine-ruth"),
    ("chapter-07-amur-leopard.md", "amur-leopard-plate-01", "chapter-07-amur-leopard-ruth"),
    ("chapter-08-axolotl.md", "axolotl-plate-01", "chapter-08-axolotl-ruth"),
]

# Supporting pieces: (md file, audio basename or None). Position in the
# edition comes from READING_ORDER below, not from chapter numbers.
PIECES = [
    ("letter-the-thin-line.md", "letter-the-thin-line-ruth"),
    ("interlude-price-of-parts.md", "interlude-price-of-parts-ruth"),
    ("interlude-the-uninvited.md", "interlude-the-uninvited-ruth"),
    ("synthesis-what-the-counted-teach.md", "synthesis-what-the-counted-teach-ruth"),
]

READING_ORDER = [
    "fs1-letter-thin-line",
    "fs1-ch01-vaquita",
    "fs1-ch02-kakapo",
    "fs1-ch03-javan-rhino",
    "fs1-interlude-price-of-parts",
    "fs1-ch04-red-wolf",
    "fs1-ch05-alala",
    "fs1-ch06-wollemi-pine",
    "fs1-interlude-uninvited",
    "fs1-ch07-amur-leopard",
    "fs1-ch08-axolotl",
    "fs1-synthesis-counted-teach",
]

# Share copy must follow the Witness honesty rules: no impact claims.
FORBIDDEN_SHARE = ["saved", "impact", "people witnessed", "made a difference"]

def clean(text):
    text = re.sub(r"\s+", " ", text).strip()
    text = re.sub(r"\s*\[S\d+\]", "", text)          # citation tags stay in the md/sources
    text = text.replace("**", "").replace("*", "")
    return text

def parse(md_path):
    text = md_path.read_text()
    fm = re.search(r"^---\n(.*?)\n---\n", text, re.S).group(1)
    meta = {
        "title": re.search(r'title: "(.*?)"', fm).group(1),
        "number": int(re.search(r"chapterNumber: (\d+)", fm).group(1)),
        "species": re.search(r"speciesID: (\S+)", fm).group(1),
        "id": re.search(r"^id: (\S+)", fm, re.M).group(1),
        "kind": m.group(1) if (m := re.search(r"^kind: (\S+)", fm, re.M)) else None,
        "status": re.search(r"status: (\S+)", fm).group(1),
    }
    share = re.search(r"\n## Share copy\n(.*?)(?=\n## )", text, re.S)
    meta["share"] = share.group(1).strip() if share else None
    if meta["share"]:
        lowered = meta["share"].lower()
        for word in FORBIDDEN_SHARE:
            if word in lowered:
                sys.exit(f"{md_path.name}: share copy breaks honesty rule ({word!r})")
    body = text.split("## Premium dossier", 1)[1]
    raw_sections = []
    for m in re.split(r"\n### ", body)[1:]:
        lines = m.splitlines()
        raw_sections.append((lines[0].strip(), "\n".join(lines[1:]).strip()))
    return meta, raw_sections

def parse_action(content):
    entries = []
    for item in re.split(r"\n- ", "\n" + content):
        item = item.strip()
        if not item:
            continue
        m = re.match(r"\*\*(.+?)\*\*\s*—\s*(.*?)\s*—\s*(https://\S+)\s*\Z", item, re.S)
        if not m:
            sys.exit(f"Take action entry not in '**Name** — sentence — https://url' form: {item[:80]}")
        entries.append({"lead": clean(m.group(1)), "text": clean(m.group(2)), "url": m.group(3)})
    return [{"heading": "TAKE ACTION", "style": "action", "entries": entries}]

def convert_section(heading, content):
    h = heading.lower()
    out = []
    if "take action" in h:
        return parse_action(content)
    if "prompt" in h:
        paras = [clean(p) for p in content.split("\n\n") if p.strip()]
        return [{"heading": "A REFLECTIVE PROMPT", "style": "prompt",
                 "entries": [{"text": p} for p in paras]}]
    if "timeline" in h:
        vm = re.search(r"\n\*Timeline last verified.*?\*\s*\Z", content, re.S)
        tail_note = clean(vm.group(0)) if vm else None
        if vm:
            content = content[: vm.start()]
        entries = []
        for item in re.split(r"\n- ", "\n" + content):
            item = item.strip()
            if not item:
                continue
            lead = re.match(r"\*\*(.+?)\*\*\s*—?\s*(.*)", item, re.S)
            if lead:
                entries.append({"lead": clean(lead.group(1)), "text": clean(lead.group(2))})
        if tail_note and entries:
            entries[-1]["text"] += " " + tail_note
        return [{"heading": "TIMELINE OF EVIDENCE", "style": "timeline", "entries": entries}]
    if h in ("sources", "credits"):
        entries = []
        for item in re.split(r"\n- ", "\n" + content):
            item = item.strip()
            if not item:
                continue
            lead = re.match(r"\*\*\[?(S?\d*[^\]*]*?)\]?\*\*\s*(.*)", item, re.S)
            if lead and lead.group(1).strip():
                entries.append({"lead": clean(lead.group(1)), "text": clean(lead.group(2))})
            else:
                entries.append({"text": clean(item)})
        return [{"heading": heading.upper(), "style": "sources", "entries": entries}]
    if h.startswith("the future"):
        pre, *rest = re.split(r"(?:\A|\n)1\. ", content, maxsplit=1)
        entries, post = [], []
        for p in pre.strip().split("\n\n"):
            if p.strip():
                post.append(None)  # marker: intro goes before list as prose entry
        intro = [clean(p) for p in pre.strip().split("\n\n") if p.strip()]
        if rest:
            for item in re.split(r"\n\d+\. ", "\n1. " + rest[0]):
                item = item.strip()
                if not item:
                    continue
                chunks = item.split("\n\n")
                m = re.match(r"\*\*(.+?)\*\*\s*(.*)", chunks[0], re.S)
                if m:
                    entries.append({"lead": clean(m.group(1)), "text": clean(m.group(2))})
                    intro_tail = [clean(c) for c in chunks[1:] if c.strip()]
                else:
                    intro_tail = [clean(c) for c in chunks if c.strip()]
                for c in intro_tail:
                    post.append(c)
        sections = []
        if intro:
            sections.append({"heading": heading.upper(), "style": "prose",
                             "entries": [{"text": p} for p in intro]})
            list_heading = "THE LEVERS"
        else:
            list_heading = heading.upper()
        sections.append({"heading": list_heading, "style": "numbered", "entries": entries})
        closing = [c for c in post if isinstance(c, str)]
        if closing:
            sections.append({"heading": "CLOSING NOTE", "style": "prose",
                             "entries": [{"text": c} for c in closing]})
        return sections
    # prose sections; split out an inline **Known:**/**Unknown:** paragraph
    sections = []
    prose_entries = []
    ku_entries = []
    for p in content.split("\n\n"):
        p = p.strip()
        if not p:
            continue
        if p.startswith("**Known:**"):
            m = re.match(r"\*\*Known:\*\*(.*?)\*\*Unknown:\*\*(.*)", p, re.S)
            if m:
                ku_entries = [
                    {"lead": "Known", "text": clean(m.group(1))},
                    {"lead": "Unknown", "text": clean(m.group(2))},
                ]
                continue
        prose_entries.append({"text": clean(p)})
    if prose_entries:
        sections.append({"heading": heading.upper(), "style": "prose", "entries": prose_entries})
    if ku_entries:
        sections.append({"heading": "KNOWN / UNKNOWN", "style": "knownUnknown", "entries": ku_entries})
    return sections

DISCLOSURE = "Narrated by a synthetic voice (Amazon Polly, Ruth). Rights record on file."
RENDERED = CONTENT / "audio/rendered"

edition = json.loads(EDITION.read_text())
known_durations = {
    c["id"]: c["audio"]["durationSeconds"]
    for c in edition["chapters"] if c.get("audio")
}

def audio_block(audio_file, chap_id):
    """Audio ships only once the mp3 is actually rendered; durations already
    patched into the edition survive a rebuild."""
    if not (RENDERED / f"{audio_file.removesuffix('-ruth')}-ruth.mp3").exists() and \
       not (RENDERED / f"{audio_file}.mp3").exists():
        return None
    return {
        "fileName": audio_file,
        "fileExtension": "mp3",
        "durationSeconds": known_durations.get(chap_id, 0),
        "voiceDisclosure": DISCLOSURE,
    }

def patch_kept(chapter):
    """Chapters 1-2 keep their shipped sections; new Take-action and Share-copy
    blocks in their markdown are layered on top."""
    md = next(CONTENT.glob(f"chapter-0{chapter['number']}-*.md"))
    meta, raw = parse(md)
    action = None
    for heading, content in raw:
        if "take action" in heading.lower():
            action = parse_action(content)
    sections = [s for s in chapter["sections"] if s["style"] != "action"]
    if action:
        prompt_at = next((i for i, s in enumerate(sections) if s["style"] == "prompt"), None)
        insert_at = prompt_at + 1 if prompt_at is not None else len(sections)
        sections = sections[:insert_at] + action + sections[insert_at:]
    chapter["sections"] = sections
    if meta["share"]:
        chapter["shareText"] = meta["share"]
    return chapter

def build(md_name, hero, audio_file):
    meta, raw = parse(CONTENT / md_name)
    if meta["status"] != "approved":
        print(f"  (skipped, {meta['status']}) {meta['title']}")
        return None
    sections = []
    for heading, content in raw:
        sections.extend(convert_section(heading, content))
    piece = {
        "id": meta["id"],
        "number": meta["number"],
        "title": meta["title"],
        "speciesID": meta["species"],
        "heroAssetID": hero,
        "audio": audio_block(audio_file, meta["id"]),
        "sections": sections,
    }
    if meta["kind"]:
        piece["kind"] = meta["kind"]
    if meta["share"]:
        piece["shareText"] = meta["share"]
    return piece

pieces = [patch_kept(c) for c in edition["chapters"] if c["number"] <= 2 and not c.get("kind")]
for md_name, hero, audio_file in CHAPTERS:
    if piece := build(md_name, hero, audio_file):
        pieces.append(piece)
for md_name, audio_file in PIECES:
    if not (CONTENT / md_name).exists():
        continue
    if piece := build(md_name, None, audio_file):
        pieces.append(piece)

order = {chap_id: i for i, chap_id in enumerate(READING_ORDER)}
pieces.sort(key=lambda c: order.get(c["id"], 100 + c["number"]))
edition["chapters"] = pieces
EDITION.write_text(json.dumps(edition, indent=2, ensure_ascii=False) + "\n")
print(f"edition now has {len(pieces)} pieces")
for c in pieces:
    marks = [c.get("kind", "chapter")]
    if c.get("shareText"):
        marks.append("share")
    if any(s["style"] == "action" for s in c["sections"]):
        marks.append("action")
    if c.get("audio"):
        marks.append(f"audio {c['audio']['durationSeconds']:.0f}s")
    print(f"  {c['number']:02d} {c['title']} — {len(c['sections'])} sections [{', '.join(marks)}]")
