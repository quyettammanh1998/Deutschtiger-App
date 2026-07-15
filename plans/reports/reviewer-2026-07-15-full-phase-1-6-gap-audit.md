# Phase 1–6 Completion Audit — 2026-07-15

Scope: current Flutter `lib/` and `test/`, the six phase files under `plans/260710-1644-flutter-port-phase-0-to-8/`, and bundled reference backend/frontend where an explicit cross-system contract required it. No production access or mutations were used.

Status legend:

- **PROVEN** — directly established by current source, automated test, analyzer, or build artifact.
- **CONTRADICTED** — current implementation materially differs from the written criterion.
- **MISSING** — no implementation/evidence found in the audited tree.
- **EXTERNAL-MANUAL** — requires a real device, identity provider, live backend/web, or cross-client test not available in this audit.

## Verification baseline

| Check | Result | Evidence |
|---|---|---|
| Backend pre-flight | **PROVEN** | `curl -sf http://127.0.0.1:8080/api/v1/health` returned success before Flutter verification. |
| Static analysis | **PROVEN** | `flutter analyze`: no issues found. |
| Automated tests | **PROVEN** | Full `flutter test`: 176 tests passed. |
| Debug Android artifact | **PROVEN** | `build/app/outputs/flutter-apk/app-debug.apk` exists (201,364,533 bytes; 2026-07-15 00:16 +0700). |

## Phase 1 — Foundation

### Requirements and implementation obligations

| Criterion | Status | Exact evidence |
|---|---|---|
| Keep one canonical copy of each screen; remove duplicate `*_screen_new.dart` / `*_new_screen.dart`. | **PROVEN** | `find lib -type f` found no matching duplicate-name patterns; router resolves under clean analysis. |
| Add web-equivalent exam tokens and complete light/dark tokens to `DesignTokens`. | **PROVEN** | `lib/core/design_tokens.dart:42-111` defines paired theme colors; `:163-243` defines light/dark exam palettes. |
| Use `DesignTokens` in every widget; no hardcoded colors. | **CONTRADICTED** | `rg -l 'Colors\.' lib` finds 161 Dart files. Example: `lib/features/vocabulary/presentation/vocabulary_screen.dart:38,135,184,193,426-431,531`. |
| Establish additive-only `/api/v1` convention and changelog. | **PROVEN** | `docs/api-changelog.md:1-28` documents additive-only fields/types and entries. |
| Send `X-App-Version` for force-update detection. | **PROVEN** | `lib/services/api_client.dart:62-68` injects package version/build header. |
| Seed reviewer account with streak 5, one deck, one exam attempt. | **MISSING** | No `reviewer@deutschtiger.app` seed or fixture exists outside plan/reference prose. |
| Seed fixed fidelity account for screenshot comparison. | **MISSING** | No `fidelity@deutschtiger.app` seed or fixture exists outside plan/reference prose. |
| Avoid a large directory restructuring in this phase. | **PROVEN** | Current implementation retains the existing mixed `screens/`, `features/`, `shared/`, `services/` layout; no phase-specific restructure artifact found. |

### Success criteria

| Success criterion | Status | Exact evidence |
|---|---|---|
| No duplicate `*_new.dart` screens. | **PROVEN** | No matching files in `lib/`. |
| `DesignTokens` contains exam and dark-mode variables. | **PROVEN** | `lib/core/design_tokens.dart:42-111,163-243`. |
| API changelog exists and states the convention. | **PROVEN** | `docs/api-changelog.md:1-28`. |
| Router imports remain valid after cleanup. | **PROVEN** | Clean `flutter analyze` compiles `lib/navigation/app_router.dart` and all imports. |
| `flutter analyze` has zero errors. | **PROVEN** | Clean full analyzer run. |
| `flutter build apk --debug` passes. | **PROVEN** | Current debug APK artifact exists at `build/app/outputs/flutter-apk/app-debug.apk`. |

## Phase 2 — Design system and shell

### Requirements and implementation obligations

| Criterion | Status | Exact evidence |
|---|---|---|
| AppShell retains five-tab behavior and “More” opens a four-column, four-group sheet. | **PROVEN** | `lib/widgets/common/app_shell.dart:16-57`; `lib/shared/widgets/more_features_sheet.dart:177-185,270-376` uses `crossAxisCount: 4` and four groups. |
| Hide all phase-2 items instead of showing disabled/beta entries. | **PROVEN** | Rendered four groups in `more_features_sheet.dart:270-376` contain no phase-2 speaking/pronunciation entries. |
| Use `MinimalShell` without bottom navigation for exam, game runner, and speaking scenario routes. | **CONTRADICTED** | `MinimalShell` is instantiated only by `exam_practice_page.dart:51,56,105` and `exam_result_page.dart:27`; no game-runner or speaking-scenario route uses it. |
| P1 WordLookupSheet: expandable dictionary sheet with phonetic, meaning, examples, and save word/sentence. | **PROVEN** | `lib/shared/widgets/word_lookup_sheet.dart`; sentence-save behavior covered by `test/shared/widgets/word_lookup_sheet_test.dart:13-55`; dictionary parsing has adapter tests. |
| P1 TappableSentence: clickable per-word spans opening word lookup. | **PROVEN** | `lib/shared/widgets/tappable_sentence.dart:63-101`; token callback tested in `test/shared/widgets/tappable_sentence_test.dart:7-31`; vocabulary examples call `showWordLookupSheet`. |
| P2 SaveCardButton has button/compact/star variants, deck picker, and “open deck”. | **PROVEN** | `lib/shared/widgets/save_card_button.dart`; picker/open-deck and variants tested by `test/shared/widgets/save_card_button_test.dart:14-107`. |
| P3 BottomSheet base with handle and drag-to-close. | **PROVEN** | Capability exists in `lib/shared/widgets/app_bottom_sheet.dart` (filename differs from planned `base_bottom_sheet.dart`). |
| P4 SpeakButton chain: recorded URL → cached TTS → device TTS `de-DE`; stop previous audio first. | **PROVEN** | `lib/services/audio_service.dart:21-47,73-76`; `lib/shared/widgets/speak_button.dart:44-68`. |
| P5 completion screen has confetti, score/learned words, replay/back CTAs. | **PROVEN** | `lib/shared/widgets/game_completion_screen.dart` implements shared completion UI. |
| P6 skeleton, persistent offline banner, confirm dialog, and confetti. | **PROVEN** | `skeleton_loader.dart`, `offline_banner.dart`, `confirm_dialog.dart`, and `confetti_overlay.dart` exist under `lib/shared/widgets/`; connectivity wiring is in `lib/services/connectivity_service.dart:20-41` and AppShell. |
| P7 LevelBadge, PremiumCrown, BackButton, and PageIntro. | **PROVEN** | Corresponding files exist under `lib/shared/widgets/`. |
| API client attaches bearer token and `X-App-Version`. | **PROVEN** | `lib/services/api_client.dart:62-68`; interceptor tests in `test/services/api_client_test.dart:11-82`. |
| Device-kicked 401 emits event without retry; ordinary expired token refreshes once. | **PROVEN** | `lib/services/api_client.dart:78-107`; both branches covered by `test/services/api_client_test.dart:11-82`. |
| Initialize Crashlytics/reporting. | **PROVEN** | `lib/main.dart:31-40` initializes `CrashService` with fallback behavior. |

### Success criteria

| Success criterion | Status | Exact evidence |
|---|---|---|
| More sheet layout is correct and phase-2 items are absent. | **PROVEN** | Four-column/four-group construction at `more_features_sheet.dart:177-185,270-376`. |
| MinimalShell exam route has no bottom nav. | **PROVEN** | Exam practice/result explicitly wrap `MinimalShell`; analyzer and tests pass. |
| “Hund” plays through recorded→TTS chain. | **EXTERNAL-MANUAL** | Chain is implemented, but no real audio/network/device playback test for “Hund” was run. |
| “Haus” live lookup shows a meaning. | **EXTERNAL-MANUAL** | Dictionary call exists at `lib/services/dictionary_service.dart:70-80` and parsing is tested, but no authenticated live “Haus” request was run. |
| Tapping a sentence word opens WordLookupSheet. | **PROVEN** | Clickable spans and sheet wiring are present in vocabulary example widgets; callback normalization is tested. |
| OfflineBanner appears after Wi-Fi is disabled. | **EXTERNAL-MANUAL** | Connectivity listener and persistent AppShell banner are implemented; physical network toggling was not performed. |
| Device-kicked 401 emits the correct event. | **PROVEN** | Dedicated API-client test covers the no-retry device-kicked branch. |
| Analyzer has zero errors. | **PROVEN** | Clean full analyzer run. |

## Phase 3 — Authentication, devices, and deletion

### Requirements and implementation obligations

| Criterion | Status | Exact evidence |
|---|---|---|
| Supabase auth storage uses secure mobile storage. | **PROVEN** | `lib/core/auth/secure_auth_storage.dart:4-50`; initialized in `lib/main.dart:44-50`; round-trip tested in `test/core/auth/secure_auth_storage_test.dart:10-31`. |
| Android disables cleartext traffic. | **PROVEN** | `android/app/src/main/AndroidManifest.xml:7` sets `android:usesCleartextTraffic="false"`. |
| Expired access token refreshes and request retries once. | **PROVEN** | `lib/services/api_client.dart:93-107` and API-client tests. |
| Google sign-in is native, then exchanges ID token with Supabase. | **PROVEN** | `lib/core/auth/auth_service.dart:46-67` uses `google_sign_in` and `signInWithIdToken`, not OAuth WebView. |
| Apple sign-in button is iOS-only and uses nonce/ID-token flow. | **CONTRADICTED** | Native nonce flow exists at `auth_service.dart:73-105`, but buttons render on iOS **or macOS** at `login_screen.dart:223` and `signup_screen.dart:221`, contrary to strict `Platform.isIOS`. |
| Android App Links and iOS Universal Links cover reset-password and OAuth callback. | **PROVEN** | Android filters: `android/app/src/main/AndroidManifest.xml:30-54`; iOS associated domains: `ios/Runner/Runner.entitlements:11-16`; reset route: `app_router.dart:153-156`. Server association remains external. |
| Server serves AASA and `assetlinks.json`. | **EXTERNAL-MANUAL** | Requires live nginx/domain validation, excluded from this audit. |
| Onboarding is 2–3 slides and skippable. | **PROVEN** | Three slides, skip, indicators, persistence, and CTA in `lib/screens/auth/onboarding_screen.dart:23-75,94-139`. |
| Three slides use the specified content: daily learning, FSRS, TELC/Goethe. | **CONTRADICTED** | Actual slides are “Học từ vựng thông minh”, “Luyện thi Goethe/telc”, and “Gamification & streak” (`onboarding_screen.dart:23-50`); the FSRS slide is absent. |
| Completed onboarding does not repeat for logged-in users. | **PROVEN** | Redirect behavior tested in `test/navigation/auth_redirect_test.dart:27-47`. |
| Device-kicked modal shows title/message/login CTA, does not retry, and returns to login. | **PROVEN** | `lib/shared/widgets/device_kicked_dialog.dart:12-79`; root wiring in `lib/view_models/providers.dart:44-57`; no-retry branch tested. |
| Device management lists `GET /user/devices` and revokes `DELETE /user/devices/{id}` from Settings → Security. | **PROVEN** | Repository calls at `lib/repositories/device_repository.dart:54-72`; UI at `lib/screens/settings/security_screen.dart:23-97,125-249`; adapter tests pass. |
| Account deletion UI is two-step and requires typing literal `XÁC NHẬN`. | **CONTRADICTED** | `lib/screens/settings/delete_account_screen.dart:12-14,25,36-72,200-238` requires the current **email**, not `XÁC NHẬN`. |
| App calls `DELETE /api/v1/user/profile`, then logs out and returns to welcome. | **PROVEN** | `lib/repositories/profile_repository.dart:34-35`; screen executes deletion/logout/navigation and repository 204 behavior is tested. |
| Backend implements `DELETE /api/v1/user/profile`, deletes app data/auth user, and revokes sessions. | **MISSING** | Bundled backend `thamkhao/deutschtiger-backend/internal/router/routes_user_learning.go:14-15` registers only GET/PUT profile; no deletion handler found. |
| Web `/delete-account` implements login, confirmation, and the same endpoint. | **EXTERNAL-MANUAL** | Live website behavior requires production access; no current Flutter-tree proof can establish it. |
| Auth gate redirects unauthenticated users to welcome and authenticated users to home. | **PROVEN** | `lib/navigation/app_router.dart:118-134` delegates to tested `resolveAuthRedirect`. |
| Auth bootstrapping displays skeleton with a 4-second timeout. | **MISSING** | No four-second bootstrap timeout/skeleton found in auth/router code. |

### Success criteria

| Success criterion | Status | Exact evidence |
|---|---|---|
| Login, signup, and forgot-password do not crash on real iOS and Android. | **EXTERNAL-MANUAL** | Screens compile and tests pass; real-device flows were not executed. |
| Native Google OAuth works. | **EXTERNAL-MANUAL** | Native implementation is present, but provider credentials/device flow require external validation. |
| Apple sign-in appears only on iOS and authenticates. | **CONTRADICTED** | It also appears on macOS; successful Apple authentication remains external. |
| Reset-password deep link opens the app. | **EXTERNAL-MANUAL** | Platform declarations and route exist; `adb`/iOS launch was not run. |
| Onboarding has three slides, skip works, and it does not repeat. | **PROVEN** | Source plus `auth_redirect_test.dart:27-47`; exact planned slide copy is separately contradicted above. |
| Fourth-device login kicks device 1, shows modal, and returns to login. | **EXTERNAL-MANUAL** | Client event/modal path is implemented; multi-device backend scenario was not run. |
| Confirm deletion removes data and prevents future login. | **EXTERNAL-MANUAL** | Destructive authenticated test was not authorized/run, and bundled backend lacks the required route. |
| Live web deletion page exists. | **EXTERNAL-MANUAL** | Production website was not accessed in this audit. |

## Phase 4 — Core vocabulary learning

### Requirements and implementation obligations

| Criterion | Status | Exact evidence |
|---|---|---|
| C1 hub loads real vocabulary data. | **PROVEN** | `lib/features/vocabulary/presentation/vocabulary_screen.dart:14-23` consumes `vocabularyPageDataProvider`; repository/provider adapters are tested. |
| C1 offers A1/A2/B1/B2 level filters, lesson grid, progress indicator, and empty state. | **CONTRADICTED** | `_levels` includes A1–C2 and renders level cards (`vocabulary_screen.dart:415-497`), but there is no A1–B2 filter-tab/lesson-grid/progress design; empty state exists only for topics at `:608`. |
| C2 provides lesson scaffold/info, swipe-reveal word cards, progress/count, and end stats/CTAs. | **MISSING** | `vocabulary_lesson_screen.dart:75-201` is a conventional list; no lesson swipe-reveal component or end view exists. |
| C3 provides pronunciation/SpeakButton, meaning/examples/GrammarInfo, clickable examples, inline multiple-choice/fill-blank, and top-right SaveCardButton. | **CONTRADICTED** | Header, meaning/examples, SpeakButton, SaveCard, and tappable examples exist in `vocabulary_word_screen.dart`/`widgets/word_widgets.dart`; no `GrammarInfo` or inline multiple-choice/fill-blank practice exists. |
| C4 has flashcard flip, related words, tappable examples, inline FSRS quick review, and native-speaker recordings. | **CONTRADICTED** | Flip/save/examples/related exist in `vocabulary_detail_screen.dart:89-132` and `widgets/detail_widgets.dart:34-193,259-301`; practice buttons only navigate to games (`:304-338`), with no inline FSRS review or recording player. |
| Routes are `/vocabulary/lesson/:id`, `/word/:id`, `/detail/:id`. | **CONTRADICTED** | Router uses `lesson/:topicKey`, `word/:itemId`, and `detail/:topicKey` at `lib/navigation/app_router.dart:165-191`; detail item ID is a query parameter. |
| Hub → lesson → word → detail is routed consistently. | **CONTRADICTED** | Lesson→word is routed (`vocabulary_lesson_screen.dart:107`), word→detail is routed (`vocabulary_word_screen.dart:50`), but hub/level/topic/related flows still use imperative `Navigator.push` (`vocabulary_screen.dart:313,395,497,578,625`; `detail_widgets.dart:259-301`). |
| Data layer calls `/vocabulary/lessons`, `/lesson/:id`, `/word/:id`, and `/search`. | **CONTRADICTED** | Current repository uses evolved endpoints including `/vocabulary-page-data`, topic/level queries, and `/learning-items/:id` (`lib/features/vocabulary/data/vocabulary_repository.dart`); only search aligns. |
| Large web screens are split into focused files/modules. | **CONTRADICTED** | Current LOC: `vocabulary_screen.dart` 636, provider 257, `detail_widgets.dart` 339, `word_widgets.dart` 261, `lesson_widgets.dart` 237; multiple files exceed the project’s preferred 200-line boundary. |

### Success criteria

| Success criterion | Status | Exact evidence |
|---|---|---|
| C1 loads lessons and filters by level. | **CONTRADICTED** | Data and level-specific queries work, but the prescribed lesson list/filter experience is not present; levels are navigation cards including C1/C2. |
| C2 opens and can swipe through each word. | **PROVEN** | Lesson opens word queue; horizontal previous/next interaction is covered by `test/features/vocabulary/vocabulary_interaction_test.dart`, though it occurs on the word screen rather than C2 cards. |
| C3 shows phonetic, meaning, and clickable TappableSentence examples. | **PROVEN** | Implemented in `vocabulary_word_screen.dart` and `widgets/word_widgets.dart`; interaction/provider tests pass. |
| C4 flip animation works and shows SaveCardButton. | **PROVEN** | `detail_widgets.dart:34-145`; widget tests pass. |
| SpeakButton in C3/C4 produces audio. | **EXTERNAL-MANUAL** | Both screens wire the shared service, but real audio playback was not exercised. |
| Hub → lesson → word → detail is seamless. | **CONTRADICTED** | Main lesson path works, but mixed GoRouter/imperative navigation and topic-key detail contract violate the specified unified route chain. |
| Analyzer has zero errors. | **PROVEN** | Clean full analyzer run. |

## Phase 5 — FSRS, saved words, decks, and missions

### Requirements and implementation obligations

| Criterion | Status | Exact evidence |
|---|---|---|
| C5 gets due cards and submits rating/response time to the backend; no client-side FSRS. | **PROVEN** | `lib/repositories/flashcard/review_repository.dart:34-67` uses `/user/srs/queue` and `/user/srs/review` with `rating` and `response_time_ms`; no client FSRS calculation found. Endpoint name differs from plan but matches current server contract. |
| C5 uses timezone-package parity with web review logic; avoid naïve `DateTime.now()`. | **MISSING** | Review flow has no `timezone`/`TZDateTime`; timezone package is used only in notifications. Review timing uses ordinary elapsed timestamps/provider timing. |
| C5 calls the hardest-word detector endpoint. | **MISSING** | No `hardest` endpoint invocation found in `lib/`. |
| Review app→web round trip reduces the same due queue. | **EXTERNAL-MANUAL** | Requires one authenticated account across app and web; not run. |
| C6 queries `/user/my-words?status=learning|known|review` and shows Đang học/Đã biết/Cần ôn counts. | **CONTRADICTED** | Current domain uses `saved/seen/reviewing`, labels “Đã lưu/Đã xem/Cần ôn”, and query key `filter` (`lib/features/my_words/domain/my_words_models.dart:1-10`; repository `:9-27`). |
| C6 lists decks from `/decks`; tapping a deck starts C7 for that deck. | **CONTRADICTED** | Repository uses `/user/flashcard-decks`; deck detail CTA pushes global `/flashcard-review` without deck ID (`lib/screens/decks/deck_detail_screen.dart:20-24`). |
| C7 front/back flip and Again/Hard/Good/Easy post correct rating and response time. | **PROVEN** | `lib/screens/flashcard/flashcard_review_screen.dart:13-115` uses server-backed review session and shared rating flow; repository payload is explicit. |
| C7 completion opens GameCompletionScreen. | **PROVEN** | Completion branch in `flashcard_review_screen.dart` renders shared completion UI. |
| B2 fetches today’s mission, displays mission/learned words/XP, and starts B3. | **PROVEN** | `lib/features/mission/data/mission_service.dart:12-17` calls `/user/learn/mission/today`; `lib/screens/journey/journey_screen.dart:101-190` renders counts/XP and CTA. |
| B3 implements `idle → starting → in_word_intro → in_practice → between_words → completed`. | **PROVEN** | State enum and transitions in `lib/features/mission/presentation/mission_session_provider.dart:19-315`; provider tests pass. |
| B3 separates word intro, practice, and result views. | **PROVEN** | Presentation widgets/state branches exist under `lib/features/mission/presentation/`. |
| B3 preserves web funnel event names. | **PROVEN** | Emits `mission_started` and `mission_completed` at `mission_session_provider.dart:157,271`, matching bundled web naming. |
| Mission completion opens GameCompletionScreen then can return to Learn. | **PROVEN** | Mission completion page uses shared completion UI and back navigation; state provider test reaches completion. |

### Success criteria

| Success criterion | Status | Exact evidence |
|---|---|---|
| Review five words in app, then web due count decreases. | **EXTERNAL-MANUAL** | Cross-client authenticated test not run. |
| My Words shows the specified three statuses with correct counts. | **CONTRADICTED** | Three tabs exist, but two status names/contracts differ (`saved/seen` vs `learning/known`). Live counts remain external. |
| Deck practice flips/rates and posts correct `/srs/review` parameters. | **PROVEN** | Review repository sends rating and `response_time_ms`; flip/rating session compiles and tests pass. Selected-deck scoping is separately contradicted above. |
| Learn hub shows today’s real backend mission. | **PROVEN** | Real mission endpoint and rendered provider path; no mock in the today-mission path. |
| A complete mission session runs without crashing. | **EXTERNAL-MANUAL** | State machine completion is unit-tested with a fake service; authenticated backend session was not run end-to-end. |
| GameCompletionScreen opens after deck and mission completion. | **PROVEN** | Both completion branches render the shared component. |

## Phase 6 — Dashboard

### Requirements and implementation obligations

| Criterion | Status | Exact evidence |
|---|---|---|
| Keep one canonical HomeScreen and update router. | **PROVEN** | Only `lib/screens/home/home_screen.dart` defines the active home; `app_router.dart:583` routes `/home` to it. |
| Port 23 dashboard widgets from web. | **MISSING** | Only 11 dashboard/home Dart files exist; no 23-widget inventory or parity test. Named weekly stats chart and achievement highlight are absent from Home. |
| Implement StreakCard, DailyGoalCard, TodayMissionCard, QuickActionsCard, ContinueLearningCard, WeeklyStatsCard, AchievementHighlightCard. | **CONTRADICTED** | Header/stats/goal/mission/quick-action/resume equivalents exist, but no seven-day `fl_chart` weekly stats card or achievement highlight is rendered; Home instead has a weekly leaderboard. |
| Hide phase-2 dashboard widgets (including streak freeze/premium banner) completely. | **PROVEN** | Active Home composition does not render those widgets; `secondRowActions` exists in `quick_actions.dart:83` but is not used by Home. |
| Dashboard uses real backend data, not mock constants. | **PROVEN** | `lib/features/dashboard/data/dashboard_repository.dart:4-13` calls `/user/dashboard-init`; `home_screen.dart:55-65,104-145` maps provider data, with no `_streak = 7`/`_dailyXp = 150`. |
| Streak claim appears only when unclaimed, posts claim, increments, confetti/count-up, and dismisses. | **CONTRADICTED** | Backend-driven claimability, POST `/user/streak/claim`, modal, and confetti exist (`home_screen.dart:27-45`; `streak_claim_modal.dart:90-114`), but no streak-number count-up implementation was found; endpoint differs from planned `/user/claim-streak`. |
| Heartbeat posts every 60 seconds in foreground and stops in background. | **PROVEN** | `lib/features/heartbeat/heartbeat_provider.dart:35-93` uses a 60-second periodic timer and lifecycle pause/resume; AppShell mounts the bootstrap. |
| Heartbeat tracks online time through the planned endpoint. | **CONTRADICTED** | Current implementation posts `/user/heartbeat` at `heartbeat_provider.dart:81`, not the written `/heartbeat`; whether this is an accepted backend evolution is unresolved. |
| Pull-to-refresh reloads dashboard data. | **PROVEN** | `lib/screens/home/home_screen.dart:66-70` invalidates/refetches through `RefreshIndicator`. |

### Success criteria

| Success criterion | Status | Exact evidence |
|---|---|---|
| Dashboard displays real streak and XP, with no mock constants. | **PROVEN** | `/user/dashboard-init` provider path and mapped UI data. |
| Claim modal appears once daily with confetti. | **EXTERNAL-MANUAL** | Backend `claimable` gating and one-open-per-widget-state guard exist, but once-per-day behavior needs live backend/day-boundary validation. |
| Heartbeat runs every 60 seconds only while foregrounded. | **PROVEN** | Lifecycle and timer code is direct; immediate POST has test coverage, although no fake-clock 60-second assertion exists. |
| Quick actions route Học→`/lessons`, Ôn→`/daily-review`, Thi→`/exam`, AI→`/ai-tutor`. | **CONTRADICTED** | `home_screen.dart:128-131` sends Học to `/learn`; the other three match. Router has `/learn` but no dashboard `/lessons` hub. |
| Phase-2 widgets do not appear in phase-1 build. | **PROVEN** | Active Home composition omits phase-2 action row and premium/freeze widgets. |
| Pull-to-refresh works. | **PROVEN** | Refresh callback is wired at `home_screen.dart:66-70`; provider refresh can be exercised in widget/runtime tests. |

## Actionable internal gaps, in phase order

1. **Phase 1:** add deterministic reviewer/fidelity seeds; migrate widget color literals to semantic `DesignTokens` (the current hardcoding is widespread, not isolated).
2. **Phase 2:** apply `MinimalShell` to game-runner and speaking-scenario routes; add integration tests for TappableSentence→sheet, offline banner, and audio fallback ordering.
3. **Phase 3:** restrict Apple button to iOS if the phase contract is authoritative; restore specified onboarding/FSRS copy; implement the four-second auth bootstrap state; change deletion confirmation to literal `XÁC NHẬN`; implement and test backend profile deletion before claiming compliance.
4. **Phase 4:** rebuild C1 as the specified A1–B2 lesson/filter/progress experience; implement C2 swipe/reveal/progress/end state; add C3 GrammarInfo and inline exercises; add C4 inline FSRS/native recordings; normalize all vocabulary routes to ID-based GoRouter navigation; split oversized modules.
5. **Phase 5:** add timezone-aware review parity and hardest-word call; reconcile My Words statuses with the accepted backend contract; pass deck ID into practice and scope its queue; add authenticated app/web and mission round-trip tests.
6. **Phase 6:** complete/document the 23-widget parity inventory, add weekly stats and achievement highlight, add claim count-up, reconcile heartbeat endpoint, and either change Learn action to `/lessons` or formally update the phase contract to `/learn`.

## External/manual release gates

- Real Android/iOS auth flows, native Google/Apple credentials, secure-store behavior, reset deep links, and universal/app-link association files.
- Multi-device kick scenario and live device-session revocation.
- Destructive account deletion plus re-login denial and the public deletion page.
- Recorded/TTS/device speech playback, offline network toggle, and live dictionary lookup.
- App↔web FSRS due-count parity and real mission/deck sessions.
- Once-per-day streak claim and full lifecycle heartbeat behavior on a device.

## Unresolved questions

- Are endpoint/route changes (`/user/srs/queue`, `/user/flashcard-decks`, `/user/heartbeat`, `/learn`, topic-key vocabulary routes) approved contract evolutions? If yes, the phase files must be updated; otherwise they are implementation gaps.
- Is macOS an intended target for Apple sign-in despite the explicit iOS-only requirement?
- Is deletion meant to be immediate hard deletion (`DELETE /user/profile`) or the separate bundled backend plan’s soft-delete/purge flow (`DELETE /user/account`)? The current artifacts conflict.
- Does “23 dashboard widgets” mean 23 source components or parity of 23 web capabilities? No acceptance inventory is present.

Status: DONE_WITH_CONCERNS

Summary: All explicit Phase 1–6 requirements and success criteria were audited against current source and tests. Core compilation and 176 tests are green, but material internal gaps remain in seeds/tokens, full shell coverage, deletion backend/compliance, vocabulary fidelity, saved-word/deck contracts, and dashboard parity.

Concerns/Blockers: Account deletion backend is absent in the bundled backend; several success criteria require real devices/live services; multiple current endpoint and route contracts diverge from the authoritative phase files.
