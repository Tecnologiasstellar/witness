import type { Metadata } from "next";
import { RecordCard } from "@/components/cards";
import { Container } from "@/components/shell";
import { ATLAS_URL } from "@/lib/site";
import { allRecords } from "@/lib/species";

export const metadata: Metadata = {
  title: "The Archive",
  description: "Thirty species records from the Witness app, each with sources, rights, and an honest review state, drawn as original plates.",
  alternates: { canonical: "/archive" },
};

export default function ArchivePage() {
  const records = allRecords();
  return (
    <>
      <section className="border-b border-line py-10 md:py-14">
        <Container>
          <p className="text-[11px] font-bold uppercase tracking-[0.16em] text-accent">The Archive</p>
          <h1 className="mt-2 font-display text-[clamp(2rem,5vw,3.4rem)] font-extrabold leading-[1.05] tracking-[-0.03em] text-ink">
            {records.length} species records.
          </h1>
          <p className="mt-3 max-w-[58ch] text-pretty text-[18px] leading-[1.55] text-muted">
            The app&rsquo;s own catalog, verbatim, kept at{" "}
            <a href={`${ATLAS_URL}/archive`} className="font-semibold text-accent hover:text-ink">
              witnessatlas.com
            </a>
            . Each record opens there, with its sources and its review state. The notes on this site are the reading around them.
          </p>
        </Container>
      </section>
      <section className="py-10 md:py-12">
        <Container>
          <div className="grid grid-cols-2 gap-6 sm:grid-cols-3 lg:grid-cols-5">
            {records.map((record) => (
              <RecordCard key={record.id} record={record} />
            ))}
          </div>
        </Container>
      </section>
    </>
  );
}
