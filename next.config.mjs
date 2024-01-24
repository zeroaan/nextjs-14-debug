/* eslint-disable no-undef */
/** @type {import('next').NextConfig} */

const nextConfig = {
  swcMinify: true,
  output: "standalone",
  productionBrowserSourceMaps: false,
  transpilePackages: [
    "@shared/i18n",
    "@shared/ui",
    "@shared/stores",
    "@shared/constant",
  ],

  typescript: {
    // !! WARN !!
    // Dangerously allow production builds to successfully complete even if
    // your project has type errors.
    // !! WARN !!
    ignoreBuildErrors: true,
  },
  eslint: {
    // Warning: This allows production builds to successfully complete even if
    // your project has ESLint errors.
    ignoreDuringBuilds: true,
  },
  reactStrictMode: false,
};

export default nextConfig;
