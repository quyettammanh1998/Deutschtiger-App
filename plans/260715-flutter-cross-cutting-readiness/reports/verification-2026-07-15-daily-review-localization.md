# Daily Review localization and large-text verification

## Root cause

Daily Review rendered Vietnamese UI literals despite the selected application
locale. Its FSRS controls always divided the available width into four columns,
leaving long localized text too narrow at large accessibility text scales.

## Verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| Pre-fix `flutter test test/screens/daily_review/review_session_localization_test.dart` | German start and answer controls at 200% | Both assertions failed because Vietnamese literals were rendered | ✅ reproduced |
| `flutter test test/screens/daily_review/review_session_localization_test.dart` | German start chrome and all four revealed FSRS choices render at 200% | 2 tests passed | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Backend reachable before Flutter gates | 200 JSON health response | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test -r compact` | Full suite stays green | 203 tests passed | ✅ |
| `flutter build apk --debug` | Debug APK compiles from this source | Built `build/app/outputs/flutter-apk/app-debug.apk` (`206777361` bytes) | ✅ |
| `git diff --check` and ARB JSON parse | No whitespace or localization-catalog syntax errors | Passed | ✅ |

The UI never computes FSRS locally. Rating requests and review sequencing remain
in `reviewSessionProvider` and the server contract.

## Follow-up: persistence feedback and overflow — 2026-07-15

The shared review provider now stores `ReviewSessionError.ratingNotSaved`, not
a localized sentence. Daily Review and Flashcard Review render the existing
ARB recovery message, while the provider retains the same-card retry behavior.
At a 360×800 German 200% viewport, that feedback exposed a 52px bottom
overflow in Daily Review; its content now scrolls when necessary instead of
clipping the FSRS choices.

| Test | Expected | Actual | Status |
|---|---|---|---|
| Pre-fix error-state widget test at 360×800, German 200% | No overflow with recovery copy and two-row ratings | `RenderFlex` overflowed by 52 pixels | ✅ reproduced |
| Focused provider/Daily Review/Flashcard Review tests | Error code preserves retry state; recovery copy localizes and stays reachable | 5 tests passed | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test` | Full suite stays green | 227 tests passed | ✅ |
| `flutter build apk --debug` | Debug APK compiles from this source | Built successfully; 206,819,922-byte APK | ✅ |
| `git diff --check` | No whitespace errors | Passed | ✅ |
