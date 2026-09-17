import type { MetadataRoute } from "next";
import { allPosts, postsInSection } from "@/lib/posts";
import { postBySlug as postBySlugEs, postsInSection as postsInSectionEs } from "@/lib/posts.es";
import { SECTIONS, SITE_URL } from "@/lib/site";

/**
 * The Spanish edition is withheld from the sitemap, deliberately, since 2026-09-17.
 *
 * Search Console that day: 95 of 117 known URLs at "Discovered — currently not
 * indexed". Google had every URL and would not spend crawl on them. Half of this
 * site's 48 URLs were machine-translated Spanish of English pages that were not
 * themselves indexed, so they competed for a crawl budget the originals did not
 * have, and none of them had been indexed either.
 *
 * Nothing is hidden. /es stays live, linked from every English page's language
 * switcher, and declared by the hreflang pair in each page's <head> — which is
 * what pairs the two editions now, bidirectionally, without the sitemap's help.
 * This only stops asking Google to queue them.
 *
 * FLIP THIS BACK when the English notes are indexed: it is the only line to
 * change, and every Spanish URL and hreflang annotation returns exactly as it
 * was. `site:community.witnessatlas.com` returned about 4 results on 2026-09-17;
 * when that is in the twenties and Discovered-not-indexed has drained, flip it.
 */
const SPANISH_IN_SITEMAP = false;

/** Both languages of a page, so search engines pair them. English is the fallback. */
function pair(path: string) {
  return { en: `${SITE_URL}${path}`, es: `${SITE_URL}/es${path}`, "x-default": `${SITE_URL}${path}` };
}

/**
 * The entries for one path: English, then Spanish when it exists and is wanted.
 * The hreflang annotation rides along only when both are listed — a one-sided
 * annotation in a sitemap is a worse signal than none, and the page <head>
 * carries the pairing regardless.
 */
function entries(path: string, hasEs: boolean, enRest: object, esRest: object) {
  const languages = pair(path);
  if (!SPANISH_IN_SITEMAP || !hasEs) return [{ url: languages.en, ...enRest }];
  return [
    { url: languages.en, ...enRest, alternates: { languages } },
    { url: languages.es, ...esRest, alternates: { languages } },
  ];
}

export default function sitemap(): MetadataRoute.Sitemap {
  const posts = allPosts().flatMap((p) => {
    const lastModified = new Date(p.date);
    return entries(`/p/${p.slug}`, Boolean(postBySlugEs(p.slug)),
      { lastModified, priority: 0.8 }, { lastModified, priority: 0.7 });
  });
  const sections = SECTIONS.flatMap((s) => {
    if (postsInSection(s.key).length === 0) {
      // English-empty but Spanish-populated: only reachable once Spanish is back in.
      return SPANISH_IN_SITEMAP && postsInSectionEs(s.key).length > 0
        ? [{ url: pair(`/s/${s.key}`).es, priority: 0.5 }]
        : [];
    }
    return entries(`/s/${s.key}`, postsInSectionEs(s.key).length > 0,
      { priority: 0.6 }, { priority: 0.5 });
  });
  return [
    ...entries("", true, { priority: 1 }, { priority: 0.9 }),
    { url: `${SITE_URL}/archive`, priority: 0.7 },
    { url: `${SITE_URL}/about`, priority: 0.5 },
    { url: `${SITE_URL}/write`, priority: 0.5 },
    { url: `${SITE_URL}/subscribe`, priority: 0.5 },
    ...sections,
    ...posts,
  ];
}
