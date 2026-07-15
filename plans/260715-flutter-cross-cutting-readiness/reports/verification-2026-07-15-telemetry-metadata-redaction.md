# Telemetry metadata redaction verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter test test/services/event_tracking_test.dart -r compact` | Content-like metadata, event names and sources are dropped; aggregate values remain | 3 tests passed | ✅ |
| `flutter test test/features/mission/mission_session_provider_test.dart -r compact` | Mission start/completion still persist after telemetry payload reduction | 2 tests passed | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test -r compact` | Full regression suite remains green | 235 tests passed | ✅ |
| `flutter build apk --debug` | Android debug build includes the redaction boundary | Built successfully; 245,658,366-byte APK | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 bash scripts/check-mobile-secrets.sh build/app/outputs/flutter-apk/app-debug.apk` | Source, debug APK and committed history contain no unallowlisted secret | Source/artifact marker scans passed; dependency report regenerated; Gitleaks scanned 19 commits and found no leaks. | ✅ |
| `git diff --check` | No tracked whitespace errors | Passed | ✅ |

The client permits only categorical event/source tokens and numeric/boolean
aggregate metadata. This does not establish backend retention timing or store
disclosure approval; those remain external release gates.
