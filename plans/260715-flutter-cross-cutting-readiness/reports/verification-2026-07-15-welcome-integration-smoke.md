# Welcome Android integration smoke verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter analyze` | New integration test has no static-analysis errors | No issues found | ✅ |
| `flutter test integration_test/welcome_flow_test.dart -d emulator-5554 -r compact` | Real app reaches welcome and the CTA opens onboarding on Android | 1 test passed on `Pixel6_API34`; route changed to `/onboarding` | ✅ |
| `flutter test integration_test/welcome_flow_test.dart -d emulator-5554 --reporter expanded` | Fresh Android emulator repeats the real welcome → onboarding flow | 1 test passed on freshly created `DeutschTiger_QA_API34` (Android 14/API 34); APK built, installed, and route changed to `/onboarding` | ✅ |
| `flutter test -r compact` | Existing unit/widget coverage remains green | 229 tests passed | ✅ |
| `flutter build apk --debug` | APK still compiles with the integration dependency | Built successfully; 245,650,680-byte APK | ✅ |
| `git diff --check` | No tracked whitespace errors | Passed | ✅ |
| `flutter test integration_test/welcome_flow_test.dart -d linux -r compact` | Optional desktop execution is viable | Blocked before test execution: host lacks `libsecret-1>=0.18.4` development package required by `flutter_secure_storage_linux` | ⚠️ |

The local backend for the current recheck was a `-tags dev` reference-backend
process with the explicit `ENABLE_DEV_AUTH=1` synthetic identity; the test
itself does not make an authenticated or live-backend request. The integration
test is Android-only. It does not prove authentication,
deep-links, payments, microphone permission, push, account lifecycle, iOS, or
visual parity. CI execution remains pending a disposable backend/config
fixture.
