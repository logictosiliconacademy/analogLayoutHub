import type { Metadata } from "next";
import { Inter, JetBrains_Mono } from "next/font/google";
import "./globals.css";
import Navbar from "@/components/Navbar";
import SearchModal from "@/components/SearchModal";
import { getAllPostsMeta, getCategoriesWithCounts } from "@/lib/posts";

const inter = Inter({ subsets: ["latin"], variable: "--font-inter" });
const mono = JetBrains_Mono({ subsets: ["latin"], variable: "--font-mono" });

export const metadata: Metadata = {
  title: "AnalogHub | Technical Knowledge Base & Engineering Journal",
  description:
    "Production-grade engineering deep dives, systems architecture guides, and low-latency backend benchmarks.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const posts = getAllPostsMeta();
  const categories = getCategoriesWithCounts();

  return (
    <html lang="en" className="dark">
      <body
        className={`${inter.variable} ${mono.variable} min-h-screen bg-[#121212] font-sans text-zinc-100 antialiased selection:bg-amber-500 selection:text-black`}
      >
        <Navbar />
        <SearchModal posts={posts} categories={categories} />
        <main className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          {children}
        </main>
        <footer
          id="about"
          className="mt-24 border-t border-border bg-[#141414] py-12"
        >
          <div className="mx-auto flex max-w-7xl flex-col items-center justify-between gap-6 px-4 sm:flex-row sm:px-6 lg:px-8">
            <div>
              <p className="font-mono text-xs uppercase tracking-widest text-amber-500">
                ANALOGHUB KNOWLEDGE BASE
              </p>
              <p className="mt-1 text-sm text-zinc-400">
                Curated systems engineering blueprints, RFC notes, and performance benchmarks.
              </p>
            </div>
            <p className="font-mono text-xs text-zinc-500">
              © {new Date().getFullYear()} AnalogHub. Press{" "}
              <span className="text-amber-500">Ctrl+K</span> to search anytime.
            </p>
          </div>
        </footer>
      </body>
    </html>
  );
}
