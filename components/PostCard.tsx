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
