# Account deletion support path verification — 2026-07-15

The Flutter client no longer invokes the unmounted `DELETE /user/profile`
route. The delete-account route renders a localized support-request path and
has no completion/sign-out behavior.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `rg "deleteAccount\\(|DELETE /user/profile" lib test` | No executable client deletion call | No matches | ✅ |
| `flutter test` | No regression across the Flutter suite | 184 tests passed | ✅ |
| `flutter analyze` | No static-analysis errors | No issues found | ✅ |
| `flutter build apk --debug` | Debug candidate builds | APK built (175,833,675 bytes) | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 scripts/check-mobile-secrets.sh <apk>` | Source, history and artifact scans are clean | 19 commits scanned; no leaks; artifact marker scan passed | ✅ |
| `go test ./cmd/server -run '^$'` | Reference backend route package compiles | Passed | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Local backend is healthy for Flutter verification | `200 {"status":"ok",...}` | ✅ |

Remaining: backend must implement and verify an authenticated account deletion
lifecycle before the support-directed path can become in-app deletion.
