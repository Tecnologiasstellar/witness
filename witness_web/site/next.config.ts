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
    ];
  },
};

export default nextConfig;
