"use client";

import { Container, PrimaryLink, TextLink } from "@/components/atlas";

export default function Error({ reset }: { error: Error; reset: () => void }) {
  return (
    <section className="flex min-h-[60dvh] items-center py-20">
      <Container>
        <p
          className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia"
          role="status"
        >
          Error · The plate did not print
        </p>
        <h1 className="mt-6 max-w-[20ch] text-balance font-display text-[clamp(2rem,5vw,3.25rem)] font-semibold leading-[1.1] text-ink">
          Something failed while rendering this page.
        </h1>
        <p className="mt-5 max-w-[52ch] text-pretty text-[17px] leading-[1.7] text-ink-muted">
          Nothing was lost because this site stores nothing about you. Try again, and
          if it keeps failing, the record index is the shortest way back.
        </p>
        <div className="mt-8 flex flex-wrap items-center gap-x-8 gap-y-2">
          <button
            type="button"
            onClick={reset}
            className="inline-flex min-h-11 items-center justify-center gap-3 bg-ink px-6 py-3 text-[15px] font-semibold text-paper transition-colors duration-200 ease-out hover:bg-sepia"
          >
            Try again
          </button>
          <TextLink href="/witnesses">Go to the record index</TextLink>
        </div>
        <div className="mt-8">
          <PrimaryLink href="/">Back to the opening</PrimaryLink>
        </div>
      </Container>
    </section>
  );
}
