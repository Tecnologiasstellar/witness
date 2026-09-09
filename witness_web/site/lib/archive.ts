/**
 * The archive's data layer.
 *
 * `data/species.json` is a verbatim assembled copy of the iOS catalog records
 * under Packages/WitnessCore/Sources/WitnessCore/Resources/catalog/ (sync with
 * `python3 tools/export_catalog.py > witness_web/site/data/species.json`). The
 * website renders that record and nothing else — no web-only species, no
 * re-worded story, no added figure. The plates come from the same asset
 * catalog through tools/export_web_plates.sh.
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

export type Program = {
  id: string;
  organization: string;
  title: string;
  summary: string;
  url: string;
  kind: string;
  sourceIDs: string[];
  lastVerified: string;
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
  stats?: {
    size: string;
    lifespan: string;
    diet: string;
    populationEstimate?: string;
    populationAsOf?: string;
    trend: string;
    threats: string[];
    sourceIDs: string[];
  };
  reproduction?: StoryPassage;
  insight?: StoryPassage;
  /** Five asset ids in a fixed order: plate, context, detail, behavior, scale. */
  gallery: string[];
  programs?: Program[];
};

export const RECORDS = speciesJson as SpeciesRecord[];

export function allRecords(): SpeciesRecord[] {
  return RECORDS;
}

export function recordById(id: string): SpeciesRecord | undefined {
  return RECORDS.find((r) => r.id === id);
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

/** The five plates every record carries, in gallery order, at their exported pixel sizes. */
const PLATE_KINDS = ["plate", "context", "detail", "behavior", "scale"] as const;
export type PlateKind = (typeof PLATE_KINDS)[number];
const PLATE_SIZE: Record<PlateKind, [number, number]> = {
  plate: [939, 1400],
  context: [1400, 939],
  detail: [1400, 1400],
  behavior: [1400, 939],
  scale: [1400, 1400],
};

/** A plate's web derivative. Ids are read from gallery[], never derived from record.id. */
export function plate(record: SpeciesRecord, kind: PlateKind) {
  const id = record.gallery[PLATE_KINDS.indexOf(kind)];
  if (!id) throw new Error(`${record.id} has no ${kind} plate`);
  const [width, height] = PLATE_SIZE[kind];
  return { src: `/images/plates/${id}.webp`, width, height };
}

/** Catalog dates are ISO days; readers get "26 August 2026". */
export function formatDate(iso: string): string {
  return new Intl.DateTimeFormat("en-GB", { dateStyle: "long", timeZone: "UTC" }).format(new Date(iso));
}

export const SITE_URL = "https://witnessatlas.com";
export const APP_STORE_URL = "https://apps.apple.com/app/id6804311122";
export const INSTAGRAM_URL = "https://www.instagram.com/witnessatlas";
export const CONTACT_EMAIL = "albertovillalpando@gmail.com";
/** The hosted Buttondown page. Empty until the account exists; the site then offers RSS only. */
export const SUBSCRIBE_URL = "";
export const FEED_PATH = "/field-notes/feed.xml";

export const CATALOGUE = { published: RECORDS.length };
