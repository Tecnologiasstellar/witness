import type { ReactNode } from "react";
import type { Route } from "next";
import Link from "next/link";
import type { Post } from "@/lib/posts";
import type { SpeciesRecord } from "@/lib/species";
import { APP_STORE_URL, ATLAS_URL, FEED_PATH, SUBSCRIBE_URL, formatDate, plateUrl, sectionByKey } from "@/lib/site";
import { Button, Container } from "./shell";

export function SectionChip({ post, className = "" }: { post: Post; className?: string }) {
  const section = sectionByKey(post.section);
  if (!section) return null;
  return (
    <Link
      href={`/s/${section.key}` as Route}
      className={`inline-flex min-h-8 items-center text-[11px] font-bold uppercase tracking-[0.14em] text-accent hover:text-ink ${className}`}
    >
      {section.name}
    </Link>
  );
}

export function Meta({ post, className = "" }: { post: Post; className?: string }) {
  return (
    <p className={`flex flex-wrap items-center gap-x-2 text-[13px] text-muted ${className}`}>
      <span className="font-semibold text-ink">{post.author ?? "Witness"}</span>
      <span aria-hidden="true">·</span>
      <time dateTime={post.date}>{formatDate(post.date)}</time>
      <span aria-hidden="true">·</span>
      <span>{post.minutes} min read</span>
    </p>
  );
}

/** The lead story: full-width plate, large title. */
export function LeadCard({ post }: { post: Post }) {
  return (
    <article className="group">
      <Link href={`/p/${post.slug}` as Route} className="block">
        <img
          src={plateUrl(post.image)}
          alt=""
          width={1400}
          height={933}
          className="plate"
          fetchPriority="high"
        />
      </Link>
      <div className="mt-5">
        <SectionChip post={post} />
        <h2 className="mt-2 max-w-[24ch] text-balance font-display text-[clamp(1.75rem,3.6vw,2.6rem)] font-extrabold leading-[1.08] tracking-[-0.025em] text-ink">
          <Link href={`/p/${post.slug}` as Route} className="transition-colors group-hover:text-accent">
            {post.title}
          </Link>
        </h2>
        <p className="mt-3 max-w-[60ch] text-pretty text-[17px] leading-[1.6] text-muted">{post.description}</p>
        <Meta post={post} className="mt-4" />
      </div>
    </article>
  );
}

/** Grid card: plate on top, title, dek, byline. */
export function PostCard({ post, dek = true }: { post: Post; dek?: boolean }) {
  return (
    <article className="group flex flex-col">
      <Link href={`/p/${post.slug}` as Route} className="block">
        <img src={plateUrl(post.image)} alt="" width={700} height={467} loading="lazy" className="plate" />
      </Link>
      <div className="mt-4 flex flex-1 flex-col">
        <SectionChip post={post} />
        <h3 className="mt-1 text-pretty font-display text-[20px] font-bold leading-[1.2] tracking-[-0.015em] text-ink">
          <Link href={`/p/${post.slug}` as Route} className="transition-colors group-hover:text-accent">
            {post.title}
          </Link>
        </h3>
        {dek ? <p className="mt-2 text-pretty text-[15px] leading-[1.55] text-muted">{post.description}</p> : null}
        <Meta post={post} className="mt-auto pt-3" />
      </div>
    </article>
  );
}

/** Row card: small plate left, title right. For side rails and the Latest list. */
export function RowCard({ post, big = false }: { post: Post; big?: boolean }) {
  return (
    <article className={`group grid gap-4 ${big ? "grid-cols-[minmax(120px,200px)_1fr]" : "grid-cols-[112px_1fr]"}`}>
      <Link href={`/p/${post.slug}` as Route} className="block">
        <img src={plateUrl(post.image)} alt="" width={400} height={267} loading="lazy" className="plate" />
      </Link>
      <div className="min-w-0">
        <SectionChip post={post} />
        <h3
          className={`mt-0.5 text-pretty font-display font-bold leading-[1.2] tracking-[-0.015em] text-ink ${
            big ? "text-[20px] md:text-[22px]" : "text-[16px] md:text-[17px]"
          }`}
        >
          <Link href={`/p/${post.slug}` as Route} className="transition-colors group-hover:text-accent">
            {post.title}
          </Link>
        </h3>
        {big ? <p className="mt-2 hidden text-pretty text-[15px] leading-[1.55] text-muted sm:block">{post.description}</p> : null}
        <Meta post={post} className="mt-2" />
      </div>
    </article>
  );
}

export function SectionHeading({
  title,
  blurb,
  href,
  more = "View more",
}: {
  title: string;
  blurb?: string;
  href?: string;
  more?: string;
}) {
  return (
    <div className="flex flex-wrap items-end justify-between gap-x-8 gap-y-2 border-b-2 border-ink pb-3">
      <div>
        <h2 className="font-display text-[13px] font-extrabold uppercase tracking-[0.16em] text-ink">
          {href ? (
            <Link href={href as Route} className="hover:text-accent">
              {title}
            </Link>
          ) : (
            title
          )}
        </h2>
        {blurb ? <p className="mt-1 text-[14px] text-muted">{blurb}</p> : null}
      </div>
      {href ? (
        <Link href={href as Route} className="inline-flex min-h-9 items-center text-[13px] font-semibold text-accent hover:text-ink">
          {more}&nbsp;→
        </Link>
      ) : null}
    </div>
  );
}

export function Section({ children, className = "" }: { children: ReactNode; className?: string }) {
  return (
    <section className={`py-10 md:py-12 ${className}`}>
      <Container>{children}</Container>
    </section>
  );
}

/** A record from the atlas: plate and name. Links out; the record is not restated here. */
export function RecordCard({ record }: { record: SpeciesRecord }) {
  return (
    <a href={`${ATLAS_URL}/archive/${record.id}`} className="group block">
      <img
        src={plateUrl(record.gallery[0] ?? `${record.id}-plate-01`)}
        alt=""
        width={400}
        height={267}
        loading="lazy"
        className="plate"
      />
      <p className="mt-2 text-[15px] font-bold leading-tight text-ink transition-colors group-hover:text-accent">
        {record.commonName}
      </p>
      <p className="mt-0.5 text-[12px] text-muted">{record.conservationStatus.displayName}</p>
    </a>
  );
}

/** The subscribe band. Honest in both states: email once the provider exists, RSS always. */
export function SubscribeBand({ compact = false }: { compact?: boolean }) {
  return (
    <section className={`bg-accent text-on-accent ${compact ? "rounded-lg" : ""}`}>
      <div className={compact ? "px-6 py-8 md:px-10" : ""}>
        {compact ? (
          <Band compact />
        ) : (
          <Container>
            <Band />
          </Container>
        )}
      </div>
    </section>
  );
}

function Band({ compact = false }: { compact?: boolean }) {
  return (
    <div className={`flex flex-col gap-6 md:flex-row md:items-center md:justify-between ${compact ? "" : "py-12"}`}>
      <div>
        <p className="text-[11px] font-bold uppercase tracking-[0.16em] opacity-80">Free on iPhone</p>
        <p className="mt-2 font-display text-[clamp(1.4rem,3vw,2rem)] font-extrabold leading-[1.15] tracking-[-0.02em]">
          Reading is where it starts.
        </p>
        <p className="mt-2 max-w-[52ch] text-[16px] leading-[1.6] opacity-90">
          Witness brings one species a week to your phone: a drawn plate, its true story with sources, and one honest
          action. These notes are the reading between them.
        </p>
      </div>
      <div className="flex flex-col items-start gap-3">
        <div className="flex flex-wrap items-center gap-3">
          <Button href={APP_STORE_URL} external tone="ink" className="!bg-on-accent !text-accent hover:!bg-ink hover:!text-bg">
            Download on the App Store
          </Button>
          <Link
            href={(SUBSCRIBE_URL || "/subscribe") as Route}
            {...(SUBSCRIBE_URL ? { target: "_blank", rel: "noreferrer noopener" } : {})}
            className="press inline-flex min-h-11 items-center rounded-md border border-on-accent/60 px-5 text-[15px] font-semibold hover:bg-on-accent hover:text-accent"
          >
            {SUBSCRIBE_URL ? "Get new notes by email" : "Get new notes"}
          </Link>
        </div>
        <a href={FEED_PATH} className="text-[13px] font-semibold underline underline-offset-4 opacity-80 hover:opacity-100">
          Or follow by RSS
        </a>
      </div>
    </div>
  );
}
