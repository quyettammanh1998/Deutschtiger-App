# Deck localization verification

## Scope

`/decks` keeps its live Deck CRUD repository. This change localizes only UI
chrome; deck names and descriptions remain user-created data.

## Verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| Pre-fix `flutter test test/screens/decks/deck_list_localization_test.dart` | German deck chrome at 200% | Failed: `Meine Karteikartensätze` absent; screen used Vietnamese literal | ✅ reproduced |
| `flutter test test/screens/decks/deck_list_localization_test.dart` | German title, create tooltip, word count and learning progress render at 200% | 1 test passed | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Backend reachable before Flutter gates | 200 JSON health response | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test -r compact` | Full suite stays green | 201 tests passed | ✅ |
| `flutter build apk --debug` | Debug APK compiles from this source | Built `build/app/outputs/flutter-apk/app-debug.apk` | ✅ |
| `git diff --check` and ARB JSON parse | No whitespace or localization-catalog syntax errors | Passed | ✅ |
