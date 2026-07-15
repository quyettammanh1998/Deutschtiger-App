# Localization catalog deduplication verification

## Scope

Removed the duplicate `examPractice` key from each ARB catalog. Generated
localization now has one authoritative source entry per locale.

## Verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| ARB key-count check | Exactly one `examPractice`, `allFilters`, and `learningJourney` key per locale | Passed | ✅ |
| `flutter test test/l10n/app_localizations_test.dart test/screens/exam/exam_catalog_localization_test.dart -r compact` | Generated delegates and Exam catalog resolve keys | 9 tests passed | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter build apk --debug` | Debug APK uses regenerated catalogs | Built `build/app/outputs/flutter-apk/app-debug.apk` (`206802169` bytes) | ✅ |
| `git diff --check` and ARB JSON parse | No whitespace or JSON syntax errors | Passed | ✅ |
