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
  ["What is Witness?", "Witness is an iPhone-first editorial app in development. Its core ritual is simple: meet one species, read a short sourced story, record a private Witness, see an honest collective count when the production service is verified, and open one credible action."],
  ["Is Witness available on the App Store?", "Not yet. The native iOS MVP and a 30-record reviewed catalog exist, but physical-device, production backend, purchase, privacy, legal, App Review, and public-release gates still require dated evidence."],
  ["Where does the species information come from?", "Every record carries declared sources, passage-level source mapping, an editorial state, a named review, a last fact-check date, and media-rights metadata. The Method page publishes the standard and the current limits."],
  ["Are the illustrations photographs?", "No. They are original AI-assisted illustrations generated under the project’s locked art direction. Each published asset has an exact generation record, commercial-use confirmation, and a species-accuracy review. They are never presented as documentary photography."],
  ["What does a Witness count mean?", "It measures reconciled acts of attention, not animals saved, money raised, policies changed, or conservation outcomes. The public count will remain unavailable until the production backend passes integrity and privacy testing."],
  ["Will the core experience be free?", "Yes. The featured story, its sources, the Witness action, the honest count or unavailable state, one credible action, and a private on-device reflection are intended to remain free. Paid Field Season and Atlas options are proposed but cannot be purchased today."],
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
          <div className="hero-proof" aria-label="Current project evidence">
            <span>{CATALOGUE.published} reviewed records</span><span>iOS MVP in development</span><span>Core ritual free</span>
          </div>
          <Eyebrow className="hero-eyebrow">A field archive of attention</Eyebrow>
          <h1>Meet one species.<br />Remember what is still here.</h1>
          <p className="hero-lede">One quiet iPhone ritual for seeing clearly, understanding deeply, and taking one honest next step.</p>
          <div className="hero-actions">
            <PrimaryLink href="#experience">Enter the experience</PrimaryLink>
            <TextLink href="/witnesses">Explore all {CATALOGUE.published} records</TextLink>
          </div>
          <div className="hero-collage" aria-label="Original Witness species illustrations">
            <figure className="hero-art hero-art-left"><Image src="/images/species/ploughshare-tortoise.jpg" alt="Original watercolor illustration of a ploughshare tortoise" fill sizes="220px" priority /></figure>
            <figure className="hero-art hero-art-center"><Image src="/images/species/whooping-crane-context.jpg" alt="Original watercolor illustration of two whooping cranes in flight" fill sizes="(max-width: 767px) 78vw, 560px" priority /></figure>
            <figure className="hero-art hero-art-right"><Image src="/images/species/philippine-eagle-detail.jpg" alt="Original watercolor head study of a Philippine eagle" fill sizes="220px" priority /></figure>
          </div>
          <p className="hero-caption">Original illustrations · exact rights records · not documentary photography</p>
        </Container>
      </section>

      <section id="experience" className="experience-section">
        <Container>
          <div className="section-intro"><div><h2>An app in the center.<br />The living world around it.</h2><p>Scroll through five approved records. The interface stays still enough to read while the archive changes around it.</p></div></div>
          <HomeExperience records={records} />
        </Container>
      </section>

      <section id="ritual" className="ritual-section">
        <Container>
          <div className="section-intro"><div><h2>One encounter.<br />Three deliberate steps.</h2></div></div>
          <ol className="ritual-grid">
            <li><span>01</span><h3>Meet</h3><p>Encounter one species through an approved illustration and a short sourced story.</p></li>
            <li><span>02</span><h3>Witness</h3><p>Record one private act of attention. A Witness is not a conservation outcome.</p></li>
            <li><span>03</span><h3>Act</h3><p>Open one credible source-backed action, chosen for the species and reviewed before release.</p></li>
          </ol>
        </Container>
      </section>

      <section className="archive-band">
        <Container>
          <div className="archive-band-grid"><div><Eyebrow className="text-[color:var(--dusk-muted)]">The reviewed launch catalog</Eyebrow><h2>{CATALOGUE.published} ways to begin paying attention.</h2></div><div><p>Each record is source-mapped, fact-checked, rights-cleared, generalized for location safety, and approved in the bundled catalog. Publication of the app is a separate gate.</p><PrimaryLink href="/witnesses" tone="dusk">Open the field archive</PrimaryLink></div></div>
          <div className="species-marquee" aria-hidden="true"><span>Vaquita</span><span>Red Wolf</span><span>Kākāpō</span><span>Amur Tiger</span><span>Axolotl</span><span>Whooping Crane</span></div>
        </Container>
      </section>

      <section className="trust-section">
        <Container>
          <div className="section-intro"><div><h2>Trust is part of the interface.</h2><p>Sources, rights, review state, privacy limits, and release status stay visible instead of disappearing behind a confident tone.</p></div></div>
          <div className="trust-grid">
            <article><span>A</span><h3>Evidence visible</h3><p>Every public claim maps to a dated repository source and an allowed wording.</p><TextLink href="/method">Read the method</TextLink></article>
            <article><span>B</span><h3>Private by default</h3><p>No account or public memories in the first release. Reflections are designed to stay on device.</p><TextLink href="/privacy">Read the privacy boundary</TextLink></article>
            <article><span>C</span><h3>Honest about readiness</h3><p>A catalog pass, a build, a backend test, a purchase, and an App Store release are separate gates.</p><TextLink href="/support">See current availability</TextLink></article>
          </div>
        </Container>
      </section>

      <section id="faq" className="faq-section">
        <Container>
          <div className="faq-layout"><div><h2>Frequently asked questions</h2><p className="faq-intro">Plain answers, including what the project cannot claim yet.</p></div><div className="faq-list">{FAQS.map(([question, answer], index) => <details key={question} open={index === 0}><summary><span>{question}</span><span aria-hidden="true" className="faq-plus" /></summary><p>{answer}</p></details>)}</div></div>
        </Container>
      </section>

      <section className="closing-section">
        <Container>
          <StatusBadge status="In development" note="Public release remains gated by production evidence." />
          <h2>Look closely.<br />Carry the name forward.</h2>
          <p>Witness is not yet on the App Store. The native MVP and reviewed catalog are real. Production backend, commerce, privacy, device, App Review, and public-release evidence are still pending.</p>
          <div className="closing-actions"><PrimaryLink href="/witnesses">Explore the records</PrimaryLink><Link href="/method">See exactly what is verified</Link></div>
        </Container>
      </section>
    </>
  );
}
