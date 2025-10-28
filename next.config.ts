import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,
  experimental: {
    // Enable ISR for Cloudflare Pages
    isrMemoryCacheSize: 52 * 50, // max 52MB
  },
};

export default nextConfig;
