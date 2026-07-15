# Fixture landing-route release-gate verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `curl -sf http://127.0.0.1:8080/api/v1/health` | Backend is available before Flutter gates | Succeeded. | ✅ |
| `flutter test test/navigation/release_redirect_test.dart -r compact` | Authenticated fixture routes redirect to Home and existing gates remain covered | 2 tests passed. | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found. | ✅ |
| `flutter test -r compact` | Full regression suite remains green | Passed; expected test-only `package_info_plus` missing-plugin logs remain. | ✅ |
| `flutter build apk --debug` | Debug Android artifact builds | Built successfully. | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 bash scripts/check-mobile-secrets.sh build/app/outputs/flutter-apk/app-debug.apk` | Source, history and debug APK are clean | Source/artifact marker scans passed; Gitleaks scanned 19 commits / ~3.56 MB with no leaks. | ✅ |
| `git diff --check` | No whitespace errors | Passed. | ✅ |

`/landing` and `/welcome-full` are local fixture presentation routes, not
release content. Unauthenticated visitors are already redirected by the auth
gate; authenticated direct links now redirect to `/home` rather than bypassing
the live-data release policy.
