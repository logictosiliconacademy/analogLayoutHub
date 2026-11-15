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
