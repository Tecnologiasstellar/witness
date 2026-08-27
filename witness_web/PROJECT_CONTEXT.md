# Witness: product and project context

> Historical v1 brief, superseded for factual claims on 2026-08-27. Use `PUBLIC_CLAIMS_SOURCE_OF_TRUTH.md` and the repository release gates for current status. The original text below is retained only as design history.

## One-sentence pitch

> Every day, witness one species on the edge of disappearance—and join a global archive of memory and action.

## What Witness is

Witness is a native iOS daily ritual about threatened and extinct species. In one or two minutes, a person meets one species, reads a short sourced story, records an act of witness, and is offered one credible action.

The experience is built around one invariant loop:

```text
Meet one species → read a sourced story → Witness once → see an honest attention state → take one credible action → optionally share → retain the card privately
```

Witness is not an encyclopedia, social network, donation marketplace, doom feed, pet app, or generic environmental dashboard.

## The promise

- One species. No feed. No decision fatigue.
- Beauty earns attention without turning extinction into spectacle.
- Sources, verification state, and rights are part of the product.
- A Witness event measures attention, not conservation impact.
- The daily story, sources, Witness action, and credible action remain free.
- Privacy is a product feature: no accounts or public user-generated content in v1.

## What exists today

The local iOS MVP includes:

- Native SwiftUI, iOS 17+, iPhone-first.
- Offline-first bundled catalog with one Vaquita prototype record.
- Atlas presentation with three destinations: Today, Cabinet, and Notes; Settings is an Index sheet.
- Local idempotent Witness persistence, private reflection, streak logic, and a share-plate preview.
- Deterministic domain tests and unsigned iOS build CI.

## What does not exist today

- No public App Store release or public download link.
- No hosted backend or collective live count.
- No RevenueCat integration, subscription, purchase, or payment flow.
- No production-cleared Vaquita photograph or production media library.
- No account, public Memory Bank, donation flow, conservation partnership, or partner-verified outcome metric.

## Current flagship story: Vaquita

The bundled prototype uses a sourced, generalized Vaquita record:

- Common name: Vaquita.
- Scientific name: *Phocoena sinus*.
- Generalized range: Northern Gulf of California, Mexico.
- Core story: gillnet entanglement threatens vaquitas; the page must not extend this into an unsourced population claim or a claim that a Witness action saves an animal.
- Credible prototype action: read NOAA Fisheries’ explanation of the threat and recovery context.
- Sources in the current record: NOAA Fisheries and CITES.

The current artwork is a code-drawn abstract prototype. It is not a documentary image. A user-provided Vaquita image remains unavailable to the workspace and pending per-file rights metadata; it must not be used on the website.

## Audience and job to be done

| Audience | What they need to feel or understand |
|---|---|
| Design-conscious early supporter | “This is beautiful, specific, and not emotionally manipulative.” |
| Conservation advisor or partner | “The claims are humble, sourced, rights-aware, and structurally credible.” |
| Shipathon judge | “This is a feasible native product with a real ethical boundary and a clear path to revenue.” |
| Future user | “I can give one species my attention without signing up, being guilted, or being overwhelmed.” |

## Repository architecture

```text
WitnessApp/                 SwiftUI composition, presentation, platform adapters
Packages/WitnessCore/       Stable models, catalog, persistence, daily logic, streaks, tests
docs/                       Product decisions, rights records, release gates, dated evidence
witness_web/                Web v1.0 handoff and build prompt
```

`WitnessCore` must remain independent of SwiftUI, backend SDKs, RevenueCat, and analytics providers. The web project must likewise be independent: static content first, integrations only after a concrete approved use case.
