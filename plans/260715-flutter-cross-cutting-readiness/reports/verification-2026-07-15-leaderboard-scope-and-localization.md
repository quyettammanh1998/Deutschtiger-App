# Leaderboard scope and localization verification

## Root cause

The prior monthly tab mapped to `/gamification/leaderboard`, the same endpoint
as all-time. The reference handler returns cumulative `total_xp` and accepts no
period parameter, so the “month” label made a claim the backend could not
support.

## Verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| curl `http://127.0.0.1:8080/api/v1/health` | Backend available before Flutter checks | Healthy response; command exited 0 | ✅ |
| curl `http://127.0.0.1:8080/api/v1/leaderboard/weekly` | 200 JSON weekly leaderboard | 503 HTML startup response with `Retry-After: 5` | ❌ environment |
| curl `http://127.0.0.1:8080/api/v1/gamification/leaderboard` | 200 JSON cumulative leaderboard | 503 HTML startup response with `Retry-After: 5` | ❌ environment |
| `flutter test test/screens/leaderboard/leaderboard_scope_test.dart` | Only weekly/all-time scopes and their exact endpoints remain | 2 tests passed | ✅ |
| `flutter test test/screens/leaderboard/leaderboard_scope_test.dart test/l10n/app_localizations_test.dart` | German tile fallback/streak works at 200%; existing l10n coverage remains green | 10 tests passed | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test -r compact` | Existing and new Flutter tests remain green | 200 tests passed | ✅ |
| `flutter build apk --debug` | Android debug bundle compiles | APK built: `206773206` bytes | ✅ |
| `git diff --check` + ARB JSON parse | No whitespace or catalog syntax errors | Passed | ✅ |

Backend APIs, response shapes, and the Home weekly leaderboard call are
unchanged. The local server's basic health endpoint measures process uptime,
not database/feature dependency readiness; do not treat it as a successful
leaderboard contract probe. Monthly can return only when a dedicated backend
contract exists.
