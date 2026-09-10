/**
 * Posts — one markdown file per piece in `content/posts/<date>-<slug>.md`, read
 * at build time. The queue, the gates and the publish command live in
 * `../../../tools/notes.py`; this file only renders what that tool already
 * validated. Nothing here re-checks a claim — a post that reaches the site
 * passed the gate, or it was never committed.
 */
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { SECTIONS, type SectionKey } from "./site";
import { recordById } from "./species";

const DIR = join(process.cwd(), "content/posts");
const FALLBACK_PLATE = "whooping-crane-context-01";

/** The context plate of a record: second in its gallery. Plate ids do not always carry the record id. */
function contextPlate(recordId: string | undefined) {
  const gallery = recordId ? recordById(recordId)?.gallery : undefined;
  return gallery?.[1] ?? gallery?.[0];
}

export type Post = {
  slug: string;
  date: string;
  title: string;
  description: string;
  /** The search question this answers, when it answers one. Drives FAQPage. */
  question?: string;
  type: string;
  section: SectionKey;
  /** Plate id from the atlas catalog. Declared, or the first record the body links. */
  image: string;
  /** Frontmatter `author:` and `authorUrl:` — a guest byline. Absent means Witness wrote it. */
  author?: string;
  authorUrl?: string;
  /** Frontmatter `sources:` — comma-separated URLs, required for any checkable claim. */
  sources: string[];
  /** Catalog record ids linked from the body. Derived, never declared, so it cannot drift. */
  records: string[];
  html: string;
  /** The standalone opening paragraph. This is what an AI assistant quotes. */
  answer: string;
  words: number;
  minutes: number;
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

/** Paragraphs, h2, h3, bullet lists, block quotes. */
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

function parse(file: string): Post {
  const raw = readFileSync(join(DIR, file), "utf8");
  const match = /^---\n([\s\S]*?)\n---\n([\s\S]*)$/.exec(raw);
  if (!match) throw new Error(`${file}: missing frontmatter`);
  const meta: Record<string, string> = {};
  for (const line of match[1].split("\n")) {
    const kv = /^(\w+):\s*(.+)$/.exec(line);
    if (kv) meta[kv[1]] = kv[2].trim();
  }
  const body = match[2];
  const records = [...new Set([...body.matchAll(/\/archive\/([a-z0-9-]+)/g)].map((m) => m[1]))];
  const section = SECTIONS.find((s) => s.key === meta.section)?.key;
  if (!section) throw new Error(`${file}: section must be one of ${SECTIONS.map((s) => s.key).join("|")}`);
  const words = (body.match(/\w+/g) ?? []).length;
  return {
    slug: file.slice(11, -3),
    date: file.slice(0, 10),
    title: meta.title ?? "",
    description: meta.description ?? "",
    question: meta.question || undefined,
    type: meta.type ?? "",
    section,
    image: meta.image || contextPlate(records[0]) || FALLBACK_PLATE,
    author: meta.author || undefined,
    authorUrl: meta.authorUrl || undefined,
    sources: (meta.sources ?? "").split(",").map((s) => s.trim()).filter(Boolean),
    records,
    html: render(body),
    answer: firstParagraph(body),
    words,
    minutes: Math.max(1, Math.round(words / 220)),
  };
}

const POSTS: Post[] = readdirSync(DIR)
  .filter((f) => f.endsWith(".md"))
  .sort()
  .reverse()
  .map(parse);

export function allPosts(): Post[] {
  return POSTS;
}

export function postBySlug(slug: string): Post | undefined {
  return POSTS.find((p) => p.slug === slug);
}

export function postsInSection(key: SectionKey): Post[] {
  return POSTS.filter((p) => p.section === key);
}

/** Same section first, then newest, never the post itself. */
export function relatedPosts(post: Post, limit = 3): Post[] {
  const others = POSTS.filter((p) => p.slug !== post.slug);
  const same = others.filter((p) => p.section === post.section);
  const rest = others.filter((p) => p.section !== post.section);
  return [...same, ...rest].slice(0, limit);
}

/** A source URL's host, which is all the label a bare URL can honestly carry. */
export function sourceHost(url: string): string {
  try {
    return new URL(url).host.replace(/^www\./, "");
  } catch {
    return url;
  }
}
