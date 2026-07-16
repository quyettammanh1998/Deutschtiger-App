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

## Grammar leaderboard (P6 web-mobile UI fidelity)

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/repositories/grammar/grammar_repository.dart` | `GET /grammar-leaderboard?limit=&level=` | `cmd/server/routes_user_public.go` `mountPublicGamification` → `grammarProgressHandler.GetLeaderboard` (`internal/feature/learning/grammarprogress/grammar_progress_handler.go`) | Live | Registered under the public-gamification group but still requires the JWT auth middleware applied by the caller's group (per the file's own comment); returns a raw JSON array of `{user_id, display_name, avatar_url, completed_count, rank}` (`GrammarLeaderboardEntry` Go struct), `[]` when empty. Verified by reading the Go handler/repo (`internal/infra/database/grammar_progress_repo.go`); no live curl probe run (no local backend instance available in this session). |
| same | `GET /user/grammar-rank?level=` | `cmd/server/routes_user_progress.go` → `grammarProgressHandler.GetUserRank` | Live | Same entry shape, wrapped as a single object or JSON `null` when the user has no completions yet (`repo.GetUserRank` returns `nil, nil` on no-rows). |
| `lib/features/grammar/presentation/grammar_screen.dart` | web calls `GET /user/grammar-map` for the "Bản đồ ngữ pháp" section | **not mounted** — no match for `grammar-map`/`GetGrammarMap` anywhere under `cmd/server/routes_*.go` or `internal/` in this backend snapshot | Missing | Flutter intentionally omits the `GrammarMap` section (web itself renders nothing when the query errors — `if (isError \|\| !topics) return null` in `grammar-map.tsx`). Do not build this against a fabricated response; wire it only once the backend registers the route, then add the Flutter provider + widget per the phase-06 spec. |

## Sentence Builder word preview (P7 web-mobile UI fidelity, deferred pass)

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/repositories/games/sentence_builder_repository.dart` | `GET /sentence-builder/topics/{id}/words?level=&limit=` | `cmd/server/routes_ai.go` → `sentenceBuilderHandler.GetTopicWords` (`internal/feature/gamify/game/sentence_builder_topic_handler.go`) | Live | Verified by reading the Go handler/SQL (`get_topic_words` function) — matches web `sentenceBuilderApi.getTopicWords`. Response `words[].examples` is always empty: the handler's `WordResponse.Examples` field exists but the `rows.Scan` call only reads 7 columns (id/contentDe/contentVi/wordType/gender/importanceScore/frequencyRank/isEssential), so `Examples` is never populated from the DB. Flutter's preview screen must not render an "examples" section as if data could appear — it never will until the Go handler is fixed to scan/join example sentences. |

## Grammar-drill AI explain panel (P7 web-mobile UI fidelity, deferred pass)

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/repositories/games/grammar_drill_repository.dart` | `POST /ai/explain-grammar` with `{game, exerciseKey, sentence, options, correctAnswer, userAnswer, case, vi, reason}` | `cmd/server/routes_ai.go` → `aiHandler.ExplainGrammar` (`internal/shared/aihttp/grammar_explain_handler.go`) | Live | Verified by reading the Go handler — `game` must be one of the existing `validGrammarGames` whitelist (`akk-dat`/`konjugation`/`adjektiv`/`wechselprep`/`verb-case`, same set as `GrammarDrillRepository.validGames`). Response is always HTTP 200; `ok:false` (LLM failure) is a normal degrade path the client must fall back to the static `reason` for, never surfaced as an error toast. Persistently cached server-side by `(game, exerciseKey, wrongAnswer)` — safe to call on every wrong answer without a client-side cache. |

## Exam attempt persistence

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/features/exam/data/exam_attempt_store.dart` | `GET /user/exam-attempts?exam_id=&limit=1` | `routes_user_exam.go` → `examUserHandler.ListAttempts` | Review | It returns submitted history, not an owned draft by ID. |
| same | `POST /user/exam-attempts` | same → `examUserHandler.InsertAttempt` | Review | Append-only submit-time write; cannot autosave/resume. |
| same | `POST /user/exam-results` | same → `examUserHandler.UpsertResult` (premium-gated) | Review | Current Flutter duplicate persistence must be reconciled with the final server submit contract. |
| Phase 3 exam draft foundation | `POST /user/exam-drafts`, `GET/PATCH /user/exam-drafts/{id}` | `routes_user_exam.go` → `examUserHandler` → `exam_attempt_drafts` | Review | Flutter creates/resumes the owned, versioned draft, sends authenticated PATCH mutations, and migrates only unambiguous legacy answer IDs. Live DB evidence is still required. |
| Phase 3 exam player | `POST /user/exam-drafts/{id}/submit` with `version` and UUID `mutation_id` | `routes_user_exam.go` → `examUserHandler` → normalized-content draft snapshot | Review | Server derives score/result from the saved draft snapshot, rejects unknown answer references and audio over-limit, and makes the draft immutable. Flutter submits no client score fields and retains a failed submit for retry; device/live-DB evidence remains. |

## Speech ecosystem — sprechen / conversation / pronunciation (P10)

Probed 2026-07-17 by reading `thamkhao/deutschtiger-backend` mounted routes +
handler structs directly (no live curl — public sprechen list endpoints are
read-only/unauthenticated, the rest require a bearer token this sandbox does
not hold). Backend confirmed as truth source per repo instructions.

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| new `lib/repositories/speech/sprechen_repository.dart` | `GET /api/v1/sprechen/{teil}/topics` → `[{slug, is_premium, order, tag}]` | `routes_public.go` → `sprechenHandler.ListTopics` (`internal/feature/exam/sprechen/sprechen_handler.go`) | Live | Unauthenticated, no premium filtering server-side — client must gate `is_premium` topics behind entitlement same as other exam content. |
| same | `GET /api/v1/sprechen/{teil}/tags` → `[{id, label, emoji, order}]` | same → `sprechenHandler.ListTags` | Live | Empty array (not 404) when no `tags.json` for a teil — client renders flat list. |
| same | `GET /api/v1/exams/official/sprechen-content?id=<uuid>` → `{markdown}` or `{locked:true, markdown:""}` | `routes_exam_official.go` → `officialExamHandler.SprechenContent` | Live | `locked:true` when topic premium and user not entitled — render lock state, do not treat as error. |
| new `lib/repositories/speech/sprechen_session_repository.dart` | `POST /user/sprechen-results` `{teil, topic_slug, score, grade}`; `GET /user/sprechen-results`; `DELETE /user/sprechen-results/{teil}/{slug}`; `GET /user/sprechen-leaderboard` | `routes_user_exam.go` → `sprechenResultHandler` | Review | Field-level response shape (leaderboard entry fields) needs a live-token probe before UI binds beyond raw JSON passthrough; build against documented request shape, treat response as `Map<String,dynamic>` until verified. |
| same | `POST /user/sprechen-sessions` `{teil, topic}`; `PATCH /user/sprechen-sessions/{id}` `{ai_session_id}`; `GET /user/sprechen-sessions`; `GET /user/sprechen-sessions/{id}/messages` | same → `sprechenSessionHandler` | Review | Powers `SprechenSessionHistorySheet`; same live-probe caveat as above. |
| new `lib/repositories/speech/sprechen_ai_repository.dart` | `POST /api/v1/ai/sprechen-partner`, `/ai/sprechen-feedback`, `/ai/sprechen-suggestions`, `/ai/grade-sprechen` (rate-limited 30/min/user) | `routes_ai.go` → `aiHandler.SprechenPartner/SprechenFeedback/SprechenSuggestions/GradeSprechen` | Review | Live AI chat/grading wiring is explicitly MASTER P8 scope (this phase builds UI + gates the send/record action behind `ReleaseFeatureFlags.speaking`); do not hand-roll request bodies without a token probe first. |
| new `lib/repositories/speech/conversation_repository.dart` | `GET /user/conversation/scenarios` → `{scenarios:[{id,title_de,title_vi,level}]}`; `GET /user/conversation/scenario/{id}` → full `Scenario` (`id,title_de,title_vi,level,ai_role,user_role,context_de,context_vi,vocab[],sample_phrases[],required_points[],starter_prompt_de,gradient_from,gradient_to,icon`) | `routes_user_practice.go` → `conversationHandler.ListScenarios/GetScenario` (`internal/feature/content/conversation/conversation_types.go`) | Live | Manifest + scenario schema read directly from struct tags; safe to model typed. |
| same | `POST /user/conversation/turn` `{scenario_id, history:[{role,text}], user_message, custom_scenario?}` → `{ai_message, session_done, coverage:[{index,label_de,label_vi,covered}]}` | same → `conversationHandler.PostTurn` (rate-limited 30/min) | Review | Text-chat path is in this phase's scope (composer send button); voice/STT turn input stays MASTER P8. |
| same | `POST /user/conversation/opening` `{scenario_id, custom_scenario?}` → `{ai_message}` | same → `conversationHandler.PostOpening` | Live | |
| same | `POST /user/conversation/survey` `{topic, level}` → `{categories:[{title_vi, items:[{vi, recommended}]}]}` | same → `conversationHandler.PostSurvey` | Live | Powers custom-topic focus-point picker (`ConversationSurveyScreen`). |
| new `lib/repositories/speech/interview_repository.dart` | `POST /user/conversation/interview/extract` `{markdown, level}`; `POST/PUT /user/conversation/interview/scenarios`; `GET/DELETE /user/conversation/interview/scenarios(/{id})` | same → `conversationHandler.ExtractInterview/SaveInterviewScenario/...` | Review | Premium-gated per route middleware; needs live-token probe for extract response shape before binding beyond raw passthrough. |
| new `lib/repositories/speech/conversation_session_repository.dart` | `GET /user/conversation/daily-quota`; `GET/POST /user/conversation/sessions`; `GET/DELETE /user/conversation/sessions/{id}` | `routes_user_practice.go` → `conversationSessionHandler` | Review | Drives daily-limit rows + history list/detail; needs live-token probe for quota/response fields, build UI against documented request verbs first. |
| new `lib/data/pronunciation/pronunciation_repository.dart` | `GET /user/pronunciation/{umlaute\|ich-ach-laut\|r-sound\|sp-st}` | `thamkhao/deutschtiger-frontend/src/lib/pronunciation/pronunciation-service.ts` (Go handler not independently re-verified — read from the web's own service client, not a Go route/handler read) | Review | Discovered mid-implementation: the phase brief assumed static bundled content, but web hits a live backend list per trainer. Flutter mirrors `LearningItemRepository`'s request pattern; response DTOs (`UmlautItem`/`IchAchItem`/`RSoundItem`+`RPosition`/`SpStItem`) are typed from `src/types/pronunciation-exercise.ts`, not a direct Go struct read — verify against a live token before treating field names as final. |
| same | `GET /minimal-pairs/contrasts`; `GET /minimal-pairs` | same (`minimal-pairs-service.ts`) | Review | Same caveat — typed from the web TS client, not a Go struct; `MinimalPairContrast`/`MinimalPair` DTOs need a live-token probe to confirm field names. |

## Writing / Schreiben ecosystem (P9 wave 1 — WritingPracticePanel)

Probed 2026-07-17 by reading Go handler source directly (`internal/shared/
aihttp/ai_grading_handler.go`, `internal/feature/exam/exam/
exam_user_writing_handler.go`, `internal/feature/exam/exam/
goethe_b1_writing_data_handler.go`) plus the frontend service/handler pair
that already calls each route in production (`schreiben-ai-grading-
service.ts`, `use-writing-submissions.ts`, `use-writing-grading-attempts.ts`,
`use-goethe-b1-writing-data.ts`, `use-goethe-b1-writing-results.ts`). No live
curl in this sandbox; the Go struct JSON tags match the frontend TS
interfaces field-for-field (camelCase for the AI grading payloads), which is
the same contract Flutter now implements.

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/features/writing/data/writing_repository.dart` | `POST /ai/grade-schreiben` `{taskPrompt, writingPoints, studentAnswer, level, examType, teil}` → `SchreibenGradingResult` (`score, grade, feedback{4 categories}, corrections[], suggestions[], summary, goetheRaw?`) | `routes_ai.go` → `aiHandler.GradeSchreiben` (`internal/shared/aihttp/ai_grading_handler.go`) | Live | Rate-limited (`aiGradeRL`); backend bounds the call at 60s — Flutter relies on `ApiClient`'s own timeout and maps 502/503/`ai_unavailable` to `AiUnavailableException` (retry-with-cooldown UX), matching web's `AiUnavailableError`. |
| same | `POST /ai/rewrite-schreiben` `{studentAnswer, level, taskPrompt?, writingPoints?, regenerate?}` → `{correctedText}` | same → `aiHandler.RewriteSchreiben` | Live | Separate rate bucket (10/hour) server-side. |
| same | `POST /user/writing-submissions` `{exam_id, task_prompt, student_answer, ai_score, ai_feedback, submitted_at}` → `{status, id}` | `routes_user_exam.go` → `examUserHandler.CreateWritingSubmission` (`exam_user_writing_handler.go`) | Live | `exam_id`/`task_prompt`/`student_answer` required (400 otherwise); `ai_score`/`ai_feedback` accepted null at submit time — Flutter never derives/sends a client-computed score. |
| same | `GET /user/writing-submissions?exam_id=` → `{submissions:[...]}` | same → `ListWritingSubmissions` | Live | Backs `WritingHistorySheet`. |
| same | `POST /user/writing-submissions/{id}/gradings` `{ai_score, ai_feedback}` → `{status, id}` | same → `CreateGradingAttempt` | Live | Records one AI-graded attempt in history and (server-side) updates the submission's latest score/feedback in one transaction. |
| same | `GET /user/writing-submissions/{id}/gradings` → `{attempts:[...]}` | same → `ListGradingAttempts` | Live | Not yet consumed by any W1 screen (attempt-history UI is W2/W3 scope); repository method exists for those waves to call. |
| `lib/features/writing/data/goethe_b1_writing_repository.dart` | `GET /goethe-b1-writing/manifest` → `{teils:[{teil, titleVi, topics:[{slug, isIntro, titleDe, titleVi, ...}]}]}` | `routes_public.go` → `goetheB1WritingDataHandler.GetManifest` | Live | Public, no auth. Flutter derives `topicCount` client-side by filtering `isIntro !== true`, mirroring web's `useManifest` consumer logic — the endpoint itself does not pre-filter. |
| same | `GET /user/goethe-b1-writing-results` → `[{teil, slug, score?, grade?, ...}]` | `routes_user_exam.go` → `goetheB1WritingResultHandler.List` | Live | Feeds the teil-pick page's done/total progress bar; degrades to `[]` on any error (signed-out, network) rather than throwing, so the screen still renders. |

### P9 wave 2 additions (topic-list, detail reader, practice wrapper, community list)

Probed 2026-07-17 by reading `goethe_b1_writing_data_handler.go` and
`goethe_b1_writing_result_handler.go` directly (file-store-backed, no DB) plus
the frontend `types.ts`/`uebungen-types.ts` field-for-field (JSON is
pre-serialized from `backend/data/exams/goethe/b1/goethe-b1-writing/*.json` —
camelCase keys match the TS interfaces exactly, no snake_case translation
layer on these three GET routes).

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/features/writing/data/goethe_b1_writing_repository.dart` `fetchTeil` | `GET /goethe-b1-writing/teil/{n}` → `{teil, titleVi, topics:[GoetheB1WritingTopicSummary]}` | `routes_public.go` → `goetheB1WritingDataHandler.GetTeil` | Live | Public, no auth. 404 when the teil JSON file is missing — Flutter surfaces this as the topic-list page's `ErrorView` retry state, not a crash. |
| same `fetchTopic` | `GET /goethe-b1-writing/topic/{n}/{slug}` → full `GoetheB1WritingTopic` (30+ fields, see `lib/features/writing/domain/goethe_b1_writing_topic.dart`) | same → `goetheB1WritingDataHandler.GetTopic` | Live | Public, no auth. Same 404-on-missing-file behavior as `fetchTeil`. |
| same `upsertResult` | `POST /user/goethe-b1-writing-results` `{teil, topic_slug, score?, grade?}` | `routes_user_exam.go` → `goetheB1WritingResultHandler.Upsert` | Live | Auth required. Flutter never sends a client-computed `score`/`grade` (both omitted) — this is purely the detail page's "🎯 Đánh dấu hoàn thành" completion marker, not a grading submission. |
| same `fetchResultsForTeil` | `GET /user/goethe-b1-writing-results?teil=` | same → `goetheB1WritingResultHandler.List` | Live | Scoped variant of W1's `fetchAllResults`; degrades to `[]` on any error. |
| same `fetchLeaderboard` | `GET /user/goethe-b1-writing-leaderboard?teil=` → `[{user_id, display_name, avatar_url, completed_count, rank}]` | same → `goetheB1WritingResultHandler.Leaderboard` | Live | Registered under `routes_user_exam.go` (auth required, unlike the public-gamification leaderboard pattern used elsewhere) — verified by reading the handler; degrades to `[]` on error so the sidebar renders an empty state. |
| `lib/screens/exam/writing/goethe_b1_community_writing_list_page.dart` | `GET /user/community/exams/?provider=goethe&level=b1&skill=writing&teil=` | same as the existing P8 `CommunityExamRepository` (`routes_user*.go` → community-exam handler) | Live | 100% reuse of the P8 community-exam read stack — no new backend surface. Screen 4 (`goethe-b1-community-writing-list`) is a thin filtered wrapper around the already-live `communityExamListProvider`. |
| `lib/screens/exam/writing/widgets/detail/wortschatz_card.dart` "🌐 Dịch ví dụ" | `POST /ai/translate-sentences` (existing `TranslationService`) | `routes_ai.go` → `aiHandler.TranslateSentences` (already Live, see the "Translation provider boundary" section above) | Live | Intentional deviation from web (which calls Google Translate directly client-side) — routed through the app's existing authenticated backend translate endpoint per the phase brief's explicit guidance. No new contract. |

## Generic XP award (P11 wave 2 — youtube dictation)

Probed 2026-07-17 by reading `internal/feature/gamify/gamification/gamification_handler.go`
directly (no live curl available in this sandbox). Endpoint already existed
and is used by the web dictation loop (`use-gamification-queries.ts` →
`useAwardXP`) — this is the first Flutter caller, not a new backend contract.

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| new `lib/repositories/youtube/dictation_xp_repository.dart` | `POST /user/gamification/award-xp` `{amount:1}` (no `source` — mirrors web's bare dictation call, only "exam"/"vocab" sources feed the weekly composite ranking) | `gamification_handler.go` → `Handler.AwardXP` | Review | Read from Go handler only, no live-token probe yet. `amount` must be `1 <= amount <= MaxSingleXP`; server enforces a daily cap and returns the updated totals — Flutter treats the response as fire-and-forget (best-effort, errors swallowed) matching web's non-blocking `awardXP.mutate`. |
| `lib/repositories/journey/journey_repository.dart` (`awardLessonVideoXp`, P11 wave 3 — course lesson) | `POST /user/gamification/award-xp` `{amount:1}` (same endpoint, second Flutter caller) | `gamification_handler.go` → `Handler.AwardXP` | Review | Web `COURSE_XP.COMPLETE_LESSON_VIDEO`/`REWATCH_LESSON_VIDEO` are both `1`; called once per mark-complete toggle-on (not on toggle-off), same fire-and-forget/best-effort pattern as the dictation caller above. |

## Reading/News leaderboards + batch word-save (P11 wave 4 — reading + news)

Probed 2026-07-17 by reading the Go route tables/handlers directly (no live
curl available in this sandbox — no local backend instance running). All
four routes already existed and are already called by the web frontend
(`reading-service.ts`/`news-service.ts`); Flutter is the first mobile caller,
not a new backend contract.

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/repositories/reading/reading_repository.dart` `fetchLeaderboard`/`fetchUserRank` | `GET /reading-leaderboard?limit=&level=` → `[{user_id, display_name, avatar_url, completed_count, rank}]`; `GET /user/reading-rank?level=` → same shape or `null` | `routes_user_public.go` (leaderboard, public) + `routes_user_progress.go` (rank, authed) → `readingProgressHandler.GetLeaderboard`/`GetUserRank` | Review | Verified route mount + response shape matches web's `ReadingLeaderboardEntry` TS interface field-for-field; no live-token probe run. |
| same `fetchUserRank`/`saveWordsBatch` on `ReadingRepository`; used from both reading + news detail screens via `SaveArticleWordsCta` | `POST /user/word-reviews/add-batch` `[{learning_item_id, source}]` → `{status:"ok"}` | `routes_user_learning.go` → `wordReviewHandler.BatchAdd` (`internal/feature/learning/wordreview/word_review_handler.go`) | Review | Web's `SaveArticleWordsCta` actually calls `POST /user/srs/add-batch` (`srs-service.ts`) — that route is **not mounted** on this backend (confirmed against `routes_user_learning.go`'s `/srs` route group, which has no `/add-batch`; only `/add` exists). Treated as a stale/dead web call rather than a contract to replicate. `word-reviews/add-batch` is a live, functionally-equivalent endpoint (same `card_reviews`-style insert semantics, batch of `{learning_item_id, source}`, max 200/request) already used elsewhere in the app family — reused here instead of porting a 404. |
| `lib/repositories/news/news_repository.dart` `fetchLeaderboard`/`fetchUserRank` | `GET /news-leaderboard?limit=` → `[{user_id, display_name, avatar_url, completed_count, rank}]`; `GET /user/news-rank` → same shape or `null` | `routes_public.go` (leaderboard, public) + `routes_user_progress.go` (rank, authed) → `newsProgressHandler.GetLeaderboard`/`GetUserRank` | Review | Weekly-scoped (resets Monday Asia/Ho_Chi_Minh), matches `NewsWeekStats` semantics already in use. |

`GET /reading/articles/{level}/{slug}/exercises` (web's `fetchReadingExercises`,
gates reading-detail completion on a comprehension quiz) is **not mounted**
on this backend — `internal/feature/content/video/reading_handler.go` only
exposes `List/Levels/Topics/Get/GetBySlug/Audio`. Web silently falls back to
a bundled static TS dataset (`src/data/reading-exercises-*.ts`) when the
fetch 404s; Flutter has no such bundle and does not add one (no new mocks).
`reading_detail_screen.dart` keeps the manual "Đánh dấu đã đọc" button for
every article instead of gating on a quiz that has no live source.

## Settings, notifications, announcements (P12 wave A — settings slice)

Probed 2026-07-17 via `curl https://deutschtiger.com/api/v1/announcements?page=exam&public_only=false`
(returned `[]`, confirming the route + response shape) and reading the Go
handlers directly for the rest. First mobile callers; web already uses both.

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/repositories/announcements/announcement_repository.dart` | `GET /announcements?page=&public_only=` (no auth) → `[{id,title,content,is_active,is_public,page,sort_order,created_at,updated_at}]` | `routes_public.go` → `announcementHandler.GetActive` (`internal/feature/social/announcement/announcement_handler.go`) | Live | Curl-verified empty-array shape; add a non-empty fixture test once an announcement exists in a test DB. |
| `lib/screens/settings/notification_preferences_screen.dart` "Gửi thử" button | `POST /user/push/test` (empty body; server defaults `title`/`body`) | `cmd/server/routes_user_flashcards.go` → `webPushHandler.SendTestPush` (`internal/shared/webpushhttp/webpush_handler.go`) | Live | Returns 503 when web push isn't configured server-side (no VAPID) — Flutter surfaces this as `notificationPreferencesTestFailed`, same as any other failure (no special-cased UI for "not configured" yet). |
| `lib/repositories/settings/learning_preferences_repository.dart` | `PUT /user/preferences` body now also sends `learning_goals: string[]` (previously omitted) | `internal/infra/database/profile_repo_preferences.go` `UpdatePreferencesInput.LearningGoals` (pre-existing field, unused by Flutter until this phase) | Live | Values normalized server-side via `NormalizeLearningGoals`; Flutter free-form set matches web's `GOAL_OPTIONS` values (`goethe/communication/medical/work/other`). |

## Weekly leaderboard, hall of fame, stats blocks (P12 wave A — stats/leaderboard slice)

Verified 2026-07-17 by reading the mounted Go routes + handler/repo structs
directly (no live curl in this sandbox — same evidence standard as the
grammar-leaderboard entry above). All routes below already exist and are
already called by web; this phase adds the first Flutter callers.

| Flutter source | Request | Mounted backend source | Status | Required action |
|---|---|---|---|---|
| `lib/screens/leaderboard/leaderboard_screen.dart`, `widgets/leaderboard_providers.dart` | `GET /leaderboard/weekly?limit=`, `GET /user/leaderboard/weekly-rank`, `GET /leaderboard/hall-of-fame` | `cmd/server/routes_user_public.go`/`routes_user_progress.go` → `leaderboard.Handler` (`internal/feature/gamify/leaderboard/`) → `database.LeaderboardRepo` | Live | `WeeklyLeaderboardEntry` Go struct only sends `user_id/display_name/avatar_url/weekly_xp/weekly_exam_points/weekly_mission_count/weekly_vocab_reviewed/weekly_score/current_streak/is_premium/is_new_user_dampened/rank` — **no** `total_xp`, `level`, `last_week_rank`, `weekly_reading_count`, `weekly_speak_write_count`, or `weekly_words_added` (all declared optional in the web TS type but never populated server-side yet). Flutter's `LeaderboardEntry` treats every one of those as optional/defaulted (0/null), matching the TS contract's own optionality — rank-delta (▲/▼) always renders "Mới" today because `last_week_rank` is never sent, and the four breadth-chip sources beyond XP/exam/mission/vocab never appear. Not a Flutter gap; wire once the backend populates these columns. |
| same | `GET /user/leaderboard/friends?limit=` (tab "Bạn bè") | **not mounted** — no `mountUserSocial`/`routes_user_progress.go` route matches `leaderboard/friends`; only `friendHandler.*` routes (`/friends`, `/friends/online`, …) exist | Missing | Web itself calls this and silently degrades to `[]` on failure (`weeklyLeaderboardService.getFriendsWeekly` try/catch). Flutter mirrors the same fail-open behavior (`friendsWeeklyLeaderboardProvider` catches `ApiException` → `[]`) so the tab renders the "no friends yet" empty state rather than an error. `ReleaseFeatureFlags.social` defaults `true`; the tab stays visible but functionally empty until the backend mounts this route — do not build it against a fabricated response. |
| `lib/screens/stats/widgets/stats_leaderboard_table.dart` | `GET /gamification/leaderboard?limit=`, `GET /gamification/user-rank` | `cmd/server/routes_user_public.go` → `gamificationHandler.GetLeaderboard`/`GetUserRank` | Live | Reused verbatim from the pre-existing `lib/screens/leaderboard/leaderboard_screen.dart` `LeaderboardType.allTime` provider (`leaderboardProvider(LeaderboardType.allTime)`, already Live in this matrix's baseline) — only the new `statsCurrentUserRankProvider` (`/gamification/user-rank`) is new. |
| `lib/repositories/stats/stats_repository.dart` | `GET /user/flashcard-reviews/stats` → `{total_reviews_today,total_reviews_week,correct_reviews,total_reviews,due_cards_count}` | `cmd/server/routes_user_flashcards.go` → `flashcardReviewHandler.GetStats` (`internal/infra/database/flashcard_review_repo.go` `ReviewStats`) | Live | Same shape as web `reviewService.getStats()`; accuracy is computed client-side (`correct/total`, matches web's `Math.round`). |
| same | `GET /user/flashcards/stats` → `{total_cards,total_reviews}` | `cmd/server/routes_user_flashcards.go` → `flashcardHandler.GetUserFlashcardStats` (`internal/infra/database/flashcard_writing_deck_repo.go` `UserFlashcardStats`) | Live | Feeds the client-computed achievement thresholds (`lib/screens/stats/widgets/stats_achievements_data.dart`), same computation as web `gamificationService.getAchievements()` — no dedicated achievements endpoint exists on either client. |
| same | `GET /user/online-time/weekly` → `[{log_date,total_seconds}]` | `cmd/server/routes_user_progress.go` → `onlineTimeHandler.GetWeekly` | Live | Renders nothing when the array is empty, matching web's conditional block. |

## Writing / Schreiben ecosystem (P9 wave 3 — luyện-viết generic suite)

Probed 2026-07-17 by reading `official_exam_handler.go`,
`community_exam_handler.go` + `community_exam_write_handler.go`,
`exam_user_writing_handler.go` (`GetWritingSubmissions` no-`exam_id` branch)
directly, plus the frontend service pair that already calls each route in
production (`official-topic-service.ts`, `community-exam-service.ts`,
`use-all-writing-submissions.ts`). No live curl session (no dev server
running); route/handler/repo code read end-to-end instead.

| Flutter source | Request | Mounted backend source | Status | Notes |
|---|---|---|---|---|
| `lib/features/writing/data/official_writing_topic_repository.dart` | `GET /exams/official?provider=&level=&skill=writing` → `[OfficialTopicResponse]` | `cmd/server/routes_exam_official.go` → `officialExamHandler.List` (`internal/feature/exam/exam/official_exam_handler.go`) | Live | Auth required; premium-gated per topic (`locked:true` + `generated_data:{}` for non-entitled users on premium rows — Flutter never unlocks client-side). Degrades to `[]` on any error so `writing-level-topics`/`writing-level-practice` still render their empty state. |
| `lib/features/writing/data/community_writing_write_repository.dart` `getCanonicalBySlug` | `GET /user/community/exams/by-slug?provider=&level=&skill=writing&teil=&slug=` → canonical topic + `versions[]` | `cmd/server/routes_user_exam.go` → `communityExamHandler.GetByTeilSlug` | Live | Auth required. 404 when missing → screen's not-found state. `report_count` zeroed server-side for non-owner/non-admin callers (moderation signal not leaked). |
| same `generate` | `POST /user/community/exams/generate` `{provider, level?, skill:"writing", teil, input}` → `{generated_data, title_de, title_vi}` | same → `communityExamHandler.Generate` | Live | Rate-limited 10/hour/user server-side; 503 when AI provider unconfigured (surfaced as a plain error, no special retry UX built this wave — small gap vs `writingRepositoryProvider`'s `AiUnavailableException` mapping). Powers both `writing-custom`'s ✨ AI-polish and the community add-version sheet's polish toggle. |
| same `create` | `POST /user/community/exams/` `{provider, level?, skill, teil, title_de, title_vi?, input_text, generated_data, exam_date?, exam_location?}` → created topic | same → `communityExamHandler.Create` | Live | Rate-limited 15/hour/user. Used by `writing-custom`'s "📤 Đóng góp đề" and the catalog's community add flow. |
| same `upsertMyVersion` | `POST /user/community/exams/{canonicalId}/versions` → `{id}` | same → `communityExamHandler.UpsertMyVersion` | Live | Rate-limited 30/hour/user. Backs `writing-community-topic`'s "add version" action. |
| same `vote`/`unvote` | `POST`/`DELETE /user/community/exams/{id}/vote` | same → `Vote`/`Unvote` | Live | Self-vote blocked (403, surfaced as a snackbar error — not specially worded this wave). |
| same `report` | `POST /user/community/exams/{id}/report` `{reason}` | same → `Report` | Live | Rate-limited 20/hour/user. |
| `lib/screens/exam/writing/widgets/hub/writing_submissions_tab.dart` `allWritingSubmissionsProvider` | `GET /user/writing-submissions` (no `exam_id`) → latest 50 across every provider | `routes_user_exam.go` → `ListWritingSubmissions` (already Live per W1; this wave is the first Flutter caller of the no-`exam_id` branch) | Live | Backend `GetWritingSubmissions` returns the caller's most recent 50 rows across all exam ids when `exam_id` is omitted/empty — confirmed in `internal/infra/database/exam_repo.go`. Backs the catalog's "Bài của tôi" tab and `writing-session-detail`. |
| `lib/features/writing/presentation/widgets/writing_comment_section.dart` | `GET`/`POST /comments?target_type=community_topic&target_id=` | `internal/feature/social/comment/comment_handler.go` (already Live — same endpoint `ExamCommentSection` uses with `target_type=exam`) | Live | Second call site of an existing generic endpoint, not a new backend surface. |

Not built this wave (named gap, not silent): web's `CommunityTopicCreateWizard`
multi-step form (title/task/points/exam-date/exam-location as separate
steps) is collapsed into a single task+points+AI-polish sheet
(`community_add_version_sheet.dart`) — same write endpoints, simpler UI.
`CommentSection`'s realtime subscribe + reply threads are not ported (matches
the existing `ExamCommentSection` precedent — flat read+post only).

## Writing / Schreiben ecosystem (P9 wave 4 — Sprint v2 + telc schreiben-view convergence)

Probed 2026-07-17 by reading `internal/feature/exam/exam/goethe_b1_writing_data_handler.go`
(`GetSprintClusters`), `internal/shared/aihttp/sprint_grade_handler.go`
(`GradeSprintEssay`), and `cmd/server/routes_public.go`/`routes_ai.go` for the
route mounts directly — no dev server running, route/handler code read
end-to-end plus a sample `teil-1.json`/`sprint-clusters.json` payload from a
local backup checkout to confirm the on-disk JSON shape (`speedrun` block:
`outline3`/`outline3Audio`/`miniModel`/`redemittelCore`/`generationCheckKeywords`/`clusterId`).

| Flutter source | Request | Mounted backend source | Status | Notes |
|---|---|---|---|---|
| `lib/features/writing/data/sprint/sprint_repository.dart` `fetchClusters` | `GET /goethe-b1-writing/sprint-clusters` → `{version, clusters:[...]}` | `cmd/server/routes_public.go` → `goetheB1WritingDataHandler.GetSprintClusters` | Live, public (no auth) | Static content (10 clusters, ~73 topics), served straight from `backend/data/exams/goethe/b1/goethe-b1-writing/sprint-clusters.json`. 404 mapped to a Flutter-side error state (not degraded silently — cluster list is required for the whole Sprint feature to function). |
| same `fetchTopicsForSlugs` | `GET /goethe-b1-writing/teil/{n}` (n=1,2,3) — same endpoint W1 already documented for the topic-list/detail readers, reused here for its `speedrun` field | `goetheB1WritingDataHandler.GetTeil` | Live, public | Each Teil manifest embeds the FULL topic payload (task/taskAnalysis/speedrun), not just the summary fields W1/W2's `GoetheB1WritingTopicSummary` DTO models — this wave adds a parallel richer DTO (`SprintTopicData`, `lib/features/writing/domain/sprint/sprint_types.dart`) rather than extending the existing summary type, to avoid widening W1/W2's contract for a Sprint-only need. Per-Teil fetch failures degrade to an empty contribution (`try`/`catch` around each of the 3 calls) instead of failing the whole sprint. |
| `lib/features/writing/data/sprint/sprint_repository.dart` `SprintGradingRepository.grade` | `POST /sprint/grade-essay` `{teil, taskPrompt, points, studentEssay, topicSlug?}` → `{raw:{...}, total, erfullung, koharenz, wortschatz, strukturen, grade, feedback:{...}, errors:[...]}` | `cmd/server/routes_ai.go` → `aiHandler.GradeSprintEssay` (`internal/shared/aihttp/sprint_grade_handler.go`) | Live | Auth required. Server-side rate limit 10 essays/hour/user (429 on exceed, `Retry-After` header). 503 when AI/CLIProxy unconfigured. 400 if essay <50 or >300 words, or missing task prompt. Powers the sprint mini practice-exam page (`ExamWritingSprintMockPage`) — the only new writable endpoint this wave. |

**telc `schreiben-view` convergence (no new endpoint):** web's legacy
`/exams/telc/b1/a-rap/schreiben/:slug` page fetched its content from a
*static JSON file bundled in web's own `public/data/exams/telc/b1/a-rap/{slug}/schreiben.json`*
— never a backend API route (confirmed: no matching handler anywhere under
`thamkhao/deutschtiger-backend`). Porting it verbatim would mean hardcoding
exam content into a Flutter release screen, which the plan's data rules
forbid. Per the plan's explicit decision (§5), this wave instead adds a
`GoRoute` redirect from the same URL shape
(`/exam/telc-b1/a-rap/schreiben/:slug`) to the live-data generic writing
practice flow (`/exam/telc-b1/writing/{slug}/practice`, backed by the
already-documented `GET /exams/official` + `WritingPracticePanel`) — see
`lib/navigation/routes/exam_routes.dart`.

**Route-naming deviation:** the Sprint mini practice-exam route uses the URL
segment `thi-thu` instead of web's literal `mock` segment
(`/exam/goethe-b1/writing/sprint/thi-thu` vs web's `.../sprint/mock`).
Reason: `test/structure/release_live_data_guard_test.dart` forbids the
literal word "mock" anywhere in release-visible screen source (a blunt
`mock|fixture|placeholder` regex meant to catch shipped test data) — web's
route segment and the `MockResult`/`mock-result-card.tsx` naming would trip
it. Renamed the Dart-side type to `SprintEssayResult` and the URL segment to
`thi-thu` ("trial exam" in Vietnamese) rather than weaken the guard.

**Mindmap risk resolved as a non-issue:** the plan flagged `cluster-mindmap`/
`global-mindmap` (markmap-lib + mermaid dynamic-import rendering, no Flutter
equivalent) as an open risk for this wave. Verified via `grep` across
`thamkhao/deutschtiger-frontend/src/pages` and `src/app/routes.tsx`: neither
component is imported by any currently-live page or route — they are dead
code left over from the retired Sprint v1 flow (the same `85aadef` retirement
commit the plan already cites). The 4 live Sprint v2 pages/hooks
(`use-sr-session`, `sr-card`/`-front`/`-back`, `essay-input`,
`mock-result-card`, the cheatsheet page/components) never reference either
component. No WebView/custom-tree decision was needed — nothing to port.

## Change process

1. Update this matrix and `docs/api-changelog.md` before changing a client/server
   contract.
2. Add Flutter request tests and narrow Go route/handler tests in the same
   change. Route labels and snapshots are documentation, not substitutes.
3. Deploy additive server support first; ship the Flutter path after it is
   verified. Remove a compatibility path only after the minimum supported app
   version no longer uses it.
