# Phase 5 — Decks/flashcards suite: implementation report

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-05-decks-flashcards.md`

## Per-screen done/deviation

| Web | Flutter | Status |
|---|---|---|
| `/notes` deck list | `deck_list_screen.dart` | DONE — header+PageIntro, starred row, folders (rotating 6-color icons, subfolder/deck counts), "Tất cả decks" list w/ default-deck star, `DeckMasteryBar` (segmented new/learning/known/mastered from live `deck-summary`), 3-dot menu (Sửa/Chuyển vào thư mục), "Tạo mới" bottom sheet (Tạo bộ thẻ/Tạo thư mục/Nói ra ghi chú). DEVIATION: `MyNotesSection compact` (YouTube video notes row) skipped — that's `vocabulary`-domain, out of my file ownership; inline create-forms replaced with dialogs (functionally equivalent, less visually 1:1); `FlashcardSprintWidget` replaced with a simple CTA card linking to the existing `/games/word-sprint` screen instead of rebuilding the widget from scratch. |
| `/notes/:id` deck detail | `deck_detail_screen.dart` | DONE (full rebuild, 924-line web → structured Flutter) — editable-name-less header w/ deck name, card count, `DeckMasteryBar`, search + star filter, "Thêm" action, sticky `DeckLearnBottomBar` (Học→lesson, Chơi→practice), card list w/ star toggle + TTS. DEVIATION: no "Từ của tôi" tab (accuracy-stats mastery view — needs `useCardAccuracy`/review-map wiring beyond this pass' time budget), no CSV import, no `DeckAudioGenerator` banner (premium-gated TTS-gen feature — no existing Flutter audio-gen client, would need its own contract-before-code pass), no inline deck-name-rename (edit happens via the list's 3-dot menu instead), no weak-only filter (needs per-card accuracy data not fetched here). |
| `/notes/:id/new`, `/edit/:cardId` | `card_form_screen.dart` (NEW) | DONE — front/back/example (DE+VI) fields, create/update/delete against the live `/user/flashcards` endpoints. DEVIATION: no audio recording/upload, no ChatGPT-helper, no CSV/paragraph import (out of scope per time budget). |
| `/notes/folder/:id` | `folder_detail_screen.dart` (NEW) | DONE — subfolders + decks-in-folder, reuses `DeckFolderSection`/`DeckRowTile`. |
| `/notes/starred` | `starred_view_screen.dart` (NEW) | DONE — flat starred-cards list w/ deck-name label, unstar. |
| `/notes/:id/lesson` guided lesson | `guided_lesson_screen.dart` (NEW) | DONE — mode selector (reused `PracticeModeSelector`) → batches of 7 cards run through the SAME P4 `{items, onComplete}` views (`PracticeClozeView`/`Listening`/`Matching`/`WritingView`, all read-only reuse, zero duplication of round logic) → per-batch summary → "Đợt tiếp theo"/"Hoàn thành" → final `PracticeResultsView`. DEVIATION: no separate new-vs-review distinction (web splits "7 new + 3 review"; this pass batches the deck sequentially since per-card SRS due-state wasn't already surfaced by `getDeckWords`) — documented, not hidden. |
| `/notes/speak` | `speak_to_notes_screen.dart` (NEW) | DONE per spec: full UI (helper text, mic button, editable textarea, deck-name input, save→creates a new deck + batch-saves each non-empty line as a card via the live `/user/flashcards/batch` endpoint, "Đã lưu N câu..." success state). Mic/STT wired behind `ReleaseFeatureFlags.speaking` (same flag P4 reused for its mic gate — no dedicated `voice` flag exists) — tapping mic when the flag is off is disabled w/ tooltip; text is otherwise fully typeable/saveable without it, so the save flow works today. |

## Delete / route rename

- Deleted `lib/screens/flashcard/` (review screen + `widgets/flashcard_view.dart` + `widgets/rating_bar.dart` — no other consumer; web review runs inside deck-detail practice modes, not a standalone page) and its only test (`test/screens/flashcard/flashcard_review_localization_test.dart`).
- Routes renamed `/decks/*` → `/notes/*` (`decks_routes.dart`); `/flashcard-review` removed. `release_redirect.dart` (append-only) gained `/decks/*` → `/notes/*` and `/flashcard-review` → `/notes` redirects — this also covers the two out-of-ownership call sites that still hardcode `/decks/...` (`lib/shared/widgets/save_card_button.dart`, `lib/screens/practice/practice_screen.dart`'s pop-fallback), so they keep working without me touching files outside my scope.

## Data layer (extended, not new endpoints — all verified live in `deutschtiger-backend/cmd/server/routes_user_flashcards.go`)

`Deck` dropped unused `word_count`/`learned_count`/`cover_color` (dead fields — never present in the real `FlashcardDeck` JSON, always defaulted 0/null) and gained `folder_id`. `DeckWord` gained `deckId`/`exampleTranslation`/`audioUrl`/`imageUrl`/`isStarred`/`sortOrder`/`deckName` (all real fields on `Flashcard`/`StarredFlashcard`), kept its existing field names so P4's `PracticeRoundItem.fromDeckWord` factory (owned by P4, read-only for me) keeps compiling unchanged. Added `DeckFolder`, `DeckSummaryRow` models. `DeckRepository` gained folder CRUD, card CRUD (+ `getCard`), star toggle/list, default-deck get/set, deck-summary, and `saveSpokenSentencesAsDeck` (create deck + batch-save, used by speak-to-notes) — all against endpoints already registered and used by the live web app. `deck_provider.dart` gained `deckFoldersProvider`/`starredCardsProvider`/`defaultDeckIdProvider`/`deckSummaryProvider`.

## Contract-before-code check

Per the task's flag ("audio-gen and speak-to-notes are the likely candidates") I checked both: speak-to-notes' backend need (`/user/flashcards/batch`, deck create) is already live and used elsewhere — no new endpoint. Deck audio-gen (`deck-audio-generator.tsx`) is premium-gated TTS generation with its own service call — genuinely new Flutter-side work beyond "wire existing endpoint," so I deferred it (documented above) rather than build a new contract mid-phase without explicit scope sign-off.

## Validation

- `flutter analyze`: 0 errors repo-wide (only pre-existing infos + 2 infos in files I don't own).
- `flutter test` (full suite, 583 tests): 2 failures, both in `test/screens/games/sentence_builder_*_test.dart` — outside my ownership (games phase, concurrent agent), not touched by me.
- My suites green: `test/screens/decks/**` (rewrote both localization tests to the new field-free `Deck` model and new screen chrome — German 200% scale, no overflow/exceptions), `test/structure/release_live_data_guard_test.dart` (added every new file, removed the deleted flashcard-review entries, no `mock|fixture|placeholder` identifiers), `test/navigation/release_redirect_test.dart`, `test/repositories/phase_3b_repository_contract_test.dart` (deck CRUD contract), `test/screens/practice/practice_screen_test.dart`, `test/shared/widgets/save_card_button_test.dart` — all pass, confirming deck CRUD keeps working against the live contract end to end.
- l10n: ~65 new keys added to `vi`/`en`/`de` ARB, ran `flutter gen-l10n` (generated files not hand-edited).

## Files

**New:** `lib/screens/decks/{card_form,folder_detail,guided_lesson,speak_to_notes,starred_view}_screen.dart`, `lib/screens/decks/widgets/{deck_mastery_bar,deck_row_tile,deck_folder_section,deck_action_sheet,deck_form_dialogs,deck_card_row,deck_learn_bottom_bar}.dart`.
**Rewritten:** `lib/data/decks/deck_models.dart`, `lib/repositories/decks/deck_repository.dart`, `lib/view_models/decks/deck_provider.dart`, `lib/screens/decks/{deck_list,deck_detail}_screen.dart`, `lib/navigation/routes/decks_routes.dart`.
**Modified (append-only):** `lib/navigation/release_redirect.dart`, `test/structure/release_live_data_guard_test.dart`, `lib/l10n/app_{vi,en,de}.arb` + generated l10n.
**Rewritten tests:** `test/screens/decks/{deck_list,deck_detail}_localization_test.dart`.
**Deleted:** `lib/screens/flashcard/` (review screen + widgets), `test/screens/flashcard/flashcard_review_localization_test.dart`.

## Unresolved questions

1. Deck detail's "Từ của tôi" mastery tab and weak-only filter need per-card SM-2 accuracy/review data beyond `getDeckWords` — worth a small follow-up (`/user/flashcard-reviews/latest` batch call) if that view is prioritized later.
2. `DeckAudioGenerator` (premium TTS-gen banner) deferred — no Flutter TTS-gen client exists yet; needs its own contract-before-code pass + premium gate wiring.
3. Guided lesson batches the deck sequentially rather than the web's "7 new + 3 review" SRS split — acceptable given P4's views don't currently expose a due/new distinction per item; flag if product wants that parity later.

Status: DONE_WITH_CONCERNS
Summary: Deck list + deck detail fully rebuilt to web structure (folders/starred/mastery/sticky Học-Chơi bar), 4 new screens added (card form, folder detail, starred view, guided lesson reusing P4's round views, speak-to-notes UI gated behind the speaking flag), routes renamed `/decks`→`/notes` with redirects, dead flashcard-review screen deleted, data layer extended against already-live endpoints only. `flutter analyze` 0 errors, all owned tests green; 2 unrelated failures in games (not mine).
Concerns/Blockers: "Từ của tôi" tab, CSV import, and audio-gen banner deferred (documented above) — genuinely out of this pass' time budget, not silently dropped.
