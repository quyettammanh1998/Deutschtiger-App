# Practice modes + Subtitle words — implementation report

Date: 2026-07-16

## Scope decision (sentence builder dropped)

Task spec asked for practice runner (cloze/listening/matching/writing) + sentence
builder + subtitle words. Investigated `/sentence-builder/*` — 3 backend endpoints
(`preferences`, `topics`, `session`) map to `src/pages/game/sentence-builder/**`,
which lives under the web's **Game** IA, not Practice/Vocabulary. Per the task's
own file-ownership note ("nếu games sweep GĐ2 P4 chưa nhận, làm ở đây; điều phối
để không làm 2 lần") and to respect `lib/screens/games/` file-ownership boundary
(no edits allowed there), sentence builder is left OUT of this pass — it belongs
with the games sweep, not practice/vocab. Documented as open item below, not
silently dropped.

## What shipped

### Practice runner (deck-scoped, reuses live deck/flashcard repos — no new endpoint)

- `lib/data/practice/practice_result.dart` — `PracticeResultEntry`, `PracticeMode` enum.
- `lib/screens/practice/practice_screen.dart` — orchestrator (mode select → mode
  view → results), reuses `deckWordsProvider` from `deck_detail_screen.dart` (DRY,
  no new repo) and `reviewRepositoryProvider` for best-effort FSRS sync
  (`source_flashcard_id` = deck card id — confirmed via backend
  `srs/lesson_batch_builder*.go` that flashcard-decks card IDs are flashcard IDs).
- `lib/screens/practice/widgets/`: `practice_mode_selector.dart`,
  `practice_cloze_view.dart`, `practice_listening_view.dart`,
  `practice_matching_view.dart`, `practice_writing_view.dart`,
  `practice_results_view.dart`, `practice_progress_header.dart`.
  - Cloze: blanks the deck word inside its `example` sentence; falls back to a
    translation-clue blank when no example exists (every deck card stays
    practiceable — no silent skip).
  - Listening: `audioServiceProvider.play()` (server TTS cache → on-device TTS,
    same seam as flashcard review) + 4-option multi-choice.
  - Matching: German↔Vietnamese tap-tap grid, capped at 8 pairs/round; shows a
    dedicated message if the deck has < 2 words instead of crashing.
  - Writing: type the German word given its Vietnamese meaning.
- Entry point: practice icon button on `DeckDetailScreen` AppBar →
  `/decks/:deckId/practice`.
- Reused (not modified) `lib/features/games/widgets/game_base.dart` visual
  language (score/progress/feedback colors) — did not import it directly since
  its `GameQuestion`/4-option-MCQ model doesn't fit cloze/writing free-text or
  matching; kept games files untouched per constraint.

### Subtitle words

- `lib/data/vocab/subtitle_word.dart`, `lib/repositories/vocab/subtitle_words_repository.dart`
  (`GET /subtitle-words`, `GET /subtitle-words/counts`, `POST /subtitle-words/add`
  — verified against `internal/feature/learning/subtitlewords/handler.go`).
- `lib/screens/vocab/subtitle_words_screen.dart` — list + multi-select +
  "add to review" FAB; entry point added as an AppBar icon on `VocabularyScreen`.

### Routing / gating / docs (contended files, narrow edits)

- `lib/navigation/app_router.dart`: `/decks/:deckId/practice`, `/subtitle-words`.
- `lib/navigation/release_redirect.dart`: gate `/subtitle-words` behind the new flag.
- `lib/core/release/release_feature_flags.dart`: added `practice` flag, default
  `true` (both surfaces reuse already-verified live sources).
- `test/structure/release_live_data_guard_test.dart`: added all new practice/vocab
  screen+repo files to the release-visible no-mock-marker scope.
- `lib/l10n/app_{en,vi,de}.arb` + `flutter gen-l10n`: ~29 new keys
  (`practice*`, `subtitleWords*`).
- `docs/flutter-live-data-inventory.md`, `docs/api-changelog.md`: new rows/entry
  documenting the live sources and the "web has a global practice pool, this
  wave only covers deck-scoped" gap.

## Tests (all green)

- `test/repositories/subtitle_words_repository_test.dart` — contract test (GET
  query params incl. `levels` join, GET counts, POST body).
- `test/screens/practice/practice_screen_test.dart` — empty deck, error+retry,
  and 1 happy-path test per mode (cloze/writing/listening/matching).
- `test/screens/vocab/subtitle_words_screen_test.dart` — empty, error+retry,
  happy path (select → save → `addWords` called → snackbar).
- `flutter analyze` (scoped to touched files): clean.
- `flutter test` (full suite, once): `All tests passed!` — pre-existing
  in-flight errors seen mid-session in `lib/screens/ai/*` and
  `lib/screens/exam/exam_readiness_screen.dart` belonged to other agents' active
  edits and had resolved by the time the full suite ran.

## Files touched

Created: `lib/data/practice/practice_result.dart`,
`lib/screens/practice/practice_screen.dart`,
`lib/screens/practice/widgets/{practice_mode_selector,practice_cloze_view,practice_listening_view,practice_matching_view,practice_writing_view,practice_results_view,practice_progress_header}.dart`,
`lib/data/vocab/subtitle_word.dart`,
`lib/repositories/vocab/subtitle_words_repository.dart`,
`lib/screens/vocab/subtitle_words_screen.dart`,
`test/repositories/subtitle_words_repository_test.dart`,
`test/screens/practice/practice_screen_test.dart`,
`test/screens/vocab/subtitle_words_screen_test.dart`.

Edited (narrow): `lib/navigation/app_router.dart`, `lib/navigation/release_redirect.dart`,
`lib/core/release/release_feature_flags.dart`,
`test/structure/release_live_data_guard_test.dart`,
`lib/screens/decks/deck_detail_screen.dart` (practice AppBar button),
`lib/features/vocabulary/presentation/vocabulary_screen.dart` (subtitle-words AppBar button),
`lib/l10n/app_en.arb`, `lib/l10n/app_vi.arb`, `lib/l10n/app_de.arb`,
`docs/flutter-live-data-inventory.md`, `docs/api-changelog.md`.

Not touched: anything under `lib/screens/learn/`, `lib/repositories/learn/`,
`lib/screens/games/` (read-only reference).

## Unresolved / follow-up

1. Sentence builder (`/sentence-builder/*`) — not implemented; belongs to the
   games sweep per web IA (`src/pages/game/sentence-builder/**`). Needs explicit
   hand-off/dedup coordination so it isn't skipped entirely.
2. Web's global (non-deck) practice pool for cloze/listening/matching/writing
   (`fetchSmartSessionItems`/`fetchItemsWithWeakMix`, no `deckId`) is not
   covered — only the deck-scoped runner shipped, per task's explicit "nguồn
   item = deck của user" instruction. Logged as a gap in `docs/api-changelog.md`.

Status: DONE_WITH_CONCERNS
Summary: Practice runner (4 mode, deck-scoped) + subtitle words shipped with tests, routes, l10n, docs; sentence builder intentionally deferred to games-domain ownership (game IA + file-ownership boundary), not silently dropped.
Concerns/Blockers: Sentence builder needs separate coordination with whichever agent owns `lib/screens/games/` sweep so it isn't missed entirely.
