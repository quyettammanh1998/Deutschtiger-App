# Android release signing-gate verification

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter build appbundle --release --obfuscate --split-debug-info=build/symbols` | Signed release AAB builds only with a valid upload keystore | Failed closed after compilation: `Release keystore file does not exist.` No AAB produced. | ✅ |
| Android release Gradle guard | Release task never selects debug signing | Build stops in the configured release task before artifact generation | ✅ |
| Signed artifact verification | A signed AAB can be inspected and scanned | Not possible: protected/local upload keystore file is absent | ⚠️ |

The keystore path and credentials are secret release infrastructure. This report
does not inspect or replace them. A protected CI release job must provide the
keystore, build the candidate, verify its signature/provenance, and scan the
result before store submission.
