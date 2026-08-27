#!/usr/bin/env python3
"""Convert approved Field Season chapter markdown into the bundled edition
JSON consumed by FieldSeasonLoader. Chapters 1-2 are kept as already
shipped; chapters 3-8 are generated from their markdown sources so the
in-app text always matches the approved files verbatim.

Usage: python3 tools/build_fieldseason_json.py
Reads  content/field-season-1/chapter-0[3-8]*.md
Edits  Packages/WitnessCore/Sources/WitnessCore/Resources/fieldseason/field-season-1.json
Audio durations default to 0 and are patched by the caller after render.
"""
import json
import pathlib
import re

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

def clean(text):
    text = re.sub(r"\s+", " ", text).strip()
    text = re.sub(r"\s*\[S\d+\]", "", text)          # citation tags stay in the md/sources
    text = text.replace("**", "").replace("*", "")
    return text

def parse(md_path):
    text = md_path.read_text()
    fm = re.search(r"^---\n(.*?)\n---\n", text, re.S).group(1)
    title = re.search(r'title: "(.*?)"', fm).group(1)
    number = int(re.search(r"chapterNumber: (\d+)", fm).group(1))
    species = re.search(r"speciesID: (\S+)", fm).group(1)
    chap_id = re.search(r"id: (\S+)", fm).group(1)
    body = text.split("## Premium dossier", 1)[1]
    raw_sections = []
    for m in re.split(r"\n### ", body)[1:]:
        lines = m.splitlines()
        raw_sections.append((lines[0].strip(), "\n".join(lines[1:]).strip()))
    return chap_id, number, title, species, raw_sections

def convert_section(heading, content):
    h = heading.lower()
    out = []
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

edition = json.loads(EDITION.read_text())
kept = [c for c in edition["chapters"] if c["number"] <= 2]
for md_name, hero, audio_file in CHAPTERS:
    chap_id, number, title, species, raw = parse(CONTENT / md_name)
    sections = []
    for heading, content in raw:
        sections.extend(convert_section(heading, content))
    kept.append({
        "id": chap_id,
        "number": number,
        "title": title,
        "speciesID": species,
        "heroAssetID": hero,
        "audio": {
            "fileName": audio_file,
            "fileExtension": "mp3",
            "durationSeconds": 0,
            "voiceDisclosure": "Narrated by a synthetic voice (Amazon Polly, Ruth). Rights record on file."
        },
        "sections": sections,
    })
kept.sort(key=lambda c: c["number"])
edition["chapters"] = kept
EDITION.write_text(json.dumps(edition, indent=2, ensure_ascii=False) + "\n")
print(f"edition now has {len(kept)} chapters")
for c in kept:
    print(f"  {c['number']:02d} {c['title']} — {len(c['sections'])} sections")
