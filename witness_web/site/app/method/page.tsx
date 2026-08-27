import type { Metadata } from "next";
import { Container, Eyebrow, PrimaryLink, TextLink } from "@/components/atlas";
import { Breadcrumbs } from "@/components/record";
import { CATALOGUE } from "@/lib/archive";

export const metadata: Metadata = {
  title: "Method",
  description: "The evidence standard behind Witness records, original illustrations, public claims, privacy boundaries, and release status.",
  alternates: { canonical: "/method" },
};

const CLAIMS = [
  ["Native product", "A native SwiftUI iOS MVP exists.", "Not yet on the App Store. Physical-device release evidence is pending."],
  ["Catalog", `${CATALOGUE.published} bundled records have approved editorial and media states.`, "Catalog approval does not prove public app release or production services."],
  ["Artwork", "Published illustrations have exact generation IDs, commercial-use confirmation, and species-accuracy review.", "They are original illustrations, not documentary photographs."],
  ["Backend", "A privacy-preserving, idempotent count architecture is implemented and documented.", "Production count integrity and hosted behavior are not yet verified."],
  ["Commerce", "Field Season, Atlas, and Support Witness are the proposed access model.", "Founder approval, store products, real purchases, restore, expiry, and production keys are pending."],
  ["Privacy", "This website has no analytics, cookies, account, or email capture.", "The app’s final retention, deletion, SDK, and privacy-label behavior is pending."],
  ["Impact", "A Witness records an act of attention.", "It does not prove an animal was saved, money reached conservation, or an outcome occurred."],
] as const;

const RECORD_STANDARD = [
  ["Sources", "Every material passage maps to declared sources with retrieval and verification context."],
  ["Editorial state", "Prototype, draft, pending review, approved, unavailable, and error states remain distinct. Only approved earns release language."],
  ["Media rights", "Every asset records creator, source, rights state, commercial-use decision, attribution, exact identifier, and accuracy review."],
  ["Location safety", "Ranges stay generalized. Exact nests, dens, coordinates, and pressured population locations are withheld."],
  ["Corrections", "Reports are checked against the source record. Changed claims receive a new verification date."],
] as const;

export default function MethodPage() {
  return <>
    <section className="border-b border-hairline/50 py-12 md:py-20"><Container><Breadcrumbs trail={[{ href: "/", label: "Witness" }, { label: "Method" }]} /><div className="mt-8 grid gap-10 md:grid-cols-12"><div className="md:col-span-7"><Eyebrow className="text-sepia">Evidence standard · verified 2026-08-26</Eyebrow><h1 className="mt-6 max-w-[17ch] text-balance font-display text-[clamp(2.4rem,6vw,5rem)] font-semibold leading-[.98] tracking-[-0.03em] text-ink">Trust is a product feature, not a tone of voice.</h1></div><p className="dropcap max-w-[52ch] text-pretty text-[17px] leading-[1.7] text-ink-muted md:col-span-5 md:pt-4">A public statement is allowed only when a repository source supports its exact scope. The canonical claim ledger records the evidence, wording, owner, verification date, and release gate. The table below is its public summary.</p></div></Container></section>

    <section className="py-16 md:py-24"><Container><h2 className="max-w-[18ch] text-balance font-display text-[clamp(2rem,4.5vw,3.5rem)] font-semibold leading-[1.05] text-ink">What Witness can say today.</h2><div className="mt-12 hidden grid-cols-[.7fr_1fr_1fr] gap-8 border-b border-hairline/50 pb-3 md:grid"><p className="text-[10px] font-semibold uppercase tracking-[.18em] text-sepia">Area</p><p className="text-[10px] font-semibold uppercase tracking-[.18em] text-sepia">Evidence-backed wording</p><p className="text-[10px] font-semibold uppercase tracking-[.18em] text-sepia">Boundary</p></div><ul>{CLAIMS.map(([area, safe, boundary]) => <li key={area} className="grid gap-3 border-b border-hairline/40 py-6 md:grid-cols-[.7fr_1fr_1fr] md:gap-8"><h3 className="font-display text-xl font-semibold text-ink">{area}</h3><p className="text-[16px] leading-[1.6] text-ink">{safe}</p><p className="text-[16px] leading-[1.6] text-ink-muted">{boundary}</p></li>)}</ul></Container></section>

    <section className="dusk py-16 md:py-24"><Container><div className="grid gap-12 md:grid-cols-12"><div className="md:col-span-4"><h2 className="font-display text-[clamp(2rem,4vw,3rem)] font-semibold leading-[1.05]">How a record earns release language.</h2><p className="mt-5 max-w-[38ch] text-[16px] leading-[1.7] text-[color:var(--dusk-muted)]">The 30 bundled catalog records currently pass editorial and media validation. The standard still applies to every revision and new record.</p></div><ol className="md:col-span-7 md:col-start-6">{RECORD_STANDARD.map(([term, detail], index) => <li key={term} className="grid grid-cols-[2rem_1fr] gap-4 border-t py-5" style={{ borderColor: "var(--dusk-rule)" }}><span className="font-display text-lg text-[color:var(--dusk-muted)]">{index + 1}</span><div><h3 className="font-display text-xl font-semibold">{term}</h3><p className="mt-1 max-w-[52ch] text-[16px] leading-[1.6] text-[color:var(--dusk-muted)]">{detail}</p></div></li>)}</ol></div></Container></section>

    <section className="py-16 md:py-24"><Container><div className="grid gap-10 md:grid-cols-3"><article className="border-t-2 border-ink pt-6"><h2 className="font-display text-2xl font-semibold">Catalog proof</h2><p className="mt-4 text-[16px] leading-[1.7] text-ink-muted">The website data is a verbatim catalog mirror, not a separate editorial rewrite. Published pages expose sources, review state, rights metadata, and dates.</p></article><article className="border-t-2 border-ink pt-6"><h2 className="font-display text-2xl font-semibold">Service proof</h2><p className="mt-4 text-[16px] leading-[1.7] text-ink-muted">Build, simulator, backend staging, purchase testing, physical device, App Review, and public availability are independent gates. One cannot substitute for another.</p></article><article className="border-t-2 border-ink pt-6"><h2 className="font-display text-2xl font-semibold">Public correction</h2><p className="mt-4 text-[16px] leading-[1.7] text-ink-muted">If a claim exceeds its evidence, the site is corrected first. The release ledger then records what changed and why.</p></article></div></Container></section>

    <section className="border-t border-hairline/50 bg-paper-aged py-16 md:py-20"><Container><div className="grid gap-10 md:grid-cols-12"><div className="md:col-span-7"><h2 className="max-w-[22ch] text-balance font-display text-[clamp(1.75rem,4vw,2.75rem)] font-semibold leading-[1.12]">Inspect the evidence where a visitor can actually use it.</h2></div><div className="md:col-span-4 md:col-start-9"><p className="text-[16px] leading-[1.65]">Read a complete catalog record or see the privacy boundary that must match the release candidate.</p><div className="mt-6 flex flex-wrap gap-x-8"><PrimaryLink href="/witnesses">Browse records</PrimaryLink><TextLink href="/privacy">Privacy</TextLink></div></div></div></Container></section>
  </>;
}
