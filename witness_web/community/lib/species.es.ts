/**
 * The Spanish catalog, copied from witness_web/site/data/species.es.json the
 * same way species.json is (`cp` after each translation; tools/check_species_es.py
 * flags a stale copy).
 */
import speciesJson from "@/data/species.es.json";
import type { SpeciesRecord } from "./species";

export type { SpeciesRecord } from "./species";

const RECORDS = speciesJson as unknown as SpeciesRecord[];

export function allRecords(): SpeciesRecord[] {
  return RECORDS;
}

export function recordById(id: string): SpeciesRecord | undefined {
  return RECORDS.find((r) => r.id === id);
}
