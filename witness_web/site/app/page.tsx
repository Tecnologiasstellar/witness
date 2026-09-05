import { readFileSync } from "node:fs";
import { join } from "node:path";
import Link from "next/link";
import { Container, Eyebrow, PrimaryLink, TextLink } from "@/components/atlas";
import { HowItWorks, type Step } from "@/components/how-it-works";
import { APP_STORE_URL, SITE_URL, allRecords, plate, recordById } from "@/lib/archive";

/** Plates in the hero strip and the archive band. Eight each, chosen for variety of form and colour. */
const STRIP = ["kakapo", "javan-rhino", "vaquita", "amur-leopard", "whooping-crane", "red-wolf", "axolotl", "snow-leopard"];
const GRID = ["philippine-eagle", "ploughshare-tortoise", "iberian-lynx", "hawaiian-crow", "gharial", "golden-lion-tamarin", "monarch-butterfly", "wollemi-pine"];
const ATLAS = ["gharial", "california-condor", "hawksbill-turtle"];

/** Screenshots of the shipped app, status bar cropped, exported by tools/export_web_plates.sh. */
const SHOT = { width: 1206, height: 2439 };

const STEPS: readonly Step[] = [
  {
    n: "01",
    title: "Every Monday, one plate arrives.",
    body: "A new species, drawn and told in full: what is known, what threatens it, what is uncertain, and where every fact comes from. Each claim maps to a public source.",
    src: "/images/app/this-week.webp",
    alt: "The Witness app showing this week’s card: an illustrated vaquita with its status, name, and first facts.",
  },
  {
    n: "02",
    title: "One deliberate tap, once a week.",
    body: "To witness is to give a species a minute of your full attention. You join an anonymous, deduplicated count of everyone who witnessed alongside you. A private note never leaves your phone.",
    src: "/images/app/witness.webp",
    alt: "The Witness app’s “I bear witness” button beneath a scale study of the Javan rhino drawn beside a human figure.",
  },
  {
    n: "03",
    title: "Every species comes with one real door.",
    body: "One vetted act per species: a real organization already doing the work, one honest sentence about what support does, and a direct link. Take it up and it leaves a line in your field journal.",
    src: "/images/app/acts.webp",
    alt: "The Witness app’s Acts tab showing this week’s act for the kākāpō and a link to the organization behind it.",
  },
] as const;

const TENETS = [
  ["Show you a feed.", "One card a week, and the archive. There is nothing to catch up on."],
  ["Ask for an account.", "No sign-in, no profile, no public memories. Your notes stay on your phone."],
  ["Gamify your attention.", "No points, streaks, or flames. A Witness is a minute of attention, given once."],
  ["Claim a tap saved an animal.", "A Witness counts attention. The acts are real doors to people doing the work."],
] as const;

const FAQS = [
  ["What is Witness?", "An iPhone app built around one question: can you give a single vanishing species your full attention this week? Each week it features one species with a drawn plate, a sourced story, a private witness, and one credible action."],
  ["Is it free?", "Yes. The weekly card, its sources, the witness, the act, and your private note are free and stay free. Field Season One and the Atlas are optional purchases inside the app."],
  ["Where do the facts come from?", "Every card names its sources and carries a fact-check date. Where something is not verified, the app says so instead of guessing. Ranges stay general so a card can never help someone find an animal already under pressure."],
  ["Are the illustrations photographs?", "No. They are original illustrations made for Witness under one fixed art direction, each reviewed for species accuracy. They are never presented as documentary photography."],
  ["What does a Witness count?", "Attention. A witness joins an anonymous count of everyone who paid attention to that species this week. It never claims an animal was saved or a policy changed."],
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
  const transcript = readFileSync(join(process.cwd(), "data/letter-transcript.txt"), "utf8").split("\n").filter(Boolean);
  const season = { src: "/images/plates/season-plate-01.webp", width: 1410, height: 2100 };

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    name: "Witness — Endangered Species",
    operatingSystem: "iOS",
    applicationCategory: "EducationalApplication",
    description: "Each week, one species on the edge of disappearance: its true story, its sources, one honest action.",
    offers: { "@type": "Offer", price: "0", priceCurrency: "USD" },
    installUrl: APP_STORE_URL,
    url: SITE_URL,
  };

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />

      <section className="home-hero">
        <Container className="home-hero-inner">
          <Eyebrow className="hero-eyebrow">Free on iPhone · one species a week</Eyebrow>
          <h1>Give one species your attention.</h1>
          <p className="hero-lede">
            Each week, Witness brings you one species on the edge of disappearance: a drawn plate, its true story with sources, and one honest action. No feed. No account. No false promises.
          </p>
          <div className="hero-actions">
            <PrimaryLink href={APP_STORE_URL} external>
              Download on the App Store
            </PrimaryLink>
            <TextLink href="/archive">Browse the archive</TextLink>
          </div>
          <ul className="plate-strip" aria-label="Species drawn for Witness">
            {strip.map((record) => {
              const art = plate(record, "plate");
              return (
                <li key={record.id}>
                  <Link href={`/archive/${record.id}`}>
                    <img src={art.src} width={art.width} height={art.height} alt={`Original illustration of the ${record.commonName}`} decoding="async" />
                  </Link>
                </li>
              );
            })}
          </ul>
          <p className="hero-caption">Original illustrations, drawn for Witness · not photographs</p>
        </Container>
      </section>

      <section id="how" className="how-section">
        <Container>
          <div className="section-intro">
            <Eyebrow className="text-sepia">How it works</Eyebrow>
            <h2>One encounter a week.<br />That is the whole app.</h2>
          </div>
          <HowItWorks steps={STEPS} width={SHOT.width} height={SHOT.height} />
        </Container>
      </section>

      <section className="archive-section">
        <Container>
          <div className="archive-head">
            <div>
              <Eyebrow className="text-sepia">The Archive</Eyebrow>
              <h2>{allRecords().length === 30 ? "Thirty" : allRecords().length} species, drawn and told in full.</h2>
            </div>
            <div>
              <p>Every card the app carries is here to read, free: five original illustrations, the sourced story, the threats, and the door.</p>
              <PrimaryLink href="/archive">Open the archive</PrimaryLink>
            </div>
          </div>
          <ul className="archive-grid">
            {grid.map((record) => {
              const art = plate(record, "plate");
              return (
                <li key={record.id}>
                  <Link href={`/archive/${record.id}`} aria-label={record.commonName}>
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
            <Eyebrow className="text-[color:var(--dusk-muted)]">The works</Eyebrow>
            <h2>Two finished works stand behind the weekly card.</h2>
          </div>

          <article className="work">
            <img src={season.src} width={season.width} height={season.height} alt="The Field Season One plate: eight species arranged around the words “the thin line”, each with its count." loading="lazy" decoding="async" className="season" />
            <div>
              <h3>Field Season One</h3>
              <p>
                A finite, authored edition about the counted few: eight species so rare that the individuals are known one by one. An opening letter, eight chapters with their dossiers, two interludes, a closing synthesis, and the season plate. Every piece narrated, seventy-five minutes in all. Bought once in the app, and kept permanently.
              </p>
              <div className="audio-panel">
                <p className="audio-label">Hear the opening letter · 4 min</p>
                <audio controls preload="none" src="/audio/letter-the-thin-line.mp3">
                  <a href="/audio/letter-the-thin-line.mp3">Download the opening letter (MP3)</a>
                </audio>
                <p className="audio-note">Narrated by a synthetic voice (Amazon Polly, Ruth). Rights record on file.</p>
                <details className="transcript">
                  <summary>Read the transcript</summary>
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
              <h3>The Atlas</h3>
              <p>
                The living library: every featured week beyond the free window, and every released field season while membership is active, narration included. It grows every Monday.
              </p>
              <p className="work-note">Both live behind the Index mark, at the top-left of every card. The weekly card stays free.</p>
            </div>
          </article>
        </Container>
      </section>

      <section className="tenets-section">
        <Container>
          <div className="section-intro">
            <h2>What Witness will never do.</h2>
          </div>
          <ul className="tenets">
            {TENETS.map(([title, body]) => (
              <li key={title}>
                <h3>{title}</h3>
                <p>{body}</p>
              </li>
            ))}
          </ul>
        </Container>
      </section>

      <section id="faq" className="faq-section">
        <Container>
          <div className="faq-layout">
            <div>
              <h2>Questions</h2>
              <p className="faq-intro">Plain answers, including what Witness will not claim.</p>
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
          <Eyebrow className="text-sepia">Free on iPhone</Eyebrow>
          <h2>Look closely.<br />Carry the name forward.</h2>
          <p>One species a week, on your phone. The card, the sources, the witness, and the act are free.</p>
          <div className="closing-actions">
            <PrimaryLink href={APP_STORE_URL} external>
              Download on the App Store
            </PrimaryLink>
            <TextLink href="/archive">Open the archive</TextLink>
          </div>
        </Container>
      </section>
    </>
  );
}
