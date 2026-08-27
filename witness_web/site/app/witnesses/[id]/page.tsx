import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { Container, Eyebrow, PrimaryLink, TextLink } from "@/components/atlas";
import { SpecimenPlate } from "@/components/specimen-plate";
import {
  ActionCard,
  Breadcrumbs,
  MetaPanel,
  RecordTimeline,
  RelatedRail,
  SourceList,
  StatusBadge,
  StoryProse,
  ThreatChain,
} from "@/components/record";
import { SITE_URL, allRecords, recordById } from "@/lib/archive";

export function generateStaticParams() {
  return allRecords().map((record) => ({ id: record.id }));
}

export async function generateMetadata({
  params,
}: PageProps<"/witnesses/[id]">): Promise<Metadata> {
  const { id } = await params;
  const record = recordById(id);
  if (!record) return { title: "Record not found" };
  return {
    title: `${record.commonName} · ${record.scientificName}`,
    description: `${record.hook} A sourced Witness record: ${record.conservationStatus.displayName}, ${record.generalizedRange}. Fact-checked ${record.editorial.lastFactChecked}.`,
    alternates: { canonical: `/witnesses/${record.id}` },
    openGraph: {
      type: "article",
      title: `${record.commonName} · ${record.scientificName}`,
      description: record.hook,
      url: `${SITE_URL}/witnesses/${record.id}`,
    },
  };
}

export default async function RecordPage({
  params,
}: PageProps<"/witnesses/[id]">) {
  const { id } = await params;
  const record = recordById(id);
  if (!record) notFound();
  const recordNumber = allRecords().findIndex((item) => item.id === record.id) + 1;

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: `${record.commonName} (${record.scientificName})`,
    description: record.hook,
    datePublished: record.publishDate,
    dateModified: record.editorial.lastFactChecked,
    isAccessibleForFree: true,
    citation: record.sources.map((s) => `${s.organization}: ${s.title} (${s.url})`),
    about: { "@type": "Thing", name: record.scientificName },
    url: `${SITE_URL}/witnesses/${record.id}`,
  };

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      {/* Opening ------------------------------------------------------- */}
      <section className="border-b border-hairline/50 py-10 md:py-14">
        <Container>
          <Breadcrumbs
            trail={[
              { href: "/", label: "Witness" },
              { href: "/witnesses", label: "The record" },
              { label: record.commonName },
            ]}
          />

          <div className="mt-10 grid gap-12 md:grid-cols-12 md:gap-10">
            <div className="md:col-span-6 md:pt-6">
              <Eyebrow className="text-sepia">
                Record {String(recordNumber).padStart(3, "0")} · Approved catalog record
              </Eyebrow>
              <h1 className="mt-6 font-display text-[clamp(2.25rem,6vw,4rem)] font-semibold leading-[1.04] tracking-[-0.01em] text-ink">
                {record.commonName}
              </h1>
              <p
                className="mt-2 font-display text-[clamp(1.25rem,3vw,1.9rem)] italic text-sepia"
                translate="no"
              >
                {record.scientificName}
              </p>
              <p className="mt-8 max-w-[42ch] text-pretty font-display text-[clamp(1.2rem,2.4vw,1.6rem)] leading-[1.4] text-ink">
                {record.hook}
              </p>
              <div className="mt-8">
                <StatusBadge
                  status={record.conservationStatus.displayName}
                  note="Exactly as the approved bundled record states. Catalog approval and public app release are separate gates."
                />
              </div>
            </div>

            <div className="md:col-span-6">
              <SpecimenPlate index="Interface study" plate="Abstract form" showIdentity={false} />
            </div>
          </div>
        </Container>
      </section>

      {/* Story + metadata ---------------------------------------------- */}
      <section className="py-16 md:py-24">
        <Container>
          <div className="grid gap-14 md:grid-cols-12 md:gap-10">
            <article className="md:col-span-7">
              <h2 className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">
                What is happening
              </h2>
              <div className="mt-8">
                <StoryProse record={record} />
              </div>
            </article>

            <aside className="md:col-span-4 md:col-start-9">
              <h2 className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">
                Record metadata
              </h2>
              <div className="mt-6">
                <MetaPanel record={record} />
              </div>
              <p className="mt-6 max-w-[42ch] text-[13px] leading-relaxed text-ink-muted">
                The range is deliberately coarse. Witness generalizes locations
                and publishes no map, so a record can never help someone find an
                animal that is already under pressure.
              </p>
            </aside>
          </div>
        </Container>
      </section>

      {/* The threat ----------------------------------------------------- */}
      <section className="dusk py-16 md:py-24">
        <Container>
          <ThreatChain record={record} tone="dusk" />
          <p className="mt-12 max-w-[62ch] text-pretty text-[17px] leading-[1.7] text-[color:var(--dusk-muted)]">This chain summarizes the approved record. Open the numbered sources below for the evidence and its limits.</p>
        </Container>
      </section>

      {/* Provenance + action -------------------------------------------- */}
      <section className="border-b border-hairline/50 py-16 md:py-24">
        <Container>
          <div className="grid gap-14 md:grid-cols-12 md:gap-10">
            <div className="md:col-span-5">
              <h2 className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">
                Record provenance
              </h2>
              <div className="mt-8">
                <RecordTimeline record={record} />
              </div>
            </div>
            <div className="md:col-span-6 md:col-start-7">
              <ActionCard record={record} />
            </div>
          </div>
        </Container>
      </section>

      {/* Sources -------------------------------------------------------- */}
      <section id="sources" className="py-16 md:py-24">
        <Container>
          <div className="grid gap-10 md:grid-cols-12">
            <div className="md:col-span-4">
              <h2 className="font-display text-[clamp(1.5rem,3vw,2.25rem)] font-semibold leading-[1.16] text-ink">
                Sources
              </h2>
              <p className="mt-4 max-w-[36ch] text-pretty text-[15px] leading-[1.65] text-ink-muted">
                Every passage above carries the number of the source it came
                from. Nothing on this page is written from memory.
              </p>
            </div>
            <div className="md:col-span-7 md:col-start-6">
              <SourceList record={record} />
              <p className="mt-6 max-w-[56ch] text-[13px] leading-relaxed text-ink-muted">
                Media: {record.media.depictionType} · {record.media.creator} ·{" "}
                {record.media.license} · verification {record.media.verificationStatus}.
              </p>
            </div>
          </div>
        </Container>
      </section>

      {/* Onward --------------------------------------------------------- */}
      <section className="border-t border-hairline/50 bg-paper-aged py-16 md:py-20">
        <Container>
          <div className="grid gap-10 md:grid-cols-12">
            <div className="md:col-span-6">
              <RelatedRail />
            </div>
            <div className="md:col-span-5 md:col-start-8">
              <h2 className="font-display text-2xl font-semibold text-ink">
                The ritual this record belongs to
              </h2>
              <p className="mt-4 max-w-[46ch] text-pretty text-[16px] leading-[1.65] text-ink">
                In the app, this record is one day: meet the species, read the
                sourced story, record a private Witness, open the action.
              </p>
              <div className="mt-6 flex flex-wrap items-center gap-x-8 gap-y-2">
                <PrimaryLink href="/#ritual">See the ritual</PrimaryLink>
                <TextLink href="/method">Read the method</TextLink>
              </div>
            </div>
          </div>
        </Container>
      </section>
    </>
  );
}
