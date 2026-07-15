# Release deep-link guards verification — 2026-07-15

Authenticated deep links now pass through a release guard after the existing
auth redirect. A gated family returns users to `/learn` or `/home`; the live
mission-session route remains reachable. Compile-time QA gates continue to
control the same families.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter test test/navigation/auth_redirect_test.dart test/navigation/release_redirect_test.dart test/features/home/release_navigation_gates_test.dart` | Auth recovery stays reachable; gated deep links cannot bypass release gates | 10 tests passed | ✅ |
| `flutter analyze` | No static-analysis errors | No issues found | ✅ |
| `flutter test` | No Flutter regression | 190 tests passed | ✅ |
| `flutter build apk --debug` | Debug candidate builds with router guard | APK built (206,739,591 bytes) | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 scripts/check-mobile-secrets.sh <apk>` | Source, history and artifact scans are clean | 19 commits scanned; no leaks; artifact marker scan passed | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Local backend is healthy for Flutter verification | `200 {"status":"ok",...}` | ✅ |

Remaining: a gate being present does not prove a family is live. Each gate may
only be enabled after its documented backend contract and user-flow tests pass.
