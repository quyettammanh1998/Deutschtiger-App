# Verification — 2026-07-15 — Apple sign-in migration

## Summary

Upgraded `sign_in_with_apple` from 6.1.4 to 8.1.0. The repository Flutter
minimum (3.44) exceeds the package minimum (3.41). AuthService only requests
an Apple credential with scopes and a nonce, then handles cancellation; it
does not use the renamed `SignInWithAppleButton` icon-alignment API.

## Verification log

| Test | Expected | Actual | Status |
|---|---|---|---|
| `flutter pub get` | resolve Apple sign-in package family | v8.1.0 plus platform interface v2.0.0 and web v3.0.0 resolved | ✅ |
| `flutter analyze` | AuthService compiles with existing Apple credential flow | `No issues found` | ✅ |
| `flutter test` | regression suite passes | 242 tests passed | ✅ |
| `flutter build apk --debug` | debug APK builds | APK built successfully | ✅ |
| Android API 34 `welcome_flow_test.dart` | app installs and CTA reaches onboarding | 1 integration test passed | ✅ |
| mobile secret/history/APK scan | no marker or committed secret | marker scan, Gitleaks (19 commits), and APK scan passed | ✅ |
| `git diff --check` | no whitespace errors | passed | ✅ |

## Findings

Flutter still reports `sign_in_with_apple` in its KGP compatibility warning at
v8.1.0. The remaining list is `flutter_tts`, `purchases_flutter`, and
`sign_in_with_apple`; do not claim that this migration clears the warning.

The Android smoke test does not exercise a real Apple identity provider.
Apple credential issuance and entitlement verification remain an iOS manual or
CI-provider gate.

## Unresolved questions

- None for source compatibility; upstream KGP migration remains open.
