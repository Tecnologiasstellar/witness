import type { Route } from "next";
import Link from "next/link";
import { LeadCard, PostCard, RecordCard, RowCard, Section, SectionHeading, SubscribeBand } from "@/components/cards";
import { Container } from "@/components/shell";
import { allPosts, postsInSection } from "@/lib/posts";
import { SECTIONS } from "@/lib/site";
import { allRecords } from "@/lib/species";

export default function Home() {
  const posts = allPosts();
  const [lead, ...rest] = posts;
  const rail = rest.slice(0, 3);
  const rows = SECTIONS.map((s) => ({ section: s, posts: postsInSection(s.key) })).filter((r) => r.posts.length > 0);
  const records = allRecords().slice(0, 6);

  return (
    <>
      {/* Lead + rail ------------------------------------------------------ */}
      <section className="py-8 md:py-10">
        <Container>
          {lead ? (
            <div className="grid gap-10 md:grid-cols-12 md:gap-8">
              <div className="md:col-span-7">
                <LeadCard post={lead} />
              </div>
              <div className="md:col-span-5">
                <ul className="divide-y divide-line border-t border-line md:border-t-0">
                  {rail.map((post) => (
                    <li key={post.slug} className="py-5 first:md:pt-0">
                      <RowCard post={post} />
                    </li>
                  ))}
                </ul>
              </div>
            </div>
          ) : (
            <p className="text-[17px] text-muted">The first note is being written.</p>
          )}
        </Container>
      </section>

      <SubscribeBand />

      {/* Section rows ----------------------------------------------------- */}
      {rows.map(({ section, posts: inSection }) => (
        <Section key={section.key}>
          <SectionHeading title={section.name} blurb={section.blurb} href={`/s/${section.key}`} />
          {inSection.length >= 3 ? (
            <div className="mt-6 grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
              {inSection.slice(0, 3).map((post) => (
                <PostCard key={post.slug} post={post} />
              ))}
            </div>
          ) : (
            <div className="mt-6 grid gap-8 md:grid-cols-2">
              {inSection.map((post) => (
                <RowCard key={post.slug} post={post} big />
              ))}
            </div>
          )}
        </Section>
      ))}

      {/* The archive ------------------------------------------------------ */}
      <Section className="bg-surface">
        <SectionHeading
          title="The Archive"
          blurb="Thirty species records, each with sources, rights, and an honest review state. The app's own catalog."
          href="/archive"
          more="All records"
        />
        <div className="mt-6 grid grid-cols-2 gap-5 sm:grid-cols-3 lg:grid-cols-6">
          {records.map((record) => (
            <RecordCard key={record.id} record={record} />
          ))}
        </div>
      </Section>

      {/* Latest ----------------------------------------------------------- */}
      <Section>
        <SectionHeading title="Latest" blurb="Every note, newest first." />
        <ul className="mt-2 divide-y divide-line">
          {posts.map((post) => (
            <li key={post.slug} className="py-6">
              <RowCard post={post} big />
            </li>
          ))}
        </ul>
        <p className="mt-6 text-[15px] text-muted">
          Have a note in you?{" "}
          <Link href={"/write" as Route} className="font-semibold text-accent hover:text-ink">
            Read the brief
          </Link>
          .
        </p>
      </Section>
    </>
  );
}
