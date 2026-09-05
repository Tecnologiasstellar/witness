import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { Container, Eyebrow, PrimaryLink, TextLink } from "@/components/atlas";
import {
  ActionCard,
  Breadcrumbs,
  MetaPanel,
  Plate,
  Programs,
  SourceList,
  StatsGrid,
  StatusBadge,
  StoryProse,
  Threats,
} from "@/components/record";
import { APP_STORE_URL, SITE_URL, allRecords, formatDate, plate, recordById } from "@/lib/archive";

export function generateStaticParams() {
  return allRecords().map((record) => ({ id: record.id }));
}

export async function generateMetadata({ params }: PageProps<"/archive/[id]">): Promise<Metadata> {
  const { id } = await params;
  const record = recordById(id);
  if (!record) return { title: "Record not found" };
  const hero = plate(record, "plate");
  return {
    title: `${record.commonName} · ${record.scientificName}`,
    description: `${record.hook} ${record.conservationStatus.displayName}, ${record.generalizedRange}. A sourced Witness card with original illustrations.`,
    alternates: { canonical: `/archive/${record.id}` },
    openGraph: {
      type: "article",
      title: `${record.commonName} · ${record.scientificName}`,
      description: record.hook,
      url: `${SITE_URL}/archive/${record.id}`,
      images: [{ url: hero.src, width: hero.width, height: hero.height, alt: `Original illustration of the ${record.commonName}` }],
    },
  };
}

const label = "text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia";

export default async function RecordPage({ params }: PageProps<"/archive/[id]">) {
  const { id } = await params;
  const record = recordById(id);
  if (!record) notFound();
  const number = allRecords().findIndex((item) => item.id === record.id) + 1;
  const total = allRecords().length;

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: `${record.commonName} (${record.scientificName})`,
    description: record.hook,
    image: `${SITE_URL}${plate(record, "plate").src}`,
    datePublished: record.publishDate,
    dateModified: record.editorial.lastFactChecked,
    isAccessibleForFree: true,
    citation: record.sources.map((s) => `${s.organization}: ${s.title} (${s.url})`),
    about: { "@type": "Thing", name: record.scientificName },
    url: `${SITE_URL}/archive/${record.id}`,
  };

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />

      {/* Opening: the plate, the name, the hook ---------------------------- */}
      <section className="border-b border-hairline/50 py-8 md:py-12">
        <Container>
          <Breadcrumbs trail={[{ href: "/", label: "Witness" }, { href: "/archive", label: "The Archive" }, { label: record.commonName }]} />
          <div className="mt-8 grid gap-10 md:grid-cols-12 md:gap-12">
            <div className="md:col-span-6 md:col-start-7">
              <Plate record={record} kind="plate" eager />
            </div>
            <div className="md:col-span-5 md:order-first md:self-center">
              <Eyebrow className="text-sepia">
                Card {String(number).padStart(2, "0")} of {total}
              </Eyebrow>
              <h1 className="mt-6 font-display text-[clamp(2.4rem,6vw,4.25rem)] font-semibold uppercase leading-[1] tracking-[-0.01em] text-ink">
                {record.commonName}
              </h1>
              <p className="mt-2 font-display text-[clamp(1.25rem,3vw,1.75rem)] italic text-sepia" translate="no">
                {record.scientificName}
              </p>
              <div className="mt-6">
                <StatusBadge status={record.conservationStatus.displayName} />
              </div>
              <div aria-hidden="true" className="mt-10 h-px w-16 bg-sepia" />
              <p className="mt-6 max-w-[30ch] text-pretty font-display text-[clamp(1.5rem,2.8vw,2.1rem)] italic leading-[1.3] text-ink">
                {record.hook}
              </p>
            </div>
          </div>
        </Container>
      </section>

      {/* The tiles ---------------------------------------------------------- */}
      {record.stats ? (
        <section className="bg-paper-fresh py-12 md:py-16">
          <Container>
            <StatsGrid stats={record.stats} />
          </Container>
        </section>
      ) : null}

      {/* Where it lives ------------------------------------------------------ */}
      <section className="py-14 md:py-20">
        <Container>
          <div className="grid gap-10 md:grid-cols-12">
            <div className="md:col-span-8">
              <Plate record={record} kind="context" caption={record.generalizedRange} />
            </div>
            <div className="md:col-span-3 md:col-start-10 md:pt-6">
              <h2 className={label}>Where it lives</h2>
              <p className="mt-4 font-display text-xl leading-[1.35] text-ink">{record.generalizedRange}</p>
              <p className="mt-4 text-[13px] leading-relaxed text-ink-muted">
                Ranges stay general on purpose. Witness never publishes a location that could help someone find an animal already under pressure.
              </p>
            </div>
          </div>
        </Container>
      </section>

      {/* Threats and life cycle --------------------------------------------- */}
      {record.stats || record.reproduction ? (
        <section className="border-y border-hairline/50 bg-paper-aged py-14 md:py-20">
          <Container>
            <div className="grid gap-12 md:grid-cols-12">
              {record.stats ? (
                <div className="md:col-span-5">
                  <h2 className={label}>What threatens it</h2>
                  <div className="mt-6">
                    <Threats threats={record.stats.threats} />
                  </div>
                </div>
              ) : null}
              {record.reproduction ? (
                <div className="md:col-span-6 md:col-start-7">
                  <h2 className={label}>Life cycle</h2>
                  <p className="mt-6 max-w-[58ch] text-pretty text-[17px] leading-[1.7] text-ink">{record.reproduction.text}</p>
                </div>
              ) : null}
            </div>
          </Container>
        </section>
      ) : null}

      {/* Two studies --------------------------------------------------------- */}
      <section className="py-14 md:py-20">
        <Container>
          <div className="grid gap-10 md:grid-cols-2">
            <Plate record={record} kind="detail" caption={`Field study · ${record.commonName}`} />
            <Plate record={record} kind="behavior" caption="Field observation" className="md:pt-16" />
          </div>
        </Container>
      </section>

      {/* Field notes ---------------------------------------------------------- */}
      <section className="border-t border-hairline/50 py-14 md:py-20">
        <Container>
          <div className="grid gap-10 md:grid-cols-12">
            <div className="md:col-span-3">
              <h2 className={label}>Field notes</h2>
              <p className="mt-4 max-w-[28ch] text-[13px] leading-relaxed text-ink-muted">
                Every passage carries the number of the source it came from. Nothing here is written from memory.
              </p>
            </div>
            <article className="md:col-span-8 md:col-start-5">
              <StoryProse record={record} />
            </article>
          </div>
        </Container>
      </section>

      {/* Scale and the one thing to remember ---------------------------------- */}
      <section className="bg-paper-fresh py-14 md:py-20">
        <Container>
          <div className="grid items-center gap-10 md:grid-cols-12">
            <div className="md:col-span-5">
              <Plate record={record} kind="scale" caption="Scale study · beside a human figure" />
            </div>
            {record.insight ? (
              <div className="md:col-span-6 md:col-start-7">
                <h2 className={label}>Did you know</h2>
                <p className="mt-6 max-w-[26ch] text-pretty font-display text-[clamp(1.6rem,3.2vw,2.5rem)] leading-[1.25] text-ink">
                  {record.insight.text}
                </p>
              </div>
            ) : null}
          </div>
        </Container>
      </section>

      {/* The door --------------------------------------------------------------- */}
      <section className="border-t border-hairline/50 py-14 md:py-20">
        <Container>
          <div className="grid gap-12 md:grid-cols-12">
            <div className="md:col-span-6">
              <ActionCard record={record} />
            </div>
            {record.programs && record.programs.length > 0 ? (
              <div className="md:col-span-5 md:col-start-8">
                <h2 className={label}>Help &amp; protection</h2>
                <div className="mt-6">
                  <Programs programs={record.programs} />
                </div>
              </div>
            ) : null}
          </div>
        </Container>
      </section>

      {/* Sources and verification ------------------------------------------------ */}
      <section id="sources" className="border-t border-hairline/50 bg-paper-aged py-14 md:py-20">
        <Container>
          <div className="grid gap-10 md:grid-cols-12">
            <div className="md:col-span-4">
              <h2 className="font-display text-[clamp(1.5rem,3vw,2.25rem)] font-semibold leading-[1.16] text-ink">Sources &amp; verification</h2>
              <div className="mt-8">
                <MetaPanel record={record} />
              </div>
            </div>
            <div className="md:col-span-7 md:col-start-6">
              <SourceList record={record} />
              <p className="mt-6 max-w-[56ch] text-[13px] leading-relaxed text-ink-muted">
                Record last fact-checked {formatDate(record.editorial.lastFactChecked)}. The illustrations are original, drawn for Witness; they are not photographs.
              </p>
            </div>
          </div>
        </Container>
      </section>

      {/* Onward ------------------------------------------------------------------- */}
      <section className="border-t border-hairline/50 py-14 md:py-20">
        <Container>
          <div className="grid gap-10 md:grid-cols-12">
            <div className="md:col-span-6">
              <h2 className="font-display text-2xl font-semibold text-ink">In the app, this card arrives on a Monday.</h2>
              <p className="mt-4 max-w-[46ch] text-pretty text-[16px] leading-[1.65] text-ink-muted">
                Meet the species, bear witness once, take up its act. The weekly card is free and stays free.
              </p>
            </div>
            <div className="flex flex-wrap items-center gap-x-8 gap-y-4 md:col-span-5 md:col-start-8 md:self-center">
              <PrimaryLink href={APP_STORE_URL} external>
                Download on the App Store
              </PrimaryLink>
              <TextLink href="/archive">Back to the archive</TextLink>
            </div>
          </div>
        </Container>
      </section>
    </>
  );
}
