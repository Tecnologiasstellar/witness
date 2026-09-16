import type { MetadataRoute } from "next";
import { SITE_URL, allRecords } from "@/lib/archive";

/** Both languages of a page, so search engines pair them. */
function pair(path: string) {
  return { en: `${SITE_URL}${path}`, es: `${SITE_URL}/es${path}` };
}

export default function sitemap(): MetadataRoute.Sitemap {
  const records = allRecords().flatMap((record) => {
    const languages = pair(`/archive/${record.id}`);
    const lastModified = new Date(record.editorial.lastFactChecked);
    return [
      { url: languages.en, lastModified, priority: 0.8, alternates: { languages } },
      { url: languages.es, lastModified, priority: 0.7, alternates: { languages } },
    ];
  });
  const home = pair("");
  const archive = pair("/archive");
  const map = pair("/map");
  return [
    { url: home.en, priority: 1, alternates: { languages: home } },
    { url: home.es, priority: 0.9, alternates: { languages: home } },
    { url: archive.en, priority: 0.9, alternates: { languages: archive } },
    { url: archive.es, priority: 0.8, alternates: { languages: archive } },
    { url: map.en, priority: 0.7, alternates: { languages: map } },
    { url: map.es, priority: 0.6, alternates: { languages: map } },
    { url: `${SITE_URL}/method`, priority: 0.6 },
    { url: `${SITE_URL}/contact`, priority: 0.5 },
    { url: `${SITE_URL}/privacy`, priority: 0.3 },
    { url: `${SITE_URL}/terms`, priority: 0.3 },
    ...records,
  ];
}
