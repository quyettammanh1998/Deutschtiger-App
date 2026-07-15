# Android authentication backup-policy verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `curl -sf http://127.0.0.1:8080/api/v1/health` | Backend is available before Flutter gates | Succeeded. | ✅ |
| `flutter test test/config/device_scope_test.dart -r compact` | Manifest and both backup-rule formats exclude app data | 2 tests passed. | ✅ |
| `flutter build apk --debug` + `aapt dump xmltree` | Compiled APK disables backup and references both rule resources | Built successfully; manifest reports `allowBackup=false`, `fullBackupContent`, and `dataExtractionRules`. | ✅ |
| `flutter analyze` | No static-analysis regression | No issues found. | ✅ |
| `flutter test -r compact` | Full regression suite remains green | Passed; expected test-only `package_info_plus` missing-plugin logs remain. | ✅ |
| `MOBILE_REQUIRE_GITLEAKS=1 bash scripts/check-mobile-secrets.sh build/app/outputs/flutter-apk/app-debug.apk` | Source, history and debug APK are clean | Source/artifact marker scans passed; Gitleaks scanned 19 commits / ~3.56 MB with no leaks. | ✅ |
| `git diff --check` | No tracked whitespace errors | Passed. | ✅ |

Android Auto Backup is enabled by default for modern apps, and Android notes
that `allowBackup=false` alone can leave manufacturer-specific device-to-device
transfer behavior on Android 12+. The manifest therefore disables backup and
references explicit exclusions for both cloud and device transfer. See the
[Android Auto Backup documentation](https://developer.android.com/identity/data/autobackup).
