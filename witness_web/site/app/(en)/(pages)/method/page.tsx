import type { Metadata } from "next";
import { Container, Eyebrow, PrimaryLink, TextLink } from "@/components/atlas";
import { Breadcrumbs } from "@/components/record";
import { CATALOGUE } from "@/lib/archive";

export const metadata: Metadata = {
  title: "Method",
  description: "How a Witness card is made: the sourcing standard, the artwork rules, the location policy, and how corrections work.",
  alternates: { canonical: "/method" },
};

const STANDARD = [
  ["Sources", "Every material passage maps to a declared public source, with the date it was retrieved. A passage with no source does not ship."],
  ["What is not known", "Where a figure is disputed or unverified, the card says so instead of guessing. A range of estimates stays a range."],
  ["Artwork", "Every illustration is original, made for Witness under one fixed art direction, reviewed for species accuracy, and recorded with its rights. None is presented as a photograph."],
  ["Location safety", "Ranges stay general. Exact nests, dens, coordinates, and pressured population sites are withheld, on every card, without exception."],
  ["The act", "Each card carries one act: a real organization already doing the work, one honest sentence about what support does, and a direct link, checked before the card ships."],
  ["Corrections", "Reports are checked against the cited source. A changed claim receives a new verification date, and the card shows it."],
] as const;

const LIMITS = [
  ["A Witness counts attention", "It never claims an animal was saved, money reached the field, or a policy changed."],
  ["A citation is not a partnership", "Witness cites organizations and agencies. It does not speak for them, and they have not endorsed it."],
  ["The site is the app, verbatim", "Every card here is the same record the app carries, word for word. Nothing is rewritten for the web."],
] as const;

export default function MethodPage() {
  return (
    <>
      <section className="border-b border-hairline/50 py-12 md:py-20">
        <Container>
          <Breadcrumbs trail={[{ href: "/", label: "Witness" }, { label: "Method" }]} />
          <div className="mt-8 grid gap-10 md:grid-cols-12">
            <div className="md:col-span-7">
              <Eyebrow className="text-sepia">Method</Eyebrow>
              <h1 className="mt-6 max-w-[17ch] text-balance font-display text-[clamp(2.4rem,6vw,5rem)] font-semibold leading-[.98] tracking-[-0.03em] text-ink">
                Trust is a product feature, not a tone of voice.
              </h1>
            </div>
            <p className="dropcap max-w-[52ch] text-pretty text-[17px] leading-[1.7] text-ink-muted md:col-span-5 md:pt-4">
              A card reaches the app, and this site, only after it passes the same six checks. The {CATALOGUE.published} cards in the archive all did. The standard applies again to every revision and every new card.
            </p>
          </div>
        </Container>
      </section>

      <section className="dusk py-16 md:py-24">
        <Container>
          <div className="grid gap-12 md:grid-cols-12">
            <div className="md:col-span-4">
              <h2 className="font-display text-[clamp(2rem,4vw,3rem)] font-semibold leading-[1.05]">How a card earns its place.</h2>
            </div>
            <ol className="md:col-span-7 md:col-start-6">
              {STANDARD.map(([term, detail], index) => (
                <li key={term} className="grid grid-cols-[2rem_1fr] gap-4 border-t py-5" style={{ borderColor: "var(--dusk-rule)" }}>
                  <span className="font-display text-lg text-[color:var(--dusk-muted)]">{index + 1}</span>
                  <div>
                    <h3 className="font-display text-xl font-semibold">{term}</h3>
                    <p className="mt-1 max-w-[52ch] text-[16px] leading-[1.6] text-[color:var(--dusk-muted)]">{detail}</p>
                  </div>
                </li>
              ))}
            </ol>
          </div>
        </Container>
      </section>

      <section className="py-16 md:py-24">
        <Container>
          <div className="grid gap-10 md:grid-cols-3">
            {LIMITS.map(([title, detail]) => (
              <article key={title} className="border-t-2 border-ink pt-6">
                <h2 className="font-display text-2xl font-semibold">{title}</h2>
                <p className="mt-4 text-[16px] leading-[1.7] text-ink-muted">{detail}</p>
              </article>
            ))}
          </div>
        </Container>
      </section>

      <section className="border-t border-hairline/50 bg-paper-aged py-16 md:py-20">
        <Container>
          <div className="grid gap-10 md:grid-cols-12">
            <div className="md:col-span-7">
              <h2 className="max-w-[22ch] text-balance font-display text-[clamp(1.75rem,4vw,2.75rem)] font-semibold leading-[1.12]">Inspect the evidence where you can actually use it.</h2>
            </div>
            <div className="md:col-span-4 md:col-start-9">
              <p className="text-[16px] leading-[1.65]">Read a complete card with its sources, or write in with a correction.</p>
              <div className="mt-6 flex flex-wrap gap-x-8">
                <PrimaryLink href="/archive">Browse the archive</PrimaryLink>
                <TextLink href="/contact">Contact</TextLink>
              </div>
            </div>
          </div>
        </Container>
      </section>
    </>
  );
}
