---
phase: 4
title: "Fidelity Integration and Release Automation"
status: in-progress
priority: P0
effort: "1–2w initial setup; continuous"
dependencies: [1, 2, 3]
---

# Phase 4: Fidelity Integration and Release Automation

## Overview

Convert the stated “web-equivalent Flutter app” bar into repeatable automation.
Current unit/widget tests and a clean analyzer are useful but cannot prove
native auth, deep links, purchases, recording, UI parity or a submit-ready
signed artifact.

## Requirements

- Maintain deterministic web and Flutter visual fixtures at phone viewports
  390×844 and 360×800 in light/dark themes; use a text antialiasing mask and
  accept at most 2% changed pixels outside intentional exclusions.
- Run Flutter integration tests on emulator/device for critical user journeys;
  run golden tests in a pinned rendering environment.
- CI gates analyze, test, integration/fidelity suites, secret/dependency scans
  and release build. Store upload artifacts require real signing and must fail
  when signing material is absent—never fall back to debug signing in a release
  pipeline.

## Architecture

```text
Web fixture seed ─ Playwright capture ─┐
                                     odiff/pixelmatch → fidelity report
Flutter integration_test capture ────┘
           │
           └─ matchesGoldenFile (pinned Linux/font CI)

PR CI: analyze → unit/widget → contract → golden → integration
Release CI: secret/SCA → signed AAB/IPA → provenance + smoke checklist
```

## Progress (2026-07-15)

- A read-only PR baseline now verifies generated l10n, format, analyzer, the
  full unit/widget suite, a debug APK build, required Gitleaks and source/APK
  marker/dependency scanning, plus an SPDX JSON SBOM artifact, in GitHub
  Actions. Format enforcement is incremental because the pre-existing baseline
  has unformatted files; every changed Dart file in a PR must be formatted. It
  does not sign or publish a release artifact.
- A separate least-privilege OSV workflow blocks new known lockfile
  vulnerabilities on PRs and performs a full blocking scan on `main` and a
  weekly schedule. It has only `actions: read`, `contents: read`, and
  `security-events: write`; device integration, visual parity, signed-artifact
  scans and protected signing remain required before this phase can close.
- `package_info_plus` now uses v10.2.0, compatible with the existing AGP 9.0.1
  and Kotlin 2.3.20 project configuration. The debug APK, Android integration
  flow and full suite pass after the upgrade; at that point the Flutter KGP
  warning dropped from five plugins to four (`flutter_tts`,
  `purchases_flutter`, `record_android`, `sign_in_with_apple`).
- `record` now uses v7.1.1. Its removed Android background-recording service
  and deprecated iOS audio-session option were not used by this app; the
  `AudioRecorder` file-recording API remains compatible. A clean Flutter/Gradle
  rebuild is required after resolving this native plugin version; the debug APK
  and Android API 34 welcome integration then pass. The KGP warning now names
  only `flutter_tts`, `purchases_flutter`, and `sign_in_with_apple`.
- `sign_in_with_apple` now uses v8.1.0. This app does not use the v8-renamed
  `SignInWithAppleButton` icon-alignment API; its Apple credential, nonce, and
  cancellation handling compile and pass the Android API 34 smoke test. The
  current Flutter KGP detector still lists this latest plugin, so upgrading it
  does not reduce the remaining warning surface; that needs upstream migration.
- Android release tasks now fail closed without all upload-keystore properties
  and no longer select debug signing. A local obfuscated `bundleRelease` run
  failed safely because `android/key.properties` refers to a missing keystore
  file; no release artifact was created. CI/protected release infrastructure
  still needs a configured signing execution and a separate absent-signing
  negative check.
- The `Pixel6_API34` Android emulator completed a native debug-install and
  launch smoke test at its 1080×2400 portrait viewport. The Vietnamese welcome
  screen had no visible clipping or overlap. This is not an integration,
  TalkBack, iOS, platform-provider, or visual-diff result; those phase gates
  remain open.
- `integration_test/welcome_flow_test.dart` now repeats the welcome-to-
  onboarding path on Android from the real app entry point. It passed on
  `Pixel6_API34`. The local PR workflow stages it in a clean Android emulator
  with the tracked non-secret `.env.example` configuration; the test does not
  use an authenticated user or live backend request. The configured GitHub
  remote has not received this locally uncommitted workflow yet, so its first
  hosted execution remains pending a commit/push or PR.

## Related Code Files

- Create: `integration_test/`, `test/goldens/`, `tools/fidelity/`, baseline fixtures and `fidelity-report.html` generator
- Create: `.github/workflows/flutter-ci.yml` (or documented equivalent CI runner), release workflow and artifact retention policy
- Modify: `pubspec.yaml`, `analysis_options.yaml`, Android/iOS build configs and release scripts
- Modify: `android/app/build.gradle.kts` so release CI fails without upload signing config
- Create: `docs/flutter-fidelity-pipeline.md`, `docs/flutter-release-runbook.md`, `plans/260715-flutter-cross-cutting-readiness/reports/release-gate-verification.md`

## Implementation Steps

1. Freeze deterministic fixture accounts/content and add reset/seed scripts.
   Disable animations, isolate video chrome and mask only text antialiasing in
   visual captures; never mask layout, color, icon or spacing defects.
2. Add Playwright web baseline capture and Flutter `integration_test` capture
   for the same route/data/theme/viewport. Compare with `odiff` or pixelmatch,
   publish web/Flutter/heatmap/diff percentage per screen.
3. Promote a Flutter capture to `matchesGoldenFile` only after it passes
   cross-platform comparison. Pin CI OS/fonts/device configuration and require
   intentional review for golden updates.
4. Build integration tests for auth/deep link/device kick, review submit,
   exam draft resume, purchase restore, mic deny/grant, account deletion/export,
   and push routing as their features become live. Use disposable test accounts
   and never real production user data.
5. Add PR CI gates: formatting/analyze, unit/widget, contract, mock-route,
   localization/a11y, golden and selected integration test. Add nightly/device
   matrix for native providers and flaky platform paths.
6. Add release CI: secret/SCA/SBOM report, validated build version, real signing
   requirement, obfuscation/split-debug-info, signed AAB/IPA generation and
   staged rollout checklist. Measure startup, frame jank, memory/image and
   network payload baselines before setting enforced budgets.
7. Keep manual gates for credentials, Store Connect/Play Console, real payments,
   real push and physical-device accessibility. Append exact evidence to the
   verification table before phase status changes.

## Success Criteria

- [ ] Fidelity report covers each enabled screen at 2 phone viewports × 2
  themes; unmasked layout/icon/color diff is ≤2% or has an approved exception.
- [ ] Critical integration journeys run against disposable accounts and include
  the platform-specific success/failure cases they claim to support.
- [ ] PR CI blocks regressions; nightly/device matrix records native failures
  separately instead of weakening deterministic tests.
- [ ] Release CI cannot create a store-candidate artifact with debug signing or
  a leaked private credential, and emits versioned signed artifacts/provenance.
- [ ] Performance budgets are based on measured baseline data and regression
  thresholds—not guessed numbers.

## Risk Assessment

- Visual tests become flaky if data/fonts/animation are not fixed. Stabilize
  fixtures rather than increasing tolerated diff.
- iOS signing and store-provider tests need protected infrastructure; their
  absence must skip deployment, not silently pass a release gate.
