/**
 * Field notes — the daily essay.
 *
 * One markdown file per essay in `content/field-notes/<date>-<slug>.md`, read at
 * build time. The queue, the gates and the publish command live in
 * `../../tools/notes.py`; this file only renders what that tool already
 * validated. Nothing here re-checks a claim — a note that reaches the site
 * passed the gate, or it was never committed.
 *
 * Essays are editorial, not catalog. A note may cite the same sources as a
 * record and must link to it, but it never restates a record's story: the
 * archive under /witnesses is the verbatim app catalog and stays that way.
 */
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const DIR = join(process.cwd(), "content/field-notes");

export type Note = {
  slug: string;
  date: string;
  title: string;
  description: string;
  /** The search question this answers, when it answers one. Drives FAQPage. */
  question?: string;
  type: string;
  /** Frontmatter `sources:` — comma-separated URLs, required for any checkable claim. */
  sources: string[];
  /** Catalog record ids linked from the body. Derived, never declared, so it cannot drift. */
  records: string[];
  html: string;
  /** The standalone opening paragraph. This is what an AI assistant quotes. */
  answer: string;
  words: number;
};

function escapeHtml(s: string) {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

/** Links, bold, italic. The gate rejects any markdown beyond this and the blocks below. */
function inline(s: string) {
  return escapeHtml(s)
    .replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>')
    .replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>")
    .replace(/\*([^*]+)\*/g, "<em>$1</em>");
}

/** Paragraphs, h2, h3, bullet lists, block quotes. Ported from the Lullable engine. */
function render(body: string) {
  return body
    .trim()
    .split(/\n\s*\n/)
    .map((block) => {
      const lines = block.trim().split("\n");
      if (lines[0].startsWith("### ")) return `<h3>${inline(lines[0].slice(4))}</h3>`;
      if (lines[0].startsWith("## ")) return `<h2>${inline(lines[0].slice(3))}</h2>`;
      if (lines.every((l) => l.startsWith("- ")))
        return `<ul>${lines.map((l) => `<li>${inline(l.slice(2))}</li>`).join("")}</ul>`;
      if (lines.every((l) => l.startsWith("> ")))
        return `<blockquote>${inline(lines.map((l) => l.slice(2)).join(" "))}</blockquote>`;
      return `<p>${inline(lines.join(" "))}</p>`;
    })
    .join("\n");
}

function firstParagraph(body: string) {
  const block = body
    .trim()
    .split(/\n\s*\n/)
    .find((b) => !/^[#>-]/.test(b));
  return (block ?? "").replace(/\n/g, " ").replace(/\[([^\]]+)\]\([^)]+\)/g, "$1").trim();
}

function parse(file: string): Note {
  const raw = readFileSync(join(DIR, file), "utf8");
  const match = /^---\n([\s\S]*?)\n---\n([\s\S]*)$/.exec(raw);
  if (!match) throw new Error(`${file}: missing frontmatter`);
  const meta: Record<string, string> = {};
  for (const line of match[1].split("\n")) {
    const kv = /^(\w+):\s*(.+)$/.exec(line);
    if (kv) meta[kv[1]] = kv[2].trim();
  }
  const body = match[2];
  return {
    slug: file.slice(11, -3),
    date: file.slice(0, 10),
    title: meta.title ?? "",
    description: meta.description ?? "",
    question: meta.question || undefined,
    type: meta.type ?? "",
    sources: (meta.sources ?? "").split(",").map((s) => s.trim()).filter(Boolean),
    records: [...new Set([...body.matchAll(/\/witnesses\/([a-z0-9-]+)/g)].map((m) => m[1]))],
    html: render(body),
    answer: firstParagraph(body),
    words: (body.match(/\w+/g) ?? []).length,
  };
}

const NOTES: Note[] = readdirSync(DIR)
  .filter((f) => f.endsWith(".md"))
  .sort()
  .reverse()
  .map(parse);

export function allNotes(): Note[] {
  return NOTES;
}

export function noteBySlug(slug: string): Note | undefined {
  return NOTES.find((n) => n.slug === slug);
}

/** The other notes, newest first, for the foot of a note page. */
export function siblingNotes(slug: string, limit = 3): Note[] {
  return NOTES.filter((n) => n.slug !== slug).slice(0, limit);
}

/** A source URL's host, which is all the label a bare URL can honestly carry. */
export function sourceHost(url: string): string {
  try {
    return new URL(url).host.replace(/^www\./, "");
  } catch {
    return url;
  }
}
