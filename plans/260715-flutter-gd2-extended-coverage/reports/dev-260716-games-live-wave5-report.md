# Games live wave 5 — Artikel, Wortstellung, Fill-blank (dev report)

Date: 2026-07-16. Scope: all 3 assigned games done (no voice needed). Games
sweep (waves 1-5) is now complete — 16/17 games live, `matching` is next
candidate, `speaking`/`pronunciation`/`conversation` explicitly blocked by
voice infra (documented, not a to-do miss).

## Content-source finding (resolves wave 3's open question)

Both web `ArtikelGamePage` and `WortstellungPage` (`src/pages/game/`) source
content from the **same corpus endpoint**, not game-specific ones:
`GET /user/learning-items/balanced?user_level=&type=&limit=`
(`internal/feature/learning/learning/learning_handler.go#GetBalanced`,
already live on web via `fetchBalancedLearningItems`). Fill-blank has **no
standalone web page at all** — cloze-fill only exists as a mini-game inside
the vocabulary-lesson flow (`FillBlankMiniGame`/`ClozeMode`,
`src/components/vocabulary/mini-games/fill-blank-mini-game.tsx`), reading the
same corpus's `examples`/`cloze` fields.

`POST /user/grammar-drill/results` (reused in wave 3 for Cases/Konjugation)
does **not** apply here — confirmed via
`internal/feature/learning/grammar/grammar_drill_handler.go`'s
`validGrammarGames` whitelist (`akk-dat`/`konjugation`/`adjektiv`/
`wechselprep`/`verb-case` only). No results/progress-write path exists for
these 3 games — same gap as every other game today (no XP-award sync
anywhere yet).

## New shared infrastructure

- `lib/data/games/learning_item_models.dart` — plain-Dart `LearningItem`
  (subset: id/type/content_de/content_vi/category/level/gender/examples —
  not the full backend shape, YAGNI) + `LearningItemExample`. No
  freezed/json_serializable (build_runner race avoidance, same convention as
  `cases_models.dart`).
- `lib/repositories/games/learning_item_repository.dart` —
  `LearningItemRepository.fetchBalanced({userLevel, type, limit})` →
  `GET /user/learning-items/balanced`.
- `lib/view_models/games/learning_item_provider.dart` —
  `learningItemRepositoryProvider`.

## Der/Die/Das (`lib/screens/games/article_game_screen.dart`, rewritten)

`type=word`, filters nouns with valid `gender` (m/f/n → der/die/das), builds
a 30-question session (10×3 rounds, mirrors web `ArtikelQuiz`'s
`TOTAL_WORDS`, repeats via modulo if pool is smaller). Strips a leading
article from `content_de` before display (data can store "der Hund"). Kept
the existing timer/streak/combo/bounce-animation UI — only the word source
changed to live data + added a level picker (default A1, dropdown A1-C2).
Min 10 valid nouns gate; loading/error views via shared
`LoadingView`/`ErrorView`.

## Wortstellung (`lib/screens/games/word_order_game_screen.dart`, rewritten)

`type=sentence`, filters by word-count range per CEFR level (3-7 words
A1/A2, 5-12 B1+, mirrors web `wordCountRange`), capped at 15 sentences/
session (web `SESSION_SIZE`). Kept the existing tap-to-arrange UI/timer.
Min 3 sentences gate.

## Điền từ (`lib/screens/games/fill_blank_game_screen.dart`, rewritten)

Ports web's `ClozeMode` logic (no direct backend endpoint since web itself
has no standalone page): `type=word` items, derives a cloze prompt per item
from `examples` (mirrors `deriveClozeFromExamples` — prefers a pre-built
`example.cloze`, else finds an example sentence containing the target word
and blanks it out with a word-boundary regex). Builds 3 distractors from the
same fetched pool (mirrors `buildClozeDistractors` — same-category words
first, falls back to a short list of real German pad words
[`machen`/`gehen`/`kaufen`/... same list web uses] only when the pool is
thin — never fabricated content). Items with no matching example are
skipped entirely (no synthetic cloze). Min 6 buildable questions gate,
session capped at 10.

## Gating (same per-game-flag pattern as prior waves)

- `lib/core/release/release_feature_flags.dart` — new `articleGame`,
  `wordOrderGame`, `fillBlankGame` flags, all default `true`.
- `lib/navigation/release_redirect.dart` — exemptions for `/games/article`,
  `/games/word-order`, `/games/fill-blank` from the blanket `games` gate.
- `lib/data/games/game_models.dart` — `wordOrder`/`fillBlank` `gd1Available`
  flipped `false`→`true` (article was already `true`); source comments
  added to all 3 entries.
- `lib/navigation/app_router.dart` — no changes needed, routes/paths were
  already registered pointing at these 3 screen files.

## Gaps (documented, not silently dropped)

1. No XP-award/mission-queue/FSRS-write sync — consistent with all games
   today (web's Artikel/Wortstellung post XP + auto-rate via
   `sessionCooldownService`/`batchAutoRate`; not ported).
2. Fill-blank has no per-word hint/explain buttons (web `HintButton`/
   `ExplainButton` inside the lesson mini-game).
3. Level picker is manual (default A1), no CEFR-profile lookup — same
   simplification as Sentence Builder/Cases.
4. `matching` is now the only remaining fixture-only vocabulary game
   (next candidate, same `VocabularyRepository` pattern as Word Sprint).

## Docs updated (contended shared files)

- `docs/flutter-live-data-inventory.md` — 3 new "Live" rows; the
  fixture-only games row narrowed from 7 to 4 remaining games (matching +
  3 voice-blocked).
- `docs/api-changelog.md` — new 2026-07-16 dated entry (GĐ 4) documenting
  the shared endpoint, the 3-game rewrite, and the grammar-drill
  non-applicability finding.
- ARB files: no changes — these screens use hardcoded Vietnamese strings
  (same convention as every other game screen, none use
  `AppLocalizations`).

## Tests (all green, my scope — 21 new tests + 2 modified suites)

```
flutter test test/repositories/games/learning_item_repository_contract_test.dart \
  test/screens/games/article_game_screen_test.dart \
  test/screens/games/word_order_game_screen_test.dart \
  test/screens/games/fill_blank_game_screen_test.dart \
  test/navigation/release_redirect_test.dart \
  test/structure/release_live_data_guard_test.dart
# all pass
```

- Contract test: GET query params (`user_level`/`type`/`limit`, `type`
  omitted case), response parsing (gender, nested `examples`).
- Widget tests per screen: happy path (renders live data), error view +
  retry, min-items gate message, and one answer-interaction case — each
  asserts `tester.takeException()` is null.
- Fixed a `find.textContaining` gotcha in the fill-blank test: standalone
  `RichText` (not `Text.rich`) needs `findRichText: true` to match.
- Fixed a pending-`Timer` teardown warning in the article "select correct
  article" test by pumping past the 800ms post-answer delay before the test
  ends.
- Added 6 new files to `release_live_data_guard_test.dart`'s allowlist
  (verified none contain `mock*/fixture*/placeholder*` markers first).
- Added a `release_redirect_test.dart` case exempting the 3 new routes.

`flutter analyze` (full repo): 0 errors, 5 pre-existing `info`-level items
(deprecated `RadioGroup` API, `prefer_initializing_formals` in unrelated test
files) — same baseline as prior waves, unrelated to this change.

`flutter test` (full repo, ~550 tests): exit code 0, "All tests passed!" —
the wave-3-flagged `flashcard_game_screen.dart`/`ReviewRating` compile error
is gone (fixed by whichever agent owned that file since then).

## Per-game status (final for this games sweep)

| Game | Status |
|---|---|
| Sentence Builder, Word Sprint, Typing Sprint | Live (prior waves) |
| Flashcard, Writing Word, Writing Sentence, Listening, Runner | Live (wave 4) |
| Cases Mastery, Konjugation | Live (wave 3) |
| **Artikel, Wortstellung, Fill-blank** | **Live (this pass)** |
| Matching | Mock, `gd1Available: true` — next candidate |
| Speaking, Pronunciation, Conversation | Mock — blocked-by-voice (MASTER P8) |

## Unresolved questions

1. Same standing question from prior waves: should the now-16-live-domain
   game set get a Learn-hub/More-sheet nav entry, or wait until `matching`
   converts too?
2. XP-award/mission-queue/FSRS-rating sync for games — still no shared
   hook, worth adding centrally now that 16/17 games are live rather than
   per-game.

Status: DONE
Summary: Artikel/Wortstellung/Fill-blank chuyển sang `GET
/user/learning-items/balanced` (nguồn corpus có sẵn từ web, mới với
Flutter) — hoàn tất games sweep, chỉ còn `matching` + 3 game voice.
Concerns/Blockers: none.
