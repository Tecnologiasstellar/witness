import type { Metadata } from "next";
import { Container, Eyebrow, TextLink } from "@/components/atlas";
import { Breadcrumbs } from "@/components/record";
import { CONTACT_EMAIL } from "@/lib/archive";

export const metadata: Metadata = {
  title: "Terms",
  description: "Plain terms for the Witness website and iPhone app, including what a purchase is and what a Witness does not claim.",
  alternates: { canonical: "/terms" },
};

const SECTIONS: [string, string[]][] = [
  ["The service", ["Witness is an editorial website and an iPhone app. Each week the app presents one featured species, a sourced story, a private act of attention, and one credible action. Content is educational and editorial, not scientific, legal, medical, investment, or donation advice. A citation does not imply affiliation or endorsement."]],
  ["Honest limits", ["A Witness, a count, a share, or an opened link does not itself save, fund, or protect anything. Every card names its sources, but facts change and errors can occur. Corrections are reviewed against the cited source before publication."]],
  ["Purchases", ["Field Season One is a one-time purchase that stays yours. The Atlas is an auto-renewing subscription in six-month or annual terms with identical access; it renews until cancelled in your Apple ID settings. The Support tip is a one-time contribution with no content entitlement.", "Apple processes every purchase under the displayed StoreKit terms and localized price. Apple’s standard licensed-application end user license agreement applies to the app."]],
  ["Your content and Witness content", ["Private notes you write belong to you and stay on your device. Share images the app makes for you are yours to post. Website and app text, original illustrations, and design may not be reproduced commercially without permission, except where an individual source or license says otherwise."]],
  ["No warranty", ["The website and the app are provided as is, without warranties of uninterrupted availability or perfect accuracy. To the extent permitted by applicable law, Witness is not liable for indirect or consequential damages arising from their use. Nothing here limits rights that cannot legally be limited."]],
  ["Changes and contact", [`Material changes to these terms are dated here. Questions: ${CONTACT_EMAIL}.`]],
];

export default function TermsPage() {
  return (
    <section className="py-12 md:py-16">
      <Container>
        <Breadcrumbs trail={[{ href: "/", label: "Witness" }, { label: "Terms" }]} />
        <div className="mt-8 max-w-[62ch]">
          <Eyebrow className="text-sepia">Terms · updated 4 September 2026</Eyebrow>
          <h1 className="mt-6 text-balance font-display text-[clamp(2rem,5vw,3.5rem)] font-semibold leading-[1.08] tracking-[-0.01em] text-ink">Plain terms for a plain product.</h1>
          {SECTIONS.map(([heading, paragraphs]) => (
            <div key={heading} className="mt-10">
              <h2 className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">{heading}</h2>
              {paragraphs.map((text) => (
                <p key={text.slice(0, 32)} className="mt-4 text-pretty text-[16px] leading-[1.7] text-ink-muted">{text}</p>
              ))}
            </div>
          ))}
          <p className="mt-10 text-[14px] leading-relaxed text-ink-muted">
            Apple&rsquo;s standard EULA:{" "}
            <TextLink href="https://www.apple.com/legal/internet-services/itunes/dev/stdeula/" external>
              apple.com/legal/…/stdeula&nbsp;↗
            </TextLink>
          </p>
        </div>
      </Container>
    </section>
  );
}
