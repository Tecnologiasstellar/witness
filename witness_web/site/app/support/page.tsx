import type { Metadata } from "next";
import { Container, Eyebrow, TextLink } from "@/components/atlas";
import { Breadcrumbs } from "@/components/record";

export const metadata: Metadata = {
  title: "Support",
  description: "Get help with Witness, report a factual correction, or check the current availability of counts and purchases.",
  alternates: { canonical: "/support" },
};

const SECTIONS: [string, string[]][] = [
  ["Contact", ["Witness is built by one person. For a bug, accessibility problem, privacy question, or catalog issue, write to albertovillalpando@gmail.com. Do not include precise sensitive-species locations or private reflection text."]],
  ["Report a correction", ["Every published record is source-mapped. Include the species, the exact line, and the source you think should be checked. The report will be reviewed against the catalog evidence before a correction is published."]],
  ["Counts and purchases", ["No public collective count or purchase flow is available today. The production backend, RevenueCat Test Store, App Store Sandbox, restore, cancellation, expiry, and production-key gates are still pending. Any page claiming otherwise is outdated and should be reported."]],
  ["Common questions", ["Is the app available? Not yet. The iOS MVP and approved 30-record catalog exist, but the public App Store release gate is pending.", "Where are reflections designed to go? Into protected on-device storage, not a public profile or social feed. Final backup and deletion behavior still requires release-candidate verification.", "What will the collective count mean? A reconciled aggregate of Witness events only. It will not mean an animal was saved, a donation was made, or a conservation outcome occurred."]],
];

export default function SupportPage() {
  return <section className="py-12 md:py-16"><Container><Breadcrumbs trail={[{ href: "/", label: "Witness" }, { label: "Support" }]} /><div className="mt-8 max-w-[62ch]"><Eyebrow className="text-sepia">Support · current availability</Eyebrow><h1 className="mt-6 text-balance font-display text-[clamp(2rem,5vw,3.5rem)] font-semibold leading-[1.08] tracking-[-0.01em] text-ink">Write to a person, not a form.</h1>{SECTIONS.map(([heading, paragraphs]) => <div key={heading} className="mt-10"><h2 className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">{heading}</h2>{paragraphs.map((text) => <p key={text.slice(0, 32)} className="mt-4 text-pretty text-[16px] leading-[1.7] text-ink-muted">{text}</p>)}</div>)}<p className="mt-10 text-[14px] leading-relaxed text-ink-muted">See also <TextLink href="/privacy">Privacy</TextLink> and <TextLink href="/terms">Terms</TextLink>.</p></div></Container></section>;
}
