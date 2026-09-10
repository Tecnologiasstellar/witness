import type { ReactNode } from "react";
import type { Route } from "next";
import Link from "next/link";
import {
  APP_STORE_LIVE,
  APP_STORE_URL,
  ATLAS_URL,
  CONTACT_EMAIL,
  FEED_PATH,
  INSTAGRAM_URL,
  PUB_DESCRIPTION,
  PUB_NAME,
  SECTIONS,
  SUBSCRIBE_URL,
} from "@/lib/site";

/** Page measure: 1200px max, 24px gutters down to 320px. */
export function Container({ children, className = "" }: { children: ReactNode; className?: string }) {
  return <div className={`mx-auto w-[min(1200px,calc(100vw-48px))] ${className}`}>{children}</div>;
}

const NAV: { href: string; label: string }[] = [
  ...SECTIONS.map((s) => ({ href: `/s/${s.key}`, label: s.name })),
  { href: "/archive", label: "The Archive" },
  { href: "/about", label: "About" },
  { href: "/write", label: "Write" },
];

export function Button({
  href,
  children,
  tone = "accent",
  external = false,
  className = "",
}: {
  href: string;
  children: ReactNode;
  tone?: "accent" | "ink" | "ghost";
  external?: boolean;
  className?: string;
}) {
  const skin = {
    accent: "bg-accent text-on-accent hover:bg-ink hover:text-bg",
    ink: "bg-ink text-bg hover:bg-accent hover:text-on-accent",
    ghost: "border border-line text-ink hover:border-ink",
  }[tone];
  const classes = `press inline-flex min-h-11 items-center justify-center gap-2 rounded-md px-5 py-2.5 text-[15px] font-semibold ${skin} ${className}`;
  if (external || !href.startsWith("/")) {
    return (
      <a href={href} target="_blank" rel="noreferrer noopener" className={classes}>
        {children}
      </a>
    );
  }
  return (
    <Link href={href as Route} className={classes}>
      {children}
    </Link>
  );
}

export function SiteHeader() {
  return (
    <header className="sticky top-0 z-30 border-b border-line bg-bg/95 supports-[backdrop-filter]:backdrop-blur-sm">
      <Container className="flex items-center justify-between gap-4 py-3">
        <Link href="/" className="flex items-baseline gap-2" translate="no">
          <span className="font-display text-[24px] font-extrabold tracking-[-0.03em] text-ink">{PUB_NAME}</span>
          <span className="hidden text-[12px] font-medium uppercase tracking-[0.14em] text-muted sm:inline">
            from Witness
          </span>
        </Link>
        <div className="flex items-center gap-2 sm:gap-3">
          <a
            href={FEED_PATH}
            className="hidden min-h-11 items-center text-[13px] font-semibold text-muted hover:text-ink sm:inline-flex"
          >
            RSS
          </a>
          <Button href={SUBSCRIBE_URL || "/subscribe"} external={Boolean(SUBSCRIBE_URL)}>
            Subscribe
          </Button>
        </div>
      </Container>
      <nav aria-label="Sections" className="border-t border-line">
        <Container>
          <ul className="-mx-1 flex gap-1 overflow-x-auto py-1 pr-10 text-[12px] font-bold uppercase tracking-[0.12em] [mask-image:linear-gradient(90deg,#000_calc(100%-3rem),transparent)] [scrollbar-width:none] md:pr-0 md:[mask-image:none]">
            {NAV.map((item) => (
              <li key={item.href} className="shrink-0">
                <Link
                  href={item.href as Route}
                  className="inline-flex min-h-10 items-center rounded px-3 text-muted transition-colors hover:bg-surface hover:text-ink"
                >
                  {item.label}
                </Link>
              </li>
            ))}
          </ul>
        </Container>
      </nav>
    </header>
  );
}

const PUBLICATION = [
  { href: "/about", label: "About" },
  { href: "/write", label: "Write for Field Notes" },
  { href: "/subscribe", label: "Subscribe" },
  { href: FEED_PATH, label: "RSS feed" },
  { href: `mailto:${CONTACT_EMAIL}`, label: "Contact" },
];

const WITNESS = [
  { href: ATLAS_URL, label: "The app" },
  { href: `${ATLAS_URL}/archive`, label: "Species records" },
  { href: `${ATLAS_URL}/method`, label: "Method" },
  { href: `${ATLAS_URL}/privacy`, label: "Privacy" },
  { href: `${ATLAS_URL}/terms`, label: "Terms" },
  ...(APP_STORE_LIVE ? [{ href: APP_STORE_URL, label: "App Store" }] : []),
  { href: INSTAGRAM_URL, label: "Instagram" },
];

const colHead = "text-[11px] font-bold uppercase tracking-[0.16em] text-ink";
const colLink = "inline-flex min-h-9 items-center text-[15px] text-muted transition-colors hover:text-ink";

export function SiteFooter() {
  return (
    <footer className="mt-20 border-t border-line bg-surface py-14">
      <Container>
        <div className="grid gap-10 md:grid-cols-12">
          <div className="md:col-span-5">
            <p className="font-display text-[22px] font-extrabold tracking-[-0.03em] text-ink" translate="no">
              {PUB_NAME}
            </p>
            <p className="mt-3 max-w-[46ch] text-pretty text-[15px] leading-[1.65] text-muted">{PUB_DESCRIPTION}</p>
            <div className="mt-6">
              <Button href={SUBSCRIBE_URL || "/subscribe"} external={Boolean(SUBSCRIBE_URL)}>
                Subscribe
              </Button>
            </div>
          </div>
          <nav aria-label="Sections" className="md:col-span-2">
            <p className={colHead}>Sections</p>
            <ul className="mt-3 flex flex-col">
              {SECTIONS.map((s) => (
                <li key={s.key}>
                  <Link href={`/s/${s.key}` as Route} className={colLink}>
                    {s.name}
                  </Link>
                </li>
              ))}
            </ul>
          </nav>
          <nav aria-label="Publication" className="md:col-span-2">
            <p className={colHead}>Publication</p>
            <ul className="mt-3 flex flex-col">
              {PUBLICATION.map((l) => (
                <li key={l.href}>
                  {l.href.startsWith("/") ? (
                    <Link href={l.href as Route} className={colLink}>
                      {l.label}
                    </Link>
                  ) : (
                    <a href={l.href} className={colLink}>
                      {l.label}
                    </a>
                  )}
                </li>
              ))}
            </ul>
          </nav>
          <nav aria-label="Witness" className="md:col-span-3">
            <p className={colHead}>Witness</p>
            <ul className="mt-3 flex flex-col">
              {WITNESS.map((l) => (
                <li key={l.href}>
                  <a href={l.href} className={colLink}>
                    {l.label}&nbsp;↗
                  </a>
                </li>
              ))}
            </ul>
          </nav>
        </div>
        <div className="mt-12 flex flex-wrap items-center justify-between gap-4 border-t border-line pt-6 text-[11px] uppercase tracking-[0.14em] text-muted">
          <p>Original illustrations · not documentary photography</p>
          <p>© 2026 Alberto Villalpando</p>
        </div>
      </Container>
    </footer>
  );
}
