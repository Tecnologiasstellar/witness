import type { Metadata } from "next";
import { Container, Eyebrow, TextLink } from "@/components/atlas";
import { Breadcrumbs, Programs } from "@/components/record.es";
import { MapLive } from "@/components/map-live";
import { SpeciesMap, mapRegions } from "@/components/species-map";
import { CATALOGUE, allRecords } from "@/lib/archive.es";

export const metadata: Metadata = {
  title: "El Mapa",
  description: "Dónde vive cada especie de Witness, dibujada como regiones generalizadas en un mapa del mundo, con las organizaciones que cita cada ficha y su acto.",
  alternates: { canonical: "/es/map", languages: { en: "/map", es: "/es/map" } },
};

export default function MapPage() {
  const records = allRecords();

  return (
    <>
      <section className="border-b border-hairline/50 py-10 md:py-16">
        <Container>
          <Breadcrumbs trail={[{ href: "/es", label: "Witness" }, { label: "El Mapa" }]} />
          <div className="mt-8 grid gap-8 md:grid-cols-12">
            <div className="md:col-span-7">
              <Eyebrow className="text-sepia">El Mapa · {CATALOGUE.published} fichas</Eyebrow>
              <h1 className="mt-6 max-w-[14ch] text-balance font-display text-[clamp(2.2rem,5.5vw,4rem)] font-semibold leading-[1.02] tracking-[-0.02em] text-ink">
                Dónde viven
              </h1>
            </div>
            <p className="max-w-[46ch] text-pretty text-[17px] leading-[1.7] text-ink-muted md:col-span-4 md:col-start-9 md:pt-4">
              Cada círculo es la región generalizada que lleva una ficha: de al menos 25 km de radio y nunca una ubicación exacta. Abre una especie para ver su área en palabras, las organizaciones que cita la ficha y su acto.
            </p>
          </div>
        </Container>
      </section>

      <section className="py-12 md:py-16">
        <Container>
          <MapLive
            regions={mapRegions(records)}
            caption="Regiones generalizadas · nunca se muestran ubicaciones exactas · detalles en la lista"
            copy={{
              lang: "es",
              title: `Mapa interactivo de las áreas generalizadas de ${records.length} especies; la lista de abajo lleva la misma información.`,
              zoomIn: "Acercar",
              zoomOut: "Alejar",
              windowsHelpText: "Usa Ctrl + rueda para hacer zoom en el mapa",
              macHelpText: "Usa ⌘ + rueda para hacer zoom en el mapa",
              mobileHelpText: "Usa dos dedos para mover el mapa",
            }}
          >
            <SpeciesMap records={records} title={`Mapa del mundo con las áreas generalizadas de ${records.length} especies; la lista de abajo nombra cada región.`} />
          </MapLive>

          <ol className="map-list">
            {records.map((record) => {
              const regions = record.habitatRegions ?? [];
              return (
                <li key={record.id} id={`s-${record.id}`}>
                  <details>
                    <summary>
                      <span className="faq-plus" aria-hidden="true" />
                      <span className="map-status">{record.conservationStatus.displayName}</span>
                      <span className="map-name">{record.commonName}</span>
                      <i className="map-latin" translate="no">
                        {record.scientificName}
                      </i>
                    </summary>
                    <div>
                      <p className="map-range">{record.generalizedRange}</p>
                      {regions.length ? (
                        <p>
                          Regiones: <span lang="en">{regions.map((region) => `${region.name} · ~${region.radiusKm} km`).join(" · ")}</span>
                        </p>
                      ) : null}
                      {record.programs?.length ? <Programs programs={record.programs} /> : null}
                      <p>
                        El acto:{" "}
                        <TextLink href={record.action.destinationURL} external>
                          {record.action.destinationOrganization} — {record.action.title}&nbsp;↗
                        </TextLink>
                      </p>
                      <p className="map-links">
                        <TextLink href={`/es/archive/${record.id}`}>Abrir la ficha</TextLink>
                        <TextLink href={`#r-${record.id}`}>Ver en el mapa</TextLink>
                      </p>
                    </div>
                  </details>
                </li>
              );
            })}
          </ol>

          <p className="map-note">
            Las áreas de distribución se mantienen generales a propósito. Witness nunca publica una ubicación que pueda ayudar a alguien a encontrar un animal que ya está bajo presión.
          </p>
          <p className="map-note">Witness cita organizaciones y agencias. No habla por ellas, y ellas no lo han avalado.</p>
        </Container>
      </section>
    </>
  );
}
