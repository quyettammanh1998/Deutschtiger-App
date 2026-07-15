# CI debug APK artifact-scan verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| Prettier check of `.github/workflows/flutter-ci.yml` | Workflow parses and follows repository YAML formatting | Passed | ✅ |
| Local `bash scripts/check-mobile-secrets.sh build/app/outputs/flutter-apk/app-debug.apk` | Source and debug artifact markers are clean | Passed | ✅ |
| GitHub Actions execution | Build APK then run required Gitleaks and artifact scan in CI | Pending next CI run | ⚠️ |

The workflow builds only a debug APK. It does not produce, upload, or imply a
signed store candidate.
