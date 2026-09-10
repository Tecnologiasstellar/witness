import type { Metadata, Route } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { PostCard, SectionChip, SubscribeBand } from "@/components/cards";
import { Container } from "@/components/shell";
import { allPosts, postBySlug, relatedPosts, sourceHost } from "@/lib/posts";
import { ATLAS_URL, PUB_NAME, SITE_URL, formatDate, plateUrl, sectionByKey } from "@/lib/site";
import { recordById } from "@/lib/species";

export function generateStaticParams() {
  return allPosts().map((post) => ({ slug: post.slug }));
}

export async function generateMetadata({ params }: PageProps<"/p/[slug]">): Promise<Metadata> {
  const { slug } = await params;
  const post = postBySlug(slug);
  if (!post) return { title: "Not found" };
  const image = plateUrl(post.image);
  return {
    title: post.title,
    description: post.description,
    alternates: { canonical: `/p/${post.slug}` },
    openGraph: {
      type: "article",
      title: post.title,
      description: post.description,
      url: `${SITE_URL}/p/${post.slug}`,
      publishedTime: post.date,
      images: [{ url: image, width: 1400, height: 939 }],
    },
    twitter: { card: "summary_large_image", title: post.title, description: post.description, images: [image] },
  };
}

export default async function PostPage({ params }: PageProps<"/p/[slug]">) {
  const { slug } = await params;
  const post = postBySlug(slug);
  if (!post) notFound();

  const section = sectionByKey(post.section);
  const records = post.records.map((id) => recordById(id)).filter((r) => r !== undefined);
  const related = relatedPosts(post);

  const jsonLd: Record<string, unknown>[] = [
    {
      "@context": "https://schema.org",
      "@type": "Article",
      headline: post.title,
      description: post.description,
      image: plateUrl(post.image),
      datePublished: post.date,
      dateModified: post.date,
      isAccessibleForFree: true,
      articleSection: section?.name,
      author: post.author
        ? { "@type": "Person", name: post.author, ...(post.authorUrl ? { url: post.authorUrl } : {}) }
        : { "@type": "Organization", name: "Witness" },
      publisher: { "@type": "Organization", name: PUB_NAME, url: SITE_URL },
      citation: post.sources,
      url: `${SITE_URL}/p/${post.slug}`,
    },
  ];
  if (post.question) {
    jsonLd.push({
      "@context": "https://schema.org",
      "@type": "FAQPage",
      mainEntity: [{ "@type": "Question", name: post.question, acceptedAnswer: { "@type": "Answer", text: post.answer } }],
    });
  }

  return (
    <>
      {jsonLd.map((schema, i) => (
        <script key={i} type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }} />
      ))}

      {/* Opening ------------------------------------------------------- */}
      <section className="pt-8 md:pt-12">
        <Container>
          <div className="mx-auto max-w-[900px]">
            <SectionChip post={post} />
            <h1 className="mt-3 text-balance font-display text-[clamp(2rem,5vw,3.4rem)] font-extrabold leading-[1.05] tracking-[-0.03em] text-ink">
              {post.title}
            </h1>
            <p className="mt-4 max-w-[60ch] text-pretty text-[19px] leading-[1.5] text-muted">{post.description}</p>
            <div className="mt-5 flex flex-wrap items-center justify-between gap-4 border-y border-line py-3">
              <p className="flex flex-wrap items-center gap-x-2 text-[14px] text-muted">
                <span className="font-semibold text-ink">
                  {post.authorUrl ? (
                    <a href={post.authorUrl} target="_blank" rel="noreferrer noopener" className="hover:text-accent">
                      {post.author}
                    </a>
                  ) : (
                    (post.author ?? "Witness")
                  )}
                </span>
                <span aria-hidden="true">·</span>
                <time dateTime={post.date}>{formatDate(post.date)}</time>
                <span aria-hidden="true">·</span>
                <span>{post.minutes} min read</span>
              </p>
              <a
                href={`https://twitter.com/intent/tweet?url=${encodeURIComponent(`${SITE_URL}/p/${post.slug}`)}&text=${encodeURIComponent(post.title)}`}
                target="_blank"
                rel="noreferrer noopener"
                className="text-[13px] font-semibold text-accent hover:text-ink"
              >
                Share&nbsp;↗
              </a>
            </div>
            <figure className="mt-6">
              <img src={plateUrl(post.image)} alt="" width={1400} height={933} className="plate" fetchPriority="high" />
              <figcaption className="mt-2 text-[12px] uppercase tracking-[0.12em] text-muted">
                Original illustration drawn for Witness
              </figcaption>
            </figure>
          </div>
        </Container>
      </section>

      {/* The piece ----------------------------------------------------- */}
      <section className="py-10 md:py-14">
        <Container>
          <div className="mx-auto max-w-[900px]">
            <div className="prose" dangerouslySetInnerHTML={{ __html: post.html }} />
          </div>
        </Container>
      </section>

      {/* Sources ------------------------------------------------------- */}
      {post.sources.length > 0 ? (
        <section className="border-t border-line bg-surface py-12">
          <Container>
            <div className="mx-auto max-w-[900px]">
              <h2 className="font-display text-[13px] font-extrabold uppercase tracking-[0.16em] text-ink">Sources</h2>
              <p className="mt-2 max-w-[58ch] text-[14px] leading-[1.6] text-muted">
                Read the same pages this note was written from. A citation is not a partnership or an endorsement.
              </p>
              <ol className="mt-5 divide-y divide-line border-y border-line">
                {post.sources.map((url, i) => (
                  <li key={url} className="grid grid-cols-[2rem_1fr] gap-3 py-3">
                    <span aria-hidden="true" className="text-[14px] font-bold text-accent">
                      {i + 1}
                    </span>
                    <a href={url} target="_blank" rel="noreferrer noopener" className="min-w-0 truncate text-[15px] text-ink hover:text-accent">
                      <span className="font-semibold">{sourceHost(url)}</span>
                      <span className="text-muted"> · {url}</span>
                    </a>
                  </li>
                ))}
              </ol>
            </div>
          </Container>
        </section>
      ) : null}

      {/* Records mentioned --------------------------------------------- */}
      {records.length > 0 ? (
        <section className="py-12">
          <Container>
            <div className="mx-auto max-w-[900px]">
              <h2 className="font-display text-[13px] font-extrabold uppercase tracking-[0.16em] text-ink">Records mentioned</h2>
              <ul className="mt-5 grid gap-5 sm:grid-cols-2">
                {records.map((record) => (
                  <li key={record.id}>
                    <a href={`${ATLAS_URL}/archive/${record.id}`} className="group grid grid-cols-[96px_1fr] items-center gap-4">
                      <img src={plateUrl(record.gallery[0])} alt="" width={300} height={200} loading="lazy" className="plate" />
                      <span>
                        <span className="block text-[17px] font-bold leading-tight text-ink transition-colors group-hover:text-accent">
                          {record.commonName}
                        </span>
                        <span className="mt-1 block text-[13px] text-muted">
                          {record.conservationStatus.displayName} · {record.generalizedRange}
                        </span>
                        <span className="mt-1 block text-[12px] font-semibold text-accent">Full record on witnessatlas.com ↗</span>
                      </span>
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          </Container>
        </section>
      ) : null}

      <Container>
        <SubscribeBand compact />
      </Container>

      {/* Related ------------------------------------------------------- */}
      {related.length > 0 ? (
        <section className="py-12 md:py-14">
          <Container>
            <div className="flex items-end justify-between border-b-2 border-ink pb-3">
              <h2 className="font-display text-[13px] font-extrabold uppercase tracking-[0.16em] text-ink">
                {section ? `More in ${section.name}` : "More notes"}
              </h2>
              {section ? (
                <Link href={`/s/${section.key}` as Route} className="text-[13px] font-semibold text-accent hover:text-ink">
                  View all&nbsp;→
                </Link>
              ) : null}
            </div>
            <div className="mt-6 grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
              {related.map((p) => (
                <PostCard key={p.slug} post={p} dek={false} />
              ))}
            </div>
          </Container>
        </section>
      ) : null}
    </>
  );
}
