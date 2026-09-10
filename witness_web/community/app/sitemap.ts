import type { MetadataRoute } from "next";
import { allPosts, postsInSection } from "@/lib/posts";
import { SECTIONS, SITE_URL } from "@/lib/site";

export default function sitemap(): MetadataRoute.Sitemap {
  const posts = allPosts().map((p) => ({ url: `${SITE_URL}/p/${p.slug}`, lastModified: new Date(p.date), priority: 0.8 }));
  const sections = SECTIONS.filter((s) => postsInSection(s.key).length > 0).map((s) => ({
    url: `${SITE_URL}/s/${s.key}`,
    priority: 0.6,
  }));
  return [
    { url: SITE_URL, priority: 1 },
    { url: `${SITE_URL}/archive`, priority: 0.7 },
    { url: `${SITE_URL}/about`, priority: 0.5 },
    { url: `${SITE_URL}/write`, priority: 0.5 },
    { url: `${SITE_URL}/subscribe`, priority: 0.5 },
    ...sections,
    ...posts,
  ];
}
