/**
 * The archive's data layer.
 *
 * `data/species.json` is a verbatim assembled copy of the individual iOS catalog
 * records under Packages/WitnessCore/Sources/WitnessCore/Resources/catalog/. The website
 * renders that record and nothing else — no web-only species, no re-worded
 * story, no added figure. If the app's record changes, copy the file again.
 */
import speciesJson from "@/data/species.json";

export type Source = {
  id: string;
  title: string;
  organization: string;
  url: string;
  lastAccessed: string;
};

export type StoryPassage = {
  id: string;
  text: string;
  sourceIDs: string[];
};

export type SpeciesRecord = {
  id: string;
  schemaVersion: number;
  commonName: string;
  scientificName: string;
  conservationStatus: { displayName: string; normalizedValue: string };
  generalizedRange: string;
  hook: string;
  story: StoryPassage[];
  action: {
    id: string;
    title: string;
    summary: string;
    effort: string;
    destinationURL: string;
    destinationOrganization: string;
    geographicApplicability: string;
    sourceIDs: string[];
    lastVerified: string;
    measurementType: string;
  };
  media: {
    assetID: string;
    depictionType: string;
    creator: string;
    source: string;
    license: string;
    requiredAttribution: string;
    commercialUseStatus: string;
    verificationStatus: string;
  };
  publishDate: string;
  sources: Source[];
  editorial: {
    state: string;
    reviewer: string;
    lastFactChecked: string;
    sensitiveLocationReview: string;
    notes: string;
  };
};

export const RECORDS = speciesJson as SpeciesRecord[];

export function allRecords(): SpeciesRecord[] {
  return RECORDS;
}

export function recordById(id: string): SpeciesRecord | undefined {
  return RECORDS.find((r) => r.id === id);
}

export function sourceById(record: SpeciesRecord, id: string) {
  return record.sources.find((s) => s.id === id);
}

/** Source ids in first-appearance order, so passages can carry stable marks. */
export function orderedSources(record: SpeciesRecord): Source[] {
  const seen: string[] = [];
  for (const passage of record.story) {
    for (const id of passage.sourceIDs) {
      if (!seen.includes(id)) seen.push(id);
    }
  }
  for (const source of record.sources) {
    if (!seen.includes(source.id)) seen.push(source.id);
  }
  return seen
    .map((id) => record.sources.find((s) => s.id === id))
    .filter((s): s is Source => Boolean(s));
}

export function sourceMark(record: SpeciesRecord, id: string): number {
  return orderedSources(record).findIndex((s) => s.id === id) + 1;
}

export const GITHUB_URL = "https://github.com/Tecnologiasstellar/witness";
export const SITE_URL = "https://witness-rho.vercel.app";

/**
 * The archive's current state. Catalog approval and public app release remain
 * separate evidence gates.
 */
export const CATALOGUE = {
  published: RECORDS.length,
  inReview: 0,
  note: `All ${RECORDS.length} bundled records are written from declared sources, fact-checked, and approved in the catalog.`,
};
