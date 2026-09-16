import type { Metadata, Viewport } from "next";
import { Grain } from "@/components/atlas";
import { SiteHeader } from "@/components/site-header.es";
import { SiteFooter } from "@/components/site-footer.es";
import { Analytics } from "@vercel/analytics/next";
import { APP_STORE_LIVE, SITE_URL } from "@/lib/archive";
import "../globals.css";

const description =
  "Cada semana, una especie al borde de la desaparición: su historia real, sus fuentes, una acción honesta. Sin feed. Sin cuenta. Sin falsas promesas." +
  (APP_STORE_LIVE ? " Gratis en iPhone." : "");

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    default: "Witness — una especie en peligro por semana",
    template: "%s · Witness",
  },
  description,
  applicationName: "Witness",
  authors: [{ name: "Witness" }],
  creator: "Witness",
  keywords: ["especies en peligro", "fauna", "extinción", "conservación", "naturaleza", "biodiversidad", "app para iPhone"],
  // Safari's Smart App Banner. It offers the store listing, so it is gated with
  // everything else that promises one — see APP_STORE_LIVE.
  ...(APP_STORE_LIVE ? { itunes: { appId: "6804311122" } } : {}),
  alternates: { canonical: "/es", languages: { en: "/", es: "/es" } },
  openGraph: {
    type: "website",
    siteName: "Witness",
    title: "Witness — una especie en peligro por semana",
    description,
    url: `${SITE_URL}/es`,
    images: [{ url: "/images/plates/whooping-crane-context-01.webp", width: 1400, height: 939, alt: "Ilustración original de grullas trompeteras dibujada para Witness" }],
  },
  twitter: { card: "summary_large_image", title: "Witness", description, images: ["/images/plates/whooping-crane-context-01.webp"] },
  robots: { index: true, follow: true },
};

export const viewport: Viewport = {
  themeColor: [
    { media: "(prefers-color-scheme: light)", color: "#F1E8D5" },
    { media: "(prefers-color-scheme: dark)", color: "#15130F" },
  ],
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="es" className="h-full antialiased">
      <body className="flex min-h-full flex-col bg-paper text-ink">
        <Grain />
        <a
          href="#main"
          className="sr-only focus:not-sr-only focus:absolute focus:left-4 focus:top-4 focus:z-50 focus:inline-flex focus:min-h-11 focus:items-center focus:bg-ink focus:px-4 focus:text-paper"
        >
          Saltar al contenido
        </a>
        <span id="top" />
        <SiteHeader />
        <main id="main" className="flex-1">
          {children}
        </main>
        <SiteFooter />
        <Analytics />
      </body>
    </html>
  );
}
