# Account-deletion large-text verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `curl -sf http://127.0.0.1:8080/api/v1/health` | Backend is available before Flutter gates | Succeeded. | ✅ |
| `flutter test test/screens/settings/delete_account_screen_test.dart -r compact` | German 200% support-only path remains reachable on a 360×640 phone | 1 test passed; localized support CTA and scroll surface rendered with no exception. | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found. | ✅ |
| `flutter test -r compact` | Full regression suite remains green | Passed; expected test-only `package_info_plus` missing-plugin logs remain. | ✅ |
| `flutter build apk --debug` | Debug APK builds with scroll-safe account-deletion guidance | Succeeded. | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 bash scripts/check-mobile-secrets.sh build/app/outputs/flutter-apk/app-debug.apk` | Source, history and debug APK are clean | Source/artifact marker scans passed; Gitleaks scanned 19 commits / ~3.56 MB with no leaks. | ✅ |
| `git diff --check` | No tracked whitespace errors | Passed. | ✅ |

The screen still opens a mailto support path and deliberately does not submit a
deletion request or claim completion. A verified authenticated account lifecycle
is still required before in-app deletion can exist.
