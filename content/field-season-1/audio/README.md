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
task with S3 output. With the Lullable-account AWS CLI profile (replace
`PROFILE` and `BUCKET`):

```sh
aws polly start-speech-synthesis-task \
  --profile PROFILE \
  --region us-east-1 \
  --engine long-form \
  --voice-id Ruth \
  --output-format mp3 \
  --text-type ssml \
  --text file://content/field-season-1/audio/chapter-01-vaquita.ssml \
  --output-s3-bucket-name BUCKET \
  --output-s3-key-prefix witness-audio/fs1/chapter-01-vaquita
```

Then check status / fetch:

```sh
aws polly list-speech-synthesis-tasks --profile PROFILE --region us-east-1 --max-results 5
```

- Recommended voice: **Ruth (long-form engine)** — warmest sustained
  read for editorial audio. Fallbacks: Danielle (long-form), or Ruth
  (neural) at lower cost.
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
| 01 vaquita | `chapter-01-vaquita.ssml` (rev 2) | pending (founder runs command) | pending |
