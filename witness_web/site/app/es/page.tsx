import { readFileSync } from "node:fs";
import { join } from "node:path";
import Link from "next/link";
import { AppStoreBadge, Container, Eyebrow, PrimaryLink, TextLink } from "@/components/atlas";
import { HowItWorks, type Step } from "@/components/how-it-works";
import { APP_STORE_URL, allRecords, plate, recordById } from "@/lib/archive.es";

/** Plates in the hero strip and the archive band. Eight each, chosen for variety of form and colour. */
const STRIP = ["kakapo", "javan-rhino", "vaquita", "amur-leopard", "whooping-crane", "red-wolf", "axolotl", "snow-leopard"];
const GRID = ["philippine-eagle", "ploughshare-tortoise", "iberian-lynx", "hawaiian-crow", "gharial", "golden-lion-tamarin", "monarch-butterfly", "wollemi-pine"];
const ATLAS = ["gharial", "california-condor", "hawksbill-turtle"];

/** Screenshots of the shipped app, status bar cropped, exported by tools/export_web_plates.sh. */
const SHOT = { width: 1206, height: 2439 };

const STEPS: readonly Step[] = [
  {
    n: "01",
    title: "Cada lunes llega una lámina.",
    body: "Una nueva especie, dibujada y contada por completo: lo que se sabe, lo que la amenaza, lo que es incierto y de dónde sale cada dato. Cada afirmación remite a una fuente pública.",
    src: "/images/app/card-vaquita.webp",
    alt: "La app Witness mostrando la ficha de esta semana: una vaquita marina ilustrada con su estado, su nombre y los primeros datos.",
  },
  {
    n: "02",
    title: "Un toque deliberado, una vez por semana.",
    body: "Dar testimonio es darle a una especie un minuto de toda tu atención. Te sumas a un recuento anónimo y sin duplicados de todos los que dieron testimonio junto a ti. Una nota privada nunca sale de tu teléfono.",
    src: "/images/app/witness-javan-rhino.webp",
    alt: "El botón «I bear witness» de la app Witness bajo un estudio de escala del rinoceronte de Java dibujado junto a una figura humana.",
  },
  {
    n: "03",
    title: "Cada especie viene con una puerta real.",
    body: "Un acto verificado por especie: una organización real que ya hace el trabajo, una frase honesta sobre lo que logra el apoyo y un enlace directo. Si lo llevas a cabo, deja una línea en tu diario de campo.",
    src: "/images/app/acts-kakapo.webp",
    alt: "La pestaña Acts de la app Witness con el acto de esta semana para el kākāpō y un enlace a la organización que está detrás.",
  },
] as const;

const FAQS = [
  ["¿Qué es Witness?", "Una app para iPhone construida en torno a una pregunta: ¿puedes darle toda tu atención a una sola especie que está desapareciendo, esta semana? Cada semana presenta una especie con una lámina dibujada, una historia con fuentes, un testimonio privado y una acción creíble."],
  ["¿Cómo ayuda a una especie usar Witness?", "Cada ficha termina en una puerta real: una organización de conservación que ya protege a esa especie, con una frase honesta sobre lo que logra el apoyo y un enlace directo. Witness te lleva a esa puerta en el mismo minuto en que aprendes el nombre del animal, y guarda un diario de las puertas que cruzaste."],
  ["¿Quién está detrás de los actos?", "Programas de campo, consorcios de recuperación y organismos públicos: NOAA Fisheries y Sea Shepherd para la vaquita marina, el Departamento de Conservación de Nueva Zelanda para el kākāpō, la International Rhino Foundation para el rinoceronte de Java, y así sucesivamente. Cada acto se revisa antes de que la ficha se publique y muestra la fecha en que fue verificado. Una cita no es una alianza ni un respaldo."],
  ["¿Dar testimonio sirve realmente de algo?", "Cuenta la atención, y el recuento es real: un testimonio anónimo y sin duplicados por persona para la especie de cada semana. La atención es el primer acto de protección; la puerta es el segundo. Witness nunca afirma que un toque salvó a un animal, así que siempre sabes qué hizo tu minuto."],
  ["¿Qué puedo hacer más allá del acto semanal?", "Leer las treinta fichas del archivo, llevar a cabo el acto de cualquier especie de la que hayas dado testimonio, compartir su lámina y donar directamente a las organizaciones. La Primera Temporada de Campo va más a fondo: ocho especies tan raras que sus individuos se cuentan uno por uno, contadas junto a las personas que hacen el trabajo."],
  ["¿Es gratis?", "Sí. La ficha semanal, sus fuentes, el testimonio, el acto y tu nota privada son gratuitos y seguirán siéndolo. La Primera Temporada de Campo y el Atlas son compras opcionales dentro de la app; sostienen la creación de Witness."],
  ["¿De dónde salen los datos?", "Cada ficha nombra sus fuentes y lleva una fecha de verificación. Cuando algo no está verificado, la ficha lo dice en lugar de adivinar. Las áreas de distribución se mantienen generales para que una ficha nunca ayude a nadie a encontrar un animal que ya está bajo presión."],
  ["¿Las ilustraciones son fotografías?", "No. Son ilustraciones originales hechas para Witness bajo una única dirección de arte fija, cada una revisada para verificar la fidelidad a la especie. Nunca se presentan como fotografía documental."],
] as const;

function pick(ids: readonly string[]) {
  return ids.map((id) => {
    const record = recordById(id);
    if (!record) throw new Error(`Unknown record ${id}`);
    return record;
  });
}

export default function Home() {
  const strip = pick(STRIP);
  const grid = pick(GRID);
  const atlas = pick(ATLAS);
  const transcript = readFileSync(join(process.cwd(), "data/letter-transcript.es.txt"), "utf8").split("\n").filter(Boolean);
  const season = { src: "/images/plates/season-plate-01.webp", width: 1410, height: 2100 };

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    name: "Witness-Endangered Species",
    operatingSystem: "iOS 17.0 or later",
    applicationCategory: "EducationalApplication",
    description: "Cada semana, una especie al borde de la desaparición: su historia real, sus fuentes, una acción honesta.",
    offers: { "@type": "Offer", price: "0", priceCurrency: "USD" },
    url: APP_STORE_URL,
    publisher: { "@type": "Organization", name: "tecnologias stellar S.A de C.V" },
  };

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />

      <section className="home-hero">
        <Container className="home-hero-inner">
          <Eyebrow className="hero-eyebrow">Gratis en iPhone · con fuentes, dibujada, lectura gratuita</Eyebrow>
          <h1>Dale tu atención a una sola especie.</h1>
          <p className="hero-lede">
            Cada semana, Witness te trae una especie al borde de la desaparición: una lámina dibujada, su historia real con fuentes y una acción honesta. Sin feed. Sin cuenta. Sin falsas promesas.
          </p>
          <div className="hero-actions">
            <div className="hero-store">
              <AppStoreBadge lang="es" />
              <p className="store-note">iPhone · iOS 17 o posterior</p>
            </div>
            <TextLink href="/es/archive">Explorar el archivo</TextLink>
          </div>
          <ul className="plate-strip" aria-label="Especies dibujadas para Witness">
            {strip.map((record) => {
              const art = plate(record, "plate");
              return (
                <li key={record.id}>
                  <Link href={`/es/archive/${record.id}`}>
                    <img src={art.src} width={art.width} height={art.height} alt={`Ilustración original: ${record.commonName}`} decoding="async" />
                  </Link>
                </li>
              );
            })}
          </ul>
          <p className="hero-caption">Ilustraciones originales, dibujadas para Witness · no son fotografías</p>
        </Container>
      </section>

      <section id="how" className="how-section">
        <Container>
          <div className="section-intro">
            <Eyebrow className="text-sepia">Cómo funciona</Eyebrow>
            <h2>Un encuentro por semana.<br />Eso es toda la app.</h2>
          </div>
          <HowItWorks steps={STEPS} width={SHOT.width} height={SHOT.height} />
          <div className="how-cta">
            <p>La lámina de esta semana ya te espera.</p>
            <AppStoreBadge lang="es" />
          </div>
        </Container>
      </section>

      <section className="archive-section">
        <Container>
          <div className="archive-head">
            <div>
              <Eyebrow className="text-sepia">El Archivo</Eyebrow>
              <h2>{allRecords().length === 30 ? "Treinta" : allRecords().length} especies, dibujadas y contadas por completo.</h2>
            </div>
            <div>
              <p>Cada ficha que lleva la app está aquí para leerla, gratis: cinco ilustraciones originales, la historia con fuentes, las amenazas y la puerta.</p>
              <PrimaryLink href="/es/archive">Abrir el archivo</PrimaryLink>
            </div>
          </div>
          <ul className="archive-grid">
            {grid.map((record) => {
              const art = plate(record, "plate");
              return (
                <li key={record.id}>
                  <Link href={`/es/archive/${record.id}`} aria-label={record.commonName}>
                    <img src={art.src} width={art.width} height={art.height} alt="" loading="lazy" decoding="async" />
                  </Link>
                </li>
              );
            })}
          </ul>
        </Container>
      </section>

      <section className="works-section dusk">
        <Container>
          <div className="section-intro">
            <Eyebrow className="text-[color:var(--dusk-muted)]">Las obras</Eyebrow>
            <h2>Detrás de la ficha semanal hay dos obras terminadas.</h2>
          </div>

          <article className="work">
            <img src={season.src} width={season.width} height={season.height} alt="La lámina de la Primera Temporada de Campo: ocho especies dispuestas alrededor de las palabras «the thin line», cada una con su recuento." loading="lazy" decoding="async" className="season" />
            <div>
              <h3>Primera Temporada de Campo</h3>
              <p>
                Una edición finita, de autor, sobre los pocos contados: ocho especies tan raras que sus individuos se conocen uno por uno. Una carta inaugural, ocho capítulos con sus expedientes, dos interludios, una síntesis final y la lámina de la temporada. Cada pieza narrada, setenta y cinco minutos en total. Se compra una vez en la app y se conserva para siempre.
              </p>
              <div className="audio-panel">
                <p className="audio-label">Escuchar la carta inaugural (en inglés) · 4 min</p>
                <audio controls preload="none" src="/audio/letter-the-thin-line.mp3">
                  <a href="/audio/letter-the-thin-line.mp3">Descargar la carta inaugural (MP3)</a>
                </audio>
                <p className="audio-note">Narrada por una voz sintética (Amazon Polly, Ruth). Registro de derechos en archivo.</p>
                <details className="transcript">
                  <summary>Leer la transcripción en español</summary>
                  {transcript.map((paragraph) => (
                    <p key={paragraph.slice(0, 40)}>{paragraph}</p>
                  ))}
                </details>
              </div>
            </div>
          </article>

          <article className="work">
            <ul className="collage" aria-hidden="true">
              {atlas.map((record) => {
                const art = plate(record, "plate");
                return (
                  <li key={record.id}>
                    <img src={art.src} width={art.width} height={art.height} alt="" loading="lazy" decoding="async" />
                  </li>
                );
              })}
            </ul>
            <div>
              <h3>El Atlas</h3>
              <p>
                La biblioteca viva: cada semana destacada más allá de la ventana gratuita, y cada temporada de campo publicada mientras la membresía esté activa, con narración incluida. Crece cada lunes.
              </p>
              <p className="work-note">Ambas viven tras la marca Index, en la esquina superior izquierda de cada ficha. La ficha semanal sigue siendo gratuita.</p>
              <AppStoreBadge lang="es" className="mt-8" />
            </div>
          </article>
        </Container>
      </section>

      <section id="faq" className="faq-section">
        <Container>
          <div className="faq-layout">
            <div>
              <h2>Preguntas</h2>
              <p className="faq-intro">Respuestas claras sobre la app y el trabajo al que apunta.</p>
            </div>
            <div className="faq-list">
              {FAQS.map(([question, answer], index) => (
                <details key={question} open={index === 0}>
                  <summary>
                    <span>{question}</span>
                    <span aria-hidden="true" className="faq-plus" />
                  </summary>
                  <p>{answer}</p>
                </details>
              ))}
            </div>
          </div>
        </Container>
      </section>

      <section className="closing-section">
        <Container>
          <Eyebrow className="text-sepia">Gratis en iPhone</Eyebrow>
          <h2>Mira de cerca.<br />Lleva el nombre contigo.</h2>
          <p>Una especie por semana, en tu teléfono. La ficha, las fuentes, el testimonio y el acto son gratuitos.</p>
          <div className="closing-actions">
            <AppStoreBadge lang="es" />
            <TextLink href="/es/archive">Abrir el archivo</TextLink>
          </div>
        </Container>
      </section>
    </>
  );
}
