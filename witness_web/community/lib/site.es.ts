/**
 * The Spanish edition's site facts. Everything not declared here — URLs, the
 * store gate, plateUrl — comes from ./site through the star re-export, which
 * skips the names declared below.
 */
export * from "./site";
import type { SectionKey } from "./site";

export const PUB_NAME = "Notas de campo";
export const PUB_TAGLINE = "Notas desde el borde del registro.";
export const PUB_DESCRIPTION =
  "Ensayos con fuentes sobre especies amenazadas, los números que se usan para describirlas y las estrategias para dejar la mitad del planeta a todo lo demás. Publicado por quien hace Witness.";
export const FEED_PATH = "/es/feed.xml";

export const SECTIONS: readonly { key: SectionKey; name: string; blurb: string }[] = [
  { key: "species", name: "Especies", blurb: "Un animal, una cosa verificable sobre él." },
  { key: "numbers", name: "Números", blurb: "Qué mide en realidad un recuento, una categoría o un porcentaje." },
  {
    key: "half",
    name: "Medio planeta",
    blurb: "Áreas protegidas, corredores, renaturalización y el argumento para dejar la mitad del planeta a todo lo demás.",
  },
  { key: "policy", name: "Política", blurb: "Leyes, tribunales, tratados y presupuestos, leídos de cerca." },
  { key: "dispatches", name: "Crónicas", blurb: "Reportes desde el campo y de las personas que hacen el trabajo." },
  { key: "attention", name: "Atención", blurb: "Apps, medios y cuánto vale prestar atención." },
];

export function sectionByKey(key: string) {
  return SECTIONS.find((s) => s.key === key);
}

export function formatDate(iso: string) {
  return new Date(`${iso}T12:00:00Z`).toLocaleDateString("es", {
    day: "numeric",
    month: "short",
    year: "numeric",
    timeZone: "UTC",
  });
}
