/**
 * The Spanish data layer. `data/species.es.json` mirrors species.json record
 * for record (tools/check_species_es.py keeps it honest). Everything that is
 * not a record, a date or a label — plates, source ordering, URLs, the store
 * link — comes straight from ./archive. A star re-export skips names declared
 * here, so the Spanish records, dates and labels shadow the English ones.
 */
export * from "./archive";
import speciesJson from "@/data/species.es.json";
import type { SpeciesRecord } from "./archive";

export const RECORDS = speciesJson as SpeciesRecord[];

export function allRecords(): SpeciesRecord[] {
  return RECORDS;
}

export function recordById(id: string): SpeciesRecord | undefined {
  return RECORDS.find((r) => r.id === id);
}

/** Catalog dates are ISO days; readers get "26 de agosto de 2026". */
export function formatDate(iso: string): string {
  return new Intl.DateTimeFormat("es", { dateStyle: "long", timeZone: "UTC" }).format(new Date(iso));
}
