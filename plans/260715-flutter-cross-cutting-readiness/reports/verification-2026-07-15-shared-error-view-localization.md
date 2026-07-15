# Shared error view localization verification

`ErrorView` is used by multiple release-visible routes. Its default error
message and retry button are now localized; route-specific callers can still
supply their own safe, localized recovery copy.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter test test/widgets/common/async_state_views_localization_test.dart` | Default German recovery copy and retry action render at 200% | 1 test passed | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test` | Full suite stays green | 228 tests passed | ✅ |
| `flutter build apk --debug` | Debug APK compiles from this source | Built successfully; 206,820,984-byte APK | ✅ |
| `jq empty` on all ARB catalogs and `git diff --check` | Valid catalogs and no whitespace errors | Passed | ✅ |
