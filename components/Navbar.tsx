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
