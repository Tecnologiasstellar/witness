import type { Metadata, Route } from "next";
import Link from "next/link";
import { Container, Eyebrow, PrimaryLink } from "@/components/atlas";
import { Breadcrumbs } from "@/components/record";
import { allNotes } from "@/lib/notes";

export const metadata: Metadata = {
  title: "Field notes",
  description:
    "Sourced short essays on threatened species, extinction language, and what attention is actually for. One note at a time, each with its evidence attached.",
  alternates: { canonical: "/field-notes" },
};

export default function FieldNotesIndex() {
  const notes = allNotes();

  return (
    <>
      <section className="border-b border-hairline/50 py-12 md:py-16">
        <Container>
          <Breadcrumbs trail={[{ href: "/", label: "Witness" }, { label: "Field notes" }]} />
          <div className="mt-8 grid gap-10 md:grid-cols-12">
            <div className="md:col-span-7">
              <Eyebrow className="text-sepia">Written in the margins</Eyebrow>
              <h1 className="mt-6 max-w-[16ch] text-balance font-display text-[clamp(2rem,5vw,3.5rem)] font-semibold leading-[1.08] tracking-[-0.01em] text-ink">
                Notes from the edge of the record.
              </h1>
            </div>
            <div className="md:col-span-5 md:pt-4">
              <p className="max-w-[52ch] text-pretty text-[17px] leading-[1.7] text-ink-muted">
                A record in the archive is the app&rsquo;s own catalog, verbatim.
                A field note is the reading around it: what a number means, where
                a word came from, why a species you have never heard of is worth
                two minutes. Every checkable claim carries its sources.
              </p>
            </div>
          </div>
        </Container>
      </section>

      <section className="py-14 md:py-20">
        <Container>
          {notes.length === 0 ? (
            <p className="text-[17px] leading-[1.7] text-ink-muted">
              The first note is being written.
            </p>
          ) : (
            <ol>
              {notes.map((note) => (
                <li key={note.slug} className="border-b border-hairline/50">
                  <Link
                    href={`/field-notes/${note.slug}` as Route}
                    className="group grid gap-4 py-9 md:grid-cols-12 md:gap-8"
                  >
                    <div className="md:col-span-3">
                      <span
                        className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia"
                        translate="no"
                      >
                        {note.date}
                      </span>
                    </div>
                    <div className="md:col-span-9">
                      <h2 className="max-w-[30ch] text-pretty font-display text-[clamp(1.4rem,2.6vw,2rem)] font-semibold leading-[1.15] text-ink transition-colors duration-200 ease-out group-hover:text-sepia">
                        {note.title}
                      </h2>
                      <p className="mt-3 max-w-[58ch] text-pretty text-[16px] leading-[1.65] text-ink-muted">
                        {note.description}
                      </p>
                      {note.sources.length > 0 ? (
                        <p className="mt-3 text-[11px] font-semibold uppercase tracking-[0.16em] text-sepia">
                          {note.sources.length} source
                          {note.sources.length === 1 ? "" : "s"}
                        </p>
                      ) : null}
                    </div>
                  </Link>
                </li>
              ))}
            </ol>
          )}
        </Container>
      </section>

      <section className="border-t border-hairline/50 bg-paper-aged py-16 md:py-20">
        <Container>
          <div className="grid gap-10 md:grid-cols-12">
            <h2 className="max-w-[20ch] text-balance font-display text-[clamp(1.75rem,4vw,2.75rem)] font-semibold leading-[1.12] md:col-span-7">
              The notes are the reading. The archive is the record.
            </h2>
            <div className="md:col-span-4 md:col-start-9">
              <p className="text-[16px] leading-[1.65]">
                Thirty species records, each with sources, rights, and an honest
                review state.
              </p>
              <div className="mt-6">
                <PrimaryLink href="/witnesses">Browse records</PrimaryLink>
              </div>
            </div>
          </div>
        </Container>
      </section>
    </>
  );
}
