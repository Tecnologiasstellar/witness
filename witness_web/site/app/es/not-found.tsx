import { Container, PrimaryLink, TextLink } from "@/components/atlas";

export default function NotFound() {
  return (
    <section className="flex min-h-[60dvh] items-center py-20">
      <Container>
        <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">
          404 · No existe esa lámina
        </p>
        <h1 className="mt-6 max-w-[18ch] text-balance font-display text-[clamp(2rem,5vw,3.25rem)] font-semibold leading-[1.1] text-ink">
          Esta página no está en el archivo.
        </h1>
        <p className="mt-5 max-w-[52ch] text-pretty text-[17px] leading-[1.7] text-ink-muted">
          Puede que se haya movido, o que la dirección esté incompleta. El archivo de campo lista cada ficha aprobada actualmente para el catálogo.
        </p>
        <div className="mt-8 flex flex-wrap items-center gap-x-8 gap-y-2">
          <PrimaryLink href="/es/archive">Ir al índice de fichas</PrimaryLink>
          <TextLink href="/es">Volver al inicio</TextLink>
        </div>
      </Container>
    </section>
  );
}
