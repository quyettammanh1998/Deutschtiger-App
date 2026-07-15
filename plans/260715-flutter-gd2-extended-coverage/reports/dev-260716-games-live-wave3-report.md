# Games live wave 3 — Cases trainers + Konjugation (dev report)

Date: 2026-07-16. Scope per task order: priority 1 (Cases trainers) done fully,
priority 2 (Konjugation) done fully. Priority 3 (Artikel/Wortstellung/fill-blank)
not started — reason: effort budget after 1+2, and content-source probing
(web static data vs corpus/learning-items) needs its own investigation pass.
Priority 4 (remaining games) untouched, per-game table updated only.

## Done: Cases Mastery Hub — 4 sub-games, all live

Backend contract read from `internal/feature/learning/cases/cases_handler.go`
(`cases_types.go`) — confirmed personalized (Leitner-weighted, mastery summary)
when authenticated, static shuffle otherwise:
`GET /user/cases/{akk-dat,adjektiv,wechselprep,verb-case}?level=&limit=`.
Progress submit shared with Konjugation: `POST /user/grammar-drill/results`
(`internal/feature/learning/grammar/grammar_drill_handler.go`).

Deleted the old single mock `lib/screens/games/cases_mastery_game_screen.dart`
(8 hardcoded Nominativ/Genitiv/Dativ/Akkusativ questions — wrong shape, backend
is actually 4 separate sub-games) and replaced with `lib/screens/games/cases/`:
- `cases_mastery_hub_screen.dart` — hub, 4 cards, mirrors web
  `cases-mastery-hub-page.tsx`.
- `case_cloze_quiz_screen.dart` — one screen for 3 cloze games (`game` param:
  `akk-dat`/`adjektiv`/`wechselprep`), mirrors `case-cloze-quiz.tsx`. Level
  picker (A1-C2, default A2), 10-question session, sentence-with-blank display,
  reason/vi shown after answering, mastery summary on results screen.
- `verb_case_quiz_screen.dart` — verb → Akkusativ/Dativ/Genitiv, mirrors
  `verb-case-matcher.tsx`.

New data/repo/provider files:
- `lib/data/games/cases_models.dart` — `CaseExercise`, `CaseMastery`,
  `CaseExercisesResponse`, `VerbCaseItem`, `VerbCaseResponse` (plain Dart, no
  freezed — avoids build_runner race with parallel agents). Go/JSON field
  `case` renamed to Dart `caseType` (`case` is a keyword).
- `lib/repositories/games/cases_repository.dart` — `fetchAkkDat`,
  `fetchAdjektiv`, `fetchWechselprep`, `fetchVerbCase`.
- `lib/repositories/games/grammar_drill_repository.dart` — `submitResults`,
  shared by Cases and Konjugation (`GrammarDrillResultInput{key,correct,
  learningItemId}`).
- `lib/view_models/games/cases_provider.dart` — `casesRepositoryProvider`,
  `grammarDrillRepositoryProvider`.

## Done: Konjugationstrainer — live text-input trainer

Backend read from `internal/feature/learning/conjugation/conjugation_handler.go`:
`GET /user/conjugation/exercise?type=&level=&limit=`. Personalizes from the
user's own learned verbs when available (returns `learning_item_id` per
exercise); results submitted with that ID so the backend additionally writes
an FSRS review (`writeVerbSRSReviews`).

Rewrote `lib/screens/games/konjugation_game_screen.dart` in place (same
file/route) — old mock was an 8-question multiple-choice quiz; new version is
a live text-input trainer (type the conjugated form, case-insensitive +
alternatives match), mirrors web `ConjugationInputCard`.

New: `lib/data/games/conjugation_models.dart` (`ConjugationExercise`),
`lib/repositories/games/conjugation_repository.dart` (`fetchExercises`),
`lib/view_models/games/conjugation_provider.dart`
(`conjugationRepositoryProvider`).

## Gating (same per-game-flag pattern as sentenceBuilder/wordSprint/typingSprint)

- `lib/core/release/release_feature_flags.dart` — new `casesMastery`,
  `konjugation` flags, both default `true`.
- `lib/navigation/release_redirect.dart` — exemptions for `/games/cases` and
  `/games/konjugation` from the blanket `games` gate.
- `lib/data/games/game_models.dart` — `GameType.cases`/`GameType.conjugation`
  `gd1Available` flipped `false` → `true`, source comments added.
- `lib/navigation/app_router.dart` — `/games/cases` now builds the hub;
  4 new sub-routes `/games/cases/{akk-dat,adjektiv,wechselprep,verb-case}`;
  `/games/konjugation` unchanged (route/file kept, content rewritten).

## Gaps (documented, not silently dropped)

1. No XP-award/mission-queue sync (consistent with all games today, not a
   regression specific to this pass).
2. No AI-deep-dive explain panel on wrong answers (web has
   `GrammarExplainPanel`, calls a separate AI endpoint) — KISS, main quiz flow
   unaffected.
3. No pre-start intro/paywall screen (web has `GrammarDrillIntro` +
   `useGamePlays`) — mobile has no equivalent play-limit system yet.
4. Cases level picker defaults to `A2` (backend default), no CEFR-profile
   lookup — same simplification as Sentence Builder's manual level chips.
5. Artikel/Wortstellung/Fill-blank content-source probing not started —
   logged as gap in `docs/flutter-live-data-inventory.md`.

## Docs updated (contended shared files, merged cleanly with concurrent agents)

- `docs/flutter-live-data-inventory.md` — 2 new "Live" rows (Cases Mastery Hub,
  Konjugation), fixture-only games row count updated 14→12 with the removed
  entries.
- `docs/api-changelog.md` — new 2026-07-16 dated entry documenting both
  endpoints, the old-mock→hub migration, and the explicit gap list.
- ARB files: no changes — game screens use hardcoded Vietnamese strings
  directly (same convention as all other game screens; none use
  `AppLocalizations`), so no new l10n keys were needed.

## Tests (all green, my scope — 26 tests)

```
flutter test test/repositories/games/cases_repository_contract_test.dart \
  test/repositories/games/conjugation_repository_contract_test.dart \
  test/repositories/games/grammar_drill_repository_contract_test.dart \
  test/screens/games/case_cloze_quiz_screen_test.dart \
  test/screens/games/verb_case_quiz_screen_test.dart \
  test/screens/games/konjugation_game_screen_test.dart \
  test/navigation/release_redirect_test.dart \
  test/structure/release_live_data_guard_test.dart
# 26 tests, all pass
```

- Contract tests: GET query params (level/limit), response parsing (mastery
  block, `case`→`caseType` rename, `learning_item_id` presence/absence), POST
  body shape for `grammar-drill/results` (including the empty-results no-op
  short-circuit).
- Widget tests: happy path (renders live data), error view + retry, and one
  answer-interaction test per screen type (cloze picks an option, verb-case
  picks a case, konjugation types + submits) — each asserts the
  correct/incorrect feedback text and `tester.takeException()` is null.
- Added 11 new files to `test/structure/release_live_data_guard_test.dart`'s
  allowlist — verified none contain `mock*/fixture*/placeholder*` markers
  before adding.
- Added a `release_redirect_test.dart` case exempting `/games/cases/**` and
  `/games/konjugation`.

`flutter analyze` on touched files: no issues.

## Full-repo checks (run once, per instructions)

- `flutter analyze` (full repo): 3 pre-existing errors in
  `lib/screens/games/flashcard_game_screen.dart` (`Undefined class/name
  'ReviewRating'`) — another agent's concurrent edit to
  `lib/data/flashcard/review_item.dart` (git status shows both files modified,
  not by me). Not in my file set. 5 pre-existing `info`-level items elsewhere
  (deprecated `RadioGroup` API, `prefer_initializing_formals` in unrelated
  test files) — unrelated to games.
- `flutter test` (full repo, ~515 tests): exactly 1 failure —
  `test/widget_test.dart` fails to *load* (compile error) because it
  transitively imports `flashcard_game_screen.dart`, which has the
  `ReviewRating` error above. Confirmed root cause by running
  `flutter test test/widget_test.dart` standalone — same compile error, zero
  relation to cases/conjugation. My own 8 test files (26 assertions) pass both
  standalone and inside the full run.
- Concurrent shared-file edits observed mid-session (another agent expanding
  `game_models.dart`/`release_feature_flags.dart`/`release_redirect.dart` with
  flashcard/writing-word/writing-sentence/listening/runner live flags) merged
  cleanly with my cases/konjugation additions — no overwritten content,
  verified by re-reading the files after the concurrent edits landed.

## Per-game status (updated)

| Game | Status | Notes |
|---|---|---|
| Sentence Builder, Word Sprint, Typing Sprint | Live | Prior waves |
| Flashcard, Writing Word, Writing Sentence, Listening, Runner | Live | Concurrent agent, this session (not mine — see `docs/flutter-live-data-inventory.md`) |
| **Cases Mastery (akk-dat/adjektiv/wechselprep/verb-case)** | **Live** | This pass — hub + 4 sub-screens, `DEUTSCHTIGER_ENABLE_CASES_MASTERY` |
| **Konjugation** | **Live** | This pass — rewrote in place, `DEUTSCHTIGER_ENABLE_KONJUGATION` |
| Article, Matching | Mock, `gd1Available: true` | Pre-existing GĐ1 games; next `VocabularyRepository`-reuse candidates |
| Fill-blank, Word Order, Speaking, Pronunciation, Conversation | Mock | Not touched; behind blanket `games` flag (default false) |

## Unresolved questions

1. Same open question as prior waves: should the now-6-live-domain set of
   games (sentence builder, word/typing sprint, cases, konjugation, + whatever
   the concurrent agent shipped) get a Learn-hub/More-sheet nav entry, or wait
   until `article`/`matching`/remaining mocks convert too?
2. XP-award/mission-queue/FSRS-rating sync for games — still no shared hook.
   Worth adding now that ~10 of 17 games are live, rather than per-game.
3. `flashcard_game_screen.dart` compile error (another agent's in-progress
   `ReviewRating` refactor) currently breaks `flutter test test/widget_test.dart`
   for the whole repo — flagging for whoever owns that file to fix before merge;
   not blocking this report since it's outside my file ownership.
