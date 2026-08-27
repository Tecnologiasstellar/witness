import { Container } from "@/components/atlas";

/** Quiet, non-spinning loading state: the plate ruling before the ink. */
export default function Loading() {
  return (
    <section className="py-20" aria-busy="true" aria-live="polite">
      <Container>
        <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">
          Loading the plate…
        </p>
        <div className="mt-10 max-w-[46ch]">
          {[100, 88, 94, 60].map((width, i) => (
            <div
              key={i}
              aria-hidden="true"
              className="mt-6 h-px bg-hairline/50"
              style={{ width: `${width}%` }}
            />
          ))}
        </div>
      </Container>
    </section>
  );
}
