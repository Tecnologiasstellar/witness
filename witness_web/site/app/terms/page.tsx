import type { Metadata } from "next";
import { Container, Eyebrow, TextLink } from "@/components/atlas";
import { Breadcrumbs } from "@/components/record";

export const metadata: Metadata = {
  title: "Terms",
  description: "Current terms for the Witness website and the iOS app in development, including the limits of editorial and commerce claims.",
  alternates: { canonical: "/terms" },
};

const SECTIONS: [string, string[]][] = [
  ["The service", ["Witness is an editorial website and an iOS app in development. The intended ritual presents one featured species, a sourced story, a private act of attention, and one credible action. Content is educational and editorial, not scientific, legal, medical, investment, or donation advice. A citation does not imply affiliation or endorsement."]],
  ["Honest limits", ["A Witness, count, share, streak, or opened link does not itself save, fund, or protect anything. The website publishes approved catalog records and visible sources, but facts can change and errors can occur. Corrections are reviewed against the cited record before publication."]],
  ["Purchases are not available today", ["The proposed access model includes a permanent Field Season purchase, six-month and annual Atlas subscriptions with the same access, and a one-time Support Witness tip with no content entitlement. These choices and product identifiers remain subject to founder approval and production testing.", "If commerce is approved and released, the displayed StoreKit terms and localized price will control the transaction. Release terms will be updated to match App Store Connect and RevenueCat configuration. Apple’s standard licensed-application end user license agreement will apply to the released app."]],
  ["Your content and Witness content", ["Private reflections you write belong to you and are designed to stay on your device. Website and app text, original illustrations, and design may not be reproduced commercially without permission, except where an individual source or license says otherwise. Final share-card rights will be stated in the released app."]],
  ["No warranty", ["The website and development builds are provided as is, without warranties of uninterrupted availability or perfect accuracy. To the extent permitted by applicable law, Witness is not liable for indirect or consequential damages arising from their use. Nothing here limits rights that cannot legally be limited."]],
  ["Changes and contact", ["These terms will change before commercial release so they match the final product, jurisdiction, and store configuration. Material changes will be dated. Questions: albertovillalpando@gmail.com."]],
];

export default function TermsPage() {
  return <section className="py-12 md:py-16"><Container><Breadcrumbs trail={[{ href: "/", label: "Witness" }, { label: "Terms" }]} /><div className="mt-8 max-w-[62ch]"><Eyebrow className="text-sepia">Development terms · updated 2026-08-26</Eyebrow><h1 className="mt-6 text-balance font-display text-[clamp(2rem,5vw,3.5rem)] font-semibold leading-[1.08] tracking-[-0.01em] text-ink">Plain terms for a product still earning release.</h1>{SECTIONS.map(([heading, paragraphs]) => <div key={heading} className="mt-10"><h2 className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">{heading}</h2>{paragraphs.map((text) => <p key={text.slice(0, 32)} className="mt-4 text-pretty text-[16px] leading-[1.7] text-ink-muted">{text}</p>)}</div>)}<p className="mt-10 text-[14px] leading-relaxed text-ink-muted">Apple&rsquo;s standard EULA: <TextLink href="https://www.apple.com/legal/internet-services/itunes/dev/stdeula/" external>apple.com/legal/…/stdeula&nbsp;↗</TextLink></p></div></Container></section>;
}
