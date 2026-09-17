import type { MetadataRoute } from "next";
import { allPosts, postsInSection } from "@/lib/posts";
import { postBySlug as postBySlugEs, postsInSection as postsInSectionEs } from "@/lib/posts.es";
import { SECTIONS, SITE_URL } from "@/lib/site";

/** Both languages of a page, so search engines pair them. English is the fallback. */
function pair(path: string) {
  return { en: `${SITE_URL}${path}`, es: `${SITE_URL}/es${path}`, "x-default": `${SITE_URL}${path}` };
}

export default function sitemap(): MetadataRoute.Sitemap {
  const home = pair("");
  const posts = allPosts().flatMap((p) => {
    const lastModified = new Date(p.date);
    if (!postBySlugEs(p.slug)) return [{ url: `${SITE_URL}/p/${p.slug}`, lastModified, priority: 0.8 }];
    const languages = pair(`/p/${p.slug}`);
    return [
      { url: languages.en, lastModified, priority: 0.8, alternates: { languages } },
      { url: languages.es, lastModified, priority: 0.7, alternates: { languages } },
    ];
  });
  const sections = SECTIONS.flatMap((s) => {
    const languages = pair(`/s/${s.key}`);
    return [
      ...(postsInSection(s.key).length > 0 ? [{ url: languages.en, priority: 0.6, alternates: { languages } }] : []),
      ...(postsInSectionEs(s.key).length > 0 ? [{ url: languages.es, priority: 0.5, alternates: { languages } }] : []),
    ];
  });
  return [
    { url: home.en, priority: 1, alternates: { languages: home } },
    { url: home.es, priority: 0.9, alternates: { languages: home } },
    { url: `${SITE_URL}/archive`, priority: 0.7 },
    { url: `${SITE_URL}/about`, priority: 0.5 },
    { url: `${SITE_URL}/write`, priority: 0.5 },
    { url: `${SITE_URL}/subscribe`, priority: 0.5 },
    ...sections,
    ...posts,
  ];
}
