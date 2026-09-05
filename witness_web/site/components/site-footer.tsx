import type { Route } from "next";
import Link from "next/link";
import { APP_STORE_URL, INSTAGRAM_URL } from "@/lib/archive";
import { Container } from "./atlas";
import { AppearanceControl } from "./appearance";

const PAGES = [
  { href: "/archive", label: "The Archive" },
  { href: "/field-notes", label: "Field notes" },
  { href: "/method", label: "Method" },
  { href: "/privacy", label: "Privacy" },
  { href: "/terms", label: "Terms" },
  { href: "/contact", label: "Contact" },
];

const ELSEWHERE = [
  { href: APP_STORE_URL, label: "App Store" },
  { href: INSTAGRAM_URL, label: "Instagram" },
];

const linkClass =
  "inline-flex min-h-11 items-center text-[15px] text-ink-muted transition-colors duration-200 ease-out hover:text-ink";

export function SiteFooter() {
  return (
    <footer className="border-t border-hairline/50 bg-paper-fresh py-16 md:py-20">
      <Container>
        <div className="grid gap-10 md:grid-cols-12">
          <div className="md:col-span-5">
            <p className="font-display text-xl font-semibold text-ink" translate="no">
              Witness
            </p>
            <p className="mt-4 max-w-[46ch] text-pretty text-[16px] leading-[1.7] text-ink-muted">
              One endangered species a week. A drawn plate, a sourced story, one honest action.
            </p>
          </div>

          <nav aria-label="Footer" className="md:col-span-3">
            <p className="text-[10px] font-semibold uppercase tracking-[0.18em] text-sepia">Pages</p>
            <ul className="mt-3 flex flex-col">
              {PAGES.map((link) => (
                <li key={link.href}>
                  <Link href={link.href as Route} className={linkClass}>
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </nav>

          <div className="md:col-span-4">
            <p className="text-[10px] font-semibold uppercase tracking-[0.18em] text-sepia">Elsewhere</p>
            <ul className="mt-3 flex flex-col">
              {ELSEWHERE.map((link) => (
                <li key={link.href}>
                  <a href={link.href} target="_blank" rel="noreferrer noopener" className={linkClass}>
                    {link.label}&nbsp;↗
                  </a>
                </li>
              ))}
            </ul>
            <div className="mt-8">
              <AppearanceControl />
            </div>
          </div>
        </div>
        <div className="mt-14 flex flex-wrap items-center justify-between gap-4 border-t border-hairline/50 pt-6 text-[11px] uppercase tracking-[.14em] text-ink-muted">
          <p>Original illustrations · not documentary photography</p>
          <p>© 2026 Alberto Villalpando</p>
        </div>
      </Container>
    </footer>
  );
}
