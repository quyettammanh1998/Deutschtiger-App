# Games sweep — Sentence Builder (dev report)

Date: 2026-07-16. Scope: GĐ2 P4 games sweep, priority 1 (Sentence Builder) only —
time-boxed to "làm đến đâu chắc đến đó", không ép xong cả 18 game.

## Done: Sentence Builder (topics → session → play → complete), live end-to-end

New files:
- `lib/data/games/sentence_builder_models.dart` — plain-Dart DTOs (Topic, SessionWord, Session, Result), no freezed/build_runner.
- `lib/repositories/games/sentence_builder_repository.dart` — `fetchTopics`, `createSession`, `completeSession`.
- `lib/view_models/games/sentence_builder_provider.dart` — Riverpod repo + topics-by-level family provider.
- `lib/screens/games/sentence_builder/sentence_builder_topics_screen.dart` — level chips + topic list (wordCount/essentialWordCount = preview, no separate preview screen) + "chủ đề ngẫu nhiên".
- `lib/screens/games/sentence_builder/sentence_builder_play_screen.dart` — creates session, grades each sentence, shows results.

Modified (narrow edits, all verified working):
- `lib/navigation/app_router.dart` — routes `/games/sentence-builder`, `/games/sentence-builder/play`.
- `lib/core/release/release_feature_flags.dart` — new `sentenceBuilder` flag, default `true`.
- `lib/navigation/release_redirect.dart` — exempts `/games/sentence-builder` from the blanket `games` gate.
- `lib/data/games/game_models.dart` — added `GameMode` entry for `GameType.sentenceBuilder`, `gd1Available: true`.
- `lib/screens/games/game_hub_screen.dart` — nav case + writing-category filter for sentence builder; removed the now-unreachable `default:` in `_navigateToGame` (all 17 `GameType` cases covered, was an analyzer warning).
- `docs/flutter-live-data-inventory.md`, `docs/api-changelog.md` — status + gaps.
- `test/structure/release_live_data_guard_test.dart` — added the 4 new sentence-builder files to the release-visible allowlist (no mock/fixture markers found).
- `test/navigation/release_redirect_test.dart` — added exemption case.

Backend contract used (all verified in `thamkhao/deutschtiger-backend`):
`GET /sentence-builder/topics?level=`, `POST /sentence-builder/session`,
`POST /sentence-builder/session/{id}/complete` (`internal/feature/gamify/game/sentence_builder_*_handler.go`).
Grading reuses the already-live `LearnRepository.gradeSentence` (`POST /ai/grade-sentence`,
`target_blocks: []`) — read-only import from `learn` domain, did NOT modify `lib/repositories/learn/**`
or `lib/view_models/learn/**` (off-limits domain).

### Gaps (documented, not silently dropped)
1. `GET/PATCH /sentence-builder/preferences` not wired — session uses in-session level/topic pick, no persisted prefs.
2. No XP-award / mission-action-queue sync after completion (web has `useAwardXP`/`missionActionQueue`) — consistent with all 17 other game screens (none sync XP today), not a regression, but a real gap if gamification parity is wanted.
3. No `wordReviewService`/FSRS rating sync post-grading (web has it for daily review) — no Flutter equivalent exists for the games surface.
4. No dedicated word-preview screen — topic list's `wordCount`/`essentialWordCount` doubles as preview (KISS).
5. Not linked from Learn hub / More-sheet nav — only reachable via direct route or Game Hub (hub itself still sits behind the blanket `games` flag, default `false`).

## Flag/gating decision

`ReleaseFeatureFlags.games` stays `false` by default (17 mock game screens: article,
word-sprint, matching, fill-blank, listening, flashcard, runner, typing-sprint,
writing-word, word-order, writing-sentence, speaking, cases, konjugation,
pronunciation, conversation — content still bundled/generated). Per the "only flip
default-on once every exposed subroute is live" rule, the blanket flag was **not**
flipped. Instead added an independent `sentenceBuilder` flag (default `true`) and a
route-specific exemption in `release_redirect.dart`, following the existing
per-flag pattern in that file (same style as `pronunciation`/`speaking`/`journey`
individual gates) — Sentence Builder is reachable in release builds today while the
rest of `/games/**` still redirects to `/learn`.

## Not done (priorities 2–4), reason: effort budget

Word sprint/typing sprint (live vocab source), Cases/Konjugation/Artikel/Wortstellung
trainers (`GET /user/cases/*`, `GET /user/conjugation/exercise` — routes confirmed
live, handlers read in `internal/feature/learning/{cases,conjugation}`), and the
remaining local-logic games were not converted this pass. Per-game status table is
in `docs/flutter-live-data-inventory.md` (`/games/**` row) so the next pass can pick
up without re-discovery. `docs/api-changelog.md` 2026-07-16 sentence-builder entry
also documents this so the "cases/konjugation still mock" gap is explicit, not lost.

## Per-game status (summary table)

| Game | Status | Reason |
|---|---|---|
| Sentence Builder | **Live** | `/sentence-builder/*` + reused `/ai/grade-sentence`; gated by its own `sentenceBuilder` flag (default true) |
| Article, Word Sprint, Matching | Mock, `gd1Available: true` in hub | Pre-existing GĐ1 confirmed games; unchanged this pass |
| Cases Mastery, Konjugation | Mock | Backend `GET /user/cases/*`, `GET /user/conjugation/exercise` confirmed live but not wired — next-pass gap |
| Fill-blank, Listening(game), Flashcard(game), Runner, Typing Sprint, Writing Word, Word Order, Writing Sentence, Speaking, Pronunciation, Conversation | Mock | Not touched; still behind blanket `games` flag (default false) |

## Tests (all green, my scope)

```
flutter test test/repositories/games/sentence_builder_repository_contract_test.dart \
  test/screens/games/sentence_builder_topics_screen_test.dart \
  test/screens/games/sentence_builder_play_screen_test.dart \
  test/navigation/release_redirect_test.dart \
  test/structure/release_live_data_guard_test.dart
# 20 tests, all pass
```

`flutter analyze` on touched files: no issues.

Full-repo `flutter analyze` + `flutter test` (run once, per instructions): pre-existing
failures found, none in my file set —
- `flutter analyze`: ~65 errors in `lib/screens/social/**`, `lib/view_models/social/social_provider.dart`
  (missing `lib/data/social/social_models.dart`, `lib/repositories/social/social_repository.dart`) — another
  agent's in-progress social domain work, mid-edit at time of this run.
- `flutter test`: 7–8 failing (`ai_chat_page_test.dart`, `settings_release_gates_test.dart`,
  `leaderboard_scope_test.dart`, `structure/view_models_layer_test.dart` re: missing social provider file)
  — same cause, unrelated to games/sentence-builder. Flaky count across two runs (7 vs 8) because
  other agents were actively editing files concurrently.

## Unresolved questions

1. Should Sentence Builder get a Learn-hub/More-sheet nav entry now, or wait until
   more `/games/**` subroutes go live (avoids a single-item "Games" menu section)?
2. XP-award/mission-queue/FSRS-rating sync for games — worth adding a shared
   games-completion hook now, or defer until more games go live (would touch all
   converted screens uniformly rather than one-off per game)?
