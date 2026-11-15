"use client";

import * as React from "react";
import { Command } from "cmdk";
import { useRouter } from "next/navigation";
import {
  Search,
  FileText,
  Folder,
  ArrowRight,
  CornerDownLeft,
  X,
} from "lucide-react";
import type { PostMeta, CategoryInfo } from "@/lib/posts";

interface SearchModalProps {
  posts: PostMeta[];
  categories: CategoryInfo[];
}

export default function SearchModal({ posts, categories }: SearchModalProps) {
  const [open, setOpen] = React.useState(false);
  const router = useRouter();

  React.useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "k") {
        e.preventDefault();
        setOpen((prev) => !prev);
      }
      if (e.key === "Escape") {
        setOpen(false);
      }
    };

    const handleCustomOpen = () => setOpen(true);

    window.addEventListener("keydown", handleKeyDown);
    window.addEventListener("open-cmdk-search", handleCustomOpen);
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
      window.removeEventListener("open-cmdk-search", handleCustomOpen);
    };
  }, []);

  const runCommand = React.useCallback((command: () => void) => {
    setOpen(false);
    command();
  }, []);

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center pt-[12vh] px-4">
      <div
        className="fixed inset-0 bg-black/75 backdrop-blur-sm transition-opacity"
        onClick={() => setOpen(false)}
      />

      <div className="relative z-10 w-full max-w-2xl overflow-hidden rounded-xl border border-border bg-[#181818] shadow-2xl shadow-black/80 ring-1 ring-white/5">
        <Command label="Knowledge Base Command Menu" className="w-full">
          <div className="flex items-center border-b border-border px-4">
            <Search className="mr-3 h-4 w-4 shrink-0 text-amber-500" />
            <Command.Input
              autoFocus
              placeholder="Search articles, topics, or architecture guides..."
              className="flex h-14 w-full bg-transparent text-sm text-white placeholder:text-zinc-500 focus:outline-none"
            />
            <button
              onClick={() => setOpen(false)}
              className="rounded-md p-1 text-zinc-500 hover:bg-zinc-800 hover:text-zinc-300"
              aria-label="Close search"
            >
              <X className="h-4 w-4" />
            </button>
          </div>

          <Command.List className="max-h-[380px] overflow-y-auto p-2">
            <Command.Empty className="py-12 text-center text-sm text-zinc-500">
              No matching technical guides or categories found.
            </Command.Empty>

            <Command.Group heading="Articles & Guides">
              {posts.map((post) => (
                <Command.Item
                  key={post.slug}
                  value={`${post.title} ${post.category} ${post.excerpt}`}
                  onSelect={() =>
                    runCommand(() => router.push(`/posts/${post.slug}`))
                  }
                  className="group flex cursor-pointer items-center justify-between rounded-lg border border-transparent px-3 py-2.5 text-sm text-zinc-300 transition-colors"
                >
                  <div className="flex items-center gap-3 min-w-0">
                    <FileText className="h-4 w-4 shrink-0 text-zinc-500 group-data-[selected=true]:text-amber-500" />
                    <div className="truncate">
                      <p className="truncate font-medium text-zinc-100 group-data-[selected=true]:text-amber-500">
                        {post.title}
                      </p>
                      <p className="truncate text-xs text-zinc-500">
                        {post.category} • {post.readTime}
                      </p>
                    </div>
                  </div>
                  <ArrowRight className="h-4 w-4 shrink-0 opacity-0 transition-opacity group-data-[selected=true]:opacity-100 text-amber-500" />
                </Command.Item>
              ))}
            </Command.Group>

            <Command.Separator className="my-2 h-px bg-border" />

            <Command.Group heading="Browse by Topic">
              {categories.map((cat) => (
                <Command.Item
                  key={cat.name}
                  value={`category topic ${cat.name}`}
                  onSelect={() =>
                    runCommand(() => {
                      window.dispatchEvent(
                        new CustomEvent("select-category", { detail: cat.name })
                      );
                      router.push("/#articles");
                    })
                  }
                  className="group flex cursor-pointer items-center justify-between rounded-lg border border-transparent px-3 py-2 text-sm text-zinc-300 transition-colors"
                >
                  <div className="flex items-center gap-3">
                    <Folder className="h-4 w-4 text-zinc-500 group-data-[selected=true]:text-amber-500" />
                    <span>{cat.name}</span>
                  </div>
                  <span className="rounded bg-zinc-800 px-2 py-0.5 font-mono text-xs text-zinc-400">
                    {cat.count} {cat.count === 1 ? "article" : "articles"}
                  </span>
                </Command.Item>
              ))}
            </Command.Group>
          </Command.List>

          <div className="flex items-center justify-between border-t border-border bg-[#141414] px-4 py-2.5 text-xs text-zinc-500">
            <div className="flex items-center gap-3">
              <span className="flex items-center gap-1">
                <CornerDownLeft className="h-3.5 w-3.5 text-amber-500" />
                Select
              </span>
              <span>↑↓ Navigate</span>
            </div>
            <span className="font-mono text-[11px] text-zinc-500">
              ESC to close
            </span>
          </div>
        </Command>
      </div>
    </div>
  );
}
