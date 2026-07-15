# Auth OAuth loading and error-boundary verification — 2026-07-15

Social login buttons now remain loading until their actual Google/Apple Future
settles. Login and sign-up SnackBars use generated generic copy rather than
rendering a raw auth/provider exception.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter test test/screens/auth/social_login_button_test.dart test/l10n/app_localizations_test.dart` | Spinner follows OAuth Future and auth copy resolves | 6 tests passed | ✅ |
| `flutter test` | No Flutter regression | 193 tests passed | ✅ |
| `flutter analyze` | No static-analysis errors | No issues found | ✅ |
| `flutter build apk --debug` | Debug candidate builds | APK built (206,752,250 bytes) | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 scripts/check-mobile-secrets.sh <apk>` | Source, history and artifact scans are clean | 19 commits scanned; no leaks; artifact marker scan passed | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Local backend is healthy for Flutter verification | `200 {"status":"ok",...}` | ✅ |

Remaining: prove native Google/Apple redirect, cancel and failure paths on
physical Android/iOS devices with disposable accounts; do not infer them from
this widget-level Future test.
