# Proposed Vercel deployment payload

Status: awaiting founder approval  
Prepared: 2026-08-27  
No Vercel mutation has been made.

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

## Execution sequence after approval

1. Deploy this exact committed site to a Vercel preview, without changing domains, environment variables, project settings, or the production alias.
2. Verify every generated route, mobile and desktop layout, keyboard behavior, metadata, external links, and Lighthouse on that preview.
3. Present the preview URL and evidence. Request a separate explicit approval to promote it to production.
4. Only after production approval, promote the verified immutable preview to the existing project alias.

## Expected result

- 40 generated static pages.
- No database, API route, analytics, cookies, account, email capture, payment, or production collective count.
- Replacement of the current public presentation only after the separate production approval.

## Rollback

If the approved production promotion regresses, immediately reassign the production alias to the prior known-good Vercel deployment. No data migration or environment rollback is required because this payload introduces no persisted data or environment changes.

## Approval language

Approval of this document authorizes only step 1: a preview deployment of the committed payload to the linked `witness` Vercel project. It does not authorize production promotion, alias changes, domain changes, environment-variable changes, purchases, or any other external mutation.
