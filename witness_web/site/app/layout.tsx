import type { Metadata, Viewport } from "next";
import { Grain } from "@/components/atlas";
import { SiteHeader } from "@/components/site-header";
import { SiteFooter } from "@/components/site-footer";
import { APP_STORE_LIVE, SITE_URL } from "@/lib/archive";
import "./globals.css";

const description =
  "Each week, one species on the edge of disappearance: its true story, its sources, one honest action. No feed. No account. No false promises." +
  (APP_STORE_LIVE ? " Free on iPhone." : "");

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    default: "Witness — one endangered species a week",
    template: "%s · Witness",
  },
  description,
  applicationName: "Witness",
  authors: [{ name: "Witness" }],
  creator: "Witness",
  keywords: ["endangered species", "wildlife", "extinction", "conservation", "nature", "biodiversity", "iPhone app"],
  itunes: { appId: "6804311122" },
  alternates: { canonical: "/" },
  openGraph: {
    type: "website",
    siteName: "Witness",
    title: "Witness — one endangered species a week",
    description,
    url: SITE_URL,
    images: [{ url: "/images/plates/whooping-crane-context-01.webp", width: 1400, height: 939, alt: "Original illustration of whooping cranes drawn for Witness" }],
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
