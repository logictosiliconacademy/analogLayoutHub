"use client";

import { useState, useEffect } from "react";
import {
  Cpu,
  Server,
  Shield,
  Terminal,
  Code2,
  Sparkles,
  Layers,
  XCircle,
} from "lucide-react";
import type { PostMeta, CategoryInfo } from "@/lib/posts";
import PostCard from "@/components/PostCard";

function getCategoryIcon(categoryName: string) {
  const normalized = categoryName.toLowerCase();
  if (normalized.includes("system") || normalized.includes("arch"))
    return <Cpu className="h-5 w-5 text-amber-500" />;
  if (normalized.includes("backend") || normalized.includes("data"))
    return <Server className="h-5 w-5 text-amber-500" />;
  if (normalized.includes("sec"))
    return <Shield className="h-5 w-5 text-amber-500" />;
  if (normalized.includes("front") || normalized.includes("ui"))
    return <Code2 className="h-5 w-5 text-amber-500" />;
  if (normalized.includes("ai") || normalized.includes("ml"))
    return <Sparkles className="h-5 w-5 text-amber-500" />;
  return <Terminal className="h-5 w-5 text-amber-500" />;
}

export default function ArticleFeed({
  allPosts,
  categories,
}: {
  allPosts: PostMeta[];
  categories: CategoryInfo[];
}) {
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const cat = params.get("category");
    if (cat) setSelectedCategory(cat);

    const handleCustomCategory = (e: Event) => {
      const customEvent = e as CustomEvent<string>;
      setSelectedCategory(customEvent.detail);
    };

    window.addEventListener("select-category", handleCustomCategory);
    return () =>
      window.removeEventListener("select-category", handleCustomCategory);
  }, []);

  const displayedPosts = selectedCategory
    ? allPosts.filter(
        (post) => post.category.toLowerCase() === selectedCategory.toLowerCase()
      )
    : allPosts;

  return (
    <>
      <section id="topics" className="scroll-mt-24">
        <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 border-b border-border pb-4">
          <div>
            <div className="flex items-center gap-2 font-mono text-xs uppercase tracking-widest text-amber-500">
              <Layers className="h-4 w-4" />
              <span>Taxonomy</span>
            </div>
            <h2 className="mt-1 text-2xl font-bold tracking-tight text-white">
              Browse by Topic
            </h2>
          </div>
          <p className="font-mono text-xs text-zinc-500">
            Select a domain to filter technical articles
          </p>
        </div>

        <div className="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {categories.map((cat) => {
            const isSelected =
              selectedCategory?.toLowerCase() === cat.name.toLowerCase();

            return (
              <button
                key={cat.name}
                type="button"
                onClick={() =>
                  setSelectedCategory(isSelected ? null : cat.name)
                }
                className={`group flex flex-col justify-between rounded-xl border p-5 text-left transition-all duration-200 ${
                  isSelected
                    ? "border-amber-500 bg-amber-500/10"
                    : "border-border bg-[#181818] hover:border-amber-500/50 hover:bg-[#1e1e1e]"
                }`}
              >
                <div>
                  <div className="flex items-center justify-between">
                    <div className="flex h-10 w-10 items-center justify-center rounded-lg border border-border bg-[#121212] group-hover:border-amber-500/30">
                      {getCategoryIcon(cat.name)}
                    </div>
                    <span className="rounded-full border border-border bg-[#121212] px-2.5 py-0.5 font-mono text-xs text-zinc-400 group-hover:border-amber-500/30 group-hover:text-amber-500">
                      {cat.count} {cat.count === 1 ? "article" : "articles"}
                    </span>
                  </div>

                  <h3 className="mt-4 text-base font-semibold text-white group-hover:text-amber-500">
                    {cat.name}
                  </h3>
                  <p className="mt-1.5 text-xs leading-relaxed text-zinc-400">
                    {cat.description}
                  </p>
                </div>
              </button>
            );
          })}
        </div>
      </section>

      <section id="articles" className="scroll-mt-24">
        <div className="flex flex-wrap items-center justify-between gap-4 border-b border-border pb-4">
          <div>
            <span className="font-mono text-xs uppercase tracking-widest text-amber-500">
              Knowledge Feed
            </span>
            <h2 className="mt-1 text-2xl font-bold tracking-tight text-white">
              {selectedCategory
                ? `Topic: ${selectedCategory}`
                : "Recent Articles"}
            </h2>
          </div>

          {selectedCategory && (
            <button
              type="button"
              onClick={() => setSelectedCategory(null)}
              className="inline-flex items-center gap-1.5 rounded-lg border border-amber-500/30 bg-amber-500/10 px-3 py-1.5 font-mono text-xs text-amber-500 transition hover:bg-amber-500 hover:text-black"
            >
              <XCircle className="h-3.5 w-3.5" />
              Clear Filter
            </button>
          )}
        </div>

        <div className="mt-8 grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
          {displayedPosts.map((post) => (
            <PostCard key={post.slug} post={post} />
          ))}
        </div>
      </section>
    </>
  );
}
