# Local Gitleaks history verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `MOBILE_REQUIRE_GITLEAKS=1 bash scripts/check-mobile-secrets.sh build/app/outputs/flutter-apk/app-debug.apk` | Fail if Gitleaks is unavailable or source, committed history, or debug APK contains an unallowlisted secret | Source marker scan passed; Gitleaks scanned 19 commits / ~3.56 MB with no leaks; debug APK marker scan passed. | ✅ |
| Dependency report | Record resolved Dart packages for follow-up review | Regenerated at `build/security/dart-dependencies.json`. | ✅ |
| `git diff --check` | No tracked whitespace errors after evidence updates | Passed. | ✅ |

Gitleaks v8.30.1 was installed only under the ignored `build/security-tools/`
directory for this local verification. This validates the local debug artifact
and committed history; it does not replace a hosted CI run or the unavailable
signed-release artifact scan.
