import type { Metadata } from "next";
import { Container, Eyebrow, TextLink } from "@/components/atlas";
import { Breadcrumbs } from "@/components/record";
import { formatDate } from "@/lib/archive";
import { NOTES_URL } from "@/lib/archive";
import { allNotes, noteUrl, sectionName } from "@/lib/notes";

export const metadata: Metadata = {
  title: "Field Notes",
  description:
    "Every field note Witness has published: one sourced essay on endangered species, conservation policy and protected land, with the sources it was written from.",
  alternates: { canonical: "/field-notes" },
};

export default function FieldNotesIndex() {
  const notes = allNotes();

  return (
    <>
      <section className="border-b border-hairline/50 py-10 md:py-16">
        <Container>
          <Breadcrumbs trail={[{ href: "/", label: "Witness" }, { label: "Field Notes" }]} />
          <div className="mt-8 grid gap-8 md:grid-cols-12">
            <div className="md:col-span-7">
              <Eyebrow className="text-sepia">{notes.length} notes · free to read</Eyebrow>
              <h1 className="mt-6 max-w-[16ch] text-balance font-display text-[clamp(2.2rem,5.5vw,4rem)] font-semibold leading-[1.02] tracking-[-0.02em] text-ink">
                The reading around the archive.
              </h1>
            </div>
            <p className="max-w-[46ch] text-pretty text-[17px] leading-[1.7] text-ink-muted md:col-span-4 md:col-start-9 md:pt-4">
              A species card tells you what is true about one animal. A field note is the reading
              around it — a count and what it measures, a law and what it reaches, the people doing
              the work. Every note carries the sources it was written from.
            </p>
          </div>
        </Container>
      </section>

      <section className="py-12 md:py-16">
        <Container>
          <ol className="grid gap-x-10 gap-y-12 md:grid-cols-2">
            {notes.map((note) => (
              <li key={note.slug}>
                <a href={noteUrl(note.slug)} className="group block">
                  <p className="text-[10px] font-semibold uppercase tracking-[0.16em] text-sepia">
                    {sectionName(note.section)} · {formatDate(note.date)}
                  </p>
                  <h2 className="mt-2 max-w-[24ch] text-pretty font-display text-[1.4rem] font-semibold leading-[1.18] text-ink underline decoration-transparent decoration-1 underline-offset-4 transition-colors duration-200 ease-out group-hover:decoration-hairline">
                    {note.title}&nbsp;↗
                  </h2>
                  <p className="mt-3 max-w-[52ch] text-pretty text-[15px] leading-[1.65] text-ink-muted">
                    {note.description}
                  </p>
                </a>
              </li>
            ))}
          </ol>
        </Container>
      </section>

      <section className="border-t border-hairline/50 py-14 md:py-20">
        <Container>
          <div className="grid gap-10 md:grid-cols-12">
            <div className="md:col-span-6">
              <h2 className="font-display text-2xl font-semibold text-ink">
                The notes live on their own site.
              </h2>
              <p className="mt-4 max-w-[46ch] text-pretty text-[16px] leading-[1.65] text-ink-muted">
                Field Notes is published separately, in English and Spanish, and the archive here is
                what it reads around.
              </p>
            </div>
            <div className="flex flex-wrap items-center gap-x-8 gap-y-4 md:col-span-5 md:col-start-8 md:self-center">
              <TextLink href={NOTES_URL} external>
                Read Field Notes
              </TextLink>
              <TextLink href="/archive">Back to the archive</TextLink>
            </div>
          </div>
        </Container>
      </section>
    </>
  );
}
