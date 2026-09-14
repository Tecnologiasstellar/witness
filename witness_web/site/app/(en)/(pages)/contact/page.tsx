import type { Metadata } from "next";
import { Container, Eyebrow, TextLink } from "@/components/atlas";

const inline = "text-sepia underline decoration-hairline/70 decoration-1 underline-offset-[5px] transition-colors duration-200 ease-out hover:text-ink hover:decoration-current";
import { Breadcrumbs } from "@/components/record";
import { CONTACT_EMAIL, INSTAGRAM_URL } from "@/lib/archive";

export const metadata: Metadata = {
  title: "Contact",
  description: "Write to the person who makes Witness: a correction, an accessibility problem, a privacy question, or a bug.",
  alternates: { canonical: "/contact" },
};

const heading = "text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia";
const body = "mt-4 text-pretty text-[16px] leading-[1.7] text-ink-muted";

export default function ContactPage() {
  return (
    <section className="py-12 md:py-16">
      <Container>
        <Breadcrumbs trail={[{ href: "/", label: "Witness" }, { label: "Contact" }]} />
        <div className="mt-8 max-w-[62ch]">
          <Eyebrow className="text-sepia">Contact</Eyebrow>
          <h1 className="mt-6 text-balance font-display text-[clamp(2rem,5vw,3.5rem)] font-semibold leading-[1.08] tracking-[-0.01em] text-ink">
            Write to a person, not a form.
          </h1>

          <div className="mt-10">
            <h2 className={heading}>Email</h2>
            <p className={body}>
              Witness is made by one person. For a bug, an accessibility problem, a privacy question, or anything about a card, write to{" "}
              <a href={`mailto:${CONTACT_EMAIL}`} className={inline}>{CONTACT_EMAIL}</a>. Please leave out private note text and precise locations of sensitive species.
            </p>
          </div>

          <div className="mt-10">
            <h2 className={heading}>Report a correction</h2>
            <p className={body}>
              Every card is source-mapped. Include the species, the exact line, and the source you think should be checked. The report is reviewed against the card&rsquo;s evidence before a correction is published, and a changed claim gets a new verification date.
            </p>
          </div>

          <div className="mt-10">
            <h2 className={heading}>Follow along</h2>
            <p className={body}>
              New plates and field notes are posted on{" "}
              <a href={INSTAGRAM_URL} target="_blank" rel="noreferrer noopener" className={inline}>
                Instagram&nbsp;↗
              </a>
              .
            </p>
          </div>

          <p className="mt-10 text-[14px] leading-relaxed text-ink-muted">
            See also <TextLink href="/privacy">Privacy</TextLink> and <TextLink href="/terms">Terms</TextLink>.
          </p>
        </div>
      </Container>
    </section>
  );
}
