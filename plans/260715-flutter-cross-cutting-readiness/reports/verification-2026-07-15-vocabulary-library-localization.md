# Vocabulary library localization verification

## Scope

The `/vocabulary` route uses live page data. This change localizes only static
UI chrome and generic errors; German words, Vietnamese meanings and topic data
returned by the API remain learning content.

## Verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| Pre-fix `flutter test test/screens/vocabulary/vocabulary_screen_localization_test.dart` | German vocabulary title at 200% | Failed: `Wortschatz` absent; route rendered Vietnamese literal | ✅ reproduced |
| `flutter test test/l10n/app_localizations_test.dart test/screens/vocabulary/vocabulary_screen_localization_test.dart` | German 200% route chrome and CEFR singular/plural resolve | 9 tests passed | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Backend reachable before Flutter gates | 200 JSON health response | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test -r compact` | Full suite stays green | 204 tests passed | ✅ |
| `flutter build apk --debug` | Debug APK compiles from this source | Built `build/app/outputs/flutter-apk/app-debug.apk` (`206784190` bytes) | ✅ |
| `git diff --check` and ARB JSON parse | No whitespace or localization-catalog syntax errors | Passed | ✅ |
