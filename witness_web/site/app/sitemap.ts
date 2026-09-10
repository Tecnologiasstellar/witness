import type { MetadataRoute } from "next";
import { SITE_URL, allRecords } from "@/lib/archive";

export default function sitemap(): MetadataRoute.Sitemap {
  const records = allRecords().map((record) => ({
    url: `${SITE_URL}/archive/${record.id}`,
    lastModified: new Date(record.editorial.lastFactChecked),
    priority: 0.8,
  }));
  return [
    { url: SITE_URL, priority: 1 },
    { url: `${SITE_URL}/archive`, priority: 0.9 },
    { url: `${SITE_URL}/method`, priority: 0.6 },
    { url: `${SITE_URL}/contact`, priority: 0.5 },
    { url: `${SITE_URL}/privacy`, priority: 0.3 },
    { url: `${SITE_URL}/terms`, priority: 0.3 },
    ...records,
  ];
}
