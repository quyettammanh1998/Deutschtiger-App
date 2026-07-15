# Home and shell release gates verification — 2026-07-15

Release defaults no longer expose Home actions for social messages, stats,
AI tutor or unreconciled Journey browsing. The AI bottom tab is omitted unless
the AI tutor compile-time flag is set. Daily-path steps with a gated skill use
the live Learn hub rather than opening a fixture route.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter test test/features/home/release_navigation_gates_test.dart test/l10n/app_localizations_test.dart` | Default build hides gated Home/shell discovery | 7 tests passed | ✅ |
| same with `--dart-define=DEUTSCHTIGER_ENABLE_AI_TUTOR=true` | QA build restores the AI tab branch | 3 tests passed | ✅ |
| `flutter analyze` | No static-analysis errors | No issues found | ✅ |
| `flutter test` | No Flutter regression | 188 tests passed | ✅ |
| `flutter build apk --debug` | Debug candidate builds with dynamic shell tabs | APK built (175,833,675 bytes) | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 scripts/check-mobile-secrets.sh <apk>` | Source, history and artifact scans are clean | 19 commits scanned; no leaks; artifact marker scan passed | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Local backend is healthy for Flutter verification | `200 {"status":"ok",...}` | ✅ |

Remaining: direct/deep links and every other release-visible route need a
central guard or a verified live contract before Phase 3 can close.
