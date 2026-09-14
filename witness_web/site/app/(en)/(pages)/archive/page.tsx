import type { Metadata, Route } from "next";
import Link from "next/link";
import { Container, Eyebrow } from "@/components/atlas";
import { Breadcrumbs } from "@/components/record";
import { allRecords, plate } from "@/lib/archive";

export const metadata: Metadata = {
  title: "The Archive",
  description: "Every species card Witness has published: original illustrations, a sourced story, its threats, and one real door. Free to read.",
  alternates: { canonical: "/archive" },
};

export default function ArchiveIndex() {
  const records = allRecords();

  return (
    <>
      <section className="border-b border-hairline/50 py-10 md:py-16">
        <Container>
          <Breadcrumbs trail={[{ href: "/", label: "Witness" }, { label: "The Archive" }]} />
          <div className="mt-8 grid gap-8 md:grid-cols-12">
            <div className="md:col-span-7">
              <Eyebrow className="text-sepia">{records.length} cards · free to read</Eyebrow>
              <h1 className="mt-6 max-w-[14ch] text-balance font-display text-[clamp(2.2rem,5.5vw,4rem)] font-semibold leading-[1.02] tracking-[-0.02em] text-ink">
                Every species, drawn and told in full.
              </h1>
            </div>
            <p className="max-w-[46ch] text-pretty text-[17px] leading-[1.7] text-ink-muted md:col-span-4 md:col-start-9 md:pt-4">
              The same cards the app carries, word for word: five original illustrations, a sourced story, what threatens the species, and one real organization already doing the work.
            </p>
          </div>
        </Container>
      </section>

      <section className="py-12 md:py-16">
        <Container>
          <ol className="grid grid-cols-2 gap-x-5 gap-y-10 sm:grid-cols-3 lg:grid-cols-5 lg:gap-x-6 lg:gap-y-12">
            {records.map((record, i) => {
              const hero = plate(record, "plate");
              return (
                <li key={record.id}>
                  <Link href={`/archive/${record.id}` as Route} className="group block">
                    <img
                      src={hero.src}
                      width={hero.width}
                      height={hero.height}
                      alt=""
                      loading={i < 5 ? undefined : "lazy"}
                      decoding="async"
                      className="h-auto w-full border border-hairline/40 bg-paper-aged transition-transform duration-300 ease-out group-hover:-translate-y-1"
                    />
                    <p className="mt-4 text-[10px] font-semibold uppercase tracking-[0.16em] text-sepia">{record.conservationStatus.displayName}</p>
                    <h2 className="mt-1 font-display text-[1.2rem] font-semibold leading-[1.15] text-ink underline decoration-transparent decoration-1 underline-offset-4 transition-colors duration-200 ease-out group-hover:decoration-hairline">
                      {record.commonName}
                    </h2>
                    <p className="mt-0.5 font-display text-[15px] italic leading-snug text-ink-muted" translate="no">
                      {record.scientificName}
                    </p>
                  </Link>
                </li>
              );
            })}
          </ol>
        </Container>
      </section>
    </>
  );
}
