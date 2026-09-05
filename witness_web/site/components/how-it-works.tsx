"use client";

/**
 * The three steps beside one sticky phone. The copy scrolls; the phone stays
 * and its screen crossfades to the step in view. The only client JavaScript
 * on the site: one IntersectionObserver. Before hydration the first step and
 * its screen show, so nothing depends on it.
 */
import { useEffect, useRef, useState } from "react";

export type Step = { n: string; title: string; body: string; src: string; alt: string };

export function HowItWorks({ steps, width, height }: { steps: readonly Step[]; width: number; height: number }) {
  const [active, setActive] = useState(0);
  const items = useRef<Array<HTMLLIElement | null>>([]);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        const visible = entries
          .filter((entry) => entry.isIntersecting)
          .sort((a, b) => b.intersectionRatio - a.intersectionRatio)[0];
        if (visible) setActive(Number((visible.target as HTMLElement).dataset.step));
      },
      { rootMargin: "-38% 0px -38%", threshold: [0, 0.25, 0.5, 0.75, 1] },
    );
    items.current.forEach((item) => item && observer.observe(item));
    return () => observer.disconnect();
  }, []);

  return (
    <div className="how-grid">
      <ol className="how-steps">
        {steps.map((step, i) => (
          <li
            key={step.n}
            ref={(node) => { items.current[i] = node; }}
            data-step={i}
            className={i === active ? "how-step is-active" : "how-step"}
          >
            <p className="how-index">{step.n}</p>
            <h3>{step.title}</h3>
            <p>{step.body}</p>
          </li>
        ))}
      </ol>
      <div className="how-device">
        <div className="phone" aria-live="polite">
          {steps.map((step, i) => (
            <img
              key={step.n}
              src={step.src}
              width={width}
              height={height}
              alt={i === active ? step.alt : ""}
              decoding="async"
              className={i === active ? "is-active" : undefined}
            />
          ))}
        </div>
      </div>
    </div>
  );
}
