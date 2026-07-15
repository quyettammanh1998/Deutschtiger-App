# Home localization slice verification — 2026-07-15

The current Home shell now uses generated localization for fallback/error
text, search, missions, Quick Actions, greeting, stats, weekly leaderboard and
daily-path CTA. Dashboard API content remains data and is not translated by
the UI layer.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter test test/l10n/app_localizations_test.dart test/features/home/dashboard_phase_3c_test.dart` | Localized Home chrome, duration and narrow daily-path card work | 10 tests passed | ✅ |
| `flutter test` | No Flutter regression | 191 tests passed | ✅ |
| `flutter analyze` | No static-analysis errors | No issues found | ✅ |
| `flutter build apk --debug` | Debug candidate builds | APK built (206,743,050 bytes) | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 scripts/check-mobile-secrets.sh <apk>` | Source, history and artifact scans are clean | 19 commits scanned; no leaks; artifact marker scan passed | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Local backend is healthy for Flutter verification | `200 {"status":"ok",...}` | ✅ |

Remaining: audit legacy Home widgets not rendered by the current route, then
cover the rest of release-visible route chrome with ARB and screen-reader
evidence.
