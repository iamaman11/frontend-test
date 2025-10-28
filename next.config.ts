import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,
  outputFileTracingRoot: undefined,
  experimental: {
    isrMemoryCacheSize: 52 * 50,
  },
  headers: async () => [
    {
      source: "/:path*",
      headers: [
        {
          key: "Cache-Control",
          value: "public, max-age=60, s-maxage=300",
        },
      ],
    },
  ],
};

export default nextConfig;
