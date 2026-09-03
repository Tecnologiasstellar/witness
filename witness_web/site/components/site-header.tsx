import type { Route } from "next";
import Link from "next/link";
import { Container, GITHUB_URL } from "./atlas";

const NAV = [
  { href: "/#experience", label: "Experience" },
  { href: "/witnesses", label: "Archive" },
  { href: "/method", label: "Method" },
  { href: "/#faq", label: "Questions" },
];

const linkClass =
  "inline-flex min-h-11 items-center text-[15px] text-ink-muted transition-colors duration-200 ease-out hover:text-ink focus-visible:text-ink";

export function SiteHeader() {
  return (
    <header className="sticky top-0 z-30 border-b border-hairline/50 bg-paper/95 shadow-[0_3px_0_-2px_color-mix(in_srgb,var(--hairline)_45%,transparent)] supports-[backdrop-filter]:backdrop-blur-sm">
      <Container className="flex flex-col gap-0 py-4 md:flex-row md:items-center md:justify-between">
        <div className="flex items-center justify-between gap-4">
          <Link
            href="/"
            className="inline-flex min-h-11 items-center gap-3 font-display text-xl font-semibold tracking-tight text-ink"
            translate="no"
          >
            Witness
            <span
              aria-hidden="true"
              className="hidden text-[10px] font-semibold uppercase tracking-[0.18em] text-sepia sm:inline"
            >
              Field archive · 30 records
            </span>
          </Link>

          {/* Compact disclosure menu, no client JavaScript. */}
          <details className="group md:hidden">
            <summary className="inline-flex min-h-11 min-w-11 cursor-pointer list-none items-center justify-end gap-2 text-[13px] font-semibold uppercase tracking-[0.14em] text-sepia [&::-webkit-details-marker]:hidden">
              Menu
              <span
                aria-hidden="true"
                className="relative block h-3 w-3 before:absolute before:left-0 before:top-1.5 before:h-px before:w-3 before:bg-current after:absolute after:left-0 after:top-1.5 after:h-px after:w-3 after:bg-current after:transition-transform after:duration-200 after:ease-out after:[transform:rotate(90deg)] group-open:after:[transform:rotate(0deg)]"
              />
            </summary>
            <nav
              aria-label="Primary"
              className="absolute left-0 right-0 z-10 mt-4 border-y border-hairline/50 bg-paper-fresh"
            >
              <ul className="mx-auto flex w-[min(1200px,calc(100vw-48px))] flex-col divide-y divide-hairline/40">
                {NAV.map((item) => (
                  <li key={item.href}>
                    <Link
                      href={item.href as Route}
                      className={`${linkClass} w-full py-1`}
                    >
                      {item.label}
                    </Link>
                  </li>
                ))}
                <li>
                  <a
                    href={GITHUB_URL}
                    target="_blank"
                    rel="noreferrer noopener"
                    className={`${linkClass} w-full py-1 text-ink`}
                  >
                    View project&nbsp;↗
                  </a>
                </li>
              </ul>
            </nav>
          </details>
        </div>

        <nav aria-label="Primary" className="hidden md:block">
          <ul className="flex items-center gap-8">
            {NAV.map((item) => (
              <li key={item.href}>
                <Link href={item.href as Route} className={linkClass}>
                  {item.label}
                </Link>
              </li>
            ))}
            <li>
              <a
                href={GITHUB_URL}
                target="_blank"
                rel="noreferrer noopener"
                className={`${linkClass} text-ink underline decoration-hairline/70 decoration-1 underline-offset-[5px] hover:decoration-current`}
              >
                View project&nbsp;↗
              </a>
            </li>
          </ul>
        </nav>
      </Container>
    </header>
  );
}
