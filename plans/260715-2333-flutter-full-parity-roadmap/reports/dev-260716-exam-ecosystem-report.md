# Exam Ecosystem Completion — Implementation Report

Date: 2026-07-16 · Phase: `phase-03-exam-ecosystem-completion.md` (PARITY P3)

## Scope shipped

Live (real backend contracts, no fake data):

- **Exam readiness** (`/exam/readiness`): `GET /exam-readiness` — band + per-skill
  accuracy + weakness details, read-only.
- **Exam schedule + registration + buddy finder** (`/exam/schedule`): tabs
  "Danh sách bạn ôn thi" (public `GET /exam-buddies`, read-only) + "Thông tin
  của tôi" (CRUD `GET/POST/PUT/DELETE /user/exam-registrations`) — mirrors the
  web's combined "Tìm bạn ôn thi" page design (1 screen, not 2).
- **Community exams — READ-ONLY** (`/exam/community`, `/exam/community/:id`):
  `GET /user/community/exams/` (list) + `/{id}` (detail). No comment/vote/
  report/generate/versions wiring — write path deferred to GĐ2 P3 (UGC
  moderation).
- **Exam dictation** (`/exam/dictation`, `/exam/dictation/:provider/:level/:slug`):
  public `GET /api/v1/exams/{telc/b1|goethe/{level}}/{slug}/word-transcript`.
  Reuses `ExamAudioPlayer` from the exam player core unmodified. Grading is
  client-side string compare (no dictation-grading endpoint exists on
  backend — confirmed by grep, not assumed).
- **De-thi public registry** (`/de-thi`, `/de-thi/:code`): public,
  unauthenticated deep-link (mirrors web `de-thi-registry.ts`). Static Dart
  registry + JSON fetch from `WEBVIEW_BASE_URL/data/de-thi/*.json` (no
  `/api/v1`, no auth) — same pattern as `PodcastRepository`.

## Known gaps (documented, not silently dropped)

1. `GET /user/exam-buddies/{id}/contact` — reveals another user's phone/
   email/Facebook. NOT wired. Buddy finder ships read-only until report/block
   for user-user UGC interaction lands (GĐ2 P3), per phase risk note.
2. Community exam comment/vote/report/generate/versions (write path) — NOT
   wired, same UGC-moderation reasoning.
3. Reminder wiring — `lib/screens/reminders/reminder_settings_screen.dart` is
   a generic daily local-notification toggle with no per-event/calendar hook;
   there is no clean integration point to attach a specific exam date. Skipped
   per phase instruction ("nếu pattern rõ, không thì bỏ + ghi note").

## Files

Created:
- `lib/data/exam/exam_ecosystem_models.dart` — plain Dart DTOs (no freezed —
  read-mostly, avoids build_runner contention with 3 parallel agents also
  running codegen).
- `lib/repositories/exam/{exam_readiness,exam_registration,community_exam,exam_dictation,de_thi}_repository.dart`
- `lib/view_models/exam/exam_ecosystem_providers.dart`
- `lib/screens/exam/{exam_readiness_screen,exam_schedule_screen,community_exams_list_screen,community_exam_detail_screen,exam_dictation_picker_screen,exam_dictation_screen,de_thi_list_screen,de_thi_practice_screen}.dart`
- Tests: `test/repositories/exam/exam_ecosystem_repositories_test.dart` (10
  contract tests), `test/screens/exam/{exam_readiness_screen_test,community_exams_list_screen_test,exam_dictation_screen_test}.dart`
  (happy/empty/error + a real overflow bug caught and fixed in
  `exam_dictation_screen.dart`'s `_BlankField`).

Modified (narrow edits, contended files):
- `lib/navigation/app_router.dart` — new routes under `/exam/*` (parentNavigatorKey
  root, full-screen) + top-level public `/de-thi`, `/de-thi/:code`.
- `lib/navigation/auth_redirect.dart` — new `alwaysVisibleRoutePrefixes` set
  so `/de-thi/*` renders regardless of auth state (unlike `publicAuthRoutes`,
  which bounces a logged-in user to `/home`).
- `lib/screens/exam/exam_screen.dart` — added `_EcosystemLinksBar` (action
  chips to readiness/schedule/community/dictation) above the existing
  `ExamCatalogList` — did not touch the catalog widget itself (exam player
  core reuse only, per constraint).
- `test/navigation/auth_redirect_test.dart` — 3 new tests for the de-thi
  always-visible prefix.
- `test/structure/release_live_data_guard_test.dart` — added the new
  screens/repos/providers to `_releaseVisibleRouteSources` (all verified
  mock/fixture/placeholder-marker-free).
- `docs/flutter-live-data-inventory.md` — 5 new route-family rows.
- `docs/api-changelog.md` — 1 new changelog row (phase 3).
- `lib/l10n/app_{vi,en,de}.arb` + regenerated `app_localizations*.dart` via
  `flutter gen-l10n` — ~34 new keys for the 5 new screens.

## Tests status

- `flutter analyze` scoped to all touched/created files: clean (2
  pre-existing-pattern `deprecated_member_use` infos on `RadioListTile`,
  matching an already-established codebase pattern in
  `lib/shared/widgets/report_content_button.dart`).
- Whole-repo `flutter analyze`: 33 pre-existing errors in
  `lib/features/journey/data/course_provider.dart` — NOT touched by this
  phase, appears to be another agent's in-progress work (journey domain is
  explicitly out of scope per task brief).
- `flutter test` scoped to exam ecosystem: 10 repository contract tests + 9
  widget tests (readiness ×3, community list ×3, dictation ×3) + 3 navigation
  tests — all pass.
- `test/structure/release_live_data_guard_test.dart` (shared/contended file):
  re-ran after another agent concurrently added `youtube/`/`video_library/`
  entries to the same list. My additions are clean (verified via grep before
  adding). The suite currently fails on `lib/screens/youtube/youtube_watch_screen.dart`
  containing the word "placeholder" — that file belongs to another agent's
  in-progress domain (not touched by this phase); not fixed here to avoid
  clobbering concurrent work.
- Full-repo `flutter test` (ran once, per instruction): 385 tests, 383 pass,
  2 fail — both failures in `test/screens/ai/ai_chat_page_test.dart`
  ("quota-exceeded banner" test timed out after 10 min, cascading into a
  second failure in the same file). Not related to this phase: no exam
  import in that file, and it's a different agent's AI-chat domain.
  `test/widget_test.dart` showed as failed only in the full run because the
  AI test's 10-min timeout ate the run budget — confirmed independently
  green when run in isolation. Every test file this phase owns
  (`test/repositories/exam/**`, `test/screens/exam/**`,
  `test/navigation/auth_redirect_test.dart`) passes both standalone and
  within the full run.

## Design decisions worth flagging

- **Buddy finder + schedule = 1 screen**, matching the web's actual design
  (`exam-schedule-page.tsx` IS the "Tìm bạn ôn thi" page with 2 tabs) — not 2
  separate screens as the phase title implies.
- **Dictation grading is client-side** — verified by grep across the backend
  exam feature package; only a raw transcript endpoint exists, no
  grading/scoring endpoint for dictation.
- **No freezed for new DTOs** — YAGNI (read-mostly data, no copyWith/union
  needed) and avoids build_runner races with 3 concurrent agents.

## Unresolved questions

None — all ambiguities (dictation grading location, de-thi backend vs static
registry, buddy contact reveal scope) were resolved by reading the actual
backend/frontend source before writing code, per the "don't guess schema"
constraint.

Status: DONE
Summary: Shipped exam readiness, schedule+registration+buddy-finder (read-only),
community exams (read-only), dictation (client-graded), and the de-thi public
registry, wired into the router with focused contract + widget tests all green.
Concerns/Blockers: buddy contact reveal and community write-path intentionally
deferred to GĐ2 P3 (UGC moderation dependency); reminders wiring skipped (no
clean integration point in the existing generic reminder toggle).
