# iOS microphone-disclosure verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `curl -sf http://127.0.0.1:8080/api/v1/health` | Backend is available before Flutter gates | Succeeded. | ✅ |
| `flutter test test/config/device_scope_test.dart -r compact` | iOS permission strings cover registered `vi`/`de`/`en` locales and describe the local temporary recording source | 4 tests passed. | ✅ |
| `xmllint --noout ios/Runner/Info.plist` | iOS property-list XML is well formed | Passed. | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found. | ✅ |
| `flutter test -r compact` | Full regression suite remains green | Passed; expected test-only `package_info_plus` missing-plugin logs remain. | ✅ |
| `flutter build apk --debug` | Android build remains valid after the cross-platform configuration change | Built successfully. | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 bash scripts/check-mobile-secrets.sh build/app/outputs/flutter-apk/app-debug.apk` | Source, history and debug APK are clean | Source/artifact marker scans passed; Gitleaks scanned 19 commits / ~3.56 MB with no leaks. | ✅ |
| `git diff --check` | No whitespace errors | Passed. | ✅ |

The checked recording implementation writes the audio file under the platform
temporary directory and has no upload client or API dependency. The localized
iOS usage descriptions now communicate that limited, implemented behavior in
Vietnamese, German and English, and the Runner project registers all three
regions. A native iOS build remains a macOS/Xcode release gate and was not
available in this Linux environment.
