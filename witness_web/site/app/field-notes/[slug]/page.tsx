import type { Metadata, Route } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { Container, Eyebrow, PrimaryLink, TextLink } from "@/components/atlas";
import { Breadcrumbs } from "@/components/record";
import { SITE_URL, recordById } from "@/lib/archive";
import { allNotes, noteBySlug, siblingNotes, sourceHost } from "@/lib/notes";

export function generateStaticParams() {
  return allNotes().map((note) => ({ slug: note.slug }));
}

export async function generateMetadata({
  params,
}: PageProps<"/field-notes/[slug]">): Promise<Metadata> {
  const { slug } = await params;
  const note = noteBySlug(slug);
  if (!note) return { title: "Note not found" };
  return {
    title: note.title,
    description: note.description,
    alternates: { canonical: `/field-notes/${note.slug}` },
    openGraph: {
      type: "article",
      title: note.title,
      description: note.description,
      url: `${SITE_URL}/field-notes/${note.slug}`,
      publishedTime: note.date,
    },
  };
}

export default async function FieldNotePage({
  params,
}: PageProps<"/field-notes/[slug]">) {
  const { slug } = await params;
  const note = noteBySlug(slug);
  if (!note) notFound();

  const records = note.records
    .map((id) => recordById(id))
    .filter((record) => record !== undefined);
  const siblings = siblingNotes(note.slug);

  const jsonLd: Record<string, unknown>[] = [
    {
      "@context": "https://schema.org",
      "@type": "Article",
      headline: note.title,
      description: note.description,
      datePublished: note.date,
      dateModified: note.date,
      isAccessibleForFree: true,
      author: { "@type": "Organization", name: "Witness" },
      publisher: { "@type": "Organization", name: "Witness" },
      citation: note.sources,
      url: `${SITE_URL}/field-notes/${note.slug}`,
    },
  ];
  if (note.question) {
    jsonLd.push({
      "@context": "https://schema.org",
      "@type": "FAQPage",
      mainEntity: [
        {
          "@type": "Question",
          name: note.question,
          acceptedAnswer: { "@type": "Answer", text: note.answer },
        },
      ],
    });
  }

  return (
    <>
      {jsonLd.map((schema, i) => (
        <script
          key={i}
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }}
        />
      ))}

      {/* Opening ------------------------------------------------------- */}
      <section className="border-b border-hairline/50 py-10 md:py-14">
        <Container>
          <Breadcrumbs
            trail={[
              { href: "/", label: "Witness" },
              { href: "/field-notes", label: "Field notes" },
              { label: note.title },
            ]}
          />
          <div className="mt-10 grid gap-8 md:grid-cols-12">
            <div className="md:col-span-8">
              <Eyebrow className="text-sepia">
                <span translate="no">{note.date}</span>
              </Eyebrow>
              <h1 className="mt-6 max-w-[20ch] text-balance font-display text-[clamp(2.1rem,5vw,3.6rem)] font-semibold leading-[1.04] tracking-[-0.02em] text-ink">
                {note.title}
              </h1>
            </div>
            <p className="max-w-[46ch] text-pretty text-[16px] leading-[1.7] text-ink-muted md:col-span-4 md:pt-6">
              {note.description}
            </p>
          </div>
        </Container>
      </section>

      {/* The note ------------------------------------------------------ */}
      <section className="py-12 md:py-16">
        <Container>
          <div
            className="note-prose"
            dangerouslySetInnerHTML={{ __html: note.html }}
          />
        </Container>
      </section>

      {/* Sources ------------------------------------------------------- */}
      {note.sources.length > 0 ? (
        <section className="border-t border-hairline/50 bg-paper-fresh py-14 md:py-16">
          <Container>
            <h2 className="font-display text-2xl font-semibold text-ink">Sources</h2>
            <p className="mt-3 max-w-[58ch] text-[15px] leading-[1.65] text-ink-muted">
              Read the same pages this note was written from. A citation is not a
              partnership or an endorsement.
            </p>
            <ol className="mt-8 max-w-[70ch] border-t border-hairline/50">
              {note.sources.map((url, i) => (
                <li
                  key={url}
                  className="grid grid-cols-[2rem_1fr] gap-4 border-b border-hairline/40 py-5"
                >
                  <span aria-hidden="true" className="font-display text-lg text-sepia">
                    {i + 1}
                  </span>
                  <div>
                    <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-sepia">
                      {sourceHost(url)}
                    </p>
                    <TextLink href={url} external>
                      Open source&nbsp;↗
                    </TextLink>
                  </div>
                </li>
              ))}
            </ol>
          </Container>
        </section>
      ) : null}

      {/* Where to go next ---------------------------------------------- */}
      <section className="border-t border-hairline/50 py-14 md:py-20">
        <Container>
          <div className="grid gap-12 md:grid-cols-12">
            {records.length > 0 ? (
              <div className="md:col-span-5">
                <h2 className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">
                  Records mentioned
                </h2>
                <ul className="mt-6">
                  {records.map((record) => (
                    <li key={record.id} className="border-t border-hairline/40 py-4">
                      <Link
                        href={`/witnesses/${record.id}` as Route}
                        className="group block"
                      >
                        <p className="font-display text-xl font-semibold text-ink transition-colors duration-200 ease-out group-hover:text-sepia">
                          {record.commonName}
                        </p>
                        <p className="mt-1 text-[15px] leading-[1.6] text-ink-muted">
                          {record.conservationStatus.displayName} ·{" "}
                          {record.generalizedRange}
                        </p>
                      </Link>
                    </li>
                  ))}
                </ul>
              </div>
            ) : null}

            {siblings.length > 0 ? (
              <div className="md:col-span-5 md:col-start-8">
                <h2 className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">
                  More notes
                </h2>
                <ul className="mt-6">
                  {siblings.map((sibling) => (
                    <li key={sibling.slug} className="border-t border-hairline/40 py-4">
                      <Link
                        href={`/field-notes/${sibling.slug}` as Route}
                        className="group block"
                      >
                        <p className="max-w-[34ch] text-pretty font-display text-xl font-semibold text-ink transition-colors duration-200 ease-out group-hover:text-sepia">
                          {sibling.title}
                        </p>
                        <p className="mt-1 text-[13px] uppercase tracking-[0.14em] text-ink-muted">
                          <span translate="no">{sibling.date}</span>
                        </p>
                      </Link>
                    </li>
                  ))}
                </ul>
              </div>
            ) : null}
          </div>

          <div className="mt-14 flex flex-wrap items-center gap-x-8 gap-y-4">
            <PrimaryLink href="/witnesses">Browse the archive</PrimaryLink>
            <TextLink href="/method">How a claim earns its place</TextLink>
          </div>
        </Container>
      </section>
    </>
  );
}
