# Flutter quality and fidelity pipeline

## Current PR gate

`.github/workflows/flutter-ci.yml` runs on pull requests, pushes to `main`, and
manual dispatch. It uses Flutter 3.44.1, the version verified for this project,
then performs:

1. dependency resolution and generated-localization verification;
2. formatting of Dart files changed by the PR and static analysis;
3. the full unit/widget test suite and a debug Android APK build; and
4. source and debug-APK marker scanning, a required Gitleaks repository scan,
   a saved Dart dependency report, and an SPDX JSON SBOM artifact; and
5. the real-app welcome-to-onboarding integration test on a clean Android
   emulator.

The workflow has read-only repository permission and produces no signed release
binary. Android `assembleRelease` and `bundleRelease` now fail closed unless
the untracked `android/key.properties` contains a complete upload-keystore
configuration; they cannot silently fall back to debug signing.

On 2026-07-15, a local obfuscated `bundleRelease` check stopped at this gate:
the local properties file referenced a missing keystore. This proves the
fail-closed behavior but does not provide a signed-candidate artifact. Protected
release infrastructure must supply the real keystore and verify its provenance.

The separate `OSV dependency scan` workflow compares pull-request dependency
vulnerabilities against `main`, then performs a blocking full scan on pushes to
`main` and each Monday. It uploads SARIF to GitHub code scanning and requires
only `actions: read`, `contents: read`, and `security-events: write`; it never
receives release-signing or deployment permission.

Both Flutter jobs create `.env` from the tracked `.env.example` before compiling. Those
values are deliberately non-secret and only support the unauthenticated build
and welcome integration smoke; production credentials stay outside the
repository and CI logs.

## Local Android integration smoke

`integration_test/welcome_flow_test.dart` starts the real app on an Android
emulator or device, verifies the unauthenticated welcome screen, and taps the
primary CTA through to onboarding:

```bash
flutter test integration_test/welcome_flow_test.dart -d <device-id>
```

The test passed on `Pixel6_API34` on 2026-07-15 and now runs in the PR workflow
on an Android emulator. It uses no authenticated user data or live backend
request; a local run only needs the standard application configuration and an
Android native runtime.

## Deliberately deferred gates

This is a CI baseline, not proof of release fidelity. The following remain
release blockers in Phase 4:

- fixture-controlled web/Flutter visual captures at 390×844 and 360×800 in
  both themes, with an unmasked pixel-diff report;
- emulator/device integration tests beyond the welcome/onboarding smoke:
  auth, deep links, purchase restore, microphone permission, push and account
  lifecycle;
- artifact scanning of generated AAB/IPA files, SBOM/SCA, and protected signing
  configuration that fails closed when upload keys are absent; generated source
  SBOM and Dart lockfile SCA are now PR/main gates, but signed AAB/IPA scanning
  remains outstanding; and
- physical-device accessibility and store-console evidence.

Do not treat a green PR job as approval to submit a store build.
