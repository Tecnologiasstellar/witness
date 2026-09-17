import type { SpeciesRecord } from "@/lib/archive";
import { LAND_D } from "@/lib/world-land";

/**
 * The world map behind /map without JavaScript: Natural Earth land under one
 * generalized ellipse per habitat region, drawn the way the app's
 * GeneralizedRangeMap draws them (sage fill, dashed sage stroke). Server
 * rendered, no script, no links: the list on the page is the control, this
 * picture only repeats it, and the tooltip says exactly what the list says.
 * MapLive replaces it in place once its canvas is ready.
 */

// Plate Carrée at 3 units per degree, lon -180..180, lat 84..-56 — the frame
// tools/build_world_land.py projected the land into.
const K = 3;
const LAT_TOP = 84;
const LAT_BOTTOM = -56;
const W = 360 * K;
const H = (LAT_TOP - LAT_BOTTOM) * K;
const KM_PER_DEG = 111.195;
/** RangeRegion.minimumRadiusKm; CatalogValidator enforces it on the app side. */
const MIN_RADIUS_KM = 25;
// ponytail: a 25 km range is 0.7 units, invisible at world scale, so small
// ranges are drawn at this floor. It overstates, never understates, a range;
// the tooltip carries the real km.
const FLOOR = 8;

type Region = NonNullable<SpeciesRecord["habitatRegions"]>[number];

/** Throws during prerender, so a record outside the rules cannot build. */
function ellipse(region: Region) {
  const { latitude, longitude, radiusKm } = region;
  if (radiusKm < MIN_RADIUS_KM || latitude <= LAT_BOTTOM || latitude >= LAT_TOP || Math.abs(longitude) > 180) {
    throw new Error(`${region.name}: outside the generalized-range rules (${radiusKm} km at ${latitude}, ${longitude})`);
  }
  const ry = Math.max(FLOOR, (radiusKm / KM_PER_DEG) * K);
  return {
    cx: (longitude + 180) * K,
    cy: (LAT_TOP - latitude) * K,
    rx: ry / Math.cos((latitude * Math.PI) / 180),
    ry,
  };
}

const one = (n: number) => Math.round(n * 10) / 10;

function maxRadius(record: SpeciesRecord) {
  return Math.max(0, ...(record.habitatRegions ?? []).map((region) => region.radiusKm));
}

/** The same regions, flat, for the live map. */
export function mapRegions(records: SpeciesRecord[]) {
  return records.flatMap((record) =>
    (record.habitatRegions ?? []).map((region) => ({
      id: record.id,
      species: record.commonName,
      region: region.name,
      lat: region.latitude,
      lng: region.longitude,
      radiusKm: region.radiusKm,
    })),
  );
}

export function SpeciesMap({ records, title }: { records: SpeciesRecord[]; title: string }) {
  // Largest ranges first, so a small circle is never buried under a bigger one.
  const ordered = records
    .filter((record) => record.habitatRegions?.length)
    .sort((a, b) => maxRadius(b) - maxRadius(a));

  return (
    <svg className="map-svg" viewBox={`0 0 ${W} ${H}`} aria-labelledby="map-title">
      <title id="map-title">{title}</title>
      <path className="land" d={LAND_D} />
      {ordered.map((record) => (
        <g key={record.id} id={`r-${record.id}`}>
          {(record.habitatRegions ?? []).flatMap((region) => {
            const e = ellipse(region);
            // A range past the antimeridian is drawn again on the left edge.
            const centres = e.cx + e.rx > W ? [e.cx, e.cx - W] : [e.cx];
            return centres.map((cx) => (
              <ellipse key={`${region.name}@${one(cx)}`} className="range" cx={one(cx)} cy={one(e.cy)} rx={one(e.rx)} ry={one(e.ry)}>
                <title>{`${record.commonName} · ${region.name} · ~${region.radiusKm} km`}</title>
              </ellipse>
            ));
          })}
        </g>
      ))}
    </svg>
  );
}
