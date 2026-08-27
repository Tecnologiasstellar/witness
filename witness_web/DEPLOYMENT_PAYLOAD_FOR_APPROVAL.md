# Vercel deployment record

Status: production promotion approved, executed, and verified  
Prepared: 2026-08-27  
Preview deployed: 2026-08-27

## Official-domain migration

- Canonical domain: `https://witnessatlas.com/`
- Canonical `www` behavior: permanent redirect to the apex domain, preserving the full path.
- Public legacy Vercel alias behavior: `witness-rho.vercel.app` permanently redirects to the canonical apex domain while preserving the full path. The team-scoped Vercel alias remains behind existing Vercel SSO protection.
- Registrar and DNS host: GoDaddy; existing nameservers and email-related MX, TXT, DKIM, and DMARC records remain unchanged.
- Vercel domain attachment: complete for `witnessatlas.com` and `www.witnessatlas.com`.
- DNS cutover: complete and publicly verified. GoDaddy nameservers and all existing email-related records were preserved.

## Production result

- Production deployment: `dpl_FmuXZobtMx4c6cJqY3DeqxgNsUXc`
- Production URL: `https://witnessatlas.com/`
- Immutable source preview promoted: `dpl_7EEcHfH32Vgku7wsDfeJZ1QnEiYt`
- Source commit: `a01d5df` (`Prepare Witness official domain migration`)
- Status: `Ready`
- Public crawl: PASS; 39/39 routes returned HTTP 200
- Production Lighthouse: Performance 95, Accessibility 100, Best Practices 100, SEO 100
- Domain aliases changed: `witnessatlas.com` and `www.witnessatlas.com` became production aliases; the public legacy alias now redirects permanently to the apex.
- Project environment variables changed: no
- Immediate pre-cutover rollback deployment: `dpl_2oy1gncewf1C2Adihdq2VAP5kuPU`

## Preview result

- Deployment ID: `dpl_7EEcHfH32Vgku7wsDfeJZ1QnEiYt`
- Preview URL: `https://witness-qyz2kpeos-tecnologiasstellars-projects.vercel.app`
- Inspector: `https://vercel.com/tecnologiasstellars-projects/witness/7EEcHfH32Vgku7wsDfeJZ1QnEiYt`
- Status: `Ready`
- Production alias changed at the founder-approved promotion step
- Project settings, domains, and environment variables changed: no

## Exact target

| Setting | Final value |
|---|---|
| Vercel team | `team_cyGKvdd1xun0Cyd5xyWcFQTe` |
| Vercel project | `witness` (`prj_33pVN7nvYINyD2fzb6Ebdzyw5EbV`) |
| Official canonical URL | `https://witnessatlas.com/` |
| Legacy public alias | `https://witness-rho.vercel.app/` |
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

1. Deployed the exact committed site to an immutable Vercel preview and verified it before changing production.
2. Attached and verified `witnessatlas.com` and `www.witnessatlas.com` on the existing Vercel project.
3. After explicit approval, replaced only the GoDaddy parking records with `A @ 216.198.79.1`, `A @ 64.29.17.1`, and `CNAME www 9da28e999f1f52d9.vercel-dns-017.com`, all at TTL 600.
4. Preserved GoDaddy nameservers plus all MX, SPF, DMARC, DKIM, bounce, and Domain Connect records.
5. Verified public DNS and Vercel configuration, issued managed TLS for apex and `www`, then promoted preview `dpl_7EEcHfH32Vgku7wsDfeJZ1QnEiYt` to production.
6. Verified the official homepage, canonical metadata, all 39 public routes/assets, Lighthouse, and path-preserving 308 redirects from `www` and the public legacy Vercel alias. The team-scoped Vercel alias correctly remains behind its pre-existing SSO protection.

## Final result

- 41 generated static pages, including the favicon route.
- No database, API route, analytics, cookies, account, email capture, payment, or production collective count.
- Official traffic now resolves to the promoted presentation after separate DNS-cutover and production-promotion approval.

## Rollback

If the approved production promotion regresses, reassign the production aliases to `dpl_2oy1gncewf1C2Adihdq2VAP5kuPU`. If the domain cutover itself must be reversed, restore the prior GoDaddy parking A record and `www` alias from the pre-cutover inventory. No data migration or environment rollback is required because this payload introduces no persisted data or environment changes.

## Approval record

Preview approval was received first. The founder then explicitly approved both the GoDaddy DNS cutover and production promotion. Only the three approved DNS record changes, Vercel managed-certificate issuance, and promotion of the verified immutable preview were performed.
