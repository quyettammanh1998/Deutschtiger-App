# iOS transport-security policy verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `curl -sf http://127.0.0.1:8080/api/v1/health` | Backend is available before Flutter gates | Succeeded. | ✅ |
| `flutter test test/config/device_scope_test.dart -r compact` | iOS app target has no ATS global or domain exception | 4 tests passed. | ✅ |
| `xmllint --noout ios/Runner/Info.plist` | iOS property-list XML is well formed | Passed. | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found. | ✅ |
| `flutter test -r compact` | Full regression suite remains green | Passed; expected test-only `package_info_plus` missing-plugin logs remain. | ✅ |
| `flutter build apk --debug` | Android build remains valid after the shared configuration test change | Built successfully. | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 bash scripts/check-mobile-secrets.sh build/app/outputs/flutter-apk/app-debug.apk` | Source, history and debug APK are clean | Source/artifact marker scans passed; Gitleaks scanned 19 commits / ~3.56 MB with no leaks. | ✅ |
| `git diff --check` | No whitespace errors | Passed. | ✅ |

The iOS app target deliberately contains no `NSAppTransportSecurity` exception,
global arbitrary-load setting, or exception-domain list. Apple documents that
`NSAllowsArbitraryLoads=YES` disables App Transport Security restrictions for
all connections, so an exception must be an explicit, reviewed change rather
than a silent configuration drift. See [Apple's
documentation](https://developer.apple.com/documentation/bundleresources/information-property-list/nsapptransportsecurity/nsallowsarbitraryloads?language=objc).
