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
      // The essays moved to their own publication (D-029).
      { source: "/field-notes", destination: "https://community.witnessatlas.com", permanent: true },
      { source: "/field-notes/write", destination: "https://community.witnessatlas.com/write", permanent: true },
      { source: "/field-notes/feed.xml", destination: "https://community.witnessatlas.com/feed.xml", permanent: true },
      { source: "/field-notes/:slug", destination: "https://community.witnessatlas.com/p/:slug", permanent: true },
    ];
  },
};

export default nextConfig;
