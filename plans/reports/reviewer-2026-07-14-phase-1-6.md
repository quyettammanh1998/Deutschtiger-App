# Review: Flutter port phases 1–6

Date: 2026-07-15  
Scope: current dirty worktree; read-only review of the six supplied phase files, `lib/**`, `test/**`, native platform configuration, bundled web/backend references, and public association URLs.

Re-review: latest targeted fixes checked after the initial report. Implementation files were not modified by the reviewer.

## Verdict

**FAIL — the six phases cannot yet be called done.** The complete targeted defect set is now closed: recovery redirect, shell indexing, deck-picker reachability, ID-only word lookup, malformed ID-only detail action, current-item detail targeting, canonical queue identity, all audited void DELETE 204 paths, heartbeat placement, and the missing shared-workflow tests. Static gates are green at 176 tests. Remaining internal blockers are broader phase-acceptance gaps listed below.

Status legend: **PROVEN** = implementation plus a relevant local check; **INCOMPLETE** = code contradicts or omits the criterion; **UNVERIFIABLE** = requires credentials, physical devices, deployed infrastructure, or production data not available to this review.

## Highest-priority remaining internal blockers

1. **Phase 1 fidelity infrastructure remains incomplete.** Global semantic dark pairs are incomplete and multiple screens still force light tokens; the two fixed reviewer/fidelity seed accounts required by the phase plan are absent. This prevents repeatable light/dark parity review even though analysis/build contracts are healthy.

2. **Vocabulary acceptance remains partial beyond the repaired C3 path.** C2 is still a list-to-word flow rather than the specified lesson-card/end-view experience. C4 still lacks the specified inline FSRS quick-review and demonstrated native-recording player behavior. Hub/detail entry points also continue to construct `VocabularyWordScreen` imperatively instead of sharing the canonical route (`lib/features/vocabulary/presentation/vocabulary_screen.dart:578-584`; `lib/features/vocabulary/presentation/widgets/detail_widgets.dart:278-283`).

3. **Phase 3b product contracts remain unresolved.** My Words uses `saved/seen/reviewing`, not the planned `learning/known/review`; Deck review still uses the global due queue rather than a selected deck; and the Learn Hub presentation remains partial against the specified mission list, learned-word, and XP fields.

4. **Dashboard/mobile fidelity remains unproven.** The implementation does not provide a criterion-level inventory proving all 23 planned dashboard widgets, and whole-screen narrow viewport, text-scale, keyboard, safe-area, and lifecycle behavior remain uncovered.

### Targeted fixes confirmed in re-review

- Documented `{"error":"device_kicked"}` is now recognized (`lib/services/api_client.dart:224-233`) and has a header-free regression test (`test/services/api_client_test.dart:41-60`).
- More sheet is four columns/four groups and no longer lists speaking/pronunciation (`lib/shared/widgets/more_features_sheet.dart:270-377`); Home quick actions are exactly Học/Ôn/Thi/AI (`lib/widgets/dashboard/quick_actions.dart:24-80`).
- C4 practice buttons now use GoRouter (`lib/features/vocabulary/presentation/widgets/detail_widgets.dart:304-338`).
- Welcome enters onboarding, completed onboarding is skipped, and corresponding redirect tests exist (`lib/screens/auth/welcome_screen.dart:91-94`; `lib/navigation/auth_redirect.dart:16-23`; `test/navigation/auth_redirect_test.dart:16-36`).
- iOS targets iPhone only in all configurations (`ios/Runner.xcodeproj/project.pbxproj:367,493,546`).
- Word lookup now uses `DraggableScrollableSheet` (`lib/shared/widgets/word_lookup_sheet.dart:325-346`).
- Authenticated recovery sessions now remain on `/reset-password` and are regression-tested (`lib/navigation/auth_redirect.dart:23-26`; `test/navigation/auth_redirect_test.dart:16-25`).
- Profile is a top-level route and the indexed shell has exactly four real branches; More remains a fifth UI-only sheet item (`lib/navigation/app_router.dart:565-575,578-711`; `lib/widgets/common/app_shell.dart:29-72`).
- Word lookup examples now expose a save-sentence action whose payload matches the backend `POST /user/learning-items` create contract (`lib/shared/widgets/word_lookup_sheet.dart:189-209,221-259`; `thamkhao/deutschtiger-backend/internal/feature/learning/learning/learning_handler.go:32-52`).
- WordHeader now uses the default SaveCard button, making the deck picker reachable; C4 detail intentionally uses the star variant (`lib/features/vocabulary/presentation/widgets/word_widgets.dart:113-122`; `lib/features/vocabulary/presentation/widgets/detail_widgets.dart:120-139`).
- The word route fetches by ID first and only fetches a topic queue when `topicKey` is supplied; its detail callback receives the current displayed item after queue navigation (`lib/features/vocabulary/presentation/vocabulary_provider.dart:89-106`; `lib/features/vocabulary/presentation/vocabulary_word_screen.dart:39-50,140-145`).
- Deck deletion now uses the empty-body-safe dynamic call path (`lib/repositories/decks/deck_repository.dart:53-55`).
- Heartbeat bootstrap is mounted once in `AppShell`, not duplicated at an application root (`lib/widgets/common/app_shell.dart:88-99`; `rg HeartbeatBootstrap lib` finds no second mount).
- ID-only word routes suppress the topic-dependent detail action, while topic routes pass the currently displayed queue item (`lib/features/vocabulary/presentation/vocabulary_word_screen.dart:39-55,140-149`).
- Topic queues replace a stale duplicate with the canonical item fetched by ID (`lib/features/vocabulary/presentation/vocabulary_provider.dart:94-108`), covered by identity assertions (`test/features/vocabulary/vocabulary_word_route_provider_test.dart:34-63`).
- Every audited void DELETE repository now uses `delete<dynamic>`; no `delete<Map<String, dynamic>>` call remains under `lib/repositories/`.
- Six targeted behavioral/contract tests cover picker/open-deck, compact/star variants, sentence-save payload, Deck empty-204, ID-only loading, and canonical optional-topic queues (`test/shared/widgets/save_card_button_test.dart`; `test/shared/widgets/word_lookup_sheet_test.dart`; `test/repositories/phase_3b_repository_contract_test.dart:51-60`; `test/features/vocabulary/vocabulary_word_route_provider_test.dart`).

## Criterion matrix

### Phase 1 / Phase 0 — foundation

| Criterion | Status | Evidence |
|---|---|---|
| No duplicate `*_new.dart` screens | PROVEN | `find lib` returned no matching files; analyzer resolves router imports. |
| Exam tokens and complete dark pairs | INCOMPLETE | Exam light/dark palettes exist (`lib/core/design_tokens.dart:143-191`; duplicated again in `lib/core/exam_design_tokens.dart`), but global dark pairs stop at border (`lib/core/design_tokens.dart:73-87`): destructive/success/error/warning/info/brand/sidebar/auth tokens lack dark counterparts. Screens also force light tokens, e.g. Home `background` at `lib/screens/home/home_screen.dart:47-49`. |
| API additive-only changelog and app-version header | PROVEN | Policy and contract exist (`docs/api-changelog.md:1-28`); interceptor sets `X-App-Version` (`lib/services/api_client.dart:62-68`). |
| Two fixed fidelity seed accounts | INCOMPLETE | No `reviewer@deutschtiger.app` or `fidelity@deutschtiger.app` seed found outside plans/reference material. |
| Router intact | PROVEN | ID-only word loading is safe; the topic-dependent detail action is hidden when no topic exists, and topic routes target the current item. |
| Analyze/build gates | PROVEN | Latest `flutter analyze` reports no issues (4.3s). A debug APK exists at `build/app/outputs/flutter-apk/app-debug.apk` (201,375,198 bytes, built 2026-07-15 00:03 +07). |

### Phase 2 / Phase 1 — design system, shell, shared widgets

| Criterion | Status | Evidence |
|---|---|---|
| More sheet is a 4-column, 4-group GĐ1 grid | PROVEN BY CODE | Grid has four columns (`lib/shared/widgets/more_features_sheet.dart:177-185`), four groups (`:270-377`), and no speaking/pronunciation entry. No widget snapshot/fidelity test was added. |
| MinimalShell for player routes | PARTIAL | Exam practice/result use `MinimalShell`; general game and speaking player routes do not. Top-level routes avoid AppShell, but that is not the specified shared shell contract. |
| SpeakButton recorded → cached TTS → device TTS, single active audio | PROVEN LOCALLY | Chain and stop-before-play exist (`lib/services/audio_service.dart:21-47,73-80`); provider shares one service instance (`lib/view_models/providers.dart:65-69`). Actual "Hund" playback on a device was not exercised. |
| WordLookupSheet expands, looks up, saves word/sentence | PROVEN LOCALLY | Lookup and draggable expansion are wired; sentence-save payload/state are widget-tested (`test/shared/widgets/word_lookup_sheet_test.dart:13-55`). |
| SaveCardButton: button/compact/star + deck picker/open deck | PROVEN LOCALLY | WordHeader uses the default picker variant, dictionary lookup uses compact, and C4 detail uses star. Tests select a deck, verify `deck_id`, open the deck route, and exercise compact/star quick save (`test/shared/widgets/save_card_button_test.dart:14-107`). |
| Offline banner | PARTIAL | AppShell watches connectivity and renders the banner (`lib/widgets/common/app_shell.dart:83-104`). No airplane-mode/physical-device test proves behavior. |
| Device-kicked 401 event/modal | PROVEN LOCALLY | Handler recognizes header, `code`, and documented `error` shapes (`lib/services/api_client.dart:224-233`); the production-shaped body test verifies no refresh (`test/services/api_client_test.dart:41-60`). The real four-device scenario remains untested. |
| Shared-widget test quality | INCOMPLETE | `test/structure/shared_widgets_test.dart:5-57` mostly asserts files/counts. The hardcoded-color check only prints warnings and always passes (`:59-78`), so it does not enforce the stated design rule. |

### Phase 3 / Phase 2 — auth, devices, deletion

| Criterion | Status | Evidence |
|---|---|---|
| Secure Supabase session storage | PROVEN LOCALLY | Supabase is initialized with secure session and PKCE storage (`lib/main.dart:44-50`); storage delegates to `flutter_secure_storage` (`lib/services/secure_auth_storage.dart:4-50`). Physical Keychain/Android Keystore persistence remains untested. |
| Native Google OAuth | PROVEN BY CODE / UNVERIFIED RUNTIME | Uses `GoogleSignIn` then Supabase `signInWithIdToken`, not WebView OAuth (`lib/services/auth_service.dart:46-67`). No real iOS/Android login evidence. |
| Sign in with Apple, iOS only | PROVEN BY CODE / UNVERIFIED RUNTIME | Nonce + native credential + Supabase ID token (`lib/services/auth_service.dart:73-105`); UI platform gate exists in login/signup. Real Apple auth not tested. |
| Reset-password deep link | INCOMPLETE EXTERNALLY | Native declarations and the local authenticated-recovery redirect exemption exist and its focused tests pass. Public association infrastructure is still invalid/unavailable, so native launch is not proven. |
| Three-slide skippable onboarding that does not repeat | PROVEN LOCALLY | Welcome now enters onboarding (`lib/screens/auth/welcome_screen.dart:91-94`); completion persists and routes to login/home; completed onboarding redirects to login, covered by tests (`test/navigation/auth_redirect_test.dart:16-36`). |
| Device management | PARTIAL | GET list and per-session DELETE are real contracts (`lib/repositories/settings/device_session_repository.dart:54-71`); "revoke others" now iterates supported per-device routes. No authenticated multi-device test. |
| Device-kicked device-4 scenario | PARTIAL | Documented response shape is handled and regression-tested, but no real four-device test was run. |
| Two-step in-app deletion | PARTIAL | UI and client call exist (`lib/screens/settings/delete_account_screen.dart:42-72,106-249`), but backend handler/deployed deletion is not proven. UI confirms by email instead of the specified `XÁC NHẬN`, a spec deviation. |
| Web `/delete-account` live | PROVEN AS PAGE | HTTP 200 HTML on 2026-07-14. Successful authenticated deletion remains unverified. |

### Phase 4 / Phase 3a — vocabulary C1–C4

| Criterion | Status | Evidence |
|---|---|---|
| C1 real hub data + filtering/empty state | PARTIAL | Repository uses real API endpoints (`lib/features/vocabulary/data/vocabulary_repository.dart:10-108`) and hub has async states. Tests use hand-written adapters (`test/features/vocabulary/vocabulary_repository_test.dart:76-120`), not a real backend. |
| C2 lesson queue and swipe/advance | PARTIAL | Lesson fetches topic/level items and now opens a GoRouter-backed word queue (`lib/features/vocabulary/presentation/vocabulary_lesson_screen.dart:75-115`); horizontal queue interaction is widget-tested (`test/features/vocabulary/vocabulary_interaction_test.dart:25-42`). It is still a list-to-word flow, not the specified lesson-card/end-view implementation. |
| C3 phonetic/meaning/clickable examples/save/audio | PROVEN LOCALLY | Word header, audio/save, meanings and tappable examples are wired (`lib/features/vocabulary/presentation/widgets/word_widgets.dart:47-129,159-209`). No real audio/dictionary/backend save test. |
| C4 flip, related words, practice, save, native recording | INCOMPLETE | Flip/save exist and C4 practice CTAs now use valid GoRouter pushes (`lib/features/vocabulary/presentation/widgets/detail_widgets.dart:304-338`). FSRS inline quick-review is absent, and no native-recording player behavior is shown. |
| Hub → lesson → word → detail route chain | PARTIAL | Lesson → `/word/:itemId` fetches the canonical item by ID and optionally restores the topic queue. Detail follows the current queue item, and ID-only routes safely omit the topic-dependent action. Other word entry points remain imperative. |
| Module size/pattern constraints | INCOMPLETE | `vocabulary_screen.dart` remains well over the preferred 200 lines and uses numerous hardcoded `Colors.*`/numeric styles (e.g. `:33-43,96-99,132-196`), contrary to the project token rule. |

### Phase 5 / Phase 3b — FSRS, my words, learn hub, mission

| Criterion | Status | Evidence |
|---|---|---|
| C5 server-side FSRS queue/rating | PROVEN LOCALLY / UNVERIFIED E2E | Correct current API contracts are used (`lib/repositories/flashcard/review_repository.dart:34-67`), and failed saves keep the card for retry (`test/view_models/review_session_provider_test.dart:10-31`). No app-to-web due-count test, real JWT call, timezone behavior, or hardest-word endpoint test. |
| C6 three status tabs/counts | INCOMPLETE AGAINST PLAN | Code uses `saved/seen/reviewing` and `Đã lưu/Đã xem/Cần ôn` (`lib/features/my_words/domain/my_word.dart:1-10`), not the planned `learning/known/review` and `Đang học/Đã biết/Cần ôn`. The test merely mirrors implementation (`test/repositories/phase_3b_repository_contract_test.dart:34-49`). |
| C7 deck flip/rate and completion | PROVEN LOCALLY | Review provider posts server ratings; completion screen is used (`lib/screens/flashcard/flashcard_review_screen.dart:55-109`). It practices the global due queue rather than accepting a selected deck ID, so tap-deck → practice-deck is not demonstrated. |
| B2 today learn hub from backend | PARTIAL | The main `/learn` branch now renders `JourneyScreen` (`lib/navigation/app_router.dart:673-698`), which reads today's mission and renders rounds/word count. Required mission list/words learned/XP presentation remains only partial. |
| B3 mission full session | PROVEN WITH FAKE / UNVERIFIED REAL | State machine persists round then mission and has retry behavior. Tests override the service with `_FakeMissionService` (`test/features/mission/mission_session_provider_test.dart:72-123`); no production payload/session run was executed. |
| GameCompletion after deck/mission | PROVEN BY CODE | Both paths render the shared completion screen (`lib/screens/flashcard/flashcard_review_screen.dart:58-65`; `lib/features/mission/presentation/mission_session_page.dart:75-91`). |

### Phase 6 / Phase 3c — dashboard

| Criterion | Status | Evidence |
|---|---|---|
| One HomeScreen, real dashboard data, no mock constants | PROVEN LOCALLY | One home screen; repository calls `/user/dashboard-init` (`lib/repositories/home/dashboard_repository.dart:4-13`); Home maps response values (`lib/screens/home/home_screen.dart:55-65,104-149`). |
| 23 dashboard widgets ported | INCOMPLETE / UNPROVEN | Current Home composes header, stats, leaderboard, four quick actions, missions, and continue-learning sections (`lib/screens/home/home_screen.dart:78-145`). There is no criterion-level inventory/test proving all 23 web widgets or their fidelity. |
| Streak claim once/day + confetti | PARTIAL | Heartbeat claimability triggers modal and claim updates state (`lib/screens/home/home_screen.dart:35-45,156-166`); synthetic widget test verifies endpoint. Once-per-day semantics depend on backend and were not exercised with a real account. |
| Heartbeat every 60s foreground only | PROVEN BY CODE / PARTIAL TEST | AppShell now globally mounts bootstrap (`lib/widgets/common/app_shell.dart:94-104`); notifier sends immediately + every 60s and stops on inactive/background states (`lib/features/heartbeat/heartbeat_provider.dart:54-93`). Test proves only the immediate request (`test/features/home/dashboard_phase_3c_test.dart:44-70`), not 60s/lifecycle behavior. |
| Required four quick-action routes | PROVEN BY CODE | Grid is exactly Học/Ôn/Thi/AI (`lib/widgets/dashboard/quick_actions.dart:24-80`) and Home wires valid routes (`lib/screens/home/home_screen.dart:127-132`). `/learn` now opens the Journey hub. |
| GĐ2 widgets hidden | PROVEN FOR AUDITED ENTRY POINTS | Speaking/pronunciation were removed from More and Home quick actions. Direct routes and daily-path backend routing remain available, but are not exposed as GĐ2 dashboard widgets. |
| Pull to refresh | PROVEN BY CODE | `RefreshIndicator` invalidates and awaits dashboard provider (`lib/screens/home/home_screen.dart:66-70`). |
| Mobile layout | PARTIAL | A single 340×640 test covers only `ResumeLearningCard` (`test/features/home/dashboard_phase_3c_test.dart:91-132`). No whole-dashboard, keyboard, safe-area, text-scale, Android toolbar, or iOS device test. |

## Public-contract and regression notes

- **Dark mode is declarative, not end-to-end:** many audited screens explicitly use light `DesignTokens.background/card/foreground`, bypassing theme brightness; token existence does not prove a usable dark UI.
- **Some tests still overstate readiness:** all 176 tests pass and the repaired shared workflows now have useful behavior tests, but many architecture tests assert file names/counts and other feature tests rely on fake repositories or custom Dio adapters. There is no authenticated API smoke test, real audio/TTS test, OAuth test, deep-link launch test, real device-kick test, deletion test, or app-to-web FSRS round trip.

## Fresh verification log

| Test | Expected | Actual | Status |
|---|---|---|---|
| Backend health `curl http://127.0.0.1:8080/api/v1/health` | Healthy before Flutter commands | `Backend OK` | ✅ |
| `flutter analyze` | 0 issues | No issues found (3.6s) | ✅ |
| `flutter test` | 0 failures | 176 tests passed (fresh full suite) | ✅ |
| Six new targeted tests | All repaired contracts exercised | Picker/open-deck, variants, sentence save, Deck 204, ID-only route, canonical topic queue all pass | ✅ |
| `flutter build apk --debug` | APK produced | Existing `app-debug.apk`, 201,375,198 bytes | ✅ |
| AASA / assetlinks | Association JSON | HTTP 200 `text/html` SPA | ❌ |
| `app.deutschtiger.com` | Resolves and serves associations | DNS resolution failed | ❌ |
| Web `/delete-account` | Live page | HTTP 200 HTML | ✅ |
| Authenticated delete/device/OAuth/FSRS | Real successful round trip | No safe credentials/device fixture available | ⚠️ |

## Minimum bar before marking phases 1–6 done

1. Deploy valid AASA/assetlinks JSON on a resolving declared domain and verify physical iOS/Android launches.
2. Finish dark-mode/token pairs and add the two fixed fidelity seed accounts.
3. Complete C2 lesson-card/end-view and C4 inline FSRS/native-recording acceptance criteria; migrate remaining imperative word entry points where route consistency is required.
4. Resolve the My Words, selected-deck review, and Learn Hub contract differences.
5. Prove the planned dashboard inventory and add whole-screen narrow/mobile tests for keyboard, safe areas, text scale, lifecycle heartbeat, and offline state.
6. Rebuild the APK after the final accepted edit set.

## Unresolved questions

- Is `saved/seen/reviewing` an intentional newer product decision superseding the phase plan? If yes, update the phase criteria instead of silently treating it as complete.
- Which hostname will own universal/app links: `deutschtiger.com` or the currently non-resolving `app.deutschtiger.com`?

Status: DONE_WITH_CONCERNS  
Summary: All targeted blocker fixes are confirmed, including canonical queue identity and six new contract/behavior tests. Remaining internal blockers are broader phase gaps: dark/fidelity infrastructure, incomplete C2/C4 criteria and route consistency, unresolved Phase 3b product contracts, and dashboard/mobile fidelity coverage.  
Concerns/Blockers: remaining internal blockers 1–4 above. Fresh analysis is clean and the full 176-test suite passes.
