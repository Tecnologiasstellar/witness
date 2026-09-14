/**
 * Spanish copy constants for the landing page. The data layer (records,
 * plates, dates) stays shared through the star re-export; a star export skips
 * any name declared locally, so the two constants below shadow the English ones.
 */
export * from "./archive";
import { APP_STORE_LIVE } from "./archive";

/** The primary call to action, wherever it appears. See APP_STORE_LIVE. */
export const APP_CTA_LABEL = APP_STORE_LIVE ? "Descargar en el App Store" : "Leer las notas de campo";
/** Eyebrows that promised availability. Kept descriptive while the store is empty. */
export const APP_EYEBROW = APP_STORE_LIVE ? "Gratis en iPhone" : "Una especie por semana";
