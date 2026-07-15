# Android release signing guard verification — 2026-07-15

Android release configuration no longer assigns the debug signing config when
the upload keystore is absent. `assembleRelease` and `bundleRelease` now check
for complete signing properties immediately before execution.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter test test/structure/android_release_signing_test.dart` | No debug-signing fallback remains in Gradle source | Passed | ✅ |
| `flutter build apk --debug` | Debug build remains usable without changing release behavior | Built successfully | ✅ |
| release negative task without keystore | Fails with release-signing guard | Skipped: local upload keystore is configured; no signed release artifact was created | ⚪ |
| `flutter analyze` | No static-analysis errors | No issues found | ✅ |
| `flutter test` | No Flutter regression | 192 tests passed | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 scripts/check-mobile-secrets.sh <apk>` | Source, history and artifact scans are clean | 19 commits scanned; no leaks; artifact marker scan passed | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Local backend is healthy for Flutter verification | `200 {"status":"ok",...}` | ✅ |

Remaining: run the negative release-task check in an environment without
signing material, then add protected CI signing, AAB/IPA artifact generation,
SBOM/SCA and provenance before a store candidate can be claimed.
