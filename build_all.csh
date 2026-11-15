#!/bin/tcsh

# Prevent C Shell from throwing globbing errors on '[slug]' or '@/*'
set nonomatch

echo "==> Creating directory structure..."
mkdir -p app "app/posts/[slug]" components lib content/posts .github/workflows

echo "==> 1/17: Writing package.json..."
cat << 'EOF' > package.json
{
  "name": "analoghub-kb",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "cmdk": "^1.0.0",
    "date-fns": "^3.6.0",
    "gray-matter": "^4.0.3",
    "lucide-react": "^0.400.0",
    "next": "14.2.5",
    "next-mdx-remote": "^5.0.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@tailwindcss/typography": "^0.5.13",
    "@types/node": "^20.14.0",
    "@types/react": "^18.3.3",
    "@types/react-dom": "^18.3.0",
    "autoprefixer": "^10.4.19",
    "postcss": "^8.4.38",
    "tailwindcss": "^3.4.4",
    "typescript": "^5.5.2"
  }
}
EOF

echo "==> 2/17: Writing tsconfig.json..."
cat << 'EOF' > tsconfig.json
{
  "compilerOptions": {
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": { "@/*": ["./*"] }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

echo "==> 3/17: Writing postcss.config.mjs..."
cat << 'EOF' > postcss.config.mjs
/** @type {import('postcss-load-config').Config} */
const config = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};

export default config;
EOF

echo "==> 4/17: Writing next.config.mjs..."
cat << 'EOF' > next.config.mjs
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "export",
  images: {
    unoptimized: true,
  },
  basePath: "/analoghub-kb",
};

export default nextConfig;
EOF

echo "==> 5/17: Writing tailwind.config.ts..."
cat << 'EOF' > tailwind.config.ts
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
EOF

echo "==> 6/17: Writing app/globals.css..."
cat << 'EOF' > app/globals.css
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  color-scheme: dark;
}

html {
  scroll-behavior: smooth;
}

body {
  background-color: #121212;
  color: #f4f4f5;
  font-feature-settings: "cv02", "cv03", "cv04", "cv11";
}

::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #121212;
}

::-webkit-scrollbar-thumb {
  background: #262626;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #3f3f46;
}

[cmdk-item][data-selected="true"] {
  background-color: rgba(245, 158, 11, 0.12);
  color: #f59e0b;
  border-color: rgba(245, 158, 11, 0.3);
}

[cmdk-group-heading] {
  padding: 0.5rem 0.75rem;
  font-family: var(--font-mono), monospace;
  font-size: 0.7rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #71717a;
}
EOF

echo "==> 7/17: Writing lib/posts.ts..."
cat << 'EOF' > lib/posts.ts
import fs from "fs";
import path from "path";
import matter from "gray-matter";

export interface PostMeta {
  slug: string;
  title: string;
  date: string;
  category: string;
  excerpt: string;
  author: string;
  readTime: string;
}

export interface Post extends PostMeta {
  content: string;
}

export interface CategoryInfo {
  name: string;
  count: number;
  description: string;
}

const postsDirectory = path.join(process.cwd(), "content/posts");

const CATEGORY_DESCRIPTIONS: Record<string, string> = {
  "Systems Architecture": "High-availability patterns, consensus protocols, and distributed systems.",
  "Backend Engineering": "Low-latency APIs, database internals, and concurrency primitives.",
  "DevOps & Infra": "Kubernetes orchestration, eBPF observability, and bare-metal performance.",
  "Frontend & UI": "React Server Components, rendering pipelines, and design systems.",
  "Security": "Zero-trust networks, cryptography fundamentals, and memory safety.",
};

function calculateReadTime(content: string): string {
  const wordsPerMinute = 220;
  const wordCount = content.trim().split(/\s+/).length;
  const minutes = Math.max(1, Math.ceil(wordCount / wordsPerMinute));
  return `${minutes} min read`;
}

export function getAllPosts(): Post[] {
  if (!fs.existsSync(postsDirectory)) return [];

  const fileNames = fs
    .readdirSync(postsDirectory)
    .filter((file) => file.endsWith(".mdx") || file.endsWith(".md"));

  const allPostsData = fileNames.map((fileName) => {
    const slug = fileName.replace(/\.mdx?$/, "");
    const fullPath = path.join(postsDirectory, fileName);
    const fileContents = fs.readFileSync(fullPath, "utf8");
    const { data, content } = matter(fileContents);

    return {
      slug: data.slug || slug,
      title: data.title || "Untitled Technical Guide",
      date: data.date ? String(data.date) : "2026-11-15",
      category: data.category || "Systems Architecture",
      excerpt: data.excerpt || "",
      author: data.author || "Core Engineering Team",
      readTime: data.readTime || calculateReadTime(content),
      content,
    } as Post;
  });

  return allPostsData.sort((a, b) =>
    new Date(a.date).getTime() < new Date(b.date).getTime() ? 1 : -1
  );
}

export function getAllPostsMeta(): PostMeta[] {
  return getAllPosts().map(({ content, ...meta }) => meta);
}

export function getPostBySlug(slug: string): Post | undefined {
  return getAllPosts().find((post) => post.slug === slug);
}

export function getCategoriesWithCounts(): CategoryInfo[] {
  const posts = getAllPostsMeta();
  const counts: Record<string, number> = {};

  posts.forEach((post) => {
    counts[post.category] = (counts[post.category] || 0) + 1;
  });

  return Object.entries(counts)
    .map(([name, count]) => ({
      name,
      count,
      description:
        CATEGORY_DESCRIPTIONS[name] ||
        "In-depth technical documentation, benchmarks, and architectural deep dives.",
    }))
    .sort((a, b) => b.count - a.count);
}
EOF

echo "==> 8/17: Writing components/Navbar.tsx..."
cat << 'EOF' > components/Navbar.tsx
"use client";

import Link from "next/link";
import { Terminal, Search, Layers, BookOpen } from "lucide-react";

export default function Navbar() {
  const triggerSearch = () => {
    window.dispatchEvent(new Event("open-cmdk-search"));
  };

  return (
    <header className="sticky top-0 z-40 border-b border-border bg-[#121212]/85 backdrop-blur-md">
      <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-4 sm:px-6 lg:px-8">
        <Link
          href="/"
          className="group flex items-center gap-2.5 text-lg font-bold tracking-tight text-white"
        >
          <div className="flex h-8 w-8 items-center justify-center rounded-lg border border-amber-500/30 bg-amber-500/10 text-amber-500 transition-colors group-hover:bg-amber-500 group-hover:text-black">
            <Terminal className="h-4 w-4" />
          </div>
          <span>
            ANALOG<span className="font-light text-amber-500">HUB</span>
          </span>
        </Link>

        <nav className="hidden md:flex items-center gap-8 text-sm font-medium text-zinc-400">
          <Link
            href="/#topics"
            className="flex items-center gap-1.5 transition-colors hover:text-amber-500"
          >
            <Layers className="h-3.5 w-3.5" />
            <span>Topics</span>
          </Link>
          <Link
            href="/#articles"
            className="flex items-center gap-1.5 transition-colors hover:text-amber-500"
          >
            <BookOpen className="h-3.5 w-3.5" />
            <span>Articles</span>
          </Link>
          <Link
            href="/#about"
            className="transition-colors hover:text-amber-500"
          >
            About
          </Link>
        </nav>

        <button
          onClick={triggerSearch}
          type="button"
          className="group flex items-center gap-3 rounded-lg border border-border bg-[#181818] px-3.5 py-1.5 text-xs text-zinc-400 transition-all hover:border-amber-500/50 hover:text-zinc-200"
        >
          <Search className="h-3.5 w-3.5 text-amber-500" />
          <span className="hidden sm:inline">Search documentation...</span>
          <span className="sm:hidden">Search</span>
          <kbd className="rounded border border-zinc-700 bg-[#121212] px-1.5 py-0.5 font-mono text-[10px] font-medium text-zinc-400 group-hover:border-amber-500/40 group-hover:text-amber-500">
            Ctrl K
          </kbd>
        </button>
      </div>
    </header>
  );
}
EOF

echo "==> 9/17: Writing components/PostCard.tsx..."
cat << 'EOF' > components/PostCard.tsx
import Link from "next/link";
import { format, parseISO } from "date-fns";
import { ArrowUpRight, Calendar, Clock } from "lucide-react";
import type { PostMeta } from "@/lib/posts";

export default function PostCard({ post }: { post: PostMeta }) {
  let formattedDate = post.date;
  try {
    formattedDate = format(parseISO(post.date), "MMM dd, yyyy");
  } catch {
    formattedDate = post.date;
  }

  return (
    <article className="group relative flex flex-col justify-between rounded-xl border border-border bg-[#181818] p-6 transition-all duration-300 hover:-translate-y-1 hover:border-amber-500/50 hover:bg-[#1c1c1c] hover:shadow-xl hover:shadow-black/60">
      <div>
        <div className="flex items-center justify-between gap-2">
          <span className="inline-flex items-center rounded-md border border-amber-500/25 bg-amber-500/10 px-2.5 py-0.5 font-mono text-[11px] font-medium uppercase tracking-wider text-amber-500">
            {post.category}
          </span>
          <span className="flex items-center gap-1 font-mono text-xs text-zinc-500">
            <Clock className="h-3 w-3" />
            {post.readTime}
          </span>
        </div>

        <Link href={`/posts/${post.slug}`} className="mt-4 block">
          <h3 className="text-lg font-semibold leading-snug text-zinc-100 transition-colors group-hover:text-amber-500">
            {post.title}
          </h3>
        </Link>

        <p className="mt-2.5 text-sm leading-relaxed text-zinc-400 line-clamp-3">
          {post.excerpt}
        </p>
      </div>

      <div className="mt-6 flex items-center justify-between border-t border-border/80 pt-4 text-xs text-zinc-500">
        <div className="flex items-center gap-1.5 font-mono">
          <Calendar className="h-3.5 w-3.5 text-zinc-500" />
          <time dateTime={post.date}>{formattedDate}</time>
        </div>

        <Link
          href={`/posts/${post.slug}`}
          className="inline-flex items-center gap-1 font-mono text-xs font-semibold uppercase tracking-wider text-zinc-300 transition-colors group-hover:text-amber-500"
        >
          Read Guide
          <ArrowUpRight className="h-3.5 w-3.5 transition-transform group-hover:translate-x-0.5 group-hover:-translate-y-0.5" />
        </Link>
      </div>
    </article>
  );
}
EOF

echo "==> 10/17: Writing components/SearchModal.tsx..."
cat << 'EOF' > components/SearchModal.tsx
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
EOF

echo "==> 11/17: Writing components/ArticleFeed.tsx..."
cat << 'EOF' > components/ArticleFeed.tsx
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
EOF

echo "==> 12/17: Writing app/layout.tsx..."
cat << 'EOF' > app/layout.tsx
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
EOF

echo "==> 13/17: Writing app/page.tsx..."
cat << 'EOF' > app/page.tsx
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
EOF

echo "==> 14/17: Writing app/posts/[slug]/page.tsx..."
cat << 'EOF' > "app/posts/[slug]/page.tsx"
import { notFound } from "next/navigation";
import Link from "next/link";
import { format, parseISO } from "date-fns";
import { MDXRemote } from "next-mdx-remote/rsc";
import {
  ChevronRight,
  Calendar,
  Clock,
  User,
  ArrowLeft,
  Terminal,
} from "lucide-react";
import { getAllPosts, getPostBySlug } from "@/lib/posts";

export async function generateStaticParams() {
  const posts = getAllPosts();
  return posts.map((post) => ({
    slug: post.slug,
  }));
}

const mdxComponents = {
  h2: (props: React.HTMLAttributes<HTMLHeadingElement>) => (
    <h2
      className="mt-12 mb-4 scroll-mt-24 border-b border-border pb-2 text-2xl font-bold tracking-tight text-white"
      {...props}
    />
  ),
  h3: (props: React.HTMLAttributes<HTMLHeadingElement>) => (
    <h3
      className="mt-8 mb-3 scroll-mt-24 text-xl font-semibold text-zinc-100"
      {...props}
    />
  ),
  pre: (props: React.HTMLAttributes<HTMLPreElement>) => (
    <div className="my-6 overflow-hidden rounded-xl border border-border bg-[#181818]">
      <div className="flex items-center justify-between border-b border-border bg-[#141414] px-4 py-2">
        <div className="flex items-center gap-2">
          <Terminal className="h-3.5 w-3.5 text-amber-500" />
          <span className="font-mono text-[11px] uppercase tracking-wider text-zinc-400">
            Code Snippet
          </span>
        </div>
        <div className="flex gap-1.5">
          <span className="h-2.5 w-2.5 rounded-full bg-zinc-700" />
          <span className="h-2.5 w-2.5 rounded-full bg-zinc-700" />
          <span className="h-2.5 w-2.5 rounded-full bg-amber-500/60" />
        </div>
      </div>
      <pre
        className="overflow-x-auto p-4 font-mono text-sm leading-relaxed text-zinc-200"
        {...props}
      />
    </div>
  ),
  table: (props: React.TableHTMLAttributes<HTMLTableElement>) => (
    <div className="my-8 overflow-x-auto rounded-xl border border-border bg-[#181818]">
      <table className="w-full border-collapse text-left text-sm" {...props} />
    </div>
  ),
  th: (props: React.ThHTMLAttributes<HTMLTableCellElement>) => (
    <th
      className="border-b border-border bg-[#141414] px-4 py-3 font-mono text-xs uppercase tracking-wider text-amber-500"
      {...props}
    />
  ),
  td: (props: React.TdHTMLAttributes<HTMLTableCellElement>) => (
    <td
      className="border-b border-border/60 px-4 py-3 text-zinc-300"
      {...props}
    />
  ),
  blockquote: (props: React.BlockquoteHTMLAttributes<HTMLQuoteElement>) => (
    <blockquote
      className="my-6 rounded-r-xl border-l-4 border-amber-500 bg-[#181818] px-5 py-4 italic text-zinc-300"
      {...props}
    />
  ),
};

export default function PostDetailPage({
  params,
}: {
  params: { slug: string };
}) {
  const post = getPostBySlug(params.slug);

  if (!post) {
    notFound();
  }

  let formattedDate = post.date;
  try {
    formattedDate = format(parseISO(post.date), "MMMM dd, yyyy");
  } catch {
    formattedDate = post.date;
  }

  return (
    <article className="mx-auto max-w-3xl py-10">
      <nav
        aria-label="Breadcrumb"
        className="flex flex-wrap items-center gap-2 font-mono text-xs text-zinc-400"
      >
        <Link href="/" className="transition hover:text-amber-500">
          Home
        </Link>
        <ChevronRight className="h-3.5 w-3.5 text-zinc-600" />
        <Link
          href={`/?category=${encodeURIComponent(post.category)}#articles`}
          className="text-amber-500 transition hover:underline"
        >
          {post.category}
        </Link>
        <ChevronRight className="h-3.5 w-3.5 text-zinc-600" />
        <span className="truncate max-w-[220px] sm:max-w-xs text-zinc-500">
          {post.slug}
        </span>
      </nav>

      <header className="mt-6 rounded-2xl border border-border bg-[#181818] p-6 sm:p-10">
        <div className="inline-flex items-center rounded-md border border-amber-500/30 bg-amber-500/10 px-2.5 py-1 font-mono text-xs font-medium uppercase tracking-wider text-amber-500">
          {post.category}
        </div>

        <h1 className="mt-4 text-3xl font-extrabold tracking-tight text-white sm:text-4xl leading-tight">
          {post.title}
        </h1>

        <p className="mt-4 text-base sm:text-lg text-zinc-400 leading-relaxed">
          {post.excerpt}
        </p>

        <div className="mt-8 flex flex-wrap items-center gap-6 border-t border-border pt-5 font-mono text-xs text-zinc-400">
          <div className="flex items-center gap-2">
            <User className="h-4 w-4 text-amber-500" />
            <span>{post.author}</span>
          </div>
          <div className="flex items-center gap-2">
            <Calendar className="h-4 w-4 text-amber-500" />
            <time dateTime={post.date}>{formattedDate}</time>
          </div>
          <div className="flex items-center gap-2">
            <Clock className="h-4 w-4 text-amber-500" />
            <span>{post.readTime}</span>
          </div>
        </div>
      </header>

      <div className="prose prose-invert prose-zinc mt-10 max-w-none">
        <MDXRemote source={post.content} components={mdxComponents} />
      </div>

      <div className="mt-16 border-t border-border pt-8">
        <Link
          href="/#articles"
          className="inline-flex items-center gap-2 rounded-lg border border-border bg-[#181818] px-4 py-2.5 font-mono text-xs uppercase tracking-wider text-zinc-300 transition hover:border-amber-500/50 hover:text-amber-500"
        >
          <ArrowLeft className="h-4 w-4" />
          Back to All Articles
        </Link>
      </div>
    </article>
  );
}
EOF

echo "==> 15/17: Writing content/posts/building-distributed-rate-limiters.mdx..."
cat << 'EOF' > content/posts/building-distributed-rate-limiters.mdx
---
title: "Designing Distributed Rate Limiters with Redis & Token Buckets"
date: "2026-11-10"
category: "Systems Architecture"
excerpt: "How to prevent race conditions and atomic drift when enforcing sub-millisecond rate limits across multi-region edge nodes."
author: "Arjun Mehta"
slug: "building-distributed-rate-limiters"
---

When scaling an API gateway across multiple availability zones, local in-memory rate limiters quickly lose accuracy. If a tenant is allocated **1,000 requests per second (RPS)** and traffic routes across 20 stateless edge proxies, naive local counters either over-admit traffic or require sticky routing.

## Comparing Rate Limiting Algorithms

| Algorithm | Memory Overhead | Burst Handling | Precision |
| :--- | :--- | :--- | :--- |
| **Fixed Window Counter** | O(1) per key | Poor (2x boundary spike) | Moderate |
| **Sliding Window Log** | O(N) timestamps | Exact | High |
| **Token Bucket (Lua)** | O(1) (2 fields) | Controlled burst | Exact |

## Atomic Token Bucket Implementation in Redis

Standard `GET` followed by `SET` operations introduce a Read-Modify-Write race condition under high concurrency. Solve this by embedding token replenishment inside an atomic Redis Lua script:

```lua
local data = redis.call("HMGET", KEYS[1], "tokens", "last_refill")
local tokens = tonumber(data[1])
local last_refill = tonumber(data[2])
-- Atomic replenishment evaluation
