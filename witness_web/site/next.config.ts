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
    ];
  },
};

export default nextConfig;
