"use client";

import "maplibre-gl/dist/maplibre-gl.css";
import { useEffect, useRef, useState, type ReactNode } from "react";
import type { ExpressionSpecification, Map as MapLibreMap, Popup, StyleSpecification } from "maplibre-gl";

/**
 * The live map: MapLibre GL over OpenFreeMap vector tiles, painted in the
 * site's own paper tokens (read from the rendered page, so day and dusk
 * follow the footer control). Progressive: the server-rendered SVG passed as
 * children is the whole map until this mounts, and stays the map without
 * JavaScript or WebGL. The style draws only land, water, borders and place
 * names, and zoom is capped, so nothing finer than the catalog's own
 * generalization can render.
 */

export type MapRegion = { id: string; species: string; region: string; lat: number; lng: number; radiusKm: number };

export type MapCopy = {
  lang: string;
  title: string;
  zoomIn: string;
  zoomOut: string;
  windowsHelpText: string;
  macHelpText: string;
  mobileHelpText: string;
};

const TILES = "https://tiles.openfreemap.org/planet";
const GLYPHS = "https://tiles.openfreemap.org/fonts/{fontstack}/{range}.pbf";
// ponytail: zoom 7 is about 611 m per pixel at the equator (MapLibre's world is
// 512 px wide at zoom 0), so a 25 km range is ~80 px across; the style has no
// roads, so nothing finer than a coastline or a town name ever resolves. One
// constant; the safety review cites it.
const MAX_ZOOM = 7;
/** Same idea as the SVG floor: a range is never drawn smaller than this. */
const FLOOR_PX = 6;
const METERS_PER_PX_AT_Z0 = 40075016.686 / 512;
const KM_PER_DEG = 111.195;
const WORLD: [[number, number], [number, number]] = [[-170, -55], [179, 80]];

/** #rrggbb mixed like the stylesheet's color-mix(in srgb, b t%, a). */
function mix(a: string, b: string, t: number) {
  const hex = (s: string) => (s.match(/[0-9a-f]{2}/gi) ?? ["00", "00", "00"]).map((h) => parseInt(h, 16));
  const [ra, ga, ba] = hex(a);
  const [rb, gb, bb] = hex(b);
  return "#" + [ra + (rb - ra) * t, ga + (gb - ga) * t, ba + (bb - ba) * t].map((x) => Math.round(x).toString(16).padStart(2, "0")).join("");
}

/** The page's tokens, as MapLibre wants them (its validator reads hex, not the color() strings computed styles return). */
function tokens() {
  const root = getComputedStyle(document.documentElement);
  const v = (name: string) => root.getPropertyValue(name).trim();
  return {
    land: mix(v("--paper-aged"), v("--sepia"), 0.14), // same tint as .land in globals.css
    coast: v("--sepia"),
    sea: v("--paper-fresh"),
    sage: v("--sage"),
    text: v("--ink-muted"),
  };
}

function geojson(regions: MapRegion[]): GeoJSON.FeatureCollection {
  return {
    type: "FeatureCollection",
    features: regions.map((r, i) => ({
      type: "Feature",
      id: i,
      properties: {
        id: r.id,
        label: `${r.species} · ${r.region} · ~${r.radiusKm} km`,
        // Pixel radius at zoom 0; the style scales it by 2^zoom.
        px0: (r.radiusKm * 1000) / (METERS_PER_PX_AT_Z0 * Math.cos((r.lat * Math.PI) / 180)),
      },
      geometry: { type: "Point", coordinates: [r.lng, r.lat] },
    })),
  };
}

function style(regions: MapRegion[], lang: string): StyleSpecification {
  const t = tokens();
  const selected: ExpressionSpecification = ["boolean", ["feature-state", "selected"], false];
  const name: ExpressionSpecification = ["coalesce", ["get", `name:${lang}`], ["get", "name:latin"], ["get", "name"]];
  return {
    version: 8,
    glyphs: GLYPHS,
    sources: {
      openmaptiles: { type: "vector", url: TILES },
      ranges: { type: "geojson", data: geojson(regions) },
    },
    layers: [
      { id: "land", type: "background", paint: { "background-color": t.land } },
      {
        id: "water",
        type: "fill",
        source: "openmaptiles",
        "source-layer": "water",
        filter: ["==", ["geometry-type"], "Polygon"],
        paint: { "fill-color": t.sea },
      },
      {
        id: "borders",
        type: "line",
        source: "openmaptiles",
        "source-layer": "boundary",
        filter: ["all", ["==", ["get", "admin_level"], 2], ["!=", ["get", "maritime"], 1]],
        paint: { "line-color": t.coast, "line-opacity": 0.4, "line-width": 0.8 },
      },
      {
        id: "ranges",
        type: "circle",
        source: "ranges",
        paint: {
          "circle-radius": ["interpolate", ["exponential", 2], ["zoom"], 0, ["max", FLOOR_PX, ["get", "px0"]], 22, ["max", FLOOR_PX, ["*", ["get", "px0"], 2 ** 22]]],
          "circle-color": t.sage,
          "circle-opacity": ["case", selected, 0.6, 0.28],
          "circle-stroke-color": t.sage,
          "circle-stroke-width": ["case", selected, 3, 1.6],
          "circle-pitch-alignment": "map",
        },
      },
      {
        id: "countries",
        type: "symbol",
        source: "openmaptiles",
        "source-layer": "place",
        filter: ["==", ["get", "class"], "country"],
        minzoom: 2,
        layout: { "text-field": name, "text-font": ["Noto Sans Regular"], "text-size": 11, "text-transform": "uppercase", "text-letter-spacing": 0.15, "text-max-width": 7 },
        paint: { "text-color": t.text, "text-halo-color": t.land, "text-halo-width": 1.2 },
      },
      {
        id: "cities",
        type: "symbol",
        source: "openmaptiles",
        "source-layer": "place",
        filter: ["all", ["==", ["get", "class"], "city"], ["<=", ["get", "rank"], 6]],
        minzoom: 4.5,
        layout: { "text-field": name, "text-font": ["Noto Sans Italic"], "text-size": 11, "text-max-width": 7 },
        paint: { "text-color": t.text, "text-halo-color": t.land, "text-halo-width": 1.2 },
      },
    ],
  };
}

function boundsOf(regions: MapRegion[]): [[number, number], [number, number]] {
  let w = 180, s = 90, e = -180, n = -90;
  for (const r of regions) {
    const dLat = r.radiusKm / KM_PER_DEG;
    const dLng = dLat / Math.cos((r.lat * Math.PI) / 180);
    w = Math.min(w, r.lng - dLng); e = Math.max(e, r.lng + dLng);
    s = Math.min(s, r.lat - dLat); n = Math.max(n, r.lat + dLat);
  }
  return [[w, s], [e, n]];
}

export function MapLive({ regions, copy, caption, children }: { regions: MapRegion[]; copy: MapCopy; caption: string; children: ReactNode }) {
  const box = useRef<HTMLDivElement>(null);
  const [ready, setReady] = useState(false);

  useEffect(() => {
    const el = box.current;
    if (!el) return;
    let dead = false;
    let map: MapLibreMap | undefined;
    let popup: Popup | undefined;
    let current: string | null = null;
    const still = matchMedia("(prefers-reduced-motion: reduce)").matches;
    const cleanups: (() => void)[] = [];

    const select = (id: string | null) => {
      if (!map) return;
      regions.forEach((r, i) => map!.setFeatureState({ source: "ranges", id: i }, { selected: r.id === id }));
      current = id;
    };
    const show = (id: string, animate: boolean) => {
      if (!map) return;
      const own = regions.filter((r) => r.id === id);
      if (!own.length) return;
      select(id);
      map.fitBounds(boundsOf(own), { padding: 80, maxZoom: MAX_ZOOM, animate: animate && !still });
    };
    const reveal = (id: string, animate: boolean) => {
      show(id, animate);
      // The browser scrolls to the hidden SVG group; bring the whole figure up instead.
      el.closest("figure")?.scrollIntoView({ block: "start", behavior: animate && !still ? "smooth" : "auto" });
    };
    const idOf = (hash: string) => (hash.startsWith("#r-") ? decodeURIComponent(hash.slice(3)) : null);
    const fromHash = (animate: boolean) => {
      const id = idOf(location.hash);
      if (id) reveal(id, animate);
    };

    const start = () => import("maplibre-gl")
      .then((ml) => {
        if (dead) return;
        // The bundlers rewrite import.meta.url, so MapLibre cannot find its own
        // module worker; prebuild copies it (and the module it imports) to /public.
        ml.setWorkerUrl("/maplibre/maplibre-gl-worker.mjs");
        map = new ml.Map({
          container: el,
          style: style(regions, copy.lang),
          bounds: WORLD,
          fitBoundsOptions: { padding: 4 },
          maxZoom: MAX_ZOOM,
          attributionControl: { compact: false },
          cooperativeGestures: true,
          locale: {
            "NavigationControl.ZoomIn": copy.zoomIn,
            "NavigationControl.ZoomOut": copy.zoomOut,
            "Map.Title": copy.title,
            "CooperativeGesturesHandler.WindowsHelpText": copy.windowsHelpText,
            "CooperativeGesturesHandler.MacHelpText": copy.macHelpText,
            "CooperativeGesturesHandler.MobileHelpText": copy.mobileHelpText,
          },
          fadeDuration: still ? 0 : 300,
        });
        map.addControl(new ml.NavigationControl({ showCompass: false }), "top-right");
        popup = new ml.Popup({ closeButton: false, closeOnClick: false, offset: 10, maxWidth: "280px" });
        // Tile and style errors go to the debug channel: visible when debugging, never a page error.
        map.on("error", (e) => console.debug("map", e.error?.message ?? e));
        map.once("load", () => {
          setReady(true);
          fromHash(false);
        });
        map.on("mousemove", "ranges", (e) => {
          const f = e.features?.[0];
          if (!f || !map) return;
          map.getCanvas().style.cursor = "pointer";
          popup!.setLngLat(e.lngLat).setText(String(f.properties.label)).addTo(map);
        });
        map.on("mouseleave", "ranges", () => {
          if (!map) return;
          map.getCanvas().style.cursor = "";
          popup!.remove();
        });
        map.on("click", "ranges", (e) => {
          const f = e.features?.[0];
          if (!f) return;
          const id = String(f.properties.id);
          select(id);
          popup!.setLngLat(e.lngLat).setText(String(f.properties.label)).addTo(map!);
          const row = document.getElementById(`s-${id}`);
          const details = row?.querySelector("details");
          if (details) details.open = true;
          row?.scrollIntoView({ block: "nearest", behavior: still ? "auto" : "smooth" });
        });
        // Day and dusk: repaint from the tokens when the footer control or the system changes.
        const repaint = () => {
          if (!map) return;
          map.setStyle(style(regions, copy.lang));
          map.once("styledata", () => select(current));
        };
        const radios = document.querySelectorAll<HTMLInputElement>('input[name="appearance"]');
        radios.forEach((r) => r.addEventListener("change", repaint));
        const scheme = matchMedia("(prefers-color-scheme: dark)");
        scheme.addEventListener("change", repaint);
        const onHash = () => fromHash(true);
        addEventListener("hashchange", onHash);
        // A second click on the same "Show on map" link changes no hash, so listen to the click too.
        const onListClick = (e: MouseEvent) => {
          const link = (e.target as Element | null)?.closest?.('a[href^="#r-"]');
          const id = link ? idOf(link.getAttribute("href") ?? "") : null;
          if (id) reveal(id, true);
        };
        document.addEventListener("click", onListClick);
        cleanups.push(() => {
          radios.forEach((r) => r.removeEventListener("change", repaint));
          scheme.removeEventListener("change", repaint);
          removeEventListener("hashchange", onHash);
          document.removeEventListener("click", onListClick);
        });
      })
      .catch((e) => {
        // No module or no WebGL: the SVG underneath stays the map.
        console.debug("map", e);
      });

    // Nothing downloads or runs until the figure is near the viewport, or at once for a deep link.
    if (location.hash.startsWith("#r-") || !("IntersectionObserver" in window)) {
      start();
    } else {
      const watcher = new IntersectionObserver((entries) => {
        if (!entries.some((entry) => entry.isIntersecting)) return;
        watcher.disconnect();
        start();
      }, { rootMargin: "240px" });
      watcher.observe(el);
      cleanups.push(() => watcher.disconnect());
    }

    return () => {
      dead = true;
      cleanups.forEach((fn) => fn());
      popup?.remove();
      map?.remove();
    };
  }, [regions, copy]);

  return (
    <figure id="map" className="map-figure" data-ready={ready ? "" : undefined}>
      <div className="map-box">
        {children}
        <div ref={box} className="map-live" />
      </div>
      <figcaption>{caption}</figcaption>
    </figure>
  );
}
