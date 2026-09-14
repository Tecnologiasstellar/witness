import { LeadCard, PostCard, RecordCard, RowCard, Section, SectionHeading, SubscribeBand } from "@/components/cards.es";
import { Container } from "@/components/shell.es";
import { allPosts, postsInSection } from "@/lib/posts.es";
import { ATLAS_URL, SECTIONS } from "@/lib/site.es";
import { allRecords } from "@/lib/species.es";

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
            <p className="text-[17px] text-muted">La primera nota se está escribiendo.</p>
          )}
        </Container>
      </section>

      <SubscribeBand />

      {/* Section rows ----------------------------------------------------- */}
      {rows.map(({ section, posts: inSection }) => (
        <Section key={section.key}>
          <SectionHeading title={section.name} blurb={section.blurb} href={`/es/s/${section.key}`} />
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
          title="El Archivo"
          blurb="Treinta fichas de especies, cada una con fuentes, derechos y un estado de revisión honesto. El catálogo propio de la app."
          href={`${ATLAS_URL}/es/archive`}
          more="Todas las fichas"
        />
        <div className="mt-6 grid grid-cols-2 gap-5 sm:grid-cols-3 lg:grid-cols-6">
          {records.map((record) => (
            <RecordCard key={record.id} record={record} />
          ))}
        </div>
      </Section>

      {/* Latest ----------------------------------------------------------- */}
      <Section>
        <SectionHeading title="Lo último" blurb="Cada nota, la más reciente primero." />
        <ul className="mt-2 divide-y divide-line">
          {posts.map((post) => (
            <li key={post.slug} className="py-6">
              <RowCard post={post} big />
            </li>
          ))}
        </ul>
      </Section>
    </>
  );
}
