import type { Metadata } from "next";
import { Container, Eyebrow } from "@/components/atlas";
import { Breadcrumbs } from "@/components/record";

export const metadata: Metadata = {
  title: "Privacy",
  description: "The current privacy boundary for the Witness website and planned iOS app, with unverified production behavior clearly marked.",
  alternates: { canonical: "/privacy" },
};

const SECTIONS: [string, string[]][] = [
  ["This website today", ["This website uses no account, email capture, analytics, advertising, or cookies. It serves public editorial pages and original illustrations only."]],
  ["The app in development", ["The iOS app is not publicly released. Its planned production design uses a random installation identifier for idempotent Witness events and purchase authorization without creating a social account. Production behavior is not claimed until backend and privacy gates pass.", "The planned service accepts one idempotent Witness event per installation and species assignment, then returns an aggregate count. Exact production fields, retention, deletion behavior, and security rules remain release gates."]],
  ["Private reflections", ["Private reflections are designed to remain in protected on-device storage. They are not part of the planned server event or share image. Device-backup and deletion behavior must be verified against the release candidate before a final privacy promise is published.", "Daily reminders are designed as local notifications. The release candidate must verify that no push token or precise location is collected."]],
  ["Purchases", ["Field Season, Atlas, and Support Witness are proposed purchase choices. They are not available today. If approved and released, Apple will process payment and RevenueCat will manage entitlement state without exposing payment-card details to Witness. Final identifiers, disclosures, and production behavior remain unverified gates."]],
  ["Tracking and disclosure", ["The current website contains no advertising SDKs, third-party analytics, fingerprinting, or data sales. The app’s final App Store privacy label has not been approved and must match the production implementation before release."]],
  ["Deletion and retention", ["Final deletion and retention behavior is not yet production-verified. Before release, the policy, server retention, on-device deletion, purchase records, and App Store disclosures must agree. Apple may retain purchase records under its own terms."]],
  ["Contact", ["Privacy questions: albertovillalpando@gmail.com. Do not email private reflection text or precise sensitive-species locations. Material policy changes will be dated and stated in plain language."]],
];

export default function PrivacyPage() {
  return <section className="py-12 md:py-16"><Container><Breadcrumbs trail={[{ href: "/", label: "Witness" }, { label: "Privacy" }]} /><div className="mt-8 max-w-[62ch]"><Eyebrow className="text-sepia">Privacy boundary · updated 2026-08-26</Eyebrow><h1 className="mt-6 text-balance font-display text-[clamp(2rem,5vw,3.5rem)] font-semibold leading-[1.08] tracking-[-0.01em] text-ink">Privacy promises must match the released code.</h1>{SECTIONS.map(([heading, paragraphs]) => <div key={heading} className="mt-10"><h2 className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">{heading}</h2>{paragraphs.map((text) => <p key={text.slice(0, 32)} className="mt-4 text-pretty text-[16px] leading-[1.7] text-ink-muted">{text}</p>)}</div>)}</div></Container></section>;
}
