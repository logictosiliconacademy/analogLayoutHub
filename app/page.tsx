import { ArrowRight, BookOpen } from "lucide-react";
import { getAllPostsMeta, getCategoriesWithCounts } from "@/lib/posts";
import ArticleFeed from "@/components/ArticleFeed";

export default function HomePage() {
  const allPosts = getAllPostsMeta();
  const categories = getCategoriesWithCounts();

  return (
    <div className="space-y-20 py-10">
      <section className="relative overflow-hidden rounded-2xl border border-border bg-[#181818] px-6 py-16 sm:px-12 sm:py-20">
        <div className="pointer-events-none absolute -top-24 right-1/4 h-72 w-72 rounded-full bg-amber-500/10 blur-3xl" />

        <div className="relative max-w-3xl">
          <div className="inline-flex items-center gap-2 rounded-full border border-amber-500/30 bg-amber-500/10 px-3 py-1 font-mono text-xs font-medium text-amber-500">
            <span>v2.4 ENGINEERING ARCHIVE</span>
          </div>

          <h1 className="mt-6 text-4xl font-extrabold tracking-tight text-white sm:text-5xl lg:text-6xl leading-[1.12]">
            Deep-Dive Systems &{" "}
            <span className="text-amber-500">Production Architecture.</span>
          </h1>

          <p className="mt-6 max-w-2xl text-base sm:text-lg text-zinc-400 leading-relaxed">
            A distraction-free technical knowledge base covering distributed
            consensus, kernel-bypass networking, database storage engines, and
            battle-tested infrastructure patterns.
          </p>

          <div className="mt-8 flex flex-wrap items-center gap-4">
            <a
              href="#articles"
              className="inline-flex items-center gap-2 rounded-lg bg-amber-500 px-5 py-3 text-sm font-semibold text-black shadow-lg shadow-amber-500/10 transition hover:bg-amber-400"
            >
              <BookOpen className="h-4 w-4" />
              Browse Articles
            </a>
            <a
              href="#about"
              className="inline-flex items-center gap-2 rounded-lg border border-border bg-[#121212] px-5 py-3 text-sm font-semibold text-zinc-200 transition hover:border-amber-500/40 hover:text-amber-500"
            >
              About the Archive
              <ArrowRight className="h-4 w-4" />
            </a>
          </div>
        </div>
      </section>

      <ArticleFeed allPosts={allPosts} categories={categories} />
    </div>
  );
}
