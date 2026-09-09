import { FEED_PATH, SUBSCRIBE_URL } from "@/lib/archive";
import { TextLink } from "./atlas";

/**
 * The publication's two doors. Email capture never happens on this host: the
 * link goes to the provider's own page, which carries its consent, retention
 * and deletion terms (DEFERRED.md). RSS is always there.
 */
export function SubscribeLine({ className = "" }: { className?: string }) {
  return (
    <p className={`flex flex-wrap items-center gap-x-6 gap-y-1 ${className}`}>
      {SUBSCRIBE_URL ? (
        <TextLink href={SUBSCRIBE_URL} external>
          Get new notes by email&nbsp;↗
        </TextLink>
      ) : null}
      <TextLink href={FEED_PATH} external>
        RSS feed
      </TextLink>
      <TextLink href="/field-notes/write">Write a note</TextLink>
    </p>
  );
}
