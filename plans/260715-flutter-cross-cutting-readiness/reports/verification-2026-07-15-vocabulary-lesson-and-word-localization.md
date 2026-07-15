# Vocabulary lesson and word localization verification

## Scope

The `/vocabulary/lesson` and `/vocabulary/word` UI chrome was localized without
translating API-delivered German words, Vietnamese meanings, examples or topic
keys. Raw provider errors no longer reach the learner UI.

## Verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| Pre-fix `flutter test test/screens/vocabulary/vocabulary_lesson_localization_test.dart` | German lesson and word controls at 200% | Both assertions failed because Vietnamese literals were rendered | ✅ reproduced |
| `flutter test test/screens/vocabulary/vocabulary_lesson_localization_test.dart` | Lesson search/filter/progress and word headings/navigation/tooltip render in German at 200% | 2 tests passed | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Backend reachable before Flutter gates | 200 JSON health response | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test -r compact` | Full suite stays green | 206 tests passed | ✅ |
| `flutter build apk --debug` | Debug APK compiles from this source | Built `build/app/outputs/flutter-apk/app-debug.apk` (`206790639` bytes) | ✅ |
| `git diff --check` and ARB JSON parse | No whitespace or localization-catalog syntax errors | Passed | ✅ |
