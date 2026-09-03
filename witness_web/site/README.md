# Witness web v3

An evidence-gated, static Next.js website for the Witness iOS app in development. The site pairs the original “Atlas at dusk” system with a centered-device narrative, five rights-cleared illustrations, a 30-record archive, a public method, FAQ, and reconciled Privacy, Terms, and Support pages.

## Run and verify

```bash
npm install
npm run dev
npm run lint
npx tsc --noEmit
npx next build --webpack
```

Next.js App Router, React, TypeScript, and Tailwind v4. All 40 public routes prerender. The homepage uses one small client component for IntersectionObserver-driven device state; the catalog and legal/editorial pages remain server-rendered.

## Source of truth

- `../PUBLIC_CLAIMS_SOURCE_OF_TRUTH.md` controls public wording.
- `data/species.json` is the assembled mirror of the 30 individual `WitnessCore` catalog records.
- `../docs/COMPETITION_AND_RELEASE_GATES.md` controls production and release claims.
- `../docs/DECISIONS.md` controls accepted project and media-rights decisions.
- `../docs/ACCESS_AND_COMMERCE_SOURCE_OF_RECORD.md` describes proposed commerce. It is not purchase evidence.

## Routes

```text
/                     Centered-device product narrative, ritual, trust, FAQ
/witnesses            30-record field archive
/witnesses/[id]       Sourced record, metadata, action, rights, JSON-LD
/field-notes          The daily essay index
/field-notes/[slug]   One sourced essay, Article + FAQPage JSON-LD, sources block
/method               Public claim and editorial evidence standard
/privacy              Current website facts and app privacy release gates
/terms                Development terms and proposed-commerce boundary
/support              Corrections, availability, count and purchase status
```

## Asset provenance

The five homepage assets are optimized derivatives of founder-supplied original AI-assisted illustrations. Each exact generation ID appears in a per-species rights record and in `PUBLIC_CLAIMS_SOURCE_OF_TRUTH.md`. D-013 records paid-plan commercial-use confirmation and catalog-wide approval. The site labels them as original illustrations and never documentary photography.

Final app screenshots are not yet available. The central phone is explicitly labeled “Development interface preview” and is assembled from approved catalog content. Replace it with authentic supplied app screenshots when those exist.

## Deployment boundary

Vercel root directory: `witness_web/site`. Framework: Next.js. No environment variables or secrets are required by this static site. Do not deploy until the exact payload in `../DEPLOYMENT_PAYLOAD_FOR_APPROVAL.md` is approved.
