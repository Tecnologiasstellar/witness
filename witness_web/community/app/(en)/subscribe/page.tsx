import type { Metadata } from "next";
import { Button, Container } from "@/components/shell";
import { ATLAS_URL, FEED_PATH, PUB_NAME, SITE_URL, SUBSCRIBE_URL } from "@/lib/site";

export const metadata: Metadata = {
  title: "Subscribe",
  description: "Get new field notes by email or by RSS. Free, no tracking, leave any time.",
  alternates: { canonical: "/subscribe" },
};

export default function SubscribePage() {
  return (
    <section className="py-10 md:py-14">
      <Container>
        <div className="mx-auto max-w-[62ch]">
          <p className="text-[11px] font-bold uppercase tracking-[0.16em] text-accent">Subscribe</p>
          <h1 className="mt-2 text-balance font-display text-[clamp(2rem,5vw,3.4rem)] font-extrabold leading-[1.05] tracking-[-0.03em] text-ink">
            Every new note, the day it ships.
          </h1>
          <p className="mt-6 text-pretty text-[18px] leading-[1.65] text-ink">
            {PUB_NAME} publishes a few short, sourced essays a week. There are two ways to follow it, and both are free.
          </p>

          <div className="mt-10 grid gap-6 sm:grid-cols-2">
            <div className="rounded-lg border border-line p-6">
              <h2 className="font-display text-[20px] font-extrabold tracking-[-0.02em] text-ink">By email</h2>
              {SUBSCRIBE_URL ? (
                <>
                  <p className="mt-2 text-[15px] leading-[1.6] text-muted">
                    A round-up of new notes, a few times a month. The list is held by a separate provider under its own privacy
                    terms; nothing on this site stores your address.
                  </p>
                  <div className="mt-5">
                    <Button href={SUBSCRIBE_URL} external>
                      Subscribe free
                    </Button>
                  </div>
                </>
              ) : (
                <p className="mt-2 text-[15px] leading-[1.6] text-muted">
                  The email edition is being set up. This page will carry the sign-up as soon as the provider is live. Until
                  then, the feed is complete.
                </p>
              )}
            </div>
            <div className="rounded-lg border border-line p-6">
              <h2 className="font-display text-[20px] font-extrabold tracking-[-0.02em] text-ink">By RSS</h2>
              <p className="mt-2 text-[15px] leading-[1.6] text-muted">
                Every note in full, with its sources, in any feed reader. Paste this address:
              </p>
              <code className="mt-3 block overflow-x-auto rounded bg-surface px-3 py-2 text-[13px] text-ink">
                {SITE_URL}
                {FEED_PATH}
              </code>
              <div className="mt-5">
                <Button href={FEED_PATH} tone="ghost">
                  Open the feed
                </Button>
              </div>
            </div>
          </div>

          <p className="mt-10 text-[15px] leading-[1.6] text-muted">
            This site sets no cookies and runs no analytics. The privacy page on the atlas,{" "}
            <a href={`${ATLAS_URL}/privacy`} className="font-semibold text-accent hover:text-ink">
              witnessatlas.com/privacy
            </a>
            , covers both sites.
          </p>
        </div>
      </Container>
    </section>
  );
}
