import type { ReactNode } from "react";
import type { Route } from "next";
import Link from "next/link";
import type { SpeciesRecord } from "@/lib/archive";
import { orderedSources, sourceMark } from "@/lib/archive";
import { TextLink } from "./atlas";

/** Status is written in words. Colour never carries it. */
export function StatusBadge({
  status,
  note,
}: {
  status: string;
  note?: string;
}) {
  return (
    <span className="inline-flex flex-col items-start gap-2">
      <span className="inline-flex min-h-11 items-center gap-3 border border-ink px-4 py-2">
        <span
          aria-hidden="true"
          className="inline-block h-2 w-2 rotate-45 border border-ink bg-ink"
        />
        <span className="text-[13px] font-semibold uppercase tracking-[0.16em] text-ink">
          {status}
        </span>
      </span>
      {note ? (
        <span className="max-w-[46ch] text-[12px] leading-relaxed text-ink-muted">
          {note}
        </span>
      ) : null}
    </span>
  );
}

/** Compact scientific metadata, the museum label under the specimen. */
export function MetaPanel({ record }: { record: SpeciesRecord }) {
  const rows: [string, ReactNode][] = [
    ["Status", record.conservationStatus.displayName],
    ["Range (generalized)", record.generalizedRange],
    ["Record state", record.editorial.state],
    ["Reviewer", record.editorial.reviewer.toLowerCase() === "pending" ? "Pending" : record.editorial.reviewer],
    ["Fact-checked", record.editorial.lastFactChecked],
    ["Location review", record.editorial.sensitiveLocationReview],
    ["Media", record.media.depictionType],
    ["Media rights", record.media.license],
    ["Schema version", String(record.schemaVersion)],
  ];
  return (
    <dl className="grid grid-cols-1 border-t border-hairline/50">
      {rows.map(([term, value]) => (
        <div
          key={term}
          className="grid grid-cols-[9rem_1fr] gap-4 border-b border-hairline/40 py-3 sm:grid-cols-[11rem_1fr]"
        >
          <dt className="text-[11px] font-semibold uppercase tracking-[0.14em] text-sepia">
            {term}
          </dt>
          <dd className="text-[15px] leading-snug text-ink first-letter:uppercase">
            {value}
          </dd>
        </div>
      ))}
    </dl>
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
        <li
          key={source.id}
          id={`source-${i + 1}`}
          className="grid grid-cols-[2rem_1fr] gap-4 border-b border-hairline/40 py-5"
        >
          <span
            aria-hidden="true"
            className="font-display text-lg text-sepia"
          >
            {i + 1}
          </span>
          <div>
            <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-sepia">
              {source.organization}
            </p>
            <p className="mt-1 max-w-[60ch] text-pretty text-[16px] leading-snug text-ink">
              {source.title}
            </p>
            <div className="mt-1 flex flex-wrap items-center gap-x-6">
              <TextLink href={source.url} external>
                Open source&nbsp;↗
              </TextLink>
              <span className="text-[13px] text-ink-muted">
                Last accessed {source.lastAccessed}
              </span>
            </div>
          </div>
        </li>
      ))}
    </ol>
  );
}

/** Record provenance — dates that exist, not a species history. */
export function RecordTimeline({ record }: { record: SpeciesRecord }) {
  const events = [
    {
      date: record.publishDate,
      label: "Record bundled",
      detail: "Written from declared public sources and included in the bundled catalog.",
    },
    {
      date: record.editorial.lastFactChecked,
      label: "Fact-checked",
      detail: record.editorial.notes,
    },
    {
      date: record.action.lastVerified,
      label: "Action verified",
      detail: `Destination checked at ${record.action.destinationOrganization}.`,
    },
    {
      date: record.editorial.lastFactChecked,
      label: "Catalog approval",
      detail: `Editorial state: ${record.editorial.state}. Reviewer: ${record.editorial.reviewer}.`,
    },
  ];
  return (
    <ol className="relative">
      <div
        aria-hidden="true"
        className="absolute bottom-2 left-[5px] top-2 w-px bg-hairline/50"
      />
      {events.map((event) => (
        <li key={event.label} className="relative grid grid-cols-[2rem_1fr] gap-4 pb-8">
          <span
            aria-hidden="true"
            className="mt-1.5 h-[11px] w-[11px] rounded-full border border-ink bg-ink"
          />
          <div>
            <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-sepia">
              {event.date}
            </p>
            <p className="mt-1 font-display text-xl font-semibold text-ink">
              {event.label}
            </p>
            <p className="mt-1 max-w-[56ch] text-pretty text-[15px] leading-relaxed text-ink-muted">
              {event.detail}
            </p>
          </div>
        </li>
      ))}
    </ol>
  );
}

/** The one credible next step the record carries. */
export function ActionCard({ record }: { record: SpeciesRecord }) {
  const { action } = record;
  return (
    <div className="border-t-2 border-ink pt-6">
      <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">
        The action in this record
      </p>
      <h3 className="mt-3 font-display text-2xl font-semibold text-ink">
        {action.title}
      </h3>
      <p className="mt-3 max-w-[56ch] text-pretty text-[16px] leading-[1.65] text-ink">
        {action.summary}
      </p>
      <dl className="mt-6 flex flex-wrap gap-x-10 gap-y-4">
        {[
          ["Reading time", action.effort],
          ["Source", action.destinationOrganization],
          ["Applies", action.geographicApplicability],
          ["Verified", action.lastVerified],
        ].map(([term, value]) => (
          <div key={term}>
            <dt className="text-[10px] font-semibold uppercase tracking-[0.16em] text-sepia">
              {term}
            </dt>
            <dd className="mt-1 text-[15px] text-ink">{value}</dd>
          </div>
        ))}
      </dl>
      <div className="mt-6">
        <TextLink href={action.destinationURL} external>
          Read it at {action.destinationOrganization}&nbsp;↗
        </TextLink>
      </div>
      <p className="mt-4 max-w-[56ch] text-[13px] leading-relaxed text-ink-muted">
        Witness records that this action was opened. It does not claim it was
        completed, and it makes no claim about the outcome.
      </p>
    </div>
  );
}

/** Breadcrumbs on every detail page. */
export function Breadcrumbs({
  trail,
}: {
  trail: { href?: string; label: string }[];
}) {
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
              <Link
                href={crumb.href as Route}
                className="inline-flex min-h-11 items-center underline decoration-hairline/70 underline-offset-4 hover:text-ink"
              >
                {crumb.label}
              </Link>
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

/** No dead ends and no invented recommendations. */
export function RelatedRail() {
  return (
    <div className="border border-dashed border-hairline/70 p-6 sm:p-8">
      <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">
        Related records
      </p>
      <p className="mt-3 max-w-[52ch] text-pretty text-[16px] leading-[1.65] text-ink">
        The archive holds 30 approved catalog records. Browse the index rather than accepting an algorithmic recommendation with no editorial basis.
      </p>
      <div className="mt-5 flex flex-wrap gap-x-8">
        <TextLink href="/method">How a record is made</TextLink>
        <TextLink href="/witnesses">Back to the record index</TextLink>
      </div>
    </div>
  );
}

/**
 * The chain of cause the record actually describes, drawn as an engraved
 * diagram. Every link is a phrase from the bundled story; nothing is added.
 */
export function ThreatChain({
  record,
  tone = "paper",
}: {
  record: SpeciesRecord;
  tone?: "paper" | "dusk";
}) {
  const links = [
    { step: "01", text: "Illegal nets set for totoaba" },
    { step: "02", text: "Gillnets in the same water" },
    { step: "03", text: "Entanglement" },
    { step: "04", text: "Cannot return to the surface to breathe" },
  ];
  const meta =
    tone === "dusk" ? "text-[color:var(--dusk-muted)]" : "text-sepia";
  const rule =
    tone === "dusk" ? "bg-[color:var(--dusk-rule)]" : "bg-hairline/60";
  return (
    <div>
      <p className={`text-[11px] font-semibold uppercase tracking-[0.18em] ${meta}`}>
        The threat, as this record describes it
        <span className="ml-1 align-super text-[10px]">
          <span className="sr-only">Sources </span>
          {record.sources.map((s, i) => (i === 0 ? "1" : ` ${i + 1}`))}
        </span>
      </p>
      <ol className="mt-6 grid gap-6 sm:grid-cols-2 lg:grid-cols-4 lg:gap-4">
        {links.map((link) => (
          <li key={link.step}>
            <div aria-hidden="true" className={`h-px w-full ${rule}`} />
            <p className={`mt-3 text-[10px] font-semibold uppercase tracking-[0.16em] ${meta}`}>
              {link.step}
            </p>
            <p className="mt-2 max-w-[26ch] text-pretty text-[16px] leading-snug">
              {link.text}
            </p>
          </li>
        ))}
      </ol>
    </div>
  );
}
