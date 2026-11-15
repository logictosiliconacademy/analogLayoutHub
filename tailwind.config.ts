import type { Config } from "tailwindcss";
import typography from "@tailwindcss/typography";

const config: Config = {
  darkMode: "class",
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "#121212",
        surface: "#181818",
        "surface-hover": "#202020",
        border: "#262626",
      },
      fontFamily: {
        sans: ["var(--font-inter)", "sans-serif"],
        mono: ["var(--font-mono)", "monospace"],
      },
      typography: {
        invert: {
          css: {
            "--tw-prose-body": "#d4d4d8",
            "--tw-prose-headings": "#ffffff",
            "--tw-prose-links": "#f59e0b",
            "--tw-prose-bold": "#ffffff",
            "--tw-prose-counters": "#f59e0b",
            "--tw-prose-bullets": "#f59e0b",
            "--tw-prose-hr": "#262626",
            "--tw-prose-quotes": "#e4e4e7",
            "--tw-prose-quote-borders": "#f59e0b",
            "--tw-prose-captions": "#a1a1aa",
            "--tw-prose-code": "#f59e0b",
            "--tw-prose-pre-code": "#e4e4e7",
            "--tw-prose-pre-bg": "#181818",
            "--tw-prose-th-borders": "#3f3f46",
            "--tw-prose-td-borders": "#262626",
          },
        },
      },
    },
  },
  plugins: [typography],
};

export default config;
