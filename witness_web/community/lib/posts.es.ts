/**
 * The Spanish edition's posts. `content/posts-es` mirrors `content/posts` file
 * for file (tools/check_notes_es.py keeps it honest) and goes through the same
 * loader. Links inside a note are written against the English edition; here
 * they are pointed at the Spanish pages and the Spanish archive instead.
 */
import { join } from "node:path";
import { loadPosts, postQueries, type Post } from "./posts";

export { sourceHost, type Post } from "./posts";

function localize(post: Post): Post {
  const html = post.html
    .replaceAll('href="/p/', 'href="/es/p/')
    .replaceAll('href="https://witnessatlas.com/archive', 'href="https://witnessatlas.com/es/archive')
    .replaceAll('href="/archive', 'href="https://witnessatlas.com/es/archive');
  return { ...post, html };
}

const POSTS = loadPosts(join(process.cwd(), "content/posts-es")).map(localize);

export const { allPosts, postBySlug, postsInSection, relatedPosts } = postQueries(POSTS);
