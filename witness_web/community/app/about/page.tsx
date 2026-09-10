import type { Metadata, Route } from "next";
import Link from "next/link";
import { SubscribeBand } from "@/components/cards";
import { Container } from "@/components/shell";
import { ATLAS_URL, CONTACT_EMAIL, PUB_NAME } from "@/lib/site";

export const metadata: Metadata = {
  title: "About",
  description: "What Field Notes is, who makes it, how it is paid for, and the one question it keeps returning to.",
  alternates: { canonical: "/about" },
};

const h2 = "mt-12 font-display text-[13px] font-extrabold uppercase tracking-[0.16em] text-ink";
const p = "mt-4 text-pretty text-[17px] leading-[1.7] text-ink";
const a = "font-semibold text-accent hover:text-ink";

export default function AboutPage() {
  return (
    <>
      <section className="py-10 md:py-14">
        <Container>
          <div className="mx-auto max-w-[68ch]">
            <p className="text-[11px] font-bold uppercase tracking-[0.16em] text-accent">About</p>
            <h1 className="mt-2 text-balance font-display text-[clamp(2rem,5vw,3.4rem)] font-extrabold leading-[1.05] tracking-[-0.03em] text-ink">
              A publication about what is still here, and what it would take to keep it.
            </h1>

            <p className={`${p} mt-8 text-[19px]`}>
              {PUB_NAME} publishes short, sourced essays about species on the edge of disappearance, about the words and numbers
              used to describe them, and about the strategies that might leave enough of the planet to everything that was here
              first. It is written for people who care about the living world and want to read something checkable.
            </p>

            <h2 className={h2}>The question</h2>
            <p className={p}>
              Whether, and how, roughly half of the Earth&rsquo;s land and sea could be set aside for other species is an idea
              argued at book length by the biologist E. O. Wilson in 2016 and debated ever since. This site does not belong to
              any organisation that carries that name. It treats the idea as an open question worth reporting on: what the
              targets are, what a protected area actually protects, where corridors and rewilding have worked, and where the
              numbers are softer than the headlines. Argument is welcome on every side of it, as long as the argument is
              sourced.
            </p>

            <h2 className={h2}>The rule</h2>
            <p className={p}>
              A claim never exceeds its evidence. Every checkable figure in a note carries at least two independent sources a
              reader can open. Ranges stay generalised; no note prints a nest, a den, or a coordinate. Nothing here says that
              reading, sharing, or using an app produces a conservation outcome, because it does not. The full standard is on
              the atlas under{" "}
              <a href={`${ATLAS_URL}/method`} className={a}>
                Method
              </a>
              .
            </p>

            <h2 className={h2}>Witness</h2>
            <p className={p}>
              {PUB_NAME} is published by the maker of{" "}
              <a href={ATLAS_URL} className={a}>
                Witness
              </a>
              , an iPhone app that puts one endangered species in front of you each week, with its true story, its sources,
              and one honest action. The thirty species records in{" "}
              <Link href={"/archive" as Route} className={a}>
                the archive
              </Link>{" "}
              are the app&rsquo;s own catalog. The illustrations on this site are original plates drawn for the app, not
              documentary photography.
            </p>

            <h2 className={h2}>Who makes it, and how it is paid for</h2>
            <p className={p}>
              One person, Alberto Villalpando, writes, edits, and publishes it, with guest writers as they come. There are no
              advertisements and no sponsors. The site is paid for by the app&rsquo;s paid editions and by the person making it.
              If that changes, this page will say so.
            </p>

            <h2 className={h2}>Write for it</h2>
            <p className={p}>
              Guest notes carry the writer&rsquo;s name and one link, pass the same gate as everything else, and stay the
              writer&rsquo;s to publish elsewhere afterwards.{" "}
              <Link href={"/write" as Route} className={a}>
                The brief is here
              </Link>
              .
            </p>

            <h2 className={h2}>Contact</h2>
            <p className={p}>
              Corrections, pitches, and questions:{" "}
              <a href={`mailto:${CONTACT_EMAIL}`} className={a}>
                {CONTACT_EMAIL}
              </a>
              . A changed claim gets a new verification date.
            </p>
          </div>
        </Container>
      </section>
      <Container>
        <SubscribeBand compact />
      </Container>
    </>
  );
}
