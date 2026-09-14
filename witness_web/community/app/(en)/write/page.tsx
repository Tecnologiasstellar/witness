import type { Metadata, Route } from "next";
import Link from "next/link";
import { Container } from "@/components/shell";
import { ATLAS_URL, CONTACT_EMAIL, PUB_NAME, SECTIONS } from "@/lib/site";

export const metadata: Metadata = {
  title: "Write for Field Notes",
  description:
    "The brief for guest notes: one species or one question, 350 to 950 words, every checkable claim with two sources, a byline that is yours.",
  alternates: { canonical: "/write" },
};

const h2 = "mt-12 font-display text-[13px] font-extrabold uppercase tracking-[0.16em] text-ink";
const p = "mt-4 text-pretty text-[17px] leading-[1.7] text-ink";
const li = "relative pl-6 text-pretty text-[17px] leading-[1.7] text-ink before:absolute before:left-0 before:top-[0.9em] before:h-[2px] before:w-3 before:bg-accent";
const a = "font-semibold text-accent hover:text-ink";

export default function WritePage() {
  return (
    <section className="py-10 md:py-14">
      <Container>
        <div className="mx-auto max-w-[68ch]">
          <p className="text-[11px] font-bold uppercase tracking-[0.16em] text-accent">Write for {PUB_NAME}</p>
          <h1 className="mt-2 text-balance font-display text-[clamp(2rem,5vw,3.4rem)] font-extrabold leading-[1.05] tracking-[-0.03em] text-ink">
            The reading around the record, by someone who did the reading.
          </h1>
          <p className={`${p} mt-8 text-[19px]`}>
            Most notes here are written by the person who makes Witness. Some should not be. If you have spent time with a
            species, a survey, a court file, a protected area, or an idea about how much of the planet should be left to
            everything else, this is the brief.
          </p>

          <h2 className={h2}>What a note is</h2>
          <ul className="mt-4 flex flex-col gap-3">
            <li className={li}>
              One species and one verifiable thing about it, or one question a person actually types into a search box, or
              one term explained properly, or one strategy examined. Not a survey of a topic.
            </li>
            <li className={li}>Between 350 and 950 words. The first paragraph stands on its own: a reader who stops there has the answer.</li>
            <li className={li}>
              Every checkable claim, meaning a year, a count, a percentage, a measurement, or a formal status category,
              carries at least two independent sources. Sources are URLs a reader can open.
            </li>
            <li className={li}>
              Where the species has a record in{" "}
              <Link href={"/archive" as Route} className={a}>
                the archive
              </Link>
              , the note links to it and does not retell it.
            </li>
            <li className={li}>
              It fits one section: {SECTIONS.map((s) => s.name).join(", ")}. Argument is welcome in all of them, as long as
              the argument is sourced the way a count is.
            </li>
          </ul>

          <h2 className={h2}>What will not be published</h2>
          <ul className="mt-4 flex flex-col gap-3">
            <li className={li}>Lists. No rankings, no ten cutest anything.</li>
            <li className={li}>Daily or hourly extinction figures. The numbers in circulation trace back to an estimate nobody can source cleanly.</li>
            <li className={li}>Exact nests, dens, roosts, or coordinates, even when a source prints them. Ranges stay generalised.</li>
            <li className={li}>Any claim that using Witness, sharing a note, or reading one produces a conservation outcome. It does not, and the site says so.</li>
            <li className={li}>Pieces whose real purpose is a donation link or a product. A citation is not an endorsement, and a note is not an advertisement.</li>
          </ul>
          <p className={p}>
            Every note, guest or house, passes the same gate before it goes live: prohibited phrases, unsupported claims,
            sensitive locations, dead links. The gate is the editor. The standard behind it is on the atlas under{" "}
            <a href={`${ATLAS_URL}/method`} className={a}>
              Method
            </a>
            .
          </p>

          <h2 className={h2}>The terms</h2>
          <ul className="mt-4 flex flex-col gap-3">
            <li className={li}>Your name on the note, and one link of your choosing under it. The words stay yours to publish elsewhere afterwards.</li>
            <li className={li}>Edits are for the gate and for length, not for voice. You see the final text before it ships.</li>
            <li className={li}>There is no payment for a guest note at present. That is stated here so nobody has to ask.</li>
            <li className={li}>A published note appears on this site, in the RSS feed, and in the email that rounds up new notes.</li>
          </ul>

          <h2 className={h2}>How to pitch</h2>
          <p className={p}>
            Send two sentences and the sources you would use to{" "}
            <a href={`mailto:${CONTACT_EMAIL}?subject=${encodeURIComponent("Field note pitch")}`} className={a}>
              {CONTACT_EMAIL}
            </a>{" "}
            with the subject line &ldquo;Field note pitch&rdquo;. A draft is welcome but not required. Every pitch is read by
            the person who makes Witness.
          </p>
        </div>
      </Container>
    </section>
  );
}
