import { Container, PrimaryLink, TextLink } from "@/components/atlas";

export default function NotFound() {
  return (
    <section className="flex min-h-[60dvh] items-center py-20">
      <Container>
        <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">
          404 · No such plate
        </p>
        <h1 className="mt-6 max-w-[18ch] text-balance font-display text-[clamp(2rem,5vw,3.25rem)] font-semibold leading-[1.1] text-ink">
          This page is not in the archive.
        </h1>
        <p className="mt-5 max-w-[52ch] text-pretty text-[17px] leading-[1.7] text-ink-muted">
          It may have moved, or the address may be incomplete. The field archive lists every record currently approved for the catalog.
        </p>
        <div className="mt-8 flex flex-wrap items-center gap-x-8 gap-y-2">
          <PrimaryLink href="/witnesses">Go to the record index</PrimaryLink>
          <TextLink href="/">Back to the opening</TextLink>
        </div>
      </Container>
    </section>
  );
}
