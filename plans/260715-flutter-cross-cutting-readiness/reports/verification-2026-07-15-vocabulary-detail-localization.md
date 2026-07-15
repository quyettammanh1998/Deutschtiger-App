# Vocabulary detail localization verification

## Scope

The vocabulary detail route now localizes its UI chrome and keeps the existing
games release boundary for practice CTAs. API-delivered German words, meanings,
examples and related-word content stay as data.

## Verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| Pre-fix `flutter test -r compact` | Existing vocabulary interaction widgets keep working | 2 tests failed with `Null check operator used on a null value` at `AppLocalizations.of` | ✅ reproduced |
| `flutter test test/features/vocabulary/vocabulary_interaction_test.dart test/screens/vocabulary/vocabulary_detail_localization_test.dart test/screens/vocabulary/vocabulary_lesson_localization_test.dart test/screens/vocabulary/vocabulary_screen_localization_test.dart -r compact` | Interaction, library, lesson, word and detail routes work with generated localization | 6 tests passed | ✅ |
| `flutter test test/screens/vocabulary/vocabulary_detail_localization_test.dart --dart-define=DEUTSCHTIGER_ENABLE_GAMES=true -r compact` | Detail practice labels appear when games are deliberately enabled | 1 test passed | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Backend reachable before Flutter gates | 200 JSON health response | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test -r compact` | Full suite stays green | 207 tests passed | ✅ |
| `flutter build apk --debug` | Debug APK compiles from this source | Built `build/app/outputs/flutter-apk/app-debug.apk` (`206799695` bytes) | ✅ |
| `git diff --check` and ARB JSON parse | No whitespace or localization-catalog syntax errors | Passed | ✅ |

## Root-cause regression guard

`AppLocalizations.of(context)` correctly requires the generated delegate above
the widget. The production app root already provides it; the two direct
vocabulary interaction test hosts did not. They now use the same supported
locales and delegates, so the interaction tests exercise the localized widget
under a valid application host.
