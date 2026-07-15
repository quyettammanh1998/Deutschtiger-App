---
scope: "Flutter port plan phases 1–6"
status: pass-with-manual-verification-gaps
role: tester
---

# Test Report — 2026-07-14 — Flutter Port Phases 1–6

## Summary

- Focused Flutter tests: **41 passed, 0 failed**.
- Latest heartbeat/shell regression tests: **6 passed, 0 failed**.
- Final post-fix focused tests: **38 passed, 0 failed**.
- SaveCardButton/shared/AppShell delta tests: **18 passed, 0 failed**.
- DailyPath GĐ1 filtering tests: **5 passed, 0 failed**.
- Latest routing/204/vocabulary/shared tests: **38 passed, 0 failed**.
- Pre-heartbeat-root definitive suite: **53 passed, 0 failed**.
- Latest heartbeat-root suite: **5 passed, 1 failed**.
- Revised definitive full suite: **170 passed, 0 failed**.
- Added contract tests: **10 passed, 0 failed**.
- Final expanded full suite: **176 passed, 0 failed**.
- Latest static analysis: **0 issues**.
- Backend health pre-flight: **HTTP 200**, `{"status":"ok"}`.
- Debug Android APK: **built successfully**.
- No implementation or test files changed during verification.

## Commands and Results

| Command | Expected | Actual | Status |
|---|---|---|---|
| `curl -sS -i http://127.0.0.1:8080/api/v1/health` | Backend responds before Flutter commands | HTTP 200; `{"status":"ok","uptime":"43.118552312s"}` | PASS |
| `flutter test test/services test/shared test/features/auth test/navigation/auth_redirect_test.dart test/repositories/device_session_repository_test.dart test/repositories/profile_repository_test.dart test/features/vocabulary test/features/mission test/repositories/phase_3b_repository_contract_test.dart test/view_models/review_session_provider_test.dart test/features/home/dashboard_phase_3c_test.dart test/features/home/home_widgets_test.dart` | Focused services/shared/auth/vocabulary/mission/FSRS/dashboard tests pass | 41 passed, 0 failed; process exit 0; wall time 10.97s | PASS |
| `flutter analyze` | Zero analyzer errors/warnings | `No issues found! (ran in 3.5s)`; process exit 0 | PASS |
| `curl -sS -i http://127.0.0.1:8080/api/v1/health` | Backend responds before latest Flutter commands | HTTP 200; `{"status":"ok","uptime":"4m21.050448477s"}` | PASS |
| `flutter test test/features/home/dashboard_phase_3c_test.dart test/widget_test.dart` | Heartbeat insertion and app shell compile; focused behavior remains green | 6 passed, 0 failed; process exit 0; wall time 8.15s | PASS |
| `flutter build apk --debug` | Phase 1 debug APK builds | Gradle `assembleDebug` succeeded; process exit 0; wall time 17.78s | PASS |
| `curl -sS -i http://127.0.0.1:8080/api/v1/health` | Backend responds before final post-fix Flutter commands | HTTP 200; `{"status":"ok","uptime":"9m42.987800128s"}` | PASS |
| `flutter test test/services/api_client_test.dart test/navigation/auth_redirect_test.dart test/features/vocabulary test/features/home/dashboard_phase_3c_test.dart test/features/home/home_widgets_test.dart test/shared test/structure/shared_widgets_test.dart test/repositories/profile_repository_test.dart test/repositories/device_session_repository_test.dart` | Final API client, auth redirect, vocabulary, dashboard, shared-widget, profile/device contracts pass | 38 passed, 0 failed; process exit 0; wall time 8.89s | PASS |
| `flutter analyze` | Latest source has zero analyzer issues | `No issues found! (ran in 4.2s)`; process exit 0 | PASS |
| `flutter build apk --debug` | Latest source produces a fresh debug APK | Gradle `assembleDebug` succeeded; process exit 0; wall time 18.66s | PASS |
| `curl -sS -i http://127.0.0.1:8080/api/v1/health` | Backend responds before SaveCardButton/AppShell delta verification | HTTP 200; `{"status":"ok","uptime":"11m40.131729811s"}` | PASS |
| `flutter analyze` | SaveCardButton/AppShell delta has zero analyzer issues | `No issues found! (ran in 3.8s)`; process exit 0 | PASS |
| `flutter test test/shared test/structure/shared_widgets_test.dart test/repositories/flashcard_quick_save_repository_test.dart test/repositories/phase_3b_repository_contract_test.dart test/widget_test.dart` | Shared widgets, save/deck repositories, and app shell smoke remain green | 18 passed, 0 failed; process exit 0; wall time 9.20s | PASS |
| `flutter test test/features/home/dashboard_phase_3c_test.dart` | DailyPath GĐ1 filtering and dashboard behavior remain green | 5 passed, 0 failed; process exit 0; wall time 8.78s | PASS |
| `flutter analyze` | Final DailyPath source has zero analyzer issues | `No issues found! (ran in 4.1s)`; process exit 0 | PASS |
| `flutter build apk --debug` | Final source after SaveCardButton/AppShell/DailyPath deltas produces APK | Gradle `assembleDebug` succeeded; process exit 0; wall time 17.67s | PASS |
| `curl -sS -i http://127.0.0.1:8080/api/v1/health` | Backend responds before latest routing/204/vocabulary/shared verification | HTTP 200; `{"status":"ok","uptime":"15m3.088674696s"}` | PASS |
| `flutter test test/services/api_client_test.dart test/navigation test/repositories/profile_repository_test.dart test/repositories/device_session_repository_test.dart test/repositories/flashcard_quick_save_repository_test.dart test/repositories/phase_3b_repository_contract_test.dart test/features/vocabulary test/shared test/structure/shared_widgets_test.dart test/structure/navigation_layer_test.dart test/widget_test.dart` | Recovery redirect, empty 204 DELETE, routes, vocabulary, lookup/save, deck picker, shared widgets, and app smoke pass | 38 passed, 0 failed; process exit 0; wall time 9.82s | PASS |
| `flutter analyze` | Latest source has zero analyzer issues | 2 issues; process exit 1; analyzer time 4.3s | FAIL |
| `flutter build apk --debug` | Latest source produces a debug APK | Gradle `assembleDebug` succeeded; process exit 0; wall time 18.81s | PASS |
| `curl -sS -i http://127.0.0.1:8080/api/v1/health` | Backend responds before pre-heartbeat-root definitive gate | HTTP 200; `{"status":"ok","uptime":"17m24.039853107s"}` | PASS |
| `flutter analyze` | Analyzer fixes and latest dark-token/learn source have zero issues | `No issues found! (ran in 3.9s)`; process exit 0 | PASS |
| `flutter test test/core/design_tokens_test.dart test/features/auth test/navigation/auth_redirect_test.dart test/structure/navigation_layer_test.dart test/features/vocabulary test/features/home/dashboard_phase_3c_test.dart test/features/home/home_widgets_test.dart test/widget_test.dart` | Tokens, auth, navigation, vocabulary, dashboard, and app smoke pass | 53 passed, 0 failed; process exit 0; wall time 11.40s | PASS |
| `curl -sS -i http://127.0.0.1:8080/api/v1/health` | Backend responds after heartbeat moved to authenticated root | HTTP 200; `{"status":"ok","uptime":"18m21.029814512s"}` | PASS |
| `flutter analyze` | Final heartbeat-root source has zero analyzer issues | 1 issue; process exit 1; analyzer time 3.9s | FAIL |
| `flutter test test/features/home/dashboard_phase_3c_test.dart test/widget_test.dart` | Heartbeat/dashboard and app smoke remain green | 5 passed, 1 failed; process exit 1; wall time 5.68s | FAIL |
| `flutter build apk --debug` | Final heartbeat-root source produces APK | Gradle `assembleDebug` succeeded; process exit 0; wall time 17.49s | PASS |
| `curl -sS -i http://127.0.0.1:8080/api/v1/health` | Backend responds before revised definitive gate | HTTP 200; `{"status":"ok","uptime":"20m52.228311245s"}` | PASS |
| `flutter test` | Entire Flutter test suite passes after reviewer fixes | 170 passed, 0 failed; process exit 0; wall time 18.45s | PASS |
| `flutter analyze` | Revised definitive source has zero analyzer issues | `No issues found! (ran in 3.6s)`; process exit 0 | PASS |
| `flutter build apk --debug` | Revised definitive source produces final debug APK | Gradle `assembleDebug` succeeded; process exit 0; wall time 18.40s | PASS |
| `flutter test test/shared/widgets/save_card_button_test.dart test/shared/widgets/word_lookup_sheet_test.dart test/features/vocabulary/vocabulary_word_route_provider_test.dart test/repositories/phase_3b_repository_contract_test.dart test/repositories/profile_repository_test.dart` | New SaveCard, sentence-save, vocabulary-route, and empty-204 contracts pass | 10 passed, 0 failed; process exit 0; wall time 6.16s | PASS |
| `flutter test` | Entire suite including new contracts passes | 176 passed, 0 failed; process exit 0; wall time 21.48s | PASS |
| `flutter analyze` | Test additions and latest implementation have zero analyzer issues | `No issues found! (ran in 4.0s)`; process exit 0 | PASS |
| `flutter build apk --debug` | Latest implementation plus test-backed contracts produces final debug APK | Gradle `assembleDebug` succeeded; process exit 0; wall time 17.74s | PASS |

## Build Artifact

- Path: `build/app/outputs/flutter-apk/app-debug.apk`
- Size: 201,364,533 bytes (193 MiB displayed by `ls -lh`)
- Modified: 2026-07-15 00:16:41 +07:00
- SHA-256: `710164db18a69e19ed6e078aaf7f33eaf20c816c671779a3101a3a4465e79fff`
- Build warning: `flutter_tts`, `package_info_plus`, `purchases_flutter`, `record_android`, and `sign_in_with_apple` still apply Kotlin Gradle Plugin. Current build passes; future Flutter versions may require plugin upgrades for Built-in Kotlin compatibility.

## Scope Covered

- Services: API 401 refresh/device-kicked handling, dictionary parsing, onboarding persistence, secure auth storage.
- Shared UI: tappable German-token extraction and callback behavior.
- Auth/device: validators, auth redirects including reset-password deep link, device response parsing, revoke-others preserving current session, account deletion route contract.
- Vocabulary: API contracts/parsing, lesson/word interactions, detail-card flip behavior.
- FSRS/mission: deck/my-words route contracts, failed grading retry state, mission completion and failed-round retry state.
- Dashboard: production dashboard parsing, widgets, heartbeat/claim persistence, daily-path timezone contract, narrow viewport, streak claim backend call.

## Diagnostics

- `package_info_plus` emitted `MissingPluginException`/uninitialized binding logs in headless tests. Root cause: the platform method-channel implementation is unavailable before a Flutter platform binding exists in the test process. `ApiClient` handled the condition, and all affected assertions passed. This is not a test failure.
- Analyzer info: `lib/features/vocabulary/presentation/vocabulary_word_screen.dart:51:17` uses an explicit null check where `use_null_aware_elements` requires `?`.
- Analyzer warning: `lib/navigation/app_router.dart:86:8` imports `interview_roadmap_screen.dart` but no longer uses it after route changes.
- Those two prior analyzer findings were fixed; the pre-heartbeat-root analyzer run passed.
- Latest analyzer info: `lib/app.dart:30:11` uses an explicit null check where `use_null_aware_elements` requires `?`.
- Latest app smoke failure: `DeutschTigerApp` now watches auth state at the MaterialApp root. In the test environment, `Supabase.instance` is read before initialization, causing `_instance._isInitialized` assertion failure; consequently no `MaterialApp` is rendered. Dashboard/heartbeat tests passed 5 assertions before the smoke failure.
- The heartbeat-root change was reverted to `AppShell`; the revised definitive `flutter test` and `flutter analyze` runs pass. The prior analyzer/app-smoke findings are resolved.
- New regression coverage verifies selected deck ID and open-deck route, compact/star quick-save variants, WordLookup sentence POST payload, ID-only vocabulary resolution, canonical current item replacement in topic queues, and empty 204 profile/deck deletes.

## Verification Gaps

Automated coverage does not prove the following phase acceptance criteria:

- Native Google/Apple OAuth and secure storage behavior on physical iOS/Android devices.
- Universal/App Links and deployed AASA/assetlinks configuration.
- Fourth-device kick flow and account deletion against an authenticated backend/database.
- Recorded audio/TTS fallback, Wi-Fi offline banner, and app lifecycle behavior on device.
- Authenticated live vocabulary, FSRS cross-client round trip, and real dashboard/streak data.

These are manual/integration verification gaps, not observed regressions.

## Unresolved Questions

- None for automated verification. Real-device and authenticated environment evidence remains needed before marking all plan success criteria complete.
