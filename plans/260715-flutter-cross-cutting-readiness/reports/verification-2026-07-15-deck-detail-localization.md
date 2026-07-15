# Deck detail localization verification

## Scope

The release-visible `/decks/:deckId` route localizes only title, review CTA and
empty/retry chrome. The live deck-card endpoint and review navigation are
unchanged.

## Verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter test test/screens/decks/deck_detail_localization_test.dart -r compact` | German live-data chrome at 200% and localized empty state | 2 tests passed | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Backend reachable before Flutter gates | 200 JSON health response | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test -r compact` | Full suite stays green | 211 tests passed | ✅ |
| `flutter build apk --debug` | Debug APK compiles from this source | Built `build/app/outputs/flutter-apk/app-debug.apk` (`206801757` bytes) | ✅ |
| `git diff --check` and ARB JSON parse | No whitespace or localization-catalog syntax errors | Passed | ✅ |
