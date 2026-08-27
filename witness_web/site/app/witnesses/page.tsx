import type { Metadata, Route } from "next";
import Link from "next/link";
import { Container, Eyebrow, PrimaryLink, TextLink } from "@/components/atlas";
import { Breadcrumbs } from "@/components/record";
import { SpecimenPlate } from "@/components/specimen-plate";
import { CATALOGUE, allRecords } from "@/lib/archive";

export const metadata: Metadata = {
  title: "The record",
  description:
    "Every record Witness has published, with its status, range, sources, and review state.",
  alternates: { canonical: "/witnesses" },
};

export default function WitnessesIndex() {
  const records = allRecords();

  return (
    <>
      <section className="border-b border-hairline/50 py-12 md:py-16">
        <Container>
          <Breadcrumbs trail={[{ href: "/", label: "Witness" }, { label: "The record" }]} />
          <div className="mt-8 grid gap-10 md:grid-cols-12">
            <div className="md:col-span-7">
              <Eyebrow className="text-sepia">The collection</Eyebrow>
              <h1 className="mt-6 max-w-[16ch] text-balance font-display text-[clamp(2rem,5vw,3.5rem)] font-semibold leading-[1.08] tracking-[-0.01em] text-ink">
                Every record the archive holds.
              </h1>
            </div>
            <div className="md:col-span-5 md:pt-4">
              <p className="max-w-[52ch] text-pretty text-[17px] leading-[1.7] text-ink-muted">
                {CATALOGUE.note} A record enters this index when its story is
                written from declared sources, its media rights are recorded,
                and its review state is honest about what has not happened yet.
              </p>
            </div>
          </div>
        </Container>
      </section>

      <section className="py-16 md:py-20">
        <Container>
          <ol>
            {records.map((record, i) => (
              <li key={record.id} className="border-b border-hairline/50 pb-14">
                <Link
                  href={`/witnesses/${record.id}` as Route}
                  className="group grid gap-10 py-10 md:grid-cols-12 md:gap-8"
                >
                  <div className="md:col-span-2">
                    <span
                      className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia"
                      translate="no"
                    >
                      {String(i + 1).padStart(3, "0")}
                    </span>
                  </div>
                  <div className="md:col-span-4">
                    <SpecimenPlate
                      variant="detail"
                      index="Plate II"
                      plate="Dorsal aspect"
                      showIdentity={false}
                    />
                  </div>
                  <div className="md:col-span-6">
                    <h2 className="font-display text-[clamp(1.6rem,3.4vw,2.4rem)] font-semibold leading-[1.14] text-ink underline decoration-transparent decoration-1 underline-offset-[6px] transition-colors duration-200 ease-out group-hover:decoration-hairline">
                      {record.commonName}
                    </h2>
                    <p className="font-display text-lg italic text-sepia" translate="no">
                      {record.scientificName}
                    </p>
                    <p className="mt-5 max-w-[46ch] text-pretty text-[17px] leading-[1.6] text-ink">
                      {record.hook}
                    </p>
                    <dl className="mt-6 flex flex-wrap gap-x-10 gap-y-4">
                      {[
                        ["Status", record.conservationStatus.displayName],
                        ["Range", record.generalizedRange],
                        ["Record state", record.editorial.state],
                      ].map(([term, value]) => (
                        <div key={term}>
                          <dt className="text-[10px] font-semibold uppercase tracking-[0.16em] text-sepia">
                            {term}
                          </dt>
                          <dd className="mt-1 max-w-[28ch] text-[15px] text-ink first-letter:uppercase">
                            {value}
                          </dd>
                        </div>
                      ))}
                    </dl>
                    <span className="mt-8 inline-flex min-h-11 items-center gap-3 text-[15px] font-semibold text-ink">
                      Read the record
                      <span
                        aria-hidden="true"
                        className="h-px w-6 origin-left bg-current transition-transform duration-200 ease-out group-hover:scale-x-[1.6]"
                      />
                    </span>
                  </div>
                </Link>
              </li>
            ))}
          </ol>

          <div className="mt-14 border border-hairline/70 p-8 md:p-10">
            <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">Catalog boundary</p>
            <p className="mt-3 max-w-[54ch] text-pretty font-display text-xl leading-[1.5] text-ink">Thirty approved records. No invented overflow.</p>
            <p className="mt-3 max-w-[58ch] text-pretty text-[16px] leading-[1.65] text-ink-muted">A new record appears only after its sources, rights, location safety, and editorial review pass the production catalog standard. Catalog approval does not claim that the app has been publicly released.</p>
            <div className="mt-6 flex flex-wrap items-center gap-x-8 gap-y-2"><PrimaryLink href="/method">How a record is made</PrimaryLink><TextLink href="/">Back to the opening</TextLink></div>
          </div>
        </Container>
      </section>
    </>
  );
}
