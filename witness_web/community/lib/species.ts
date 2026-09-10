/**
 * The app catalog, verbatim (`python3 tools/export_catalog.py`). The hub shows
 * it as plates and names and links every record to its page on the atlas; it
 * never restates a record's story.
 */
import speciesJson from "@/data/species.json";

export type SpeciesRecord = {
  id: string;
  commonName: string;
  scientificName: string;
  conservationStatus: { displayName: string; normalizedValue: string };
  generalizedRange: string;
  hook: string;
  gallery: string[];
};

const RECORDS = speciesJson as unknown as SpeciesRecord[];

export function allRecords(): SpeciesRecord[] {
  return RECORDS;
}

export function recordById(id: string): SpeciesRecord | undefined {
  return RECORDS.find((r) => r.id === id);
}

/** Every plate id the catalog knows, for checking a post's `image:`. */
export function plateIds(): Set<string> {
  return new Set(RECORDS.flatMap((r) => r.gallery));
}
