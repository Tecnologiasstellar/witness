"use client";

import Image from "next/image";
import Link from "next/link";
import { useEffect, useRef, useState } from "react";

export type ExperienceRecord = {
  id: string;
  commonName: string;
  scientificName: string;
  status: string;
  hook: string;
  image: string;
  alt: string;
};

export function HomeExperience({ records }: { records: ExperienceRecord[] }) {
  const [active, setActive] = useState(0);
  const steps = useRef<Array<HTMLDivElement | null>>([]);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        const visible = entries
          .filter((entry) => entry.isIntersecting)
          .sort((a, b) => b.intersectionRatio - a.intersectionRatio)[0];
        if (visible) setActive(Number((visible.target as HTMLElement).dataset.step));
      },
      { rootMargin: "-34% 0px -42%", threshold: [0.1, 0.35, 0.65] },
    );

    steps.current.forEach((step) => step && observer.observe(step));
    return () => observer.disconnect();
  }, []);

  const current = records[active] ?? records[0];

  return (
    <div className="experience-grid">
      <div className="experience-copy">
        {records.map((record, index) => (
          <div
            key={record.id}
            ref={(node) => { steps.current[index] = node; }}
            data-step={index}
            className="experience-step"
          >
            <p className="experience-index">0{index + 1} / 0{records.length}</p>
            <h3>{record.commonName}</h3>
            <p className="experience-hook">{record.hook}</p>
            <p className="experience-detail">
              A reviewed story, its sources, a private Witness, and one credible action.
            </p>
            <Link href={`/witnesses/${record.id}`}>Open this record</Link>
          </div>
        ))}
      </div>

      <div className="experience-device-column">
        <div className="device-sticky">
          <p className="device-label">Development interface preview</p>
          <div className="iphone-shell">
            <div className="iphone-screen">
              <div className="iphone-status" aria-hidden="true">
                <span>9:41</span><span>WITNESS</span><span>•••</span>
              </div>
              <div className="phone-art">
                {records.map((record, index) => (
                  <Image
                    key={record.id}
                    src={record.image}
                    alt={index === active ? record.alt : ""}
                    fill
                    sizes="(max-width: 767px) 72vw, 330px"
                    priority={index === 0}
                    className={index === active ? "phone-image is-active" : "phone-image"}
                  />
                ))}
              </div>
              <div className="phone-copy">
                <p className="phone-date">Today’s witness</p>
                <h4>{current.commonName}</h4>
                <p className="phone-scientific">{current.scientificName}</p>
                <p className="phone-status-copy">{current.status}</p>
                <p className="phone-story">{current.hook}</p>
                <span className="phone-action">Read the story</span>
              </div>
              <div className="phone-tabs" aria-hidden="true">
                <span>Today</span><span>Archive</span><span>Notes</span>
              </div>
            </div>
          </div>
          <p className="device-note">
            Built from approved catalog records and original illustrations. Final app screenshots will replace this preview.
          </p>
        </div>
      </div>
    </div>
  );
}
