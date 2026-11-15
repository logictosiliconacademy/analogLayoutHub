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
