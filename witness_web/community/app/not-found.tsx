import type { Route } from "next";
import Link from "next/link";
import { Container } from "@/components/shell";

export default function NotFound() {
  return (
    <section className="py-20">
      <Container>
        <p className="text-[11px] font-bold uppercase tracking-[0.16em] text-accent">404</p>
        <h1 className="mt-2 font-display text-[clamp(2rem,5vw,3.4rem)] font-extrabold leading-[1.05] tracking-[-0.03em] text-ink">
          Nothing on disk behind this address.
        </h1>
        <p className="mt-4 max-w-[52ch] text-[17px] leading-[1.6] text-muted">
          The note may have moved, or the link was never right.{" "}
          <Link href={"/" as Route} className="font-semibold text-accent hover:text-ink">
            Start from the front page
          </Link>
          .
        </p>
      </Container>
    </section>
  );
}
