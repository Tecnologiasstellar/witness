# Field Season narration (AWS Polly)

Founder decision 2026-08-26: chapters are narrated with AWS Polly using the
Lullable AWS account, with Witness work kept strictly separated.

## Rules

- **Disclose the voice.** Everywhere narration is offered, the app says the
  voice is synthetic. We never imply a human narrator (spec §6.2.3 honesty).
- **Separation from Lullable:** all Witness synthesis jobs write to a
  dedicated S3 prefix (or bucket) named `witness-audio`, and commands are
  tagged where supported. No Lullable assets are read or touched.
- **Credentials never enter this repo or chat.** The founder runs the
  synthesis command locally with an AWS profile; only the resulting MP3 and
  its metadata come back.
- **One rights record per chapter** in `docs/media/` before the audio
  ships: engine + voice + synthesis date + AWS terms note (Polly output is
  licensed for commercial use under the AWS service terms), duration, file
  size, and the transcript pointer (the SSML file doubles as transcript
  source).

## How to synthesize a chapter

The SSML exceeds the 3,000-character synchronous limit, so use an async
task with S3 output. With the Lullable-account AWS CLI profile (profile `lullable`;
bucket `witness-audio-fs1-a4724`, private, us-east-1):

```sh
aws polly start-speech-synthesis-task \
  --profile lullable \
  --region us-east-1 \
  --engine long-form \
  --voice-id Ruth \
  --output-format mp3 \
  --text-type ssml \
  --text file://content/field-season-1/audio/chapter-01-vaquita.ssml \
  --output-s3-bucket-name witness-audio-fs1-a4724 \
  --output-s3-key-prefix witness-audio/fs1/chapter-01-vaquita
```

Then check status / fetch:

```sh
aws polly list-speech-synthesis-tasks --profile lullable --region us-east-1 --max-results 5
```

- Voice: **Ruth (long-form engine)** — founder-selected 2026-08-26 after
  a three-voice audition (Ruth/Danielle/Gregory); the standard narrator
  for all Field Season 1 chapters.
- Cost: long-form is $100 per 1M characters — roughly **$0.60 per chapter,
  under $6 for all eight**. Neural is ~6× cheaper if the long-form voice
  isn't clearly better. Failure mode: an S3 bucket policy typo leaves the
  MP3 unreadable — keep the bucket private and copy the file out rather
  than making it public.
- The SSML uses only widely supported tags (`<p>`, `<break>`), so it works
  on the neural, long-form, and generative engines unchanged.

## Status

| Chapter | SSML | Audio synthesized | Rights record |
|---|---|---|---|
| 01 vaquita | `chapter-01-vaquita.ssml` (rev 2) | **done** — `rendered/chapter-01-vaquita-ruth.mp3`, Ruth long-form, 6:45 | `docs/media/fs1-ch01-audio-rights.md` |
| 02 kākāpō | `chapter-02-kakapo.ssml` | **done** — `rendered/chapter-02-kakapo-ruth.mp3`, Ruth long-form, 7:15 | `docs/media/fs1-ch02-audio-rights.md` |
| 03 javan rhino | `chapter-03-javan-rhino.ssml` | **done** — Ruth long-form, 6:41 | `docs/media/fs1-ch03-audio-rights.md` |
| 04 red wolf | `chapter-04-red-wolf.ssml` | **done** — Ruth long-form, 6:34 | `docs/media/fs1-ch04-audio-rights.md` |
| 05 ʻalalā | `chapter-05-alala.ssml` | **done** — Ruth long-form, 6:12 | `docs/media/fs1-ch05-audio-rights.md` |
| 06 wollemi pine | `chapter-06-wollemi-pine.ssml` | **done** — Ruth long-form, 6:14 | `docs/media/fs1-ch06-audio-rights.md` |
| 07 amur leopard | `chapter-07-amur-leopard.ssml` | **done** — Ruth long-form, 6:12 | `docs/media/fs1-ch07-audio-rights.md` |
| 08 axolotl | `chapter-08-axolotl.ssml` | **done** — Ruth long-form, 7:07 | `docs/media/fs1-ch08-audio-rights.md` |
| letter (opening) | `letter-the-thin-line.ssml` | **done** — Ruth long-form, 4:16 | `docs/media/fs1-letter-audio-rights.md` |
| interlude 1 | `interlude-price-of-parts.ssml` | **done** — Ruth long-form, 5:59 | `docs/media/fs1-interludes-audio-rights.md` |
| interlude 2 | `interlude-the-uninvited.ssml` | **done** — Ruth long-form, 5:48 | `docs/media/fs1-interludes-audio-rights.md` |
| synthesis (closing) | `synthesis-what-the-counted-teach.ssml` | **done** — Ruth long-form, 5:37 | `docs/media/fs1-synthesis-audio-rights.md` |
