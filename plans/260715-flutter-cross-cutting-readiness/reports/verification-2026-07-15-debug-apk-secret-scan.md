# Debug APK secret-scan verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `bash scripts/check-mobile-secrets.sh build/app/outputs/flutter-apk/app-debug.apk` | No forbidden provider marker in release source paths or debug APK | Source and APK scans passed | ✅ |
| Dependency report | Produce Dart dependency inventory for review | `build/security/dart-dependencies.json` (80,320 bytes) | ✅ |
| Local Gitleaks availability | Verify committed history when installed | Not installed locally; CI requires Gitleaks | ⚠️ |

This is debug-artifact evidence only. It does not replace the required signed
release artifact scan or CI Gitleaks history scan.
