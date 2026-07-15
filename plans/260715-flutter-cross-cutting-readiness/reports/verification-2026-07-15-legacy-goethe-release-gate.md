# Legacy Goethe B1 release-gate verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `curl -sf http://127.0.0.1:8080/api/v1/health` | Backend is available before Flutter gates | Succeeded. | ✅ |
| `flutter test test/navigation/release_redirect_test.dart -r compact` | Default release redirect blocks legacy nested Goethe B1 route; QA define can allow it | 2 tests passed. | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found. | ✅ |
| `flutter test -r compact` | Full regression suite remains green | Passed; expected test-only `package_info_plus` missing-plugin logs remain. | ✅ |
| `flutter build apk --debug` | Debug APK builds with the legacy route gate | Succeeded. | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 bash scripts/check-mobile-secrets.sh build/app/outputs/flutter-apk/app-debug.apk` | Source, history and debug APK are clean | Source/artifact marker scans passed; Gitleaks scanned 19 commits / ~3.56 MB with no leaks. | ✅ |
| `git diff --check` | No tracked whitespace errors | Passed. | ✅ |

`/exam/goethe-b1/**` remains registered for explicit local QA, but release
builds redirect it to the live `/exam` catalog unless
`DEUTSCHTIGER_ENABLE_LEGACY_GOETHE_B1` is set. The legacy hub/readiness and
topic routes embed fixture data and are therefore not evidence of a live exam
contract.
