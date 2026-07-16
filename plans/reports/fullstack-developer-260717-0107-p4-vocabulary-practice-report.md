# Phase 4 — Vocabulary & practice: implementation report

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-04-vocabulary-practice.md`
Scope executed: **the 4 practice-view round types + shared primitives + routing/deletion bookkeeping** (the piece that blocks P3/P5). Full vocabulary/my-words/daily-review/subtitle-words screen rebuilds are **NOT** done this pass — see Deferred section.

## Delivered

### 1. Shared primitives (P1 gap — hoisted here as instructed)

- `lib/widgets/common/umlaut_input_bar.dart` — `UmlautInputBar({onInsert, visible, chars})`. Web parity `special-char-bar.tsx`. Static helper `UmlautInputBar.insertAtCursor(controller, char)` for cursor-safe insertion. No focus-stealing hack needed (plain `GestureDetector` never requests focus in Flutter).
- `lib/widgets/common/answer_diff_view.dart` — `computeAnswerDiff(user, correct) → List<DiffSegment>` (word-level LCS, mirrors web `answer-diff.ts`) + `AnswerDiffView` chip renderer (green/amber/red). Char-level diff (web's `computeCharDiff`) was **not** ported — word-level covers the sentence/word round types used here; add if P9 needs letter-pinpointing.
- Both are reusable by P9 (exam writing) per the plan note.

### 2. Round-type contract (the "clean reusable API")

`lib/data/practice/practice_round_item.dart` — `PracticeRoundItem {id, word, translation, example, exampleTranslation, audioUrl}`, with factories `.fromDeckWord(DeckWord)` and `.fromLearningItem(LearningItem)`. This is the shared input type for all 4 practice views — source-agnostic, so any caller with a `List<PracticeRoundItem>` + `onComplete(List<PracticeResultEntry>)` callback can drive a round. `PracticeResultEntry` (existing model, `lib/data/practice/practice_result.dart`) is unchanged as the output type.

### 3. The 4 practice views (`lib/screens/practice/widgets/`) — public API

All four share the exact same constructor shape:
```dart
Widget(items: List<PracticeRoundItem>, onComplete: void Function(List<PracticeResultEntry>))
```
- **`PracticeClozeView`** (`/games/cloze`) — inline underlined blank via `Wrap` (not `WidgetSpan`/`PlaceholderAlignment` — that identifier trips the release-guard's `placeholder` regex; word-level `Wrap` is simpler anyway since a round item has one target word). "Nghe" pill (`AudioService`), "Gợi ý" hint (reveals first letter), `AnswerDiffView` + 1-round simplified reinforce loop on miss, XP via `PracticeProgressHeader`.
- **`PracticeListeningView`** (`/games/flashcards`) — redesigned to match web's flip-card `ListeningPlayer` (front: word + speaker; back: VN meaning) instead of the old MCQ. Self-rated "Chưa nhớ"/"Đã nhớ" (web has no right/wrong answer here — matches `PracticeListeningResults` understood/misunderstood semantics). Speed chips (0.75/1/1.25x — UI only, no audio-rate wiring since `AudioService`/`just_audio` speed control was out of scope for this pass).
- **`PracticeMatchingView`** (`/games/matching`) — paginated into 6-pair rounds (web parity, was a single flat round), pink→rose progress bar, DE/VI column labels, purple selection tint, red shake-on-wrong, audio plays on German tile tap.
- **`PracticeWritingView`** (`/games/writing`) — "Nghe" pill, `UmlautInputBar`, `AnswerDiffView` + reinforce loop on miss, XP. Mic UI is present but gated behind `ReleaseFeatureFlags.speaking` (see Decision below) — action is a no-op stub, recording pipeline stays MASTER P8's job.
- **`PracticeProgressHeader`** reworked into a shared XP + gradient-progress-bar header, gradient colors parameterized per mode (orange default, pink→rose for matching) instead of one hardcoded color.
- **`PracticeResultsView`** got one additive param (`backLabel`) so the standalone routes can say "Về Game" instead of "Back to deck" — no behavior change for the deck-practice caller.

### 4. Callers wired

- **Deck practice** (`lib/screens/practice/practice_screen.dart`): now maps `DeckWord → PracticeRoundItem` before handing off to the 4 views (was passing `DeckWord` directly).
- **Standalone `/games/*` routes** (new): `PracticeRouteScaffold` (`widgets/practice_route_scaffold.dart`) is a DRY wrapper — `GameShell` header + async load + results + restart — parameterized by `loadItems`/`buildView`. Four thin screens sit on top: `practice_cloze_route_screen.dart`, `practice_listening_route_screen.dart`, `practice_matching_route_screen.dart`, `practice_writing_route_screen.dart`. Data source: `practice_items_loader.dart` → `GET /user/learning-items/balanced` (same live endpoint the Artikel/Wortstellung/Fill-blank games already use — no new mock, no new endpoint).

### 5. Routing

- `lib/navigation/routes/practice_routes.dart`: routes renamed `/games/fill-blank`→`/games/cloze`, `/games/flashcard`→`/games/flashcards`; `/games/matching`, `/games/writing` unchanged paths, new content.
- `lib/navigation/release_redirect.dart`: old→new redirects added (`/games/fill-blank`→`/games/cloze`, `/games/flashcard`→`/games/flashcards`); the 4 new/renamed paths now gated by the existing `ReleaseFeatureFlags.practice` flag (default **true** — same flag already documented as covering "deck-scoped practice runner (cloze/listening/matching/writing)"), replacing the old per-legacy-screen flags (`fillBlankGame`/`flashcardGame`/`writingWordGame`) whose screens are deleted. Those flag constants still exist (I can't edit `lib/core/**`) but are now unreferenced by this file.
- `lib/features/vocabulary/presentation/widgets/detail_widgets.dart`: one-line fix, `/games/flashcard` → `/games/flashcards`.

### 6. Deletions

- `lib/screens/games/{fill_blank,flashcard,matching,writing_word}_game_screen.dart` + their tests (`fill_blank_game_screen_test.dart`, `flashcard_game_screen_test.dart`, `writing_word_game_screen_test.dart`) — replaced by the practice views above.
- `lib/screens/vocab_search/{vocab_search_screen,vocab_search_provider}.dart` — no web counterpart, was already unreferenced by any route.
- **NOT deleted**: `lib/screens/games/writing_sentence_game_screen.dart`. It's still imported by `lib/navigation/routes/games_routes.dart` at `/games/writing-sentence`, which is **P7's file** (explicitly off-limits — "other route files (parallel agents own those RIGHT NOW)"). Deleting the screen without editing that route file would break P7's concurrent work. **Coordination item**: P7 owns removing the `/games/writing-sentence` route (no web counterpart per plan); once that lands, this screen + its test + the `writingSentenceGame` flag/redirect become deletable.

### 7. Guard test / ARB / l10n

- `test/structure/release_live_data_guard_test.dart`: removed entries for the 4 deleted legacy screens; added entries for every new file in this phase (round-item model, 4 route screens, `practice_items_loader.dart`, `practice_route_scaffold.dart`, the 2 new shared primitives).
- ARB: added `practiceListenPill/practiceHintPill/practiceHintLetter/practiceRetryAnswer/practiceMicTooltip/practiceListeningNotYet/practiceListeningKnown/practiceListeningTapToFlip/practiceListeningMeaningLabel/practiceMatchingColumnDe/practiceMatchingColumnVi/practiceBackToGames/practiceNotEnoughWords` to `vi/en/de`, updated `practiceListeningPrompt` copy (semantics changed MCQ→flip-card) in all 3 locales, ran `flutter gen-l10n` (generated files updated, not hand-edited).
- `test/navigation/release_redirect_test.dart` and `test/screens/practice/practice_screen_test.dart` updated to match the new routes/UI (matching test interacts with the flip-card key `practice_listening_word` instead of MCQ option text, timing constants adjusted to the new 700ms/500ms delays).

## Decision: mic gate flag

Spec says "record-path gate flag voice" but no `voice`-named flag exists anywhere in the codebase, and the flag file (`lib/core/release/release_feature_flags.dart`) is out of this phase's ownership. Reused the existing `ReleaseFeatureFlags.speaking` flag (default **false**) — semantically closest (speech/recording feature) and already off by default, satisfying "gate default-off" without touching a forbidden file. Flagged as an assumption; if a dedicated `voice` flag lands later (MASTER P8), swap the one `if` in `practice_writing_view.dart`.

## Validation

- `flutter analyze` — 0 errors across the whole repo (4 pre-existing warnings/infos in files I don't own).
- `flutter test` (full suite) — all failures left are in files outside this phase's ownership, actively being edited by concurrent phase agents in the same working tree during this session (`lib/screens/auth/welcome/*`, `lib/screens/exam/*`, `test/screens/auth/welcome_screen_test.dart`, `test/screens/exam/exam_dictation_screen_test.dart`, `test/l10n/app_localizations_test.dart` welcome/reset-password cases). Verified via `git diff --stat` that I did not touch any of those files. All tests in `test/screens/practice/`, `test/navigation/`, `test/structure/release_live_data_guard_test.dart` (after my edits) pass.
- Regression check for the 3 consuming flows:
  - **Standalone practice** (`PracticeScreen`) — `practice_screen_test.dart` 6/6 green (cloze/writing/listening/matching happy paths + empty/error states), using the new round-type API end to end.
  - **Mission runner** — `test/features/mission/mission_session_provider_test.dart` passes; mission runner does not yet consume the rebuilt practice views (still its own word-intro/flip-card flow per scout report A2 — that's P3's rebuild, out of this phase's scope, but the round-type contract is ready for it).
  - **Daily review** — untouched this pass (deferred, its own tests still pass); does not consume the practice views yet either.

## Deferred (out of scope this pass — see report header)

Given the size of phase-04's full screen table (11 screens) vs. the explicit blocking priority stated in the task ("practice-view APIs must be clean and reusable... this phase BLOCKS P3/P5"), I prioritized the 4 practice views + primitives + routing to unblock P3/P5, and did **not** attempt in this pass:
- `vocabulary_screen.dart` (4th tab "⭐ Của tôi", WordSprint widget, PageIntro, 13 goals, gradient tabs)
- `vocabulary_detail_screen.dart` (wrong concept currently — needs full topic word-list rebuild: search/tabs/mastery bar/weak filter/sticky bottom bar)
- `vocabulary_lesson_screen.dart` (SRS mode-select → session → 7 card renderers → rating grid)
- `vocabulary_word_screen.dart` (pill/badge row, gender bar, YouGlish, conjugation, practice games/sheets)
- `daily_review_screen.dart` (drop bespoke start screen, mini-game playlist, `DailyReviewDone`)
- `subtitle_words_screen.dart` (level pills, select-all, card rows, sticky bottom bar)
- `my_words_screen.dart` (3 emoji-headed groups, fold into vocabulary tab)
- `practice_screen.dart`'s mode selector (still 4 flat rows, not the web's 13 gradient mode cards) and `practice_results_view.dart` (still missing XP pill/confetti visuals)
- `/vocabulary/:slug` client-side slug resolution (`topic-{key}`/`level-{level}`) — old `/vocabulary/detail/:topicKey` route still in place, works, just not web-path-aligned yet.

These remain pending; recommend a follow-up phase-04b pass or reassigning to the next available cycle. The guard test / redirect map / ARB protocol touchpoints are already correctly set up for whoever picks these up.

## Files changed

**New:** `lib/data/practice/practice_round_item.dart`, `lib/widgets/common/umlaut_input_bar.dart`, `lib/widgets/common/answer_diff_view.dart`, `lib/screens/practice/practice_items_loader.dart`, `lib/screens/practice/practice_{cloze,listening,matching,writing}_route_screen.dart`, `lib/screens/practice/widgets/practice_route_scaffold.dart`.
**Modified:** `lib/screens/practice/practice_screen.dart`, `lib/screens/practice/widgets/practice_{cloze,listening,matching,writing}_view.dart`, `lib/screens/practice/widgets/practice_progress_header.dart`, `lib/screens/practice/widgets/practice_results_view.dart`, `lib/navigation/routes/practice_routes.dart`, `lib/navigation/release_redirect.dart`, `lib/features/vocabulary/presentation/widgets/detail_widgets.dart`, `lib/l10n/app_{vi,en,de}.arb` + generated l10n, `test/structure/release_live_data_guard_test.dart`, `test/navigation/release_redirect_test.dart`, `test/screens/practice/practice_screen_test.dart`.
**Deleted:** `lib/screens/games/{fill_blank,flashcard,matching,writing_word}_game_screen.dart`, `lib/screens/vocab_search/{vocab_search_screen,vocab_search_provider}.dart`, `test/screens/games/{fill_blank,flashcard,writing_word}_game_screen_test.dart`.

## Unresolved questions

1. `writing_sentence_game_screen.dart` deletion + `/games/writing-sentence` route removal needs P7 (owns `games_routes.dart`) — flagged above, not blocking this phase's deliverable.
2. Mic gate reused `ReleaseFeatureFlags.speaking` instead of a dedicated `voice` flag (none exists) — confirm with MASTER P8 owner if a rename/dedicated flag is expected later.
3. Full vocabulary/my-words/daily-review/subtitle-words screen rebuilds (7 screens) are deferred — needs explicit scheduling decision (this session vs. new phase-04b).
4. Listening-view speed selector (0.75/1/1.25x) is UI-only in this pass — no `AudioService`/TTS playback-rate wiring; note if P3/P5 or a later polish pass needs real speed control.

Status: DONE_WITH_CONCERNS
Summary: Rebuilt the 4 practice views on a clean, source-agnostic `PracticeRoundItem` round-type contract (deck practice + new standalone `/games/{cloze,flashcards,matching,writing}` routes both consume it), added the umlaut-bar/diff-view P1-gap primitives, deleted 4 legacy game screens + vocab_search, updated routes/redirects/guard-test/ARB. `flutter analyze` 0 errors, all tests in my ownership area pass; full vocabulary/my-words/daily-review/subtitle-words screen rebuilds from the phase-04 table are deferred (documented above) since the task's stated priority was the blocking practice-view API for P3/P5.
Concerns/Blockers: `writing_sentence_game_screen.dart` deletion blocked on P7; 7 vocabulary-family screens still pending a follow-up pass; mic flag reuse assumption noted above.
