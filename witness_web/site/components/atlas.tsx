import type { ReactNode } from "react";
import type { Route } from "next";
import Link from "next/link";

const GITHUB_URL = "https://github.com/Tecnologiasstellar/witness";

/** Page measure: 1200px max, 24px gutters down to 320px. */
export function Container({
  children,
  className = "",
}: {
  children: ReactNode;
  className?: string;
}) {
  return (
    <div className={`mx-auto w-[min(1200px,calc(100vw-48px))] ${className}`}>
      {children}
    </div>
  );
}

/** Procedural paper grain. Fixed, inert, and removed under reduced transparency. */
export function Grain() {
  return <div className="grain" aria-hidden="true" />;
}

/** Fine engraved rule with an optional corner tick. Decorative only. */
export function AtlasRule({
  tick = false,
  className = "",
}: {
  tick?: boolean;
  className?: string;
}) {
  return (
    <div aria-hidden="true" className={`relative ${className}`}>
      <div className="h-px w-full bg-hairline/60" />
      {tick ? (
        <div className="absolute left-0 top-0 h-2 w-px bg-hairline/70" />
      ) : null}
    </div>
  );
}

/** Sparse uppercase label. At most one every three sections. */
export function Eyebrow({
  children,
  className = "",
}: {
  children: ReactNode;
  className?: string;
}) {
  return (
    <p
      className={`flex items-center gap-3 text-[10px] font-semibold uppercase tracking-[0.14em] sm:text-[11px] sm:tracking-[0.18em] ${className}`}
    >
      <span
        aria-hidden="true"
        className="hidden h-px w-8 bg-current opacity-50 sm:block"
      />
      {children}
    </p>
  );
}

/** Ink-on-paper primary action; inverts on the dusk band. 44px minimum target. */
/** Internal routes use next/link; hashes and external URLs stay plain anchors. */
function isRoute(href: string) {
  return href.startsWith("/");
}

export function PrimaryLink({
  href,
  children,
  external = false,
  tone = "paper",
}: {
  href: string;
  children: ReactNode;
  external?: boolean;
  tone?: "paper" | "dusk";
}) {
  const skin =
    tone === "dusk"
      ? "bg-paper text-ink hover:bg-[color:var(--dusk-muted)] focus-visible:bg-[color:var(--dusk-muted)]"
      : "bg-ink text-paper hover:bg-sepia focus-visible:bg-sepia";
  const className = `group inline-flex min-h-11 items-center justify-center gap-3 px-6 py-3 text-[15px] font-semibold transition-colors duration-200 ease-out ${skin}`;
  const inner = (
    <>
      {children}
      <span
        aria-hidden="true"
        className="h-px w-6 origin-left bg-current transition-transform duration-200 ease-out group-hover:scale-x-[1.4]"
      />
    </>
  );
  if (!external && isRoute(href)) {
    return (
      <Link href={href as Route} className={className}>
        {inner}
      </Link>
    );
  }
  return (
    <a
      href={href}
      {...(external ? { target: "_blank", rel: "noreferrer noopener" } : {})}
      className={className}
    >
      {inner}
    </a>
  );
}

/** Sepia text link with a permanent underline affordance. */
export function TextLink({
  href,
  children,
  external = false,
  tone = "paper",
  className = "",
}: {
  href: string;
  children: ReactNode;
  external?: boolean;
  tone?: "paper" | "dusk";
  className?: string;
}) {
  const skin =
    tone === "dusk"
      ? "text-paper decoration-[color:var(--dusk-rule)] hover:decoration-current"
      : "text-sepia decoration-hairline/70 hover:text-ink hover:decoration-current focus-visible:text-ink";
  const classes = `inline-flex min-h-11 items-center gap-1 text-[15px] font-medium underline decoration-1 underline-offset-[5px] transition-colors duration-200 ease-out ${skin} ${className}`;
  if (!external && isRoute(href)) {
    return (
      <Link href={href as Route} className={classes}>
        {children}
      </Link>
    );
  }
  return (
    <a
      href={href}
      {...(external ? { target: "_blank", rel: "noreferrer noopener" } : {})}
      className={classes}
    >
      {children}
    </a>
  );
}

export { GITHUB_URL };
