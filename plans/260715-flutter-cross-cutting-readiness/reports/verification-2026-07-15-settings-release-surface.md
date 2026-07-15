# Settings release-surface verification

## Root causes

- `SettingsScreen` linked to `/change-password` and `/change-email`, neither
  of which is mounted by `app_router.dart` or documented as a live account
  lifecycle contract.
- The default Settings UI exposed AI Settings even though the central release
  redirect gated `/ai-tutor/**` behind `DEUTSCHTIGER_ENABLE_AI_TUTOR`.
- `SettingsCard` used a decorated `Container` between `ListTile` and Material,
  triggering Flutter's runtime assertion that ink splashes could be invisible.

## Verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| curl `http://127.0.0.1:8080/api/v1/health` | Backend available before Flutter checks | Healthy response; command exited 0 | ✅ |
| `flutter test test/screens/settings/settings_release_gates_test.dart` | Default Settings has no dead credential links or AI entry; Feedback remains | Passed | ✅ |
| `flutter test --dart-define=DEUTSCHTIGER_ENABLE_AI_TUTOR=true test/screens/settings/settings_release_gates_test.dart` | Explicit local QA define renders AI Settings | Passed | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test -r compact` | Existing and new Flutter tests remain green | 198 tests passed | ✅ |
| `flutter build apk --debug` | Android debug bundle compiles | APK built: `206770353` bytes | ✅ |
| `git diff --check` | No whitespace error | Passed | ✅ |

Public API/backend contracts are unchanged. The supported Security, export and
Feedback paths remain visible; only unmounted or feature-gated entries changed.
