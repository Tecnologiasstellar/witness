# Witness web v3 accessibility contract

Last implementation review: 2026-08-26

## Required checks

- One descriptive `h1` per route with sequential headings.
- Skip link is the first focusable element.
- Header, primary navigation, main, breadcrumbs, and footer are landmarks.
- All actions use native anchors, buttons, summary, or radio inputs.
- Visible focus uses a 2 px sage outline with 3 px offset.
- Touch targets are at least 44 by 44 CSS pixels.
- Mobile navigation and FAQ use native `details` and `summary`.
- Original illustrations have concise species-specific alternative text.
- Decorative illustrations and inactive phone states use empty alternative text.
- Device state updates are announced through a polite live region.
- Record sources, rights state, editorial state, and generalized location remain text, not color-only signals.
- Reduced motion disables the species marquee and device image transitions.
- Reduced transparency removes procedural grain.
- No hover-only information or keyboard trap.
- 320 px layouts must have no horizontal overflow.

## Contrast tokens

The inherited light and dusk tokens remain the tested foundation: ink on paper, sepia on paper, muted ink on paper, paper on ink, and sage focus. Any future screenshot overlays or new status colors require fresh contrast verification before release.

## Honest preview boundary

The central phone is labeled as a development interface preview. It is not described as a screenshot, released product, or proof of production backend and commerce behavior.

## Remaining release distinction

Website accessibility QA does not pass the native app’s VoiceOver, Dynamic Type, Reduce Motion, contrast, and touch-target release gate. Those require separate physical-device evidence.
