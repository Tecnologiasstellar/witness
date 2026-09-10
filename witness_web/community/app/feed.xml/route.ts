import { allPosts } from "@/lib/posts";
import { FEED_PATH, PUB_DESCRIPTION, PUB_NAME, SITE_URL, plateUrl, sectionByKey } from "@/lib/site";

// GET handlers are dynamic by default; this one is a file, built once with the site.
export const dynamic = "force-static";

const esc = (s: string) => s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

export function GET() {
  const posts = allPosts();
  const items = posts
    .map((p) => {
      const url = `${SITE_URL}/p/${p.slug}`;
      const html = `<p><img src="${plateUrl(p.image)}" alt=""/></p>\n${p.html.replace(/href="\//g, `href="${SITE_URL}/`)}`;
      return `<item>
<title>${esc(p.title)}</title>
<link>${url}</link>
<guid isPermaLink="true">${url}</guid>
<pubDate>${new Date(p.date).toUTCString()}</pubDate>
<category>${esc(sectionByKey(p.section)?.name ?? p.section)}</category>
${p.author ? `<dc:creator>${esc(p.author)}</dc:creator>` : ""}
<description>${esc(p.description)}</description>
<content:encoded><![CDATA[${html}]]></content:encoded>
</item>`;
    })
    .join("\n");

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
<title>${esc(PUB_NAME)}</title>
<link>${SITE_URL}</link>
<atom:link href="${SITE_URL}${FEED_PATH}" rel="self" type="application/rss+xml"/>
<description>${esc(PUB_DESCRIPTION)}</description>
<language>en</language>
<lastBuildDate>${new Date(posts[0]?.date ?? Date.now()).toUTCString()}</lastBuildDate>
${items}
</channel>
</rss>`;

  return new Response(xml, { headers: { "Content-Type": "application/rss+xml; charset=utf-8" } });
}
