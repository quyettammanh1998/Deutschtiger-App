# Learn Extensions — Implementation Report

Scope: 4 Learn extension screens (Can-Do practice, Topic explore, Focus
session, Learner model) per phase-02 partial. Practice modes/sentence
builder/subtitle words explicitly excluded (other agent's scope, confirmed
already landed concurrently in `lib/screens/practice/**` and
`lib/screens/vocab/subtitle_words_screen.dart`).

## Files

Created:
- `lib/data/learn/learn_models.dart` — plain Dart DTOs (no freezed/build_runner
  — avoids regenerating shared generated files while 3 other agents work in
  parallel). Covers `CapabilityMap`/`CanDo`, `WeeklyRecap`, `FocusSessionData`,
  `LearnerModel`, `LearnPreferences`, `GradeSentenceResult`.
- `lib/repositories/learn/learn_repository.dart` — `LearnRepository` (+
  `TargetBlockInput`).
- `lib/view_models/learn/learn_provider.dart` — `learnRepositoryProvider` +
  5 `FutureProvider.autoDispose`.
- `lib/screens/learn/{focus_session,learner_model,can_do_practice,topic_explore}_screen.dart`
- `lib/screens/learn/widgets/{mastery_ring,can_do_card}.dart`
- `test/repositories/learn_contract_test.dart` (5 tests)
- `test/screens/learn/{focus_session,learner_model,can_do_practice,topic_explore}_screen_test.dart`
  (12 tests: happy/empty/error per screen)

Modified:
- `lib/navigation/app_router.dart` — added `/learner-model`, `/focus-session`
  top-level routes; `/learn/topics`, `/learn/can-do/:canDoId/practice` nested
  under `/learn` (root-navigator, fullscreen).
- `lib/screens/journey/journey_screen.dart` — added `_LearnExtensionsSection`
  entry-point tiles (learner model / topic explore / focus session) below the
  today-session banner.
- `lib/l10n/app_{vi,en,de}.arb` + generated `app_localizations*.dart` —
  ~60 new keys per locale (focusSession*, learnerModel*, canDoStatus*,
  canDoPractice*, topicExplore*, `back`). Narrow appends after each agent's
  own last key; no collisions.
- `test/structure/release_live_data_guard_test.dart` — added the 4 new screens
  + repo/provider files to the release-visible mock/fixture guard list.
- `docs/flutter-live-data-inventory.md`, `docs/api-changelog.md` — documented
  live contracts + scope deviations (see below).

## Endpoints used (probed via `route-snapshot-devauth.txt` + Go handlers)

- `GET /user/learn/capability-map?goal=` — can-do map (can-do practice +
  learner model can-do section).
- `GET /user/learner-model?weak_limit=` — mastery/coverage/weak words.
- `GET /focus-session?due=&fails=&subs=` — focus session (read-only
  aggregation dashboard, matches actual web behavior).
- `GET/PUT /user/preferences` (sparse `priority_topics`) — topic pin.
- `POST /ai/grade-sentence` — can-do practice sentence grading. Route is
  mounted on backend; called directly from `LearnRepository` rather than
  through `AIRepository` (still mock, being converted to live by another
  agent in parallel) — avoids touching AI domain files per constraint.
- Topic catalog reuses already-live `vocabularyTopicsProvider` /
  `topicLevelCountsProvider` (features/vocabulary) instead of a new fetch.

## Scope deviations from spec (documented in api-changelog.md)

1. Focus session is a **read-only action dashboard** (`GET /focus-session`),
   not a start/stop timer — verified against actual web
   `focus-session-page.tsx`; task brief's "start/stop log" description did
   not match the real spec.
2. Simplified focus-session empty state to one "caught up" message instead
   of web's 3-way branch (new-user-no-history vs caught-up vs loading), to
   avoid an extra `flashcards/stats` fetch — KISS.
3. Learner model page omits web's separate weekly-recap card and detailed
   readiness top-actions routing; core mastery/coverage/weak-words/can-do
   data all present. No parity-pixel requirement per task brief.
4. `/daily-review` route doesn't accept a `retry=<id>` query param (unlike
   web) — weak-word row navigates to the generic review queue instead of
   claiming per-word retry.

## Tests

- Type check / analyze: `flutter analyze` — 0 errors (8 pre-existing
  info/warnings in other agents' files, unrelated).
- `flutter test` (full suite, once): **365 passed**, 0 failed.
- New: 5 contract tests (`learn_contract_test.dart`) + 12 widget tests
  (4 screens × happy/empty/error) — all green.

## Status

Status: DONE
Summary: 4 learn-extension screens live on real backend contracts, entry
points wired into the `/learn` hub, contract + widget tests green, full repo
test suite green (365/365).
Concerns: None blocking. `/ai/grade-sentence` call bypasses the (still-mock)
AIRepository by design — flagged in api-changelog for whoever converts AI
domain to live, in case they want to consolidate later.
