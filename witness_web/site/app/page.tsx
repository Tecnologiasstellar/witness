import Image from "next/image";
import Link from "next/link";
import { Container, Eyebrow, PrimaryLink, TextLink } from "@/components/atlas";
import { HomeExperience, type ExperienceRecord } from "@/components/home-experience";
import { StatusBadge } from "@/components/record";
import { CATALOGUE, recordById } from "@/lib/archive";

const FEATURE_IDS = ["whooping-crane", "ploughshare-tortoise", "red-wolf", "amur-tiger", "philippine-eagle"] as const;

const ART: Record<(typeof FEATURE_IDS)[number], Omit<ExperienceRecord, "id" | "commonName" | "scientificName" | "status" | "hook">> = {
  "whooping-crane": { image: "/images/species/whooping-crane-context.jpg", alt: "Original watercolor illustration of two whooping cranes flying above a marsh" },
  "ploughshare-tortoise": { image: "/images/species/ploughshare-tortoise.jpg", alt: "Original watercolor illustration of a ploughshare tortoise" },
  "red-wolf": { image: "/images/species/red-wolf.jpg", alt: "Original watercolor illustration of a red wolf in pocosin habitat" },
  "amur-tiger": { image: "/images/species/amur-tiger.jpg", alt: "Original watercolor illustration of an Amur tiger on a rocky ledge" },
  "philippine-eagle": { image: "/images/species/philippine-eagle-detail.jpg", alt: "Original watercolor head study of a Philippine eagle" },
};

const FAQS = [
  ["What is Witness?", "An iPhone app built around one species a day. You meet it through an original illustration, read a short story with its sources, record a private Witness, and open one credible action."],
  ["Can I get it today?", "Not yet. The iOS app and the 30-record archive are built; the App Store release is not. Nothing can be installed or bought today."],
  ["Where does the information come from?", "Every record names its sources, carries a review and a fact-check date, and keeps sensitive locations general. The Method page publishes the standard and its current limits."],
  ["Are the illustrations photographs?", "No. They are original AI-assisted illustrations made under a fixed art direction, each with a generation record and a species-accuracy review. They are never presented as documentary media."],
  ["What does a Witness count?", "Acts of attention. Not animals saved, money raised, or policies changed. Witness will never claim an outcome it did not produce."],
  ["Will it be free?", "The daily story, its sources, the Witness, one action, and your private reflection are meant to stay free. Paid options are proposed, and nothing can be purchased today."],
] as const;

export default function Home() {
  const records = FEATURE_IDS.map((id) => {
    const record = recordById(id);
    if (!record) throw new Error(`Missing approved catalog record: ${id}`);
    return { id, commonName: record.commonName, scientificName: record.scientificName, status: record.conservationStatus.displayName, hook: record.hook, ...ART[id] } satisfies ExperienceRecord;
  });

  return (
    <>
      <section className="home-hero">
        <Container className="home-hero-inner">
          <Eyebrow className="hero-eyebrow">A field archive of attention</Eyebrow>
          <h1>Meet one species.<br />Remember what is still here.</h1>
          <p className="hero-lede">Each day, one animal: an original illustration, a short story with its sources, and one honest thing you can do.</p>
          <div className="hero-actions">
            <PrimaryLink href="/witnesses">Browse the {CATALOGUE.published} records</PrimaryLink>
            <TextLink href="#experience">See how it works</TextLink>
          </div>
          <div className="hero-collage" aria-label="Original Witness species illustrations">
            <figure className="hero-art hero-art-left"><Image src="/images/species/ploughshare-tortoise.jpg" alt="Original watercolor illustration of a ploughshare tortoise" fill sizes="220px" priority /></figure>
            <figure className="hero-art hero-art-center"><Image src="/images/species/whooping-crane-context.jpg" alt="Original watercolor illustration of two whooping cranes in flight" fill sizes="(max-width: 767px) 78vw, 560px" priority /></figure>
            <figure className="hero-art hero-art-right"><Image src="/images/species/philippine-eagle-detail.jpg" alt="Original watercolor head study of a Philippine eagle" fill sizes="220px" priority /></figure>
          </div>
          <p className="hero-caption">Original illustrations, not documentary photography · iOS app in development, not yet on the App Store</p>
        </Container>
      </section>

      <section id="experience" className="experience-section">
        <Container>
          <div className="section-intro"><div><h2>One species a day.<br />That is the whole app.</h2><p>No feed, no streak, no catching up. Five records from the archive, as they appear on the phone.</p></div></div>
          <HomeExperience records={records} />
        </Container>
      </section>

      <section id="ritual" className="ritual-section">
        <Container>
          <div className="section-intro"><div><h2>One encounter.<br />Three steps.</h2></div></div>
          <ol className="ritual-grid">
            <li><span>01</span><h3>Meet</h3><p>One species, one original illustration, one short story you can read in a few minutes.</p></li>
            <li><span>02</span><h3>Witness</h3><p>Record a private act of attention. It counts attention — never a conservation outcome.</p></li>
            <li><span>03</span><h3>Act</h3><p>Open one credible action, chosen for that species and reviewed before it ships.</p></li>
          </ol>
        </Container>
      </section>

      <section className="archive-band">
        <Container>
          <div className="archive-band-grid"><div><Eyebrow className="text-[color:var(--dusk-muted)]">The reviewed archive</Eyebrow><h2>{CATALOGUE.published} ways to begin paying attention.</h2></div><div><p>Every record names its sources, carries a fact-check date, and keeps sensitive locations general. You can read all of them right now, on this website.</p><PrimaryLink href="/witnesses" tone="dusk">Open the archive</PrimaryLink></div></div>
          <div className="species-marquee-track" aria-hidden="true">
            <div className="species-marquee"><span>Vaquita</span><span>Red Wolf</span><span>Kākāpō</span><span>Amur Tiger</span><span>Axolotl</span><span>Whooping Crane</span></div>
            <div className="species-marquee"><span>Vaquita</span><span>Red Wolf</span><span>Kākāpō</span><span>Amur Tiger</span><span>Axolotl</span><span>Whooping Crane</span></div>
          </div>
        </Container>
      </section>

      <section className="trust-section">
        <Container>
          <div className="section-intro"><div><h2>Trust is part of the interface.</h2><p>Sources, rights, privacy, and what is not ready yet stay visible instead of disappearing behind a confident tone.</p></div></div>
          <div className="trust-grid">
            <article><span>A</span><h3>Evidence stays visible</h3><p>Every claim on this site points to a dated source in the repository.</p><TextLink href="/method">Read the method</TextLink></article>
            <article><span>B</span><h3>Private by default</h3><p>No account, no profile, no public memories. Reflections are designed to stay on your device.</p><TextLink href="/privacy">Read the privacy boundary</TextLink></article>
            <article><span>C</span><h3>Honest about readiness</h3><p>The app and the archive are built. The App Store release, the backend, and purchases are not.</p><TextLink href="/support">See what ships when</TextLink></article>
          </div>
        </Container>
      </section>

      <section id="faq" className="faq-section">
        <Container>
          <div className="faq-layout"><div><h2>Questions</h2><p className="faq-intro">Plain answers, including what Witness cannot claim yet.</p></div><div className="faq-list">{FAQS.map(([question, answer], index) => <details key={question} open={index === 0}><summary><span>{question}</span><span aria-hidden="true" className="faq-plus" /></summary><p>{answer}</p></details>)}</div></div>
        </Container>
      </section>

      <section className="closing-section">
        <Container>
          <StatusBadge status="In development" note="Not yet on the App Store." />
          <h2>Look closely.<br />Carry the name forward.</h2>
          <p>Thirty species are already written, sourced, and illustrated. You can meet them here today.</p>
          <div className="closing-actions"><PrimaryLink href="/witnesses">Open the archive</PrimaryLink><Link href="/method">See exactly what is verified</Link></div>
        </Container>
      </section>
    </>
  );
}
