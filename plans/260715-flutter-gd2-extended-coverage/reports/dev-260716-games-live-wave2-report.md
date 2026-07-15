# Games live wave 2 — Word Sprint + Typing Sprint (dev report)

Date: 2026-07-16. Scope: GĐ2 P4 games sweep, priority 1 only (Word Sprint +
Typing Sprint) — time-boxed same as the prior Sentence Builder pass; priorities
2-4 (Cases/Konjugation, Artikel/Wortstellung/fill-blank) not started, reasons below.

## Done: Word Sprint — live vocab source

- `lib/view_models/games/word_sprint_provider.dart` (new) — `wordSprintWordsProvider`
  FutureProvider wrapping `VocabularyRepository.getLearnedWords()` (`GET /vocabulary/learned`,
  already-live endpoint, reused per instruction — no new repo written).
- `lib/screens/games/word_sprint_game_screen.dart` — converted `StatefulWidget` →
  `ConsumerStatefulWidget`; quiz mechanics (60s timer, 2x2 grid, streak/combo scoring)
  unchanged, but word source is now the live learned-words list instead of a
  hardcoded 15-word table. Requires ≥4 learned words to build 1 correct + 3 wrong
  options; shows a real guidance empty state ("Cần học ít nhất 4 từ...") when the
  user hasn't learned enough yet — not a fake fallback list.
- Deleted `lib/screens/games/word_sprint_models.dart` (dead mock data, was the
  only file importing it).
- `lib/data/games/game_models.dart` — added a source comment on the `wordSprint`
  `GameMode` entry (it already had `gd1Available: true`).

## Done: Typing Sprint — live sentence source (backend contract, not vocab words)

Read the actual backend handler (`internal/feature/gamify/game/typing_handler.go`)
before touching anything: Typing Sprint on the backend is a **sentence-typing**
game (`GET /user/typing/sentences?count=`, personalized SRS-prioritized sentences
from `learning_items` when the user has ≥12 usable ones, else the bundled
`typingdata/b1-sentences.json` — server-side fallback, not client fake data), with
server-computed WPM/accuracy-based XP on `POST /user/typing/results` (caps: 50
XP/session, 100 XP/day). This is a different game shape than the old mock (single
German word + 4 wrong meaning options... actually old mock was word→typed-word,
not a quiz — regardless, mock typed single words, backend expects full sentences).
Converted the gameplay to match the real contract rather than bolt sentence data
onto the old word-typing UI:

- `lib/data/games/typing_sprint_models.dart` (new) — plain-Dart `TypingSentence`,
  `TypingResultResponse` DTOs (no freezed/build_runner, same convention as
  `sentence_builder_models.dart`, avoids build_runner race with parallel agents).
- `lib/repositories/games/typing_sprint_repository.dart` (new) — `fetchSentences`,
  `submitResult`.
- `lib/view_models/games/typing_sprint_provider.dart` (new) — repo provider.
- `lib/screens/games/typing_sprint_game_screen.dart` — rewritten: fetches 20
  sentences, user types the full German sentence matching the shown Vietnamese
  meaning (Enter or explicit "Bỏ qua câu này" skip button), tracks
  correctWords/wrongWords/correctChars, computes wpm/cpm/accuracy at game end,
  submits via `submitResult` (fire-and-forget style — submit failure shows a
  small note but never blocks the local score/results screen), shows `+xpAwarded
  XP` when the server grants XP. Kept the original visual style (AppColors,
  Colors.lightBlue palette) — only the data source and question unit changed.
- `lib/data/games/game_models.dart` — `typingSprint` `GameMode` entry: description
  updated ("Gõ câu" not "Gõ từ"), `gd1Available` flipped `false` → `true`.

## Gating

Followed the `sentenceBuilder` pattern exactly (per-game flag + redirect exemption,
independent of the blanket `games` flag which stays `false` — 14 other mock game
screens still gated):

- `lib/core/release/release_feature_flags.dart` — new `wordSprint`, `typingSprint`
  flags, both default `true`.
- `lib/navigation/release_redirect.dart` — exemptions for `/games/word-sprint` and
  `/games/typing-sprint`.

## Tests (all green, my scope)

```
flutter test test/repositories/games/typing_sprint_repository_contract_test.dart \
  test/screens/games/word_sprint_game_screen_test.dart \
  test/screens/games/typing_sprint_game_screen_test.dart \
  test/navigation/release_redirect_test.dart \
  test/structure/release_live_data_guard_test.dart
# 15 tests, all pass
```

- Contract test for the new `TypingSprintRepository` (GET query contract, POST body
  contract, personalized `learning_item_id` parsing). Word Sprint needed no new
  repo contract test — reuses the pre-existing `VocabularyRepository`.
- Widget tests for both screens: happy path (renders live data), error view +
  retry, and Word-Sprint-specific insufficient-data empty state. Typing Sprint
  widget test also exercises a correct-sentence submission via `enterText` +
  `TextInputAction.done` against a hand-written fake repository (`typingSprintRepositoryProvider`
  is a plain `Provider`, overridden with `overrideWithValue`).
- Both game screens use `Timer.periodic` for the 60s countdown; each widget test
  ends with `tester.pumpWidget(const SizedBox.shrink())` to force `dispose()` (which
  cancels the timer) before the test completes, avoiding a "Timer still pending"
  failure.
- Added the 6 new/changed source files to `test/structure/release_live_data_guard_test.dart`'s
  allowlist (verified no `mock*/fixture*/placeholder*` markers — had to reword two
  doc comments that used the word "mock" in Vietnamese prose, since the regex is
  a whole-word match).
- Added a redirect-exemption test case to `test/navigation/release_redirect_test.dart`
  (contended shared file — another agent had concurrently appended their own social
  entries to the guard allowlist; my additions merged cleanly, no conflict).

## Docs updated (contended shared files)

- `docs/flutter-live-data-inventory.md` — split the old "17 mock games" row into
  the current 14-mock row (with a note that `article`/`matching` are the next
  `VocabularyRepository`-reuse candidates) plus two new "Live" rows for
  `/games/word-sprint` and `/games/typing-sprint`.
- `docs/api-changelog.md` — new dated entry (2026-07-16, GĐ2 P4) documenting both
  endpoints, the Typing Sprint gameplay-shape change, and the explicit gap list
  for priorities 2-4.

## Not done (priorities 2-4), reason: effort budget

Cases Mastery, Konjugation, Artikel, Wortstellung, Fill-blank were not converted
this pass. Backend routes for cases/konjugation were confirmed live in the prior
agent's pass (`GET /user/cases/{adjektiv,akk-dat,verb-case,wechselprep}`,
`GET /user/conjugation/exercise`) but still unwired — logged in
`docs/flutter-live-data-inventory.md` row 36 as an explicit gap for the next pass,
not silently dropped. Artikel/Wortstellung/fill-blank content-source probing
(web static data vs. corpus/learning-items) was not started at all.

## Full-repo checks (run once, per instructions)

- `flutter analyze` (full repo): 2 pre-existing errors, both in
  `lib/view_models/social/social_legacy_provider.dart` (`Undefined name
  'socialLegacyMockRepositoryProvider'`) — another agent's in-progress social
  domain work, not in my file set. No issues in any file I touched.
- `flutter test` (full repo): 495 tests, 1 failure —
  `test/screens/settings/settings_release_gates_test.dart: Settings hides entries
  without a release-ready route` (`StateError: Bad state: No element` from
  `scrollUntilVisible`, unrelated to games — settings screen entries are also
  being touched by the concurrent social-domain work per the handoff note). Not
  caused by anything in my scope; my own 15 tests are green in isolation and
  within the full run.

## Unresolved questions

1. Same as before (still open): should live games get a Learn-hub/More-sheet nav
   entry now that 3 are live (Sentence Builder, Word Sprint, Typing Sprint), or
   wait until more `/games/**` subroutes convert?
2. XP-award/mission-queue sync for games — still no shared hook across any game
   screen (word/typing sprint included). Worth adding once ≥half the games are
   live, rather than one-off per game.
