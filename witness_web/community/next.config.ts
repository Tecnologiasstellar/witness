import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  async redirects() {
    return [
      // The catalog lives on the atlas. A relative /archive link in an old note still lands.
      { source: "/archive/:id", destination: "https://witnessatlas.com/archive/:id", permanent: true },
      // The notes' first home.
      { source: "/field-notes", destination: "/", permanent: true },
      { source: "/field-notes/write", destination: "/write", permanent: true },
      { source: "/field-notes/feed.xml", destination: "/feed.xml", permanent: true },
      { source: "/field-notes/:slug", destination: "/p/:slug", permanent: true },
    ];
  },
};

export default nextConfig;
