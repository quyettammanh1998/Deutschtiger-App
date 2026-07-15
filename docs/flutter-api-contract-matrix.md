# Flutter API Contract Matrix

Baseline: 2026-07-15. Scope is the implemented Flutter Phase 1–6 paths. A
mounted Go route plus handler schema is the current server truth. This document
does not treat stale labels or a client call as proof that an API exists.

## Status legend

- **Live** — Flutter request matches a mounted backend route.
- **Gap** — Flutter needs behavior that the current backend cannot provide.
- **Review** — path exists, but payload/response or product semantics still
  require a focused contract test.

## Account, device, and dashboard

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/services/auth_service.dart` | Supabase SDK session, refresh and OAuth callbacks | Supabase Auth (external identity contract; no Go `/user/*` route) | Live | Keep auth SDK behaviour separate from Go-route evidence; device/API calls below require the resulting bearer token. |
| `lib/repositories/profile_repository.dart` | `GET /user/profile` | `cmd/server/routes_user_learning.go` → `profileHandler.GetProfile` | Live | Add/keep client parse and auth failure test. |
| same | `PUT /user/profile` | same → `profileHandler.UpdateProfile` | Live | Assert only accepted patch fields are sent. |
| `lib/repositories/settings/device_session_repository.dart` | `GET /user/devices` | `cmd/server/routes_user.go` → `deviceSessionHandler.List` | Live | Keep the envelope parse test and verify unauthenticated/cross-session handling in Go. |
| same | `DELETE /user/devices/{sessionId}` | same → `deviceSessionHandler.Revoke` | Live | Keep the client verb/path test; Go owns the current-session and cross-user policy. |
| `lib/screens/settings/delete_account_screen.dart` | No API request; opens a localized support email path | No mounted deletion route; only GET/PUT `/profile` | Gap contained | Do not claim deletion succeeded. Replace this temporary support path only after the approved authenticated `/user/account` lifecycle is implemented and verified. |
| `lib/repositories/home/dashboard_repository.dart` | `GET /user/dashboard-init` | `cmd/server/routes_user.go` → `dashboardHandler.GetDashboardInit` | Live | Preserve the single-round-trip parser test; dashboard fields are additive only. |
| `lib/features/heartbeat/heartbeat_provider.dart` | `POST /user/heartbeat` | `routes_user_learning.go` → `gamificationHandler.Heartbeat` | Live | Keep foreground/lifecycle and request-path tests. |
| `lib/widgets/dashboard/streak_claim_modal.dart` | streak claim client path | `POST /user/streak/claim` | Review | Verify payload/response and once-per-day behavior with an authenticated test account. |

## FSRS, My Words, and decks

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/repositories/flashcard/review_repository.dart` | `GET /user/srs/queue?limit=` | `routes_user_learning.go` → `srsHandler.Queue` | Live | Server owns due scheduling; test app/web queue parity. |
| same | `POST /user/srs/review` with rating and `response_time_ms` | same → `srsHandler.Review` | Live | Prove no Flutter FSRS calculation and log queue before/after. |
| `lib/features/my_words/data/my_words_repository.dart` | `GET /user/my-words?filter=saved|seen|reviewing` | `routes_user_learning.go` → `myWordsHandler.List` | Live | Contract-test enum, count and unknown values; only version API if product wants different names. |
| `lib/repositories/decks/deck_repository.dart` | CRUD `/user/flashcard-decks` | `routes_user_flashcards.go` → `flashcardHandler` | Live | Add all verb/path/client parsing tests. |
| same | `GET /user/flashcard-decks/{id}/cards` | same → `flashcardHandler.GetCards` | Live | Keep ownership test in backend. |
| `lib/repositories/flashcard/flashcard_quick_save_repository.dart` | `POST /user/flashcards/quick-save` | `routes_user_flashcards.go` → `flashcardHandler.QuickSave` | Live | Keep the trimmed payload and duplicate-result contract tests. |
| deck practice flow | `GET /user/srs/queue?deck_id={deckId}&limit=` | `routes_user_learning.go` → `srsHandler.Queue` → `QueueBuilder.BuildDeckQueue` | Live | The server filters by both `flashcards.deck_id` and authenticated `user_id`; unreviewed deck cards enter the queue with `source_flashcard_id` so their first rating creates FSRS state. |

## Missions and public exam content

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/features/daily_path/data/daily_path_repository.dart` | `GET /user/learn/path/today?tz=` | `routes_user_learning.go` → `learnHandler.GetTodayPath` | Live | Keep timezone-query and response parsing tests; the server resolves the daily path. |
| `lib/features/mission/data/mission_service.dart` | `GET /user/learn/mission/today` | `routes_user_learning.go` → `learnHandler.GetTodayMission` | Live | Add authenticated happy/error tests. |
| same | start, round-complete, complete under `/user/learn/mission/{id}` | same → respective `learnHandler` methods | Live | Test idempotent completion and emitted event names. |
| `lib/features/exam/data/exam_service.dart` | `GET /exams`, `GET /exams/{slug}`, `GET /exams/{slug}/parts/{id}` | `routes_public.go` → exam handlers | Review | Production catalog probe on 2026-07-15 returned a non-empty array with Goethe A1 parts. The local runtime returned `200 null`, which is inconsistent with the current handler's empty-array normalization; align that runtime/fixture first, then verify the mapper against a real Lesen and Hören fixture. |

## Translation provider boundary

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/core/translation/translation_service.dart` | `POST /ai/translate-sentences` with bounded `sentences`, `sourceLang`, `targetLang` | `cmd/server/routes_ai.go` → `aiHandler.TranslateSentences` | Live | Flutter calls only this JWT-authenticated, rate-limited API. Source/target are `de`, `en`, or `vi`; no vendor key or vendor authorization header may exist in the app. |

## Tiger AI chat (PARITY P1)

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/repositories/ai/ai_repository.dart` | `POST /ai/chat` (SSE, `payload_mode: session`) via shared `lib/services/api/sse_client.dart` | `cmd/server/routes_ai.go` → `aiHandler.Chat` (`internal/shared/aihttp/ai_chat_stream_handler.go`) | Live | SSE frames are `data: {"content": "..."}` tokens, `data: {"error": "..."}`, and a trailing `data: [DONE]`; a quota/session-limit/validation rejection instead returns a plain JSON error before headers switch to `text/event-stream` (mapped to `AiChatRequestException`). Image attachments (`attachments: [{url,type,path}]`, a Supabase Storage URL) are modeled but not wired to any upload UI yet — text-only. |
| same | `GET /ai/sessions`, `GET /ai/sessions/{id}/messages` | same → `aiHandler.ListSessions`/`GetSessionMessages` | Live | History sidebar + session resume. |
| same | `GET /ai/chat-status` | same → `aiHandler.GetChatStatus` | Live | Daily/session quota banner data; not yet surfaced in the UI (state is fetched but no widget renders it — follow-up). |
| same | `GET/DELETE /ai/memory`, `DELETE /ai/memory/{factKey}` | same → `aiHandler.GetMemory`/`DeleteAllMemory`/`DeleteMemoryFact` | Live | Auto-extracted learner facts, managed from `ai_settings_page.dart`. |
| same | `GET/PUT /ai/profile` | same → `aiHandler.GetProfile`/`UpdateProfile` | Live | User-authored "Tiger AI Memory" fields/notes. |

## Exam attempt persistence

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/features/exam/data/exam_attempt_store.dart` | `GET /user/exam-attempts?exam_id=&limit=1` | `routes_user_exam.go` → `examUserHandler.ListAttempts` | Review | It returns submitted history, not an owned draft by ID. |
| same | `POST /user/exam-attempts` | same → `examUserHandler.InsertAttempt` | Review | Append-only submit-time write; cannot autosave/resume. |
| same | `POST /user/exam-results` | same → `examUserHandler.UpsertResult` (premium-gated) | Review | Current Flutter duplicate persistence must be reconciled with the final server submit contract. |
| Phase 3 exam draft foundation | `POST /user/exam-drafts`, `GET/PATCH /user/exam-drafts/{id}` | `routes_user_exam.go` → `examUserHandler` → `exam_attempt_drafts` | Review | Flutter creates/resumes the owned, versioned draft, sends authenticated PATCH mutations, and migrates only unambiguous legacy answer IDs. Live DB evidence is still required. |
| Phase 3 exam player | `POST /user/exam-drafts/{id}/submit` with `version` and UUID `mutation_id` | `routes_user_exam.go` → `examUserHandler` → normalized-content draft snapshot | Review | Server derives score/result from the saved draft snapshot, rejects unknown answer references and audio over-limit, and makes the draft immutable. Flutter submits no client score fields and retains a failed submit for retry; device/live-DB evidence remains. |

## Change process

1. Update this matrix and `docs/api-changelog.md` before changing a client/server
   contract.
2. Add Flutter request tests and narrow Go route/handler tests in the same
   change. Route labels and snapshots are documentation, not substitutes.
3. Deploy additive server support first; ship the Flutter path after it is
   verified. Remove a compatibility path only after the minimum supported app
   version no longer uses it.
