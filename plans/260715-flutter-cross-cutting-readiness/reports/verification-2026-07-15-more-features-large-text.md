# More Features large-text verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `curl -sf http://127.0.0.1:8080/api/v1/health` | Backend is available before Flutter gates | Succeeded. | ✅ |
| `flutter test test/l10n/app_localizations_test.dart -r compact` | German 200% phone viewport shows full More Features labels | 9 tests passed; two-column grid, `Karteikartensätze`, and `Wortschatzbibliothek` assertions passed without overflow. | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found. | ✅ |
| `flutter test -r compact` | Full regression suite remains green | Passed; expected test-only `package_info_plus` missing-plugin logs remain. | ✅ |
| `flutter build apk --debug` | Debug APK builds with responsive More Features grid | Succeeded. | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 bash scripts/check-mobile-secrets.sh build/app/outputs/flutter-apk/app-debug.apk` | Source, history and debug APK are clean | Source/artifact marker scans passed; Gitleaks scanned 19 commits / ~3.56 MB with no leaks. | ✅ |
| `git diff --check` | No tracked whitespace errors | Passed. | ✅ |

The More Features sheet keeps its feature gates and destinations. It changes
only layout density: three columns at default text size, two columns at 130%+
text scale, and scrollable content rather than essential-label truncation.
