# Witness physical-device accessibility QA

Status: INSTALLED — manual accessibility review pending  
Prepared: August 21, 2026  
Target device: paired iPhone 12 (`iPhone13,2`)  
Physical UDID: `REDACTED — local device record only`  
CoreDevice identifier: `REDACTED — local device record only`  
OS observed: iOS 17.6.1 (`21G93`)  
Connection observed: paired, wired, Developer Mode enabled

This checklist keeps installation, launch, VoiceOver, persistence, share-sheet, and Reduced Motion evidence separate. A successful build or automated test cannot substitute for a human accessibility observation.

## Preconditions

- [x] Device is paired, wired, booted, and in Developer Mode.
- [x] Mac has a valid Apple Development identity whose certificate user identifier is `SPA3Z69T75` and whose actual Team ID is `L5R9XW45B6`.
- [x] User explicitly approved automatic signing for `com.avp.witness`, including bundle registration and development-profile creation/update, on August 21, 2026.
- [x] User confirmed the relevant Apple ID is available in Xcode on August 21, 2026.
- [x] User explicitly approved automatic signing under corrected Team ID `L5R9XW45B6` on August 21, 2026.
- [ ] Device is unlocked and remains connected during installation and first launch.
- [ ] No unrelated Xcode or `xcodebuild` process is active.
- [ ] Original owned Vaquita media file and complete rights record are available if production-media integration is included.

## Gate A — signed build, installation, and launch

Attempted twice on August 21, 2026 with automatic signing and provisioning updates enabled, using `SPA3Z69T75` as the team. The build stopped during `GatherProvisioningInputs` with:

- `No Account for Team "SPA3Z69T75".`
- `No profiles for 'com.avp.witness' were found.`

Certificate inspection then established that `SPA3Z69T75` is the certificate user identifier. Its Organizational Unit—and both existing local profiles—identify the actual Team ID as `L5R9XW45B6`. The earlier unsigned arm64 physical-target build succeeded. No app was installed and no launch evidence was created by either failed signing attempt.

After corrected authorization, the signed physical build succeeded on August 21, 2026. `codesign --verify --deep --strict` passed, `devicectl` installed bundle `com.avp.witness`, and `devicectl` launched it successfully. The normal non-test app was launched again at `2026-08-21 21:02:04 CST` after physical UI testing.

Required evidence:

- [x] Signed Debug build succeeds for the physical device.
- [x] Exact `.app` path recorded: `/private/tmp/WitnessSignedPhysicalDerivedData/Build/Products/Debug-iphoneos/Witness.app`.
- [x] `devicectl` installation succeeds.
- [x] Installed bundle identifier is `com.avp.witness`.
- [x] `devicectl` reports a successful launch. This tool/runtime did not print a process identifier.
- [ ] Today renders the bundled Vaquita card without network access. Physical UI automation rendered and operated Today, but the device network was not disabled during that run.

Do not mark the core ritual or accessibility gate passed from installation alone.

## Gate B — VoiceOver traversal

Preparation:

1. On iPhone, open Settings → Accessibility → VoiceOver.
2. Enable VoiceOver. Do not use an automated accessibility audit as a substitute.
3. Launch Witness from the Home Screen.

Manual traversal and expected meaning:

- [ ] Hero is announced once as an abstract/photographic/illustrated Vaquita depiction, matching its approved depiction type.
- [ ] `TODAY`, written status, common name, scientific name, generalized range, and hook follow a coherent reading order.
- [ ] Story sentences are reachable in source order without duplicate decorative elements.
- [ ] Witness control announces its current state and consequence: one private on-device Witness.
- [ ] After activation, the confirmed state is announced and cannot be activated a second time.
- [ ] Credible action identifies NOAA Fisheries and that it opens outside Witness.
- [ ] Sources and evidence can be expanded and traversed.
- [ ] Four tabs are clearly named: Today, Archive, Witnessed, Settings.
- [ ] Witnessed card, continuity, private reflection, save action, and share-preview action are reachable.
- [ ] Reflection editor is announced as private and stored only on this device.
- [ ] Share preview announces the species card and privacy/outcome disclaimer.
- [ ] No control is unlabeled, duplicated, trapped, or unreachable.
- [ ] Manual notes and any defects are recorded below.

VoiceOver result: `PENDING MANUAL OBSERVATION`

## Gate C — physical persistence and idempotency

1. With VoiceOver on or off, activate Witness once.
2. Confirm the UI changes to `Witnessed on this device`.
3. Terminate Witness without uninstalling it.
4. Relaunch the installed app.
5. Scroll to the Witness control.
6. Open Witnessed.

Required evidence:

- [x] Confirmed state remains after process termination and relaunch.
- [x] The restored Witness control is disabled, preventing a second UI submission for the same species/local day; repository idempotency remains covered separately by unit tests.
- [x] Vaquita is present in Witnessed after relaunch.
- [x] Save a private reflection, terminate, relaunch, and confirm it restores.
- [ ] No network connection is required for restoration.

Persistence result: `PASSED ON PHYSICAL DEVICE WITH ISOLATED TEST ARCHIVE`; network-disabled physical repetition remains pending.

## Gate D — native share sheet and privacy

1. Enter a recognizable temporary private reflection.
2. Save it.
3. Open Share preview.
4. Verify the rendered card visually.
5. Tap `Share this card`.

Required evidence:

- [x] Native iOS `ActivityListView` share sheet appears on the physical device.
- [ ] Preview image is sharp and correctly cropped.
- [ ] Species name, scientific name, hook, and Witness identity are legible.
- [x] The private reflection is absent from the Witness preview and the exposed activity-sheet accessibility hierarchy.
- [ ] No fabricated count or conservation-outcome claim appears.
- [ ] Cancel returns safely to Witness without losing local state.

Share-sheet result: `PARTIAL PASS`; native presentation and reflection exclusion passed automation, while visual sharpness/cropping, copy legibility, and safe manual cancellation remain pending direct observation.

## Gate E — runtime Reduced Motion inspection

Preparation:

1. On iPhone, open Settings → Accessibility → Motion.
2. Enable Reduce Motion.
3. Terminate and relaunch Witness so the environment state is fresh.

Required evidence:

- [ ] Today scroll and editorial hierarchy remain usable.
- [ ] Witness confirmation communicates state without expanding/ringing/transform motion.
- [ ] Share-card preparation completes without animated presentation owned by Witness.
- [ ] No essential state depends on animation.
- [ ] Native sheet/navigation behavior remains understandable.
- [ ] Repeat with Reduce Motion disabled only if a comparison is needed; do not reset or uninstall local history without explicit approval.

Reduced Motion result: `PENDING MANUAL OBSERVATION`

## Evidence log

| Gate | Date/time | Build/configuration | Observer | Result | Evidence/notes |
|---|---|---|---|---|---|
| Install/launch | August 21, 2026, 21:02 CST | Debug / physical device | Codex | PASS | Signed with Team ID `L5R9XW45B6`; signature verified; `devicectl` installed and launched `com.avp.witness` |
| VoiceOver | PENDING | Debug / physical device | PENDING | PENDING | PENDING |
| Persistence | August 21, 2026 | Debug / physical device; isolated archive | XCTest | PASS | Witness, disabled/idempotent UI state, Witnessed card, and reflection restored across relaunches; network-disconnected repetition pending |
| Share sheet | August 21, 2026 | Debug / physical device; isolated archive | XCTest | PARTIAL PASS | Native `ActivityListView` appeared and reflection was absent; manual visual and cancellation checks pending |
| Reduced Motion | PENDING | Debug / physical device | PENDING | PENDING | PENDING |

Focused physical test result: 1 test executed, 0 failures, 49.952 seconds. Result bundle: `/private/tmp/WitnessPhysicalQADerivedData/Logs/Test/Test-Witness-2026.08.21_21-00-29--0600.xcresult`.

## Cleanup and rollback

- Do not uninstall Witness after testing unless explicitly approved; uninstalling destroys the local archive.
- Do not reset the device, erase simulator/device content, or change unrelated accessibility settings.
- Restore VoiceOver and Reduce Motion to the user’s preferred settings after the review.
- A development app installation can be removed manually from the iPhone later; Apple signing records/profiles require a separate account-level decision.

## Next review

Signing is unblocked. The next gate is direct human review of VoiceOver traversal and Reduced Motion on the installed app, followed by the remaining share-sheet visual/cancellation checks and a network-disabled restoration run.
