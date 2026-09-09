import type { Metadata } from "next";
import { Container, Eyebrow, TextLink } from "@/components/atlas";
import { Breadcrumbs } from "@/components/record";
import { CONTACT_EMAIL } from "@/lib/archive";

export const metadata: Metadata = {
  title: "Write a field note",
  description:
    "The brief for guest field notes: one species or one question, 350 to 950 words, every checkable claim with two sources, a byline that is yours.",
  alternates: { canonical: "/field-notes/write" },
};

const heading = "text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia";
const body = "mt-4 text-pretty text-[16px] leading-[1.7] text-ink-muted";
const list = "mt-4 flex flex-col gap-3 text-pretty text-[16px] leading-[1.7] text-ink-muted";
const inline =
  "text-sepia underline decoration-hairline/70 decoration-1 underline-offset-[5px] transition-colors duration-200 ease-out hover:text-ink hover:decoration-current";

const PITCH_SUBJECT = encodeURIComponent("Field note pitch");

export default function WritePage() {
  return (
    <section className="py-12 md:py-16">
      <Container>
        <Breadcrumbs
          trail={[
            { href: "/", label: "Witness" },
            { href: "/field-notes", label: "Field notes" },
            { label: "Write a note" },
          ]}
        />
        <div className="mt-8 max-w-[62ch]">
          <Eyebrow className="text-sepia">Write a field note</Eyebrow>
          <h1 className="mt-6 text-balance font-display text-[clamp(2rem,5vw,3.5rem)] font-semibold leading-[1.08] tracking-[-0.01em] text-ink">
            The reading around the record, by someone who did the reading.
          </h1>
          <p className={`${body} mt-8 text-[17px]`}>
            Field notes are short, sourced essays about species on the edge of
            disappearance and the words and numbers used to describe them. Most
            are written by the person who makes Witness. Some should not be. If
            you have spent time with a species, a survey, a court file, or an
            idea about how much of the planet should be left to everything else,
            this is the brief.
          </p>

          <div className="mt-10">
            <h2 className={heading}>What a note is</h2>
            <ul className={list}>
              <li>
                One species and one verifiable thing about it, or one question a
                person actually types into a search box, or one term explained
                properly. Not a survey of a topic.
              </li>
              <li>
                Between 350 and 950 words. The first paragraph stands on its own:
                a reader who stops there has the answer.
              </li>
              <li>
                Every checkable claim, meaning a year, a count, a percentage, a
                measurement, or a formal status category, carries at least two
                independent sources. Sources are URLs a reader can open.
              </li>
              <li>
                Where the species has a record in{" "}
                <TextLink href="/archive">the archive</TextLink>, the note links to
                it and does not retell it. The record is the catalog; the note is
                the reading around it.
              </li>
              <li>
                Argument is welcome. A note on protected-area targets, on setting
                aside half the planet for other species, or on why a census
                method fails at low numbers is a field note if the argument is
                sourced the same way a count is.
              </li>
            </ul>
          </div>

          <div className="mt-10">
            <h2 className={heading}>What will not be published</h2>
            <ul className={list}>
              <li>Lists. No rankings, no ten cutest anything.</li>
              <li>
                Daily or hourly extinction figures. The numbers in circulation
                trace back to an estimate nobody can source cleanly.
              </li>
              <li>
                Exact nests, dens, roosts, or coordinates, even when a source
                prints them. Ranges stay generalized.
              </li>
              <li>
                Any claim that using Witness, sharing a card, or reading a note
                produces a conservation outcome. It does not, and the site says
                so.
              </li>
              <li>
                Pieces whose real purpose is a donation link or a product. A
                citation is not an endorsement, and a note is not an
                advertisement.
              </li>
            </ul>
            <p className={body}>
              Every note, guest or house, passes the same gate before it goes
              live: prohibited phrases, unsupported claims, sensitive locations,
              dead links. The gate is the editor. Read{" "}
              <TextLink href="/method">how a claim earns its place</TextLink> for
              the standard behind it.
            </p>
          </div>

          <div className="mt-10">
            <h2 className={heading}>The terms</h2>
            <ul className={list}>
              <li>
                Your name on the note, and one link of your choosing under it.
                The words stay yours to publish elsewhere afterwards.
              </li>
              <li>
                Edits are for the gate and for length, not for voice. You see
                the final text before it ships.
              </li>
              <li>
                There is no payment for a guest note at present. That is stated
                here so nobody has to ask.
              </li>
              <li>
                A published note appears on this site, in the RSS feed, and in
                the email that rounds up new notes.
              </li>
            </ul>
          </div>

          <div className="mt-10">
            <h2 className={heading}>How to pitch</h2>
            <p className={body}>
              Send two sentences and the sources you would use to{" "}
              <a
                href={`mailto:${CONTACT_EMAIL}?subject=${PITCH_SUBJECT}`}
                className={inline}
              >
                {CONTACT_EMAIL}
              </a>{" "}
              with the subject line &ldquo;Field note pitch&rdquo;. A draft is
              welcome but not required. Every pitch is read by the person who
              makes Witness.
            </p>
          </div>
        </div>
      </Container>
    </section>
  );
}
