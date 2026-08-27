import type { Metadata, Viewport } from "next";
import { Grain } from "@/components/atlas";
import { SiteHeader } from "@/components/site-header";
import { SiteFooter } from "@/components/site-footer";
import { SITE_URL } from "@/lib/archive";
import "./globals.css";

const description =
  "A quiet iPhone ritual for meeting one species, reading a sourced story, recording attention privately, and taking one honest action. iOS MVP in development.";

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    default: "Witness | Meet one species. Remember what is still here.",
    template: "%s · Witness",
  },
  description,
  applicationName: "Witness",
  authors: [{ name: "Witness" }],
  creator: "Witness",
  keywords: ["biodiversity", "conservation", "species", "iOS", "editorial"],
  alternates: { canonical: "/" },
  openGraph: {
    type: "website",
    siteName: "Witness",
    title: "Witness | Meet one species. Remember what is still here.",
    description,
    url: SITE_URL,
    images: [{ url: "/images/species/whooping-crane-context.jpg", width: 1800, height: 1208, alt: "Two whooping cranes in an original watercolor illustration for Witness" }],
  },
  twitter: { card: "summary_large_image", title: "Witness", description, images: ["/images/species/whooping-crane-context.jpg"] },
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
    <html lang="en" className="h-full antialiased">
      <body className="flex min-h-full flex-col bg-paper text-ink">
        <Grain />
        <a
          href="#main"
          className="sr-only focus:not-sr-only focus:absolute focus:left-4 focus:top-4 focus:z-50 focus:inline-flex focus:min-h-11 focus:items-center focus:bg-ink focus:px-4 focus:text-paper"
        >
          Skip to content
        </a>
        <span id="top" />
        <SiteHeader />
        <main id="main" className="flex-1">
          {children}
        </main>
        <SiteFooter />
      </body>
    </html>
  );
}
