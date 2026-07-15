# Mission session localization verification

The server-backed daily mission runner and its shared completion card now
localize only UI chrome. German word text and Vietnamese meanings remain data
supplied by the mission payload. The completion-card score labels expand at
large text scales instead of relying on a fixed-width row.

Persistence failures use locale-neutral state codes; the screen maps them to
the active catalog before rendering feedback. This prevents a provider error
from switching a German or English session back to a Vietnamese string.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter test test/screens/journey/mission_session_localization_test.dart` | German mission controls and completion-card defaults remain usable at 200% text scale | 1 test passed | ✅ |
| `flutter test test/screens/journey/mission_session_localization_test.dart test/features/mission/mission_session_provider_test.dart` | Persistence failures retain retry state and resolve in German | 4 tests passed | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test` | Full suite stays green | 227 tests passed | ✅ |
| `flutter build apk --debug` | Debug APK compiles from this source | Built successfully; 206,820,790-byte APK | ✅ |
| `jq empty` on all ARB catalogs and `git diff --check` | Valid catalogs and no whitespace errors | Passed | ✅ |
