# Dev Report — AI Chat + Tiger AI Live (SSE), Phase 1

Plan: `plans/260715-2333-flutter-full-parity-roadmap/phase-01-ai-chat-and-tiger-ai-live.md`

## Scope delivered

1. **Shared SSE client** — `lib/services/api/sse_client.dart`. `parseSseByteStream`
   parses `data:`/`event:`/comment lines per WHATWG SSE (chunk-split-safe via
   `Utf8Decoder`+`LineSplitter` buffering); `SseClient` wraps it over any `Dio`
   instance (pass `ApiClient.raw`), maps non-2xx/network failures to
   `SseException`, exposes `onHeaders` for response-header reads (`X-Session-Id`),
   and swallows a `DioException(cancel)` cleanly. Reusable by sprechen-partner
   (MASTER P8) and grading (GĐ2 P2) later, as required.
2. **Live AI repository** — `lib/repositories/ai/ai_repository.dart` rewritten:
   `sendMessage` streams `POST /ai/chat` (session payload mode), `getSessions`,
   `getSessionMessages`, `getChatStatus`, `getMemory`/`deleteMemoryFact`/
   `deleteAllMemory`, `getProfile`/`updateProfile`. New DTOs in
   `lib/data/ai/ai_chat_live_models.dart` mirror the Go handler shapes exactly
   (probed from `internal/shared/aihttp/*.go`, not guessed).
3. **Provider layer** — `lib/view_models/ai/ai_provider.dart` rewritten to a
   `StateNotifier`-based `AiChatNotifier` (the old plain-`Provider` + mutated
   `.state` pattern never actually triggered rebuilds — fixed as part of this
   pass) with streaming token accumulation, session resume, retry, and
   quota/session-limit/error banner state. Memory + profile get their own
   notifiers.
4. **Screens** — `ai_chat_page.dart` rewritten: streaming bubbles, typing
   indicator, sessions sidebar (`chat_history_sidebar.dart`, now backed by
   `GET /ai/sessions`), error/quota/session-limit banners with Retry.
   `ai_settings_page.dart` repurposed to manage the *live* memory facts +
   user-authored profile (the old screen edited a purely local mock
   `AISettings` object with no backend correlate).
5. **Unified ai vs ai_tutor** — `screens/ai_tutor/`, `repositories/ai_tutor/`,
   `data/ai_tutor/`, `view_models/ai_tutor/` deleted (100% mock duplicate).
   `screens/ai/` (the live chat) is now the single Tiger AI surface for both
   the `/ai` shell tab and every `/ai-tutor/**` deep link (paths kept for
   back-compat with `home_screen.dart`/`settings_screen.dart`/
   `more_features_sheet.dart` pushes — only the target widget changed).
   `ReleaseFeatureFlags.aiTutor` default flipped to `true`.
6. **Docs** — `docs/flutter-live-data-inventory.md` (ai row → Live with gap),
   `docs/flutter-api-contract-matrix.md` (new "Tiger AI chat" section),
   `docs/api-changelog.md` (gap entries below).

## Deliberate scope cuts (documented gaps, per phase spec §5)

- **Image input**: backend (`ai_chat_streaming.go`) accepts
  `attachments: [{url, type, path}]` — a Supabase Storage URL, not a
  multipart/base64 upload. Flutter has no image-upload-to-Storage UI in this
  phase, so chat stays text-only; `ChatAttachment` is modeled and the request
  body wires it through, ready for a follow-up upload screen.
- **Writing practice** (`/ai-tutor/writing`, Schreiben grading) is out of the
  endpoint list this phase specifies and stays on
  `AIWritingMockRepository` (trimmed `mock_data.dart`) — audit when grading
  (GĐ2 P2) lands.
- **Exam-context chat** (`examContext` field) is modeled (`AiExamContext`) but
  no screen passes it yet — general chat only this wave.
- Chat-status quota banner is fetched (`aiChatStatusProvider`) but not yet
  rendered anywhere in the UI — small follow-up.

## Files

- Created: `lib/services/api/sse_client.dart`,
  `lib/data/ai/ai_chat_live_models.dart`,
  `test/services/api/sse_client_test.dart`,
  `test/repositories/ai_chat_contract_test.dart`,
  `test/screens/ai/ai_chat_page_test.dart`.
- Modified: `lib/repositories/ai/ai_repository.dart`,
  `lib/repositories/ai/mock_data.dart` (trimmed to writing-practice-only),
  `lib/data/ai/ai_models.dart` (trimmed to writing-practice-only),
  `lib/view_models/ai/ai_provider.dart`, `lib/screens/ai/ai_chat_page.dart`,
  `lib/screens/ai/ai_settings_page.dart`, `lib/widgets/ai/chat_history_sidebar.dart`,
  `lib/navigation/app_router.dart` (narrow edits — imports + 3 `GoRoute`
  builders), `lib/core/release/release_feature_flags.dart` (`aiTutor` default
  `true`), `docs/flutter-live-data-inventory.md`,
  `docs/flutter-api-contract-matrix.md`, `docs/api-changelog.md`,
  plan/phase-01 status.
- Deleted: `lib/screens/ai_tutor/**`, `lib/repositories/ai_tutor/**`,
  `lib/data/ai_tutor/**`, `lib/view_models/ai_tutor/**`,
  `lib/widgets/ai/voice_recording_overlay.dart` (only referenced by the old
  mock chat page; no backend voice-input contract exists).

## Tests

- Unit: `test/services/api/sse_client_test.dart` — 15/15 pass. Covers
  single-chunk, chunk-split mid-line, chunk-split mid-UTF-8-character,
  multi-event ordering + keep-alive comment skip, multi-line `data:` join,
  `event:` field capture, malformed-line tolerance, no-trailing-blank-line
  flush, empty stream, `SseClient` 200/non-2xx/network-error/onHeaders, and
  two cancel scenarios (subscriber-cancel, Dio-cancel-mid-stream).
- Contract: `test/repositories/ai_chat_contract_test.dart` — 7/7 pass
  (streaming tokens + session-id header, in-band error event, pre-stream
  quota/session-forbidden mapping, sessions/memory/profile JSON contracts).
- Widget: `test/screens/ai/ai_chat_page_test.dart` — 3/3 pass (streaming
  render, quota-exceeded banner without Retry, generic-error banner with
  Retry that resends).
- `flutter analyze`: 11 issues repo-wide, all pre-existing in files owned by
  other in-flight agents (`lib/data/news/news_models.dart`,
  `lib/screens/exam/de_thi_practice_screen.dart`,
  `test/repositories/{journey_course,news}_contract_test.dart` — all
  untracked in git, not touched by this phase). Zero issues in every file
  this phase owns.
- `flutter test` (full suite, once): 425 passed, 1 failed —
  `test/l10n/app_localizations_test.dart: release flags map every gated
  More-sheet route family`, asserting `ReleaseFeatureFlags.journey` is
  `false`. Another agent flipped `journey`'s `defaultValue` to `true` in
  `release_feature_flags.dart` (visible via the session's file-change
  reminders) without updating this shared test — pre-existing contention,
  unrelated to `aiTutor`/AI chat. Not fixed here per instructions (file
  ownership boundary).

## Notable implementation finding (worth flagging for reuse)

Cancelling a `StreamSubscription` on a `Stream` built by an `async*` generator
that internally does `await for` over a chained `.transform()` pipeline can
make `subscription.cancel()`'s **returned Future** hang indefinitely while the
upstream source is still open (repro'd directly with `dart:async` primitives,
independent of Dio). Production code and the test suite both treat
`cancel()` as fire-and-forget (never `await` it) to avoid this — documented
inline in `sse_client_test.dart`. Real network-level abort should use
`CancelToken.cancel()` (verified working — the Dio-cancel-mid-stream test
passes cleanly), not `subscription.cancel()`.

## Not done / follow-ups

- ARB files (`lib/l10n/app_{vi,en,de}.arb`) were **not** touched — the ai/
  ai_tutor screens were already 100% hardcoded English strings pre-existing
  this phase (no l10n keys existed for them), and this rewrite preserves that
  same convention rather than introducing new ARB churn on a contended shared
  file for zero net-new user-facing localized strings. `flutter gen-l10n` was
  therefore not run (no ARB delta to regenerate). If localizing this surface
  is wanted, it is a clean, separate follow-up.
- `test/structure/release_live_data_guard_test.dart`'s route whitelist does
  not include `lib/screens/ai/ai_chat_page.dart` — left untouched (contended
  file, and adding it is an improvement not required by this phase); worth a
  follow-up PR since `/ai` is now a default-on release route.
- Emulator/device smoke test against a live backend was not run in this
  sandbox (no local backend instance available here); contract/unit/widget
  tests substitute per the constraints given.

Status: DONE_WITH_CONCERNS
Summary: SSE client + live AI chat/sessions/memory/profile shipped and unit/contract/widget-tested; ai_tutor merged into ai (routes preserved); aiTutor flag now default-on. Image input and writing-practice grading are documented gaps, not silently faked.
Concerns/Blockers: 1 pre-existing full-suite failure from another agent's `journey` flag change (unrelated, not touched). `release_live_data_guard_test.dart` route whitelist not extended to include the now-default-on `ai_chat_page.dart` — recommend a follow-up. Chat-status quota isn't rendered in the UI yet (fetched, unused).
