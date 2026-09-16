import type { Metadata } from "next";
import { Container, Eyebrow, TextLink } from "@/components/atlas";
import { Breadcrumbs, Programs } from "@/components/record";
import { SpeciesMap } from "@/components/species-map";
import { CATALOGUE, allRecords } from "@/lib/archive";

export const metadata: Metadata = {
  title: "The Map",
  description: "Where each Witness species lives, drawn as generalized regions on one world map, with the organizations every card cites and its one act.",
  alternates: { canonical: "/map", languages: { en: "/map", es: "/es/map" } },
};

export default function MapPage() {
  const records = allRecords();

  return (
    <>
      <section className="border-b border-hairline/50 py-10 md:py-16">
        <Container>
          <Breadcrumbs trail={[{ href: "/", label: "Witness" }, { label: "The Map" }]} />
          <div className="mt-8 grid gap-8 md:grid-cols-12">
            <div className="md:col-span-7">
              <Eyebrow className="text-sepia">The Map · {CATALOGUE.published} cards</Eyebrow>
              <h1 className="mt-6 max-w-[14ch] text-balance font-display text-[clamp(2.2rem,5.5vw,4rem)] font-semibold leading-[1.02] tracking-[-0.02em] text-ink">
                Where they live
              </h1>
            </div>
            <p className="max-w-[46ch] text-pretty text-[17px] leading-[1.7] text-ink-muted md:col-span-4 md:col-start-9 md:pt-4">
              Every circle is the generalized region a card carries, at least 25 km in radius and never an exact location. Open a species for its range in words, the organizations the card cites, and its one act.
            </p>
          </div>
        </Container>
      </section>

      <section className="py-12 md:py-16">
        <Container>
          <SpeciesMap
            records={records}
            title={`World map of generalized ranges for ${records.length} species; the list below names every region.`}
            caption="Generalized regions · exact locations are never shown · details in the list"
          />

          <ol className="map-list">
            {records.map((record) => {
              const regions = record.habitatRegions ?? [];
              return (
                <li key={record.id}>
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
                          Regions: <span lang="en">{regions.map((region) => `${region.name} · ~${region.radiusKm} km`).join(" · ")}</span>
                        </p>
                      ) : null}
                      {record.programs?.length ? <Programs programs={record.programs} /> : null}
                      <p>
                        The act:{" "}
                        <TextLink href={record.action.destinationURL} external>
                          {record.action.destinationOrganization} — {record.action.title}&nbsp;↗
                        </TextLink>
                      </p>
                      <p className="map-links">
                        <TextLink href={`/archive/${record.id}`}>Open the card</TextLink>
                        <TextLink href={`#r-${record.id}`}>Show on map</TextLink>
                      </p>
                    </div>
                  </details>
                </li>
              );
            })}
          </ol>

          <p className="map-note">
            Ranges stay general on purpose. Witness never publishes a location that could help someone find an animal already under pressure.
          </p>
          <p className="map-note">Witness cites organizations and agencies. It does not speak for them, and they have not endorsed it.</p>
        </Container>
      </section>
    </>
  );
}
