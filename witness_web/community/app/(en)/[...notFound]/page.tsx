import { notFound } from "next/navigation";

/**
 * With two root layouts (English and /es) there is no top-level layout for
 * Next's own 404 entry, so unmatched URLs would get the bare built-in page.
 * This catch-all routes them here instead, and notFound() renders
 * ../not-found.tsx inside the English layout.
 */
export default function CatchAll() {
  notFound();
}
