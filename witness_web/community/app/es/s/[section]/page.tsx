import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { PostCard, SubscribeBand } from "@/components/cards.es";
import { Container } from "@/components/shell.es";
import { postsInSection } from "@/lib/posts.es";
import { SECTIONS, sectionByKey } from "@/lib/site.es";

export function generateStaticParams() {
  return SECTIONS.map((s) => ({ section: s.key }));
}

export async function generateMetadata({ params }: PageProps<"/es/s/[section]">): Promise<Metadata> {
  const { section } = await params;
  const s = sectionByKey(section);
  if (!s) return { title: "No encontrada" };
  return {
    title: s.name,
    description: s.blurb,
    alternates: { canonical: `/es/s/${s.key}`, languages: { en: `/s/${s.key}`, es: `/es/s/${s.key}` } },
  };
}

export default async function SectionPage({ params }: PageProps<"/es/s/[section]">) {
  const { section } = await params;
  const s = sectionByKey(section);
  if (!s) notFound();
  const posts = postsInSection(s.key);

  return (
    <>
      <section className="border-b border-line py-10 md:py-14">
        <Container>
          <p className="text-[11px] font-bold uppercase tracking-[0.16em] text-accent">Sección</p>
          <h1 className="mt-2 font-display text-[clamp(2rem,5vw,3.4rem)] font-extrabold leading-[1.05] tracking-[-0.03em] text-ink">
            {s.name}
          </h1>
          <p className="mt-3 max-w-[56ch] text-pretty text-[18px] leading-[1.55] text-muted">{s.blurb}</p>
        </Container>
      </section>
      <section className="py-10 md:py-12">
        <Container>
          {posts.length === 0 ? (
            <div className="max-w-[56ch]">
              <p className="text-[18px] leading-[1.6] text-ink">La primera pieza de esta sección se está escribiendo.</p>
            </div>
          ) : (
            <div className="grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
              {posts.map((post) => (
                <PostCard key={post.slug} post={post} />
              ))}
            </div>
          )}
        </Container>
      </section>
      <Container>
        <SubscribeBand compact />
      </Container>
    </>
  );
}
