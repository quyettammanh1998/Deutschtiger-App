# Auth localization and accessibility verification

Scope: Welcome, Onboarding, Login, Sign-up, Forgot Password, Reset Password,
and shared auth validation.

| Test | Expected | Actual | Status |
|---|---|---|---|
| curl `http://127.0.0.1:8080/api/v1/health` | Local backend is available before Flutter checks | Healthy response; command exited 0 | ✅ |
| `flutter gen-l10n` + `jq empty lib/l10n/app_{vi,en,de}.arb` | Generated catalogs accept the new auth strings | Generation and JSON validation passed | ✅ |
| `flutter test test/features/auth/auth_validators_test.dart test/l10n/app_localizations_test.dart` | Validator errors use the active locale; German Welcome/Reset Password remain operable at 200% text scale | 15 tests passed | ✅ |
| `flutter analyze` | No static analysis regressions | No issues found | ✅ |
| `flutter test -r compact` | Existing and new Flutter tests remain green | 196 tests passed | ✅ |
| `flutter build apk --debug` | Android debug build compiles | APK built: `206765787` bytes | ✅ |
| UI flow (widget): German Welcome/Reset Password at 200% text scale | Localized primary actions and password form remain visible/reachable | `Deutsch lernen`, `Lernen starten`, `Anmelden`, `Neues Passwort`, and `Passwort bestätigen` assertions passed | ✅ |
| `bash scripts/check-mobile-secrets.sh` + gitleaks detect | No new source markers or secrets | Marker scan and gitleaks passed | ✅ |

Known non-blocker: the debug build warns that `flutter_tts`, `package_info_plus`,
`purchases_flutter`, `record_android`, and `sign_in_with_apple` still apply the
legacy Kotlin Gradle Plugin. No dependency upgrade was made in this scoped UI
change.
