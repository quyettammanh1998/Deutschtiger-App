# P4d — Daily review, subtitle words, practice mode selector: implementation report

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-04-vocabulary-practice.md`
Scope: the 3 items deferred by both prior P4 passes (round types + primitives, and vocab hub/detail/lesson/word).

## 1. `lib/screens/daily_review/**` — daily-review-page.tsx

- Removed the bespoke start screen (`StreakCard`/`TodayStatsCard`/`StartReviewButton`,
  `lib/screens/daily_review/widgets/start_widgets.dart` — deleted) and the flip-card FSRS
  session (`review_session_view.dart` — deleted). `DailyReviewScreen` now loads straight
  into the mini-game playlist, matching web (no start screen at all).
- New round-based playlist (`widgets/daily_review_{rounds,round_cards,playlist}.dart`):
  chunks the SRS queue (`ReviewItem`) into ~6-word rounds, cycling through the 4 **existing
  P4 practice-view round types** (matching/cloze/listening/writing —
  `PracticeMatchingView`/`PracticeClozeView`/`PracticeListeningView`/`PracticeWritingView`,
  reused as-is via a new `roundItemFromReview()` → `PracticeRoundItem` converter). Round
  intro → playing → summary state machine per web's `PracticeSession` engine, scoped down
  (see deviation below).
- `widgets/daily_review_done.dart` (`DailyReviewDoneScreen`) — web parity `daily-review-
  done.tsx`: status pill (Xuất sắc/Khá tốt/Cần ôn thêm by accuracy), 📖 hero + accuracy %,
  XP gradient pill, weak-words chip list, CTAs (Ôn thêm / Luyện lại N từ yếu / Về trang chủ
  / Tiếp tục học) + secondary CTAs (🎧 Luyện nghe, ✨ Hỏi AI — gated `ReleaseFeatureFlags.
  aiTutor`, shown when ≥5 words reviewed, matching web). Empty state (0 due words) renders
  the same screen with the 🎉 "Không có từ cần ôn!" copy.
- FSRS persistence: `DailyReviewScreen._persist()` rates every result via the existing
  `reviewRepositoryProvider.rate()` after the whole session finishes (best-effort, mirrors
  `PracticeScreen._syncResults`), then invalidates `dashboardProvider`. Retry-weak-words
  reuses the same `ReviewItem` objects already in memory (no refetch).
- Route/redirect unchanged (`/daily-review`); no navigation-file edits needed.

**Deviation (documented, scoped):** web's `PracticeSession` engine dispatches 9 mini-game
types (matching/artikel/wordSprint/listening/flashcard/fillBlank/typing/writing/speaking)
built from `buildRounds()`'s heuristics. Per the task's explicit instruction to drive rounds
from the existing P4 practice-view API and not build new game logic, the playlist only
cycles the 4 implemented types (uniform 6-word chunks, round-robin order). Round XP uses the
`correct * 10` heuristic (matches web's non-mini-game round XP calc in `practice-session.tsx`
`finishRound`), since the underlying practice views don't thread a total-XP value back
through `onComplete`. Exit from mid-round has no confirm dialog (web uses `window.confirm`,
no Flutter equivalent primitive readily available in scope) — tapping back leaves the round
immediately.

## 2. `lib/screens/vocab/subtitle_words_screen.dart` — subtitle-words-page.tsx

Full rebuild, split under 200 LOC/file:
- `subtitle_words_screen.dart` (170 LOC) — state (level filter, selection, save flow) only.
- `subtitle_words_providers.dart` — counts + family-parameterized word-list providers
  (`levelsKey` = sorted comma-joined levels, since Riverpod `family` needs a hashable arg).
- `widgets/subtitle_words_header.dart` — back button + title/subtitle + level-filter pills
  (`Tất cả` + `{level}·{count}`, selected = orange gradient).
- `widgets/subtitle_word_row.dart` — card row: checkbox, ring selection (2px primary border
  when selected), IPA mono, "đã thấy Nx" orange pill, level/word-type pills, 🔊 play button
  (`AudioService`).
- `widgets/subtitle_words_list.dart` — select-all/clear toolbar + rows + 📽️ empty state.
- `widgets/subtitle_words_action_bar.dart` — sticky bottom CTA (`StickyCtaBar` +
  `AppButton` "Thêm N từ vào ôn tập" / emerald success banner, auto-dismiss 3s).

Replaces the old `CheckboxListTile` + `FloatingActionButton.extended` + `SnackBar` design.
Now wires the repository's existing `getCounts()`/level-filter params (previously unused by
the screen) — level filtering is real, not cosmetic.

## 3. `lib/screens/practice/practice_screen.dart` — practice-page.tsx

- `widgets/practice_mode_cards.dart` (new) — `PracticeModeCardConfig` list mirroring web's
  `FlashcardModeSelector.MODE_CONFIGS` (gradient icon tile, title, description).
- `widgets/practice_mode_selector.dart` — rebuilt as a 2-col grid of gradient cards (was 4
  flat rows), + real "Bao gồm từ đã thuộc" checkbox (`includeGraduated`, filters `DeckWord.
  isLearned` — wires existing data, not just cosmetic) + "N thẻ sẵn sàng" footer.
- `widgets/practice_results_view.dart` — dropped the `Icons.emoji_events` trophy; now shows
  `ConfettiOverlay` (reused from `lib/shared/widgets/confetti_overlay.dart`) + the shared
  `DailyReviewXpPill` (`⚡ +{xp} XP` gradient pill, `xp = correctCount * 10` — same heuristic
  as the daily-review round summary, documented above) + `AppCard`/`AppButton` primitives.
- `practice_screen.dart` — dropped the Material `AppBar`; web has no AppBar on this route,
  just an in-content back link ("← Quay lại bộ thẻ" at mode-select, "← Đổi chế độ" while
  playing — new `_PracticeLinkButton`, new ARB `practiceChangeMode`).

**Deviation (documented, scoped):** web lists 12 modes in `MODE_CONFIGS`/`VALID_MODES`
(writing/sentence/cloze/flashcards/listening/matching/runner/fade/dictation/chaining/gist/
speaking) — the phase-04 table says "13", which doesn't match the current web source; going
with the verified 12. Of those, only 4 have a built Flutter round-type view
(cloze/matching/writing, plus this app's single `PracticeMode.listening` flip-card view,
which — per the existing P4 pass's naming/route convention already used in 3 other files —
conflates web's separate `flashcards` (flip-card) and `listening` (MCQ) modes under one
"Luyện nghe" card). The other 7 (sentence/runner/fade/dictation/chaining/gist/speaking)
render as visually-correct gradient cards but disabled + "Sắp ra mắt" (YAGNI — building 7 new
mini-game engines was explicitly out of scope: "MUST drive these round types, not new game
logic"). This gives 11 visible cards, not 13/12; flagged as a scope decision, not an
oversight.

## Shared fix (applies to both daily-review-done and practice-results)

Found and fixed a **real mobile-width overflow bug** while wiring these: web's CTA rows in
both `daily-review-done.tsx` and `practice-page.tsx` results use `flex-col ... sm:flex-row`
— i.e. **column layout by default on mobile**, row only from `sm:` breakpoint up. The
existing Flutter primitives (`AppButton`'s internal `Row` has no `Flexible` around its label)
overflow when two are placed side-by-side in a tight `Expanded` pair with longer localized
labels (caught by the German-200%-scale test). Fixed by stacking these CTA rows vertically
(`Column`, full-width), which is actually *more* web-accurate than the row layout it
replaces, not just a workaround.

## ARB / l10n

Added to `vi`/`en`/`de`: `dailyReviewRound*` (7 keys), `dailyReviewRetryBanner`,
`dailyReviewEmpty*`, `dailyReviewSessionLabel`, `dailyReviewStatus*` (3), `dailyReview
CompletedTitle`, `dailyReviewWeakWordsTitle`, `dailyReviewCta*` (5), `subtitleWords*`
(reworded/added 12 keys to match the new design), `practiceMode*Desc`/`practiceMode{Sentence,
Runner,Fade,Dictation,Chaining,Gist,Speaking}` (new 12-mode set), `practiceModeComingSoon`,
`practiceIncludeGraduated`, `practiceCardsReady`, `practiceXpEarned`, `practiceChangeMode`.
Ran `flutter gen-l10n` after every ARB edit — generated files are the tool's output, not
hand-edited.

## Guard test / protocol

`test/structure/release_live_data_guard_test.dart`: added entries for every new file
(4 daily_review widgets, `practice_mode_cards.dart`, `subtitle_words_providers.dart`, 4
subtitle_words widgets). No entries removed (the 2 deleted daily_review files were never in
the guard list to begin with).

## Files changed

**New:** `lib/screens/daily_review/widgets/daily_review_{rounds,round_cards,playlist,done}.dart`,
`lib/screens/practice/widgets/practice_mode_cards.dart`,
`lib/screens/vocab/subtitle_words_providers.dart`,
`lib/screens/vocab/widgets/subtitle_word_row.dart`,
`lib/screens/vocab/widgets/subtitle_words_{header,list,action_bar}.dart`.
**Modified:** `lib/screens/daily_review/daily_review_screen.dart`,
`lib/screens/practice/practice_screen.dart`,
`lib/screens/practice/widgets/practice_{mode_selector,results_view}.dart`,
`lib/screens/vocab/subtitle_words_screen.dart` (rewritten),
`lib/l10n/app_{vi,en,de}.arb` + generated l10n,
`test/structure/release_live_data_guard_test.dart`,
`test/screens/{daily_review/review_session_localization_test,practice/practice_screen_test,
vocab/subtitle_words_screen_test}.dart`.
**Deleted:** `lib/screens/daily_review/widgets/{start_widgets,review_session_view}.dart`.

## Validation

- `flutter analyze` on every file/dir I touched: 0 issues.
- `flutter analyze` (whole repo): pre-existing errors only in files I never touched
  (`lib/screens/pronunciation/**`, `lib/screens/speaking/conversation*` — missing ARB
  getters from another in-flight phase; `lib/screens/youtube/**`; verified via
  `git diff --stat` that none of these are mine).
- `flutter test` (whole repo): all failures are in `test/screens/listening/**` and
  `test/navigation/release_redirect_test.dart` (2 cases about `/listening/podcast/...`) —
  confirmed via `git diff --stat` these files are being actively edited by a concurrent
  agent (P11 media/listening; `release_redirect.dart`/`release_live_data_guard_test.dart`
  mid-edit with a reference to a not-yet-created `listening_coming_soon.dart`), not touched
  by me.
- My suites green: `test/screens/daily_review/`, `test/screens/vocab/`,
  `test/screens/practice/`, `test/structure/release_live_data_guard_test.dart`,
  `test/navigation/` (all but the 2 listening-related cases above),
  `test/features/mission/mission_session_provider_test.dart`, `test/l10n/
  app_localizations_test.dart`.
- Regression: daily-review flow (playlist → rounds → done screen, including retry-weak and
  continue-more branches) exercised via the rewritten widget tests; deck practice flow
  (`PracticeScreen`) exercised end-to-end for all 4 modes via `practice_screen_test.dart`
  (had to grow the test surface to `400x2000` since the new 2-col gradient grid needs more
  vertical room than the default 800x600 test viewport — this mirrors real narrow-phone
  widths, not an artificial widening).

## Unresolved questions

1. Daily-review round mid-play exit has no confirm dialog (web uses `window.confirm`) —
   acceptable gap or should a `ConfirmDialog` (already exists in `lib/shared/widgets/`) be
   wired in a follow-up?
2. 11 visible practice mode cards vs. the phase-04 table's "13" — confirmed against current
   web source (12 configs, `practice-page.tsx`/`flashcard-mode-selector.tsx`); flag if the
   plan's "13" was itself sourced from a different web revision.
3. `PracticeMode.listening` still conflates web's `flashcards` and `listening` (MCQ) modes
   under one card (pre-existing from the earlier P4 pass, not changed here) — worth a
   dedicated MCQ card wired to the existing `/games/listening` screen in a future pass?

Status: DONE
Summary: Rebuilt daily-review (dropped bespoke start screen, added round-based mini-game
playlist reusing the 4 P4 practice views + full DailyReviewDone), subtitle-words (card rows/
ring-selection/level pills/select-all/sticky CTA, replacing CheckboxListTile+FAB), and the
practice mode selector (11 gradient cards replacing 4 flat rows, XP pill + confetti results,
dropped the trophy icon) — all 3 deferred items from the phase-04 table. flutter analyze
clean on all touched files; my test suites green; only failures anywhere are in
listening/release_redirect files being concurrently edited by another agent.
Concerns/Blockers: none blocking; 3 unresolved questions above are scope-confirmation items,
not defects.
