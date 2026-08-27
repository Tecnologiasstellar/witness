/**
 * Original engraved-style specimen geometry, written for this site.
 * Not documentary media: no photograph, trace, map, or third-party asset.
 * Every mark is drawn in currentColor so a plate reads correctly on paper
 * and on the inverted dusk band alike.
 */

type Tone = "paper" | "dusk";

const metaClass = (tone: Tone) =>
  tone === "dusk"
    ? "text-[color:var(--dusk-muted)]"
    : "text-sepia";

const ruleStyle = (tone: Tone) =>
  tone === "dusk"
    ? { backgroundColor: "var(--dusk-rule)" }
    : { backgroundColor: "color-mix(in srgb, var(--hairline) 60%, transparent)" };

const borderStyle = (tone: Tone) =>
  tone === "dusk"
    ? { borderColor: "var(--dusk-rule)" }
    : { borderColor: "color-mix(in srgb, var(--hairline) 70%, transparent)" };

/** Registration crosses, as printers use to align a plate. */
function Registration({ tone }: { tone: Tone }) {
  const mark = (
    <svg viewBox="0 0 16 16" className="h-3 w-3" aria-hidden="true">
      <path
        d="M8 1v14M1 8h14"
        stroke="currentColor"
        strokeWidth="0.8"
        opacity="0.55"
      />
      <circle
        cx="8"
        cy="8"
        r="3.2"
        fill="none"
        stroke="currentColor"
        strokeWidth="0.8"
        opacity="0.55"
      />
    </svg>
  );
  return (
    <div aria-hidden="true" className={metaClass(tone)}>
      <span className="absolute -left-1.5 -top-1.5">{mark}</span>
      <span className="absolute -right-1.5 -top-1.5">{mark}</span>
      <span className="absolute -bottom-1.5 -left-1.5">{mark}</span>
      <span className="absolute -bottom-1.5 -right-1.5">{mark}</span>
    </div>
  );
}

/** Hairline scale motif for the abstract interface study. */
function ScaleMotif({ tone }: { tone: Tone }) {
  return (
    <div className="flex items-center gap-3">
      <div aria-hidden="true" className="relative h-2 w-28 shrink-0">
        {[0, 25, 50, 75, 100].map((left) => (
          <span
            key={left}
            className="absolute top-0 w-px"
            style={{
              left: `${left}%`,
              height: left % 50 === 0 ? "8px" : "5px",
              ...ruleStyle(tone),
            }}
          />
        ))}
        <span
          className="absolute left-0 top-1 h-px w-full"
          style={ruleStyle(tone)}
        />
      </div>
      <span
        className={`text-[10px] font-semibold uppercase tracking-[0.16em] ${metaClass(tone)}`}
      >
        Scale unavailable
      </span>
    </div>
  );
}

/** Engraving hatch patterns, sized so they read as ink rather than grey. */
function HatchDefs({ uid }: { uid: string }) {
  return (
    <defs>
      <pattern
        id={`hatch-fine-${uid}`}
        width="7"
        height="7"
        patternUnits="userSpaceOnUse"
        patternTransform="rotate(38)"
      >
        <line
          x1="0"
          y1="0"
          x2="0"
          y2="7"
          stroke="currentColor"
          strokeWidth="0.7"
        />
      </pattern>
      <pattern
        id={`hatch-dense-${uid}`}
        width="3.4"
        height="3.4"
        patternUnits="userSpaceOnUse"
        patternTransform="rotate(38)"
      >
        <line
          x1="0"
          y1="0"
          x2="0"
          y2="3.4"
          stroke="currentColor"
          strokeWidth="0.65"
        />
      </pattern>
    </defs>
  );
}

const BODY_PATH =
  "M96 214C104 180 150 152 226 150C300 148 380 166 452 192C500 210 528 220 556 230L600 196C612 190 620 196 614 208C606 224 588 238 566 246C590 258 610 272 616 288C620 300 610 306 598 298L556 266C520 268 470 278 400 282C320 286 240 282 172 266C128 254 100 236 96 214Z";

/** Ruled water: engraved strata that ground the figure without depicting a place. */
function RuledWater({ tone }: { tone: Tone }) {
  const rows = [
    { y: 332, x1: 62, x2: 588, o: 0.3 },
    { y: 340, x1: 104, x2: 548, o: 0.24 },
    { y: 346, x1: 48, x2: 602, o: 0.28 },
    { y: 351, x1: 150, x2: 512, o: 0.2 },
    { y: 355.5, x1: 70, x2: 580, o: 0.26 },
    { y: 359.5, x1: 42, x2: 606, o: 0.22 },
    { y: 363, x1: 190, x2: 470, o: 0.18 },
    { y: 366.5, x1: 80, x2: 566, o: 0.2 },
    { y: 369.5, x1: 44, x2: 604, o: 0.17 },
    { y: 372, x1: 150, x2: 520, o: 0.15 },
    { y: 374.5, x1: 62, x2: 588, o: 0.14 },
    { y: 376.5, x1: 44, x2: 604, o: 0.12 },
  ];
  return (
    <g aria-hidden="true" opacity={tone === "dusk" ? 0.9 : 1}>
      {rows.map((r) => (
        <line
          key={r.y}
          x1={r.x1}
          y1={r.y}
          x2={r.x2}
          y2={r.y}
          stroke="currentColor"
          strokeWidth="0.8"
          opacity={r.o}
        />
      ))}
    </g>
  );
}

function VaquitaStudy({
  title,
  uid,
  tone,
}: {
  title: string;
  uid: string;
  tone: Tone;
}) {
  return (
    <svg
      viewBox="0 0 640 400"
      role="img"
      aria-label={title}
      className="h-auto w-full"
      fill="none"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <HatchDefs uid={uid} />
      <defs>
        <linearGradient id={`tone-${uid}`} x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#fff" stopOpacity="1" />
          <stop offset="0.5" stopColor="#fff" stopOpacity="0.5" />
          <stop offset="1" stopColor="#fff" stopOpacity="0.05" />
        </linearGradient>
        <mask
          id={`tonemask-${uid}`}
          maskUnits="userSpaceOnUse"
          x="80"
          y="142"
          width="560"
          height="160"
        >
          <rect
            x="80"
            y="142"
            width="560"
            height="160"
            fill={`url(#tone-${uid})`}
          />
        </mask>
      </defs>
      <clipPath id={`body-${uid}`}>
        <path d={BODY_PATH} />
      </clipPath>

      <RuledWater tone={tone} />

      {/* engraved tone: hatching densest along the dorsal ridge, fading to the belly */}
      <g clipPath={`url(#body-${uid})`} aria-hidden="true">
        <rect
          x="80"
          y="140"
          width="560"
          height="170"
          fill={`url(#hatch-fine-${uid})`}
          opacity="0.28"
        />
        <g mask={`url(#tonemask-${uid})`}>
          <rect
            x="80"
            y="140"
            width="560"
            height="170"
            fill={`url(#hatch-dense-${uid})`}
            opacity="0.6"
          />
        </g>
      </g>

      {/* body */}
      <path d={BODY_PATH} stroke="currentColor" strokeWidth="1.7" />
      {/* dorsal fin */}
      <path
        d="M290 150C302 120 324 104 346 96C338 118 332 136 334 154"
        stroke="currentColor"
        strokeWidth="1.7"
      />
      {/* pectoral flipper */}
      <path
        d="M190 250C210 272 240 291 270 297C246 302 210 292 186 271"
        stroke="currentColor"
        strokeWidth="1.7"
      />
      {/* rostrum and lip line */}
      <path
        d="M99 222C120 231 141 236 160 237"
        stroke="currentColor"
        strokeWidth="1.2"
      />
      {/* eye patch, drawn as geometry rather than portraiture */}
      <ellipse
        cx="139"
        cy="203"
        rx="15"
        ry="11"
        stroke="currentColor"
        strokeWidth="1.2"
      />
      <circle cx="139" cy="203" r="3.2" fill="currentColor" stroke="none" />

      {/* contour lines following the flank */}
      <g opacity="0.5" aria-hidden="true">
        <path
          d="M164 208C226 196 306 198 384 214"
          stroke="currentColor"
          strokeWidth="0.9"
        />
        <path
          d="M172 231C232 222 312 224 392 240"
          stroke="currentColor"
          strokeWidth="0.9"
        />
        <path
          d="M186 253C242 246 316 249 392 263"
          stroke="currentColor"
          strokeWidth="0.9"
        />
        <path
          d="M430 214C468 224 500 235 528 246"
          stroke="currentColor"
          strokeWidth="0.9"
        />
      </g>

      {/* taxonomy leader lines, never labels of severity */}
      <g opacity="0.45" aria-hidden="true" className="max-sm:hidden">
        <path
          d="M346 96L346 60M346 60L292 60"
          stroke="currentColor"
          strokeWidth="0.9"
        />
        <path
          d="M139 203L139 312M139 312L206 312"
          stroke="currentColor"
          strokeWidth="0.9"
        />
        <path
          d="M604 292L604 306M604 306L552 306"
          stroke="currentColor"
          strokeWidth="0.9"
        />
      </g>
      <g
        aria-hidden="true"
        className="max-sm:hidden"
        fill="currentColor"
        stroke="none"
        opacity="0.75"
        fontSize="15"
        letterSpacing="2.4"
        fontFamily="var(--font-body)"
      >
        <text x="286" y="56" textAnchor="end">
          DORSAL
        </text>
        <text x="214" y="316">
          CRANIAL
        </text>
        <text x="544" y="310" textAnchor="end">
          CAUDAL
        </text>
      </g>
    </svg>
  );
}

function DorsalStudy({ title, uid }: { title: string; uid: string }) {
  const path =
    "M30 130C34 110 64 96 120 96C186 96 250 110 278 124C296 118 320 100 344 86C352 81 357 88 350 96C336 114 314 128 292 133C314 138 336 152 350 170C357 178 352 185 344 180C320 166 296 148 278 138C250 152 186 166 120 166C64 166 34 150 30 130Z";
  const flipperTop = "M134 106C152 88 178 74 198 68C188 84 168 100 148 110Z";
  const flipperBottom = "M134 154C152 172 178 186 198 192C188 176 168 160 148 150Z";
  return (
    <svg
      viewBox="0 0 380 260"
      role="img"
      aria-label={title}
      className="h-auto w-full"
      fill="none"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <HatchDefs uid={uid} />
      <clipPath id={`dorsal-${uid}`}>
        <path d={path} />
      </clipPath>

      {/* axis of symmetry */}
      <path
        d="M12 130H368"
        stroke="currentColor"
        strokeWidth="0.8"
        strokeDasharray="7 5"
        opacity="0.35"
        aria-hidden="true"
      />

      <g clipPath={`url(#dorsal-${uid})`} aria-hidden="true">
        <rect
          x="0"
          y="80"
          width="380"
          height="110"
          fill={`url(#hatch-fine-${uid})`}
          opacity="0.3"
        />
        <rect
          x="0"
          y="112"
          width="380"
          height="36"
          fill={`url(#hatch-dense-${uid})`}
          opacity="0.5"
        />
      </g>

      <path d={path} stroke="currentColor" strokeWidth="1.7" />
      <path d={flipperTop} stroke="currentColor" strokeWidth="1.5" />
      <path d={flipperBottom} stroke="currentColor" strokeWidth="1.5" />

      {/* breadth callipers */}
      <g opacity="0.45" aria-hidden="true">
        <path
          d="M120 78H120M120 74V86M120 80H200M200 74V86"
          stroke="currentColor"
          strokeWidth="0.9"
        />
        <path
          d="M350 96V86M350 170V180"
          stroke="currentColor"
          strokeWidth="0.9"
        />
      </g>
    </svg>
  );
}

export function SpecimenPlate({
  variant = "full",
  plate,
  index,
  tone = "paper",
  showIdentity = true,
}: {
  variant?: "full" | "detail";
  plate: string;
  index: string;
  tone?: Tone;
  showIdentity?: boolean;
}) {
  const uid = `${variant}-${index}`.toLowerCase().replace(/[^a-z0-9-]/g, "");
  const description =
    variant === "full"
      ? "Engraved-style line study of a small porpoise in profile, drawn from simple geometry, with hatched shading, contour lines, ruled water beneath, and technical leader lines."
      : "Engraved-style line study of the same porpoise seen from above, drawn from simple geometry, with hatched shading along the spine and an axis of symmetry.";

  return (
    <figure className="m-0">
      <div className="flex items-baseline justify-between gap-4">
        <span
          className={`border px-2 py-1 text-[10px] font-semibold uppercase tracking-[0.18em] ${metaClass(tone)}`}
          style={borderStyle(tone)}
          translate="no"
        >
          {index}
        </span>
        <span
          className={`text-[10px] font-semibold uppercase tracking-[0.18em] ${metaClass(tone)}`}
        >
          {plate}
        </span>
      </div>

      <div className="relative mt-4 px-4 py-6 sm:px-7 sm:py-8">
        <Registration tone={tone} />
        {variant === "full" ? (
          <VaquitaStudy title={description} uid={uid} tone={tone} />
        ) : (
          <DorsalStudy title={description} uid={uid} />
        )}
      </div>

      <div aria-hidden="true" className="h-px w-full" style={ruleStyle(tone)} />

      <figcaption className="mt-4 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
        {showIdentity ? (
          <div>
            <p className="font-display text-2xl font-semibold">Vaquita</p>
            <p
              className={`font-display text-lg italic ${metaClass(tone)}`}
              translate="no"
            >
              Phocoena sinus
            </p>
          </div>
        ) : null}
        <ScaleMotif tone={tone} />
      </figcaption>

      <p
        className={`mt-4 max-w-[46ch] text-[13px] leading-relaxed ${
          tone === "dusk" ? "text-[color:var(--dusk-muted)]" : "text-ink-muted"
        }`}
      >
        Abstract interface study · not a species depiction.
      </p>
    </figure>
  );
}
