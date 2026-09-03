import type { Route } from "next";
import Link from "next/link";
import { Container, GITHUB_URL, TextLink } from "./atlas";
import { AppearanceControl } from "./appearance";

const LINKS = [
  { href: "/witnesses", label: "Field archive" },
  { href: "/field-notes", label: "Field notes" },
  { href: "/method", label: "Method" },
  { href: "/#experience", label: "Experience" },
  { href: "/#faq", label: "Questions" },
  { href: "/privacy", label: "Privacy" },
  { href: "/terms", label: "Terms" },
  { href: "/support", label: "Support" },
];

export function SiteFooter() {
  return (
    <footer className="border-t border-hairline/50 bg-paper-fresh py-16 md:py-20">
      <Container>
        <div className="grid gap-10 md:grid-cols-12">
          <div className="md:col-span-5">
            <p
              className="font-display text-xl font-semibold text-ink"
              translate="no"
            >
              Witness
            </p>
            <p className="mt-4 max-w-[52ch] text-pretty text-[16px] leading-[1.7] text-ink-muted">
              Meet one species. Read the evidence. Record attention privately. Take one honest next step.
            </p>
            <div className="mt-6">
              <TextLink href={GITHUB_URL} external>
                github.com/Tecnologiasstellar/witness&nbsp;↗
              </TextLink>
            </div>
          </div>

          <nav aria-label="Footer" className="md:col-span-3">
            <p className="text-[10px] font-semibold uppercase tracking-[0.18em] text-sepia">
              Pages
            </p>
            <ul className="mt-3 flex flex-col">
              {LINKS.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href as Route}
                    className="inline-flex min-h-11 items-center text-[15px] text-ink-muted transition-colors duration-200 ease-out hover:text-ink"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </nav>

          <div className="md:col-span-4">
            <AppearanceControl />
            <p className="mt-8 max-w-[46ch] text-pretty text-[13px] leading-relaxed text-ink-muted">
              Sources, rights, privacy, and release readiness are product requirements. Witness is not yet available on the App Store.
            </p>
          </div>
        </div>
        <div className="mt-14 flex flex-wrap items-center justify-between gap-4 border-t border-hairline/50 pt-6 text-[11px] uppercase tracking-[.14em] text-ink-muted">
          <p>Original illustrations · not documentary photography</p>
          <p>Updated 26 August 2026</p>
        </div>
      </Container>
    </footer>
  );
}
