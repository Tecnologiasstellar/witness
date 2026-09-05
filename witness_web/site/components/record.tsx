import type { ReactNode } from "react";
import type { PlateKind, Program, SpeciesRecord } from "@/lib/archive";
import { formatDate, orderedSources, plate, sourceMark } from "@/lib/archive";
import { TextLink } from "./atlas";

/** Status is written in words. Colour never carries it. */
export function StatusBadge({ status, note }: { status: string; note?: string }) {
  return (
    <span className="inline-flex flex-col items-start gap-2">
      <span className="inline-flex min-h-11 items-center gap-3 border border-ink px-4 py-2">
        <span aria-hidden="true" className="inline-block h-2 w-2 rotate-45 border border-ink bg-ink" />
        <span className="text-[13px] font-semibold uppercase tracking-[0.16em] text-ink">{status}</span>
      </span>
      {note ? <span className="max-w-[46ch] text-[12px] leading-relaxed text-ink-muted">{note}</span> : null}
    </span>
  );
}

const ALT: Record<PlateKind, (name: string) => string> = {
  plate: (name) => `Original illustration of the ${name}`,
  context: (name) => `The ${name} in its habitat, an original illustration`,
  detail: (name) => `Field study of the ${name}, an original illustration`,
  behavior: (name) => `The ${name} observed in the field, an original illustration`,
  scale: (name) => `The ${name} drawn to scale beside a human figure`,
};

/** One of the record's five plates, captioned the way the app captions it. */
export function Plate({
  record,
  kind,
  caption,
  eager = false,
  className = "",
}: {
  record: SpeciesRecord;
  kind: PlateKind;
  caption?: string;
  eager?: boolean;
  className?: string;
}) {
  const { src, width, height } = plate(record, kind);
  return (
    <figure className={`m-0 ${className}`}>
      <img
        src={src}
        width={width}
        height={height}
        alt={ALT[kind](record.commonName)}
        className="h-auto w-full border border-hairline/40 bg-paper-aged"
        loading={eager ? undefined : "lazy"}
        decoding="async"
        fetchPriority={eager ? "high" : undefined}
      />
      {caption ? (
        <figcaption className="mt-3 text-[10px] font-semibold uppercase tracking-[0.18em] text-sepia">{caption}</figcaption>
      ) : null}
    </figure>
  );
}

const TREND: Record<string, [string, string]> = {
  decreasing: ["↓", "decreasing"],
  increasing: ["↑", "increasing"],
  stable: ["→", "stable"],
};

/** Size, lifespan, diet, remaining — the four tiles under the hook on the phone. */
export function StatsGrid({ stats }: { stats: NonNullable<SpeciesRecord["stats"]> }) {
  const [glyph, trend] = TREND[stats.trend] ?? ["·", "trend unknown"];
  const remaining = stats.populationEstimate
    ? [stats.populationEstimate, stats.populationAsOf].filter(Boolean).join(" ")
    : "Not yet verified";
  const tiles: [string, string, ReactNode?][] = [
    ["Size", stats.size],
    ["Lifespan", stats.lifespan],
    ["Diet", stats.diet],
    ["Remaining", remaining, <span key="t" aria-label={trend} className="ml-1">{glyph}</span>],
  ];
  return (
    <dl className="grid grid-cols-2 gap-px border border-hairline/50 bg-hairline/50 md:grid-cols-4">
      {tiles.map(([term, value, extra]) => (
        <div key={term} className="bg-paper-fresh p-5">
          <dt className="text-[10px] font-semibold uppercase tracking-[0.18em] text-sepia">
            {term}
            {extra}
          </dt>
          <dd className="mt-2 text-pretty font-display text-[1.15rem] font-semibold leading-[1.3] text-ink">{value}</dd>
        </div>
      ))}
    </dl>
  );
}

/** The threats, as the record lists them. */
export function Threats({ threats }: { threats: string[] }) {
  return (
    <ul className="flex flex-wrap gap-2">
      {threats.map((threat) => (
        <li key={threat} className="border border-hairline/60 px-3 py-1.5 text-[14px] leading-snug text-ink">
          {threat}
        </li>
      ))}
    </ul>
  );
}

/** The record's story, with every passage carrying its own source marks. */
export function StoryProse({ record }: { record: SpeciesRecord }) {
  return (
    <div className="max-w-[62ch]">
      {record.story.map((passage, i) => (
        <p
          key={passage.id}
          className={
            i === 0
              ? "text-pretty font-display text-[clamp(1.25rem,2.4vw,1.7rem)] leading-[1.45] text-ink"
              : "mt-5 text-pretty text-[17px] leading-[1.72] text-ink"
          }
        >
          {passage.text}
          {passage.sourceIDs.map((id) => (
            <a
              key={id}
              href={`#source-${sourceMark(record, id)}`}
              className="ml-1 align-super text-[11px] font-semibold text-sepia underline decoration-hairline/70 underline-offset-2 hover:text-ink"
            >
              <span className="sr-only">Source </span>
              {sourceMark(record, id)}
            </a>
          ))}
        </p>
      ))}
    </div>
  );
}

/** Sources, always reachable, never buried. */
export function SourceList({ record }: { record: SpeciesRecord }) {
  const sources = orderedSources(record);
  return (
    <ol className="border-t border-hairline/50">
      {sources.map((source, i) => (
        <li key={source.id} id={`source-${i + 1}`} className="grid grid-cols-[2rem_1fr] gap-4 border-b border-hairline/40 py-5">
          <span aria-hidden="true" className="font-display text-lg text-sepia">
            {i + 1}
          </span>
          <div>
            <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-sepia">{source.organization}</p>
            <p className="mt-1 max-w-[60ch] text-pretty text-[16px] leading-snug text-ink">{source.title}</p>
            <div className="mt-1 flex flex-wrap items-center gap-x-6">
              <TextLink href={source.url} external>
                Open source&nbsp;↗
              </TextLink>
              <span className="text-[13px] text-ink-muted">Last accessed {formatDate(source.lastAccessed)}</span>
            </div>
          </div>
        </li>
      ))}
    </ol>
  );
}

/** Compact record label: the museum tag under the specimen. */
export function MetaPanel({ record }: { record: SpeciesRecord }) {
  const rows: [string, string][] = [
    ["Status", record.conservationStatus.displayName],
    ["Range (generalized)", record.generalizedRange],
    ["Fact-checked", formatDate(record.editorial.lastFactChecked)],
    ["Location review", record.editorial.sensitiveLocationReview],
    ["Artwork", record.media.depictionType],
  ];
  return (
    <dl className="grid grid-cols-1 border-t border-hairline/50">
      {rows.map(([term, value]) => (
        <div key={term} className="grid grid-cols-[9rem_1fr] gap-4 border-b border-hairline/40 py-3 sm:grid-cols-[11rem_1fr]">
          <dt className="text-[11px] font-semibold uppercase tracking-[0.14em] text-sepia">{term}</dt>
          <dd className="text-[15px] leading-snug text-ink first-letter:uppercase">{value}</dd>
        </div>
      ))}
    </dl>
  );
}

/** The one credible next step the record carries. */
export function ActionCard({ record }: { record: SpeciesRecord }) {
  const { action } = record;
  return (
    <div className="border-t-2 border-ink pt-6">
      <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">This week&rsquo;s act · for the {record.commonName}</p>
      <h3 className="mt-3 font-display text-2xl font-semibold text-ink">{action.title}</h3>
      <p className="mt-3 max-w-[56ch] text-pretty text-[16px] leading-[1.65] text-ink">{action.summary}</p>
      <p className="mt-3 font-display text-lg italic text-sepia">with {action.destinationOrganization}</p>
      <p className="mt-2 text-[11px] font-semibold uppercase tracking-[0.14em] text-ink-muted">
        {action.effort} · {action.geographicApplicability} · verified {formatDate(action.lastVerified)}
      </p>
      <div className="mt-6">
        <TextLink href={action.destinationURL} external>
          Open · {action.destinationOrganization}&nbsp;↗
        </TextLink>
      </div>
      <p className="mt-4 max-w-[56ch] text-[13px] leading-relaxed text-ink-muted">
        Witness records that this door was opened. It never claims the outcome.
      </p>
    </div>
  );
}

/** The organizations already doing the work, as the Cabinet lists them. */
export function Programs({ programs }: { programs: Program[] }) {
  return (
    <ul className="border-t border-hairline/50">
      {programs.map((program) => (
        <li key={program.id} className="border-b border-hairline/40 py-5">
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-sepia">{program.organization}</p>
          <p className="mt-1 font-display text-xl font-semibold text-ink">{program.title}</p>
          <p className="mt-2 max-w-[56ch] text-pretty text-[15px] leading-[1.65] text-ink-muted">{program.summary}</p>
          <div className="mt-1 flex flex-wrap items-center gap-x-6">
            <TextLink href={program.url} external>
              View initiative&nbsp;↗
            </TextLink>
            <span className="text-[13px] text-ink-muted">Verified {formatDate(program.lastVerified)}</span>
          </div>
        </li>
      ))}
    </ul>
  );
}

/** Breadcrumbs on every detail page. */
export function Breadcrumbs({ trail }: { trail: { href?: string; label: string }[] }) {
  return (
    <nav aria-label="Breadcrumb">
      <ol className="flex flex-wrap items-center gap-x-2 text-[13px] text-ink-muted">
        {trail.map((crumb, i) => (
          <li key={crumb.label} className="flex items-center gap-2">
            {i > 0 ? (
              <span aria-hidden="true" className="text-hairline">
                /
              </span>
            ) : null}
            {crumb.href ? (
              <TextLink href={crumb.href} className="text-[13px] font-normal">
                {crumb.label}
              </TextLink>
            ) : (
              <span aria-current="page" className="text-ink">
                {crumb.label}
              </span>
            )}
          </li>
        ))}
      </ol>
    </nav>
  );
}
