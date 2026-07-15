# Device-kicked dialog localization verification

The forced-sign-out dialog now uses generated localization for its title,
recovery explanation and acknowledgement action. Its interceptor and
root-navigator behavior are unchanged.

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter test test/shared/widgets/device_kicked_dialog_test.dart` | German dialog copy remains actionable at 200% and acknowledgement callback fires | 1 test passed | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found | ✅ |
| `flutter test` | Full suite stays green | 229 tests passed | ✅ |
| `flutter build apk --debug` | Debug APK compiles from this source | Built successfully; 206,825,713-byte APK | ✅ |
| `jq empty` on all ARB catalogs and `git diff --check` | Valid catalogs and no whitespace errors | Passed | ✅ |
