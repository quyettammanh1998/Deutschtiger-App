# Phase 4c — vocabulary-lesson + vocabulary-word screen rebuild: report

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-04-vocabulary-practice.md` (follow-up part C, prior pass deferred these 2 screens).
Web source: `thamkhao/deutschtiger-frontend/src/pages/vocabulary/{vocabulary-lesson-page,vocabulary-word-page,vocabulary-word-sub-components}.tsx`, `src/components/vocabulary/vocabulary-lesson-card-renderers.tsx`.

## 1. `vocabulary_lesson_screen.dart` — DONE

Full rebuild: mode-select (Nhanh/Đầy đủ/Chuyên sâu tier cards) → SRS study session → 7 card-mode renderers → FSRS emoji rating grid (😬🤔🙂😎) → done/empty/error states.

- **Data**: new `lib/features/vocabulary/data/vocab_lesson_{models,utils,repository}.dart` — `LessonCard`/`LessonBatch` mirror backend `srs.QueueCard`/`srs.LessonBatch` JSON (`GET /user/srs/lesson-batch{,-by-topic,-by-level}` — verified live endpoints in `internal/feature/gamify/game/srs_{handler,lesson_handler,handler_topic}.go`). `vocab_lesson_utils.dart` ports `distributeVocabCardModes`/`deriveCloze`/`pickComposeReference`/`isWritingCorrect` 1:1 from web's `vocab-lesson-utils.ts`.
- **Rating**: reuses the existing `ReviewRepository.rate()` (`POST /user/srs/review`, same endpoint web's `recordReviewRated` hits) — no new wire format.
- **AI grading reused, not reimplemented**: writing card → `WordWritingRepository.gradeWord` (`/ai/grade-word-writing`, same endpoint the Writing Word game already uses); compose card → `LearnRepository.gradeSentence` (`/ai/grade-sentence`, same endpoint can-do-practice/sentence-builder use).
- **Session state**: `vocab_lesson_session_controller.dart` — plain `ChangeNotifier` (not a StateNotifier — screen-scoped, mirrors the page's own `useState` design on web) owning per-card ephemeral state (showBack/writingInput/choiceResult/clozeInput/composeInput + submit handlers).
- **7 card renderers** under `widgets/lesson/`: `lesson_flip_listen_cards.dart` (Flip+Reverse, Listen), `lesson_writing_choice_cards.dart` (Writing, Choice), `lesson_cloze_card.dart`, `lesson_compose_card.dart`. Plus `lesson_mode_select_view.dart`, `lesson_session_header.dart`, `lesson_rating_grid.dart`, `lesson_end_states.dart`.
- **New provider file** `vocab_lesson_provider.dart` (does not touch shared `vocabulary_provider.dart`) — repository + lesson-batch `FutureProvider.family` + the 2 reused-repo providers (word-writing, learn).

### Deviations (documented)
- Route contract: current Flutter route (`lib/navigation/routes/vocabulary_routes.dart`, out of scope — DO NOT TOUCH per task) only wires `topicKey` (+ `?level=` overlay), i.e. web's topic-mode. `VocabLessonRepository` also implements `fetchForCollection`/`fetchForLevel` for the legacy-collection and pure-level-mode branches web supports, but those paths are unreachable until a route change adds them (noted for whoever next touches route ownership).
- No localStorage progress-resume (web: `getVocabLessonProgress`/`saveVocabLessonProgress`) — every mode pick starts a fresh batch. Low risk (session-scoped convenience only).
- Compose-mode AI correctness uses `GradeSentenceResult.isCorrect` (`score >= 70`) since the Dart model doesn't expose `grammar_ok`/`contains_word` (web's fuller `ok = score>=70 && grammar_ok && contains_word`) — the model only parses the fields the existing can-do-practice caller needed. Acceptable proxy, didn't want to widen a shared model's parse surface for one caller.

## 2. `vocabulary_word_screen.dart` — DONE

Rebuild: hero card (gender accent bar, badge row, big word + plural/lemma, VN meaning, meanings box, image, "Đã thuộc" star, YouGlish button) → examples card (tappable + per-line speak) → conjugation card (verbs) → "Luyện tập thêm" 4-icon sheet-game grid → sticky prev/next bottom bar.

- **New widgets** under `widgets/word/`: `word_hero_card.dart`, `word_examples_card.dart`, `word_conjugation_card.dart`, `word_practice_sheet_games.dart`.
- **"Đã thuộc"**: new `vocab_word_provider.dart` reuses `ReviewRepository.rate()` with an explicit Easy(4) rating — same FSRS effect as web's `srsService.recordPractice([{itemId, rating:4}], 'vocab')` (`POST /user/srs/practice`), without adding a new Dart wrapper for that batch endpoint for a single-item action.
- **Practice games reused, not reimplemented**: SHEET_GAMES grid opens `PracticeWritingView`/`PracticeListeningView` (existing P4-first-pass round-type widgets) in a bottom sheet, fed by `PracticeRoundItem`s built from the current word + up to 7 queue neighbors (stand-in for web's `useRelatedWords`).
- **YouGlish**: external-browser link (`url_launcher` → `youglish.com/pronounce/{word}/german`) instead of an embedded iframe widget (no native YouGlish SDK/webview wiring existed).

### Deviations (documented, not silently dropped)
- No inline `MobileVocabSearch` header search (no standalone Flutter search endpoint wired for this header this pass).
- No ancestor breadcrumb / sibling phrases (`getAncestors`/`getChildren` have no `VocabularyRepository` methods yet — would need new repository methods in a shared file I don't own this pass).
- SHEET_GAMES condensed: web has 4 *distinct* mini-game components (writing/listening/speaking/flashcard); Flutter only has the 2 reused practice-round views, so "Nghe & chọn" and "Lật thẻ" both open `PracticeListeningView` (flip-card). "Phát âm" is gated behind `ReleaseFeatureFlags.speaking` (shows a "sẽ sớm ra mắt" toast when off — no mic UI ported, full pronunciation-assessment panel doesn't exist in Flutter).
- Conjugation table only renders the tenses `ConjugationInfo` exposes (praesens/praeteritum/perfekt/konjunktiv_ii/raw) — web's richer table (plusquamperfekt/futur/konjunktiv_i/…) needs backend+model fields the Flutter domain model doesn't carry; didn't widen `vocabulary_models.dart` (shared file) for this.
- Prev/next queue nav via sticky bottom bar buttons instead of web's non-existent gesture — this is an app-only addition kept from the pre-rebuild screen (Flutter always has a queue since C2 opens C3 from a topic's SRS batch). Dropped the old horizontal-swipe gesture in favor of the buttons (test updated to tap instead of swipe).

## Bug fix along the way

`WordHeroCard`'s "Đã thuộc"/YouGlish action-row buttons overflowed (`RenderFlex overflowed`) at German 200% text scale — fixed by wrapping the label in `Flexible(... overflow: ellipsis)` instead of a `mainAxisSize: min` Row inside a centered container. Same fix pattern applied to the word screen's prev/next buttons (custom `_NavButtonLabel` instead of `OutlinedButton.icon`/`FilledButton.icon`, whose built-in Row has no `Flexible` around the label and overflows at 2x scale).

## Files changed

**New:**
- `lib/features/vocabulary/data/vocab_lesson_models.dart`
- `lib/features/vocabulary/data/vocab_lesson_utils.dart`
- `lib/features/vocabulary/data/vocab_lesson_repository.dart`
- `lib/features/vocabulary/presentation/vocab_lesson_provider.dart`
- `lib/features/vocabulary/presentation/vocab_lesson_session_controller.dart`
- `lib/features/vocabulary/presentation/vocab_word_provider.dart`
- `lib/features/vocabulary/presentation/widgets/lesson/{lesson_mode_select_view,lesson_session_header,lesson_rating_grid,lesson_flip_listen_cards,lesson_writing_choice_cards,lesson_cloze_card,lesson_compose_card,lesson_end_states}.dart`
- `lib/features/vocabulary/presentation/widgets/word/{word_hero_card,word_examples_card,word_conjugation_card,word_practice_sheet_games}.dart`

**Modified (rebuilt):**
- `lib/features/vocabulary/presentation/vocabulary_lesson_screen.dart`
- `lib/features/vocabulary/presentation/vocabulary_word_screen.dart`
- `test/structure/release_live_data_guard_test.dart` (added entries for every new file above)
- `test/screens/vocabulary/vocabulary_lesson_localization_test.dart` (rewritten for the new mode-select/hero UI — still asserts no exceptions at German 200% scale)
- `test/features/vocabulary/vocabulary_interaction_test.dart` (swipe→button-tap, since the swipe gesture was dropped)

**Deleted (superseded by the new `widgets/lesson/` and `widgets/word/` files):**
- `lib/features/vocabulary/presentation/widgets/lesson_widgets.dart`
- `lib/features/vocabulary/presentation/widgets/word_widgets.dart`

## Validation

- `flutter analyze` — 0 errors, 4 pre-existing style infos (`prefer_initializing_formals`), none new besides one in my own controller (intentional: public constructor param, private backing field — same pattern used elsewhere in the codebase).
- `flutter test test/features/vocabulary test/screens/vocabulary test/screens/practice test/screens/daily_review test/features/mission test/navigation test/structure` — all green.
- Full `flutter test` — 583/585, only 2 failures, both in `test/screens/my_words/my_words_localization_test.dart` (owned by the sibling agent rebuilding `lib/features/my_words/**` concurrently, not touched by me — confirmed via `git diff --stat` not touching that tree).

## Unresolved questions

1. Route ownership: `/vocabulary/lesson/:topicKey` doesn't cover web's `level-{level}`/legacy-collection lesson slugs. `VocabLessonRepository` is ready for them; needs a route-file owner to wire `/vocabulary/:slug/lesson` generically.
2. `getAncestors`/`getChildren` (breadcrumb + sibling phrases on word page) need new `VocabularyRepository` methods — that file is shared with the sibling vocabulary-screen rebuild; flagging instead of editing it this pass.
3. Speaking mini-game sheet is a gated stub (toast only) — needs the real pronunciation-assessment panel once MASTER P8 wires mic/Azure PA into a reusable widget.
4. `firstOrNull` / word_widgets.dart old files removed — confirmed no other file referenced them before deleting.

Status: DONE
Summary: Rebuilt `vocabulary_lesson_screen.dart` (mode-select → SRS session → 7 card renderers → FSRS rating grid) and `vocabulary_word_screen.dart` (hero/badges/gender-bar/Đã-thuộc/YouGlish/conjugation/examples/sheet-games practice grid) per web parity, reusing existing SRS/AI-grading/practice-round infra instead of reimplementing; `flutter analyze` 0 errors, full test suite green except 2 pre-existing failures in a concurrent sibling's `my_words` tree.
Concerns/Blockers: none blocking; see unresolved questions above for scoped follow-ups (route coverage, breadcrumb/siblings, speaking mini-game).
