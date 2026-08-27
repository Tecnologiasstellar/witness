# Vercel deployment record

Status: production promotion approved, executed, and verified  
Prepared: 2026-08-27  
Preview deployed: 2026-08-27

## Production result

- Production deployment: `dpl_2oy1gncewf1C2Adihdq2VAP5kuPU`
- Production URL: `https://witness-rho.vercel.app/`
- Immutable source preview: `dpl_6r2sc7t33BA364mk5ySHc7oHWG8W`
- Source commits: `528df0e` and `a5d4b0c` on top of website commit `b2eaf2b`
- Status: `Ready`
- Public crawl: PASS; 39/39 routes returned HTTP 200
- Production Lighthouse: Performance 95, Accessibility 100, Best Practices 100, SEO 100
- Project settings, domains, and environment variables changed: no
- Previous rollback deployment: `dpl_5wrYmeupoDBZavQ4MJDczCcoCJT5`

## Preview result

- Deployment ID: `dpl_Ayhs6hCU8toWkboddv3qdBdK6Saa`
- Preview URL: `https://witness-4nvnhbw96-tecnologiasstellars-projects.vercel.app`
- Inspector: `https://vercel.com/tecnologiasstellars-projects/witness/Ayhs6hCU8toWkboddv3qdBdK6Saa`
- Status: `Ready`
- Production alias changed at the founder-approved promotion step
- Project settings, domains, and environment variables changed: no

## Exact target

| Setting | Proposed value |
|---|---|
| Vercel team | `team_cyGKvdd1xun0Cyd5xyWcFQTe` |
| Vercel project | `witness` (`prj_33pVN7nvYINyD2fzb6Ebdzyw5EbV`) |
| Existing public alias | `https://witness-rho.vercel.app/` |
| Repository working tree | `/Users/avp/Documents/CODEX/Witness` |
| Root directory | `witness_web/site` |
| Framework | Next.js 16.3.2 |
| Install command | `npm ci` |
| Build command | `npm run build` |
| Output | Next.js default `.next` output |
| Runtime | Node.js 24.x, declared in `site/package.json` and locally verified with 24.19.0 |
| Required environment variables | None for public website behavior |

The local `.env.local` contains only a Vercel CLI OIDC token and is ignored. It is excluded from the payload and must not be copied into Git or Vercel project variables.

## Included source payload

- `witness_web/site/app/**`
- `witness_web/site/components/**`
- `witness_web/site/data/species.json`
- `witness_web/site/lib/**`
- `witness_web/site/public/images/species/**`
- `witness_web/site/*.md`
- `witness_web/site/package.json`
- `witness_web/site/package-lock.json`
- `witness_web/site/next.config.ts`
- `witness_web/site/tsconfig.json`
- `witness_web/site/eslint.config.mjs`
- `witness_web/site/postcss.config.mjs`
- Root `witness_web/*.md` governance, evidence, QA, and handoff files

## Explicit exclusions

- `witness_web/site/.env.local`
- `witness_web/site/.vercel/**`
- `witness_web/site/.next/**`
- `witness_web/site/node_modules/**`
- All files outside `witness_web/**`, including the unrelated modified Xcode project
- Source PNGs in the user's Downloads folder

## Executed sequence

1. Deploy this exact committed site to a Vercel preview, without changing domains, environment variables, project settings, or the production alias.
2. Verify every generated route, mobile and desktop layout, keyboard behavior, metadata, external links, and Lighthouse on that preview.
3. Present the preview URL and evidence. Request a separate explicit approval to promote it to production.
4. Only after production approval, promote the verified immutable preview to the existing project alias.

## Expected result

- 41 generated static pages, including the favicon route.
- No database, API route, analytics, cookies, account, email capture, payment, or production collective count.
- Replacement of the current public presentation only after the separate production approval.

## Rollback

If the approved production promotion regresses, immediately reassign the production alias to the prior known-good Vercel deployment. No data migration or environment rollback is required because this payload introduces no persisted data or environment changes.

## Approval record

Preview approval was received first. Production promotion was separately and explicitly approved afterward. No other external mutation was authorized or performed.
