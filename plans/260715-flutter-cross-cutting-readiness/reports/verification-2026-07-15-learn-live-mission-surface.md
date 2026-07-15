# Learn live mission surface verification

## Scope

`/learn` now renders only the server-backed daily mission. The fixture-backed
journey roadmap remains outside the release tab and behind its existing gate.

## Verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter test test/screens/journey/journey_live_mission_test.dart -r compact` | German live mission at 200%; no fixture chapter text | 1 test passed | ✅ |
| `curl http://127.0.0.1:8080/api/v1/health` | Backend reachable before Flutter gates | 200 JSON health response | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test -r compact` | Full suite stays green | 215 tests passed | ✅ |
| `flutter build apk --debug` | Debug APK compiles from this source | Built `build/app/outputs/flutter-apk/app-debug.apk` (`206802169` bytes) | ✅ |
| `git diff --check` and ARB JSON parse | No whitespace or localization-catalog syntax errors | Passed | ✅ |
