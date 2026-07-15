# Games live wave 4 — Flashcard, Writing Word, Writing Sentence, Listening, Runner (dev report)

Date: 2026-07-16. Scope: GĐ2 P4 games sweep, wave 4 — 5 non-microphone games.
speaking/pronunciation/conversation intentionally skipped (blocked-by-voice, MASTER P8).

## Per-game table

| Game | Route | Source | Status |
|---|---|---|---|
| Flashcard | `/games/flashcard` | `GET /user/srs/queue` + `POST /user/srs/review` — tái dùng nguyên `ReviewRepository`/`reviewSessionProvider` (scope `flashcard_game`, tách khỏi `flashcard`/`daily_review`) | Live |
| Writing Word | `/games/writing` | `GET /vocabulary/learned` (tái dùng `VocabularyRepository`) + `POST /ai/grade-word-writing` (mới: `WordWritingRepository`) | Live |
| Writing Sentence | `/games/writing-sentence` | `GET /vocabulary/learned` + `POST /ai/grade-sentence` (tái dùng `LearnRepository.gradeSentence`, read-only import, không sửa domain `learn`) | Live |
| Listening | `/games/listening` | `GET /vocabulary/learned` + audio qua `AudioService` có sẵn (server TTS cache `/user/tts/vocab-cache` → fallback máy) | Live |
| Deutsch Runner | `/games/runner` | `GET /vocabulary/learned`; quiz đổi từ der/die/das (không có gender trong API) sang chọn nghĩa đúng | Live |

## Files

New:
- `lib/data/games/word_writing_models.dart` — `WordGradeResult` (plain Dart).
- `lib/repositories/games/word_writing_repository.dart` — `gradeWord()` (`POST /ai/grade-word-writing`).
- `lib/view_models/games/word_writing_provider.dart` — repo provider + `writingWordWordsProvider` (reused by both Writing Word and Writing Sentence).
- `lib/view_models/games/listening_game_provider.dart`, `lib/view_models/games/runner_game_provider.dart` — thin `FutureProvider` wrapping `VocabularyRepository.getLearnedWords()`, same pattern as `word_sprint_provider.dart`.

Rewritten (StatefulWidget → ConsumerStatefulWidget, mock data removed):
- `lib/screens/games/flashcard_game_screen.dart`
- `lib/screens/games/writing_word_game_screen.dart`
- `lib/screens/games/writing_sentence_game_screen.dart`
- `lib/screens/games/listening_game_screen.dart` (also fixed a small-viewport overflow: body wrapped in `SingleChildScrollView`, `Spacer()` → fixed `SizedBox`)
- `lib/screens/games/runner_game_screen.dart` (lane/obstacle animation mechanic unchanged — pure gameplay, no data dependency; only the quiz Q&A content changed)

Shared/contended files (narrow edits, verified no conflict with the concurrent wave-3 agent — that agent's own `articleGame`/`wordOrderGame`/`fillBlankGame` additions to the same files landed mid-session and merged cleanly, confirmed by re-reading after their edits):
- `lib/data/games/game_models.dart` — `gd1Available: true` + source comment on `flashcard`/`runner`/`listening`/`writingWord`/`writingSentence` entries.
- `lib/core/release/release_feature_flags.dart` — 5 new flags: `flashcardGame`, `writingWordGame`, `writingSentenceGame`, `listeningGame`, `runnerGame` (all default `true`).
- `lib/navigation/release_redirect.dart` — 5 new per-route exemptions from the blanket `games` gate, same pattern as `sentenceBuilder`/`wordSprint`.
- `test/navigation/release_redirect_test.dart` — replaced the now-stale `/games/runner` "still mock" example with `/games/matching`; added a new test block asserting the 5 routes are exempt + `/listening` (podcast hub) stays independently gated.
- `test/structure/release_live_data_guard_test.dart` — added the 10 new/changed source files to the release-visible allowlist (verified: no `mock*/fixture*/placeholder*` markers).
- `docs/flutter-live-data-inventory.md` — narrowed the "remaining mock games" row to the 7 still-mock (article/matching/fill-blank/word-order/speaking/pronunciation/conversation — article/fill-blank/word-order status may differ now since another agent is converting them concurrently), added 5 new per-game rows, and an explicit note that speaking/pronunciation/conversation are blocked-by-voice (not effort/priority).
- `docs/api-changelog.md` — 2026-07-16 GĐ2 P4 wave-4 entry.

Game Hub (`game_hub_screen.dart`) and router (`app_router.dart`) needed **no changes** — routes/nav cases for all 5 games already existed from the original mock screens.

Did not touch (per instructions): the 5 wave-3 game screens (cases_mastery, konjugation, article/artikel, word_order/wortstellung, fill_blank) — only read `article_game_screen.dart` briefly to check gender-data availability, no writes.

## Design decisions worth flagging

1. **Flashcard rating simplification**: FSRS has 4 ratings (Quên/Khó/Tốt/Dễ); the game UI keeps 2 buttons ("Chưa nhớ"→Quên, "Nhớ rồi"→Tốt) for a faster game feel, but the real `ReviewRating` is submitted so due-date scheduling stays correct. `ReviewSessionScope(mode: 'flashcard_game')` is a distinct mode string from the existing `'flashcard'`/`'daily_review'` scopes so backend provenance tracking isn't conflated.
2. **Writing Sentence reuses `writingWordWordsProvider`** (same learned-words source as Writing Word) rather than a 3rd near-identical provider — DRY, not a boundary violation since both are thin wraps of the same already-shared `VocabularyRepository`.
3. **Runner quiz shape changed**: web's `use-runner-words.ts` sources a separate learning-items balanced pool with 4 gender-independent quiz modes (de-to-vi/vi-to-de/listen-de/listen-vi) via `fetchItemsWithWeakMix` — not reused here (would need a brand-new learning-items HTTP client, out of scope for this pass). Adapted to "pick the correct meaning" instead of the old mock's der/die/das guessing, since `GET /vocabulary/learned` doesn't return grammatical gender. This is a genuine gap, documented in the inventory table, not a silently-dropped feature.
4. **Listening play button** now calls `AudioService.play(text:, audioUrl:)` — same infra `flashcard_review_screen.dart` already uses (server TTS cache → device TTS fallback). No new audio endpoint needed.

## Tests (all green, my scope)

```
flutter test test/repositories/games/word_writing_repository_contract_test.dart \
  test/screens/games/flashcard_game_screen_test.dart \
  test/screens/games/writing_word_game_screen_test.dart \
  test/screens/games/writing_sentence_game_screen_test.dart \
  test/screens/games/listening_game_screen_test.dart \
  test/screens/games/runner_game_screen_test.dart \
  test/navigation/release_redirect_test.dart \
  test/structure/release_live_data_guard_test.dart
# 22 tests, all pass
```

- Contract test for `WordWritingRepository` (POST body/path contract, correct/incorrect parse).
- Widget tests per screen: happy path (renders live data), error view + retry, and (word sprint-style) too-few-words guidance state where applicable. Flashcard/writing-word/writing-sentence tests override the relevant repository with a hand-written fake subclass (`ReviewRepository`/`WordWritingRepository`/`LearnRepository`), following the existing `review_session_provider_test.dart` pattern. Listening test overrides `audioServiceProvider` with a fake `AudioService` subclass (real one hits network/plugin channels not available in the widget-test sandbox).
- Timer-heavy screens (writing word/sentence 1.8-2s post-answer delay, flashcard/listening/runner countdown) each `pump()` past the pending delay before `pumpWidget(SizedBox.shrink())` to force clean `dispose()`.

`flutter analyze` on touched files: no issues (verified twice — once before, once after the concurrent wave-3 agent's edits to the same shared files landed).

## Full-repo checks (run once, per instructions)

- `flutter analyze` (full repo): clean except 5 pre-existing infos (deprecated `RadioGroup` API in `de_thi_practice_screen.dart`, `prefer_initializing_formals` in 3 unrelated social/notification test files) — none in my file set, none are errors.
- `flutter test` (full repo): 538 tests, **all pass**. No pre-existing failures encountered this run (unlike the wave-2/wave-3 handoffs, which hit concurrent in-progress social-domain breakage — that appears resolved by the time this run executed).

## Unresolved questions

1. Runner's learning-items balanced-pool parity gap (item 3 above) — worth a dedicated `LearningItemRepository` client later if Runner needs to match web's exact quiz variety, or is "pick the correct meaning" from learned-words acceptable long-term?
2. Same open question from prior waves: XP-award/mission-queue sync — still no shared hook across any of the (now 10) live game screens. Worth adding once most games are live rather than one-off per game.
3. `docs/flutter-live-data-inventory.md`'s "remaining mock" row (article/matching/fill-blank/word-order/speaking/pronunciation/conversation) may already be stale for article/fill-blank/word-order since another agent was converting those concurrently in the same session — next pass should re-verify against `game_models.dart`'s actual `gd1Available` state rather than trusting this doc in isolation.

Status: DONE
Summary: 5 non-voice games (Flashcard, Writing Word, Writing Sentence, Listening, Runner) converted to live data sources, each behind its own default-true release flag; full-repo analyze/test green (538 tests).
Concerns/Blockers: none blocking; see unresolved questions above for follow-up scope.
