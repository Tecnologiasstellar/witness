import type { Metadata, Viewport } from "next";
import { SiteFooter, SiteHeader } from "@/components/shell";
import { FEED_PATH, PUB_DESCRIPTION, PUB_NAME, PUB_TAGLINE, SITE_URL, plateUrl } from "@/lib/site";
import "./globals.css";

const title = `${PUB_NAME} — ${PUB_TAGLINE}`;
const ogImage = plateUrl("whooping-crane-context-01");

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: { default: title, template: `%s · ${PUB_NAME}` },
  description: PUB_DESCRIPTION,
  applicationName: PUB_NAME,
  authors: [{ name: "Witness" }],
  keywords: ["endangered species", "biodiversity", "conservation", "half-earth", "extinction", "wildlife", "nature"],
  alternates: { canonical: "/", types: { "application/rss+xml": FEED_PATH } },
  openGraph: {
    type: "website",
    siteName: PUB_NAME,
    title,
    description: PUB_DESCRIPTION,
    url: SITE_URL,
    images: [{ url: ogImage, width: 1400, height: 939, alt: "Original illustration of whooping cranes drawn for Witness" }],
  },
  twitter: { card: "summary_large_image", title, description: PUB_DESCRIPTION, images: [ogImage] },
  robots: { index: true, follow: true },
};

export const viewport: Viewport = {
  themeColor: [
    { media: "(prefers-color-scheme: light)", color: "#fcfbf7" },
    { media: "(prefers-color-scheme: dark)", color: "#0f1411" },
  ],
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="en" className="h-full antialiased">
      <body className="flex min-h-full flex-col bg-bg text-ink">
        <a
          href="#main"
          className="sr-only focus:not-sr-only focus:absolute focus:left-4 focus:top-4 focus:z-50 focus:inline-flex focus:min-h-11 focus:items-center focus:bg-ink focus:px-4 focus:text-bg"
        >
          Skip to content
        </a>
        <SiteHeader />
        <main id="main" className="flex-1">
          {children}
        </main>
        <SiteFooter />
      </body>
    </html>
  );
}
