# Profile localization and Premium release-gate verification

## Root cause

`docs/flutter-live-data-inventory.md` classified `/settings/premium` as
feature-flagged, but `ReleaseFeatureFlags` and `resolveReleaseRedirect` had no
Premium entry. A deep link therefore reached the unverified RevenueCat purchase
screen in the default release configuration.

## Verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| curl `http://127.0.0.1:8080/api/v1/health` | Backend available before Flutter checks | Healthy response; command exited 0 | ✅ |
| `flutter test test/navigation/release_redirect_test.dart test/l10n/app_localizations_test.dart` | Default build redirects Premium deep link; Profile German chrome reflows at 200% | 10 tests passed | ✅ |
| `flutter test --dart-define=DEUTSCHTIGER_ENABLE_PREMIUM=true test/navigation/release_redirect_test.dart` | Explicit local QA define leaves Premium deep link available | 2 tests passed | ✅ |
| `flutter analyze` | No static analysis regression | No issues found | ✅ |
| `flutter test -r compact` | Existing and new Flutter tests remain green | 197 tests passed | ✅ |
| `flutter build apk --debug` | Android debug bundle compiles | APK built: `206770082` bytes | ✅ |
| UI flow (widget): German Profile at 200% text scale | Fallback learner, Premium badge and all stat labels remain visible without layout exception | Assertions passed; no widget exception | ✅ |
| `git diff --check` + ARB JSON parse | No whitespace or catalog syntax errors | Passed | ✅ |

Public API, data models, backend routes and RevenueCat calls are unchanged.
The default release now blocks only `/settings/premium` and redirects it to its
live parent Settings route; `DEUTSCHTIGER_ENABLE_PREMIUM=true` remains the
explicit local-QA escape hatch.
