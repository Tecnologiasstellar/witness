# Witness website

This folder contains the source-controlled Witness public website and its evidence ledger. The current experience is a responsive, editorial Next.js site inspired by an app-centered storytelling rhythm while retaining Witness's own archival identity.

Witness is still in development. This website is not evidence of App Store availability, a production count, working purchases, a conservation partnership, or a conservation outcome.

## Start here

1. [Public claims source of truth](PUBLIC_CLAIMS_SOURCE_OF_TRUTH.md) - canonical wording and evidence for every public claim.
2. [Site README](site/README.md) - local development, architecture, and checks.
3. [Design notes](site/DESIGN_NOTES.md) - current visual system and anti-copy boundary.
4. [Accessibility](site/ACCESSIBILITY.md) - implemented behavior and test checklist.
5. [QA report](QA_REPORT_2026-08-27.md) - dated validation evidence.
6. [Deployment payload](DEPLOYMENT_PAYLOAD_FOR_APPROVAL.md) - exact proposed Vercel change; approval required before execution.

## Current scope

- Homepage with central iPhone development preview, five rights-cleared web illustrations, ritual explanation, archive preview, trust principles, FAQ, and status CTA.
- Archive and 30 statically generated species-record routes copied from the approved bundled iOS catalog.
- Method, Privacy, Terms, and Support pages reconciled to the same evidence ledger.
- No analytics, cookies, email capture, account, payment flow, or live collective count.

## Historical documents

`PROJECT_CONTEXT.md`, `WEBSITE_V1_SCOPE.md`, `DESIGN_SYSTEM.md`, `CLAIMS_AND_ASSET_GUARDRAILS.md`, and `PROMPT_ONE_PAGE_WEBSITE.md` preserve the original v1 brief. They are design history, not current factual authority. When they conflict with the public claims ledger or repository release gates, the newer evidence wins.

## Local commands

```bash
cd site
npm ci
npm run dev
npm run lint
npx tsc --noEmit
npm run build -- --webpack
```

The official canonical domain is `https://witnessatlas.com/`. The GoDaddy DNS cutover and Vercel production verification are recorded in `DEPLOYMENT_PAYLOAD_FOR_APPROVAL.md` and `QA_REPORT_2026-08-27.md`.
