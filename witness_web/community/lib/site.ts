/** Hardcoded site facts. One place, no env vars. */
export const SITE_URL = "https://community.witnessatlas.com";
export const PUB_NAME = "Field Notes";
export const PUB_TAGLINE = "Notes from the edge of the record.";
export const PUB_DESCRIPTION =
  "Sourced essays on threatened species, the numbers used to describe them, and the strategies for leaving half the planet to everything else. Published by the maker of Witness.";

export const ATLAS_URL = "https://witnessatlas.com";
export const APP_STORE_URL = "https://apps.apple.com/app/id6804311122";
export const INSTAGRAM_URL = "https://www.instagram.com/witnessatlas";
export const CONTACT_EMAIL = "albertovillalpando@gmail.com";
/** The hosted Buttondown page. Empty until the account exists; the site then offers RSS only. */
export const SUBSCRIBE_URL = "";
export const FEED_PATH = "/feed.xml";

export const SECTIONS = [
  { key: "species", name: "Species", blurb: "One animal, one verifiable thing about it." },
  { key: "numbers", name: "Numbers", blurb: "What a count, a category, or a percentage actually measures." },
  {
    key: "half",
    name: "Half the Earth",
    blurb: "Protected areas, corridors, rewilding, and the argument for leaving half the planet to everything else.",
  },
  { key: "policy", name: "Policy", blurb: "Laws, courts, treaties, and budgets, read closely." },
  { key: "dispatches", name: "Dispatches", blurb: "Reports from the field and from the people doing the work." },
  { key: "attention", name: "Attention", blurb: "Apps, media, and what noticing is worth." },
] as const;

export type SectionKey = (typeof SECTIONS)[number]["key"];
export type Section = (typeof SECTIONS)[number];

export function sectionByKey(key: string): Section | undefined {
  return SECTIONS.find((s) => s.key === key);
}

/** Every plate is served once, from the atlas. The hub never copies an image. */
export function plateUrl(id: string) {
  return `${ATLAS_URL}/images/plates/${id}.webp`;
}

export function formatDate(iso: string) {
  return new Date(`${iso}T12:00:00Z`).toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
    timeZone: "UTC",
  });
}
