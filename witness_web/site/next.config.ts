import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  async redirects() {
    return [
      {
        source: "/:path*",
        has: [{ type: "host", value: "www.witnessatlas.com" }],
        destination: "https://witnessatlas.com/:path*",
        permanent: true,
      },
      {
        source: "/:path*",
        has: [{ type: "host", value: "witness-rho.vercel.app" }],
        destination: "https://witnessatlas.com/:path*",
        permanent: true,
      },
      {
        source: "/:path*",
        has: [
          {
            type: "host",
            value: "witness-tecnologiasstellars-projects.vercel.app",
          },
        ],
        destination: "https://witnessatlas.com/:path*",
        permanent: true,
      },
      // Final paths. The App Store Connect support URL still points at /support.
      { source: "/witnesses", destination: "/archive", permanent: true },
      { source: "/witnesses/:id", destination: "/archive/:id", permanent: true },
      { source: "/support", destination: "/contact", permanent: true },
      // The essays moved to their own publication (D-029), so every note path still
      // redirects. /field-notes itself came back on 2026-09-17 as an index that links
      // them: Search Console had 95 of 117 known URLs at "Discovered - currently not
      // indexed", and this domain — which holds what little authority exists — linked
      // the publication's home page and not one note. A hub here is the path in.
      { source: "/field-notes/write", destination: "https://community.witnessatlas.com/write", permanent: true },
      { source: "/field-notes/feed.xml", destination: "https://community.witnessatlas.com/feed.xml", permanent: true },
      { source: "/field-notes/:slug", destination: "https://community.witnessatlas.com/p/:slug", permanent: true },
    ];
  },
};

export default nextConfig;
