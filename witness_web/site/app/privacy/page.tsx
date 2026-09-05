import type { Metadata } from "next";
import { Container, Eyebrow } from "@/components/atlas";
import { Breadcrumbs } from "@/components/record";
import { CONTACT_EMAIL } from "@/lib/archive";

export const metadata: Metadata = {
  title: "Privacy",
  description: "What the Witness website and iPhone app do and do not collect: no account, no tracking, private notes that stay on your phone.",
  alternates: { canonical: "/privacy" },
};

const SECTIONS: [string, string[]][] = [
  ["This website", ["This website uses no account, email capture, analytics, advertising, or cookies. It serves public editorial pages, original illustrations, and one audio sample."]],
  ["The app", ["Witness needs no account and never asks for your name, email, or location. To keep the weekly witness count honest, the app stores a random installation identifier and sends one witness event per installation and featured species; the server returns an aggregate count. That is the whole exchange.", "The App Store privacy label reads “Data Not Linked to You: Identifiers, Usage Data”. Nothing is used for tracking or advertising, nothing is sold, and no third-party analytics or advertising SDK is in the app."]],
  ["Private notes", ["Notes you write stay in protected storage on your phone. They are never sent to a server, never shown to anyone else, and never appear in a share image. Deleting the app removes them from the device."]],
  ["Reminders", ["The weekly reminder is a local notification scheduled on your phone. No push token and no location are collected, and the reminder can be turned off at any time in Settings."]],
  ["Purchases", ["Field Season One, the Atlas, and the Support tip are in-app purchases processed by Apple. RevenueCat manages entitlement state using the same anonymous identifier. Witness never receives your payment details. Apple keeps purchase records under its own terms."]],
  ["Deletion", ["Delete the app and its on-device data goes with it. Witness events already counted are anonymous and cannot be traced back to you, so there is nothing further to delete."]],
  ["Contact", [`Privacy questions: ${CONTACT_EMAIL}. Please leave out private note text and precise locations of sensitive species. Material changes to this policy are dated and stated in plain language.`]],
];

export default function PrivacyPage() {
  return (
    <section className="py-12 md:py-16">
      <Container>
        <Breadcrumbs trail={[{ href: "/", label: "Witness" }, { label: "Privacy" }]} />
        <div className="mt-8 max-w-[62ch]">
          <Eyebrow className="text-sepia">Privacy · updated 4 September 2026</Eyebrow>
          <h1 className="mt-6 text-balance font-display text-[clamp(2rem,5vw,3.5rem)] font-semibold leading-[1.08] tracking-[-0.01em] text-ink">Nothing about you leaves your phone.</h1>
          {SECTIONS.map(([heading, paragraphs]) => (
            <div key={heading} className="mt-10">
              <h2 className="text-[11px] font-semibold uppercase tracking-[0.18em] text-sepia">{heading}</h2>
              {paragraphs.map((text) => (
                <p key={text.slice(0, 32)} className="mt-4 text-pretty text-[16px] leading-[1.7] text-ink-muted">{text}</p>
              ))}
            </div>
          ))}
        </div>
      </Container>
    </section>
  );
}
