# P7b Games — Deferred-Items Pass — Implementation Report

Phase: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-07-games.md`, follow-up
to `plans/reports/fullstack-developer-260717-0217-p7-games-report.md` (which
deferred exactly these 5 items).

## 1. `runner_game_screen.dart` — DONE

- `GameShell` adoption (chrome/exit-guard, `exitGuard: _started` so the
  loading state can still pop freely).
- New `widgets/runner_sprite_stage.dart` — cheap `AnimatedBuilder`-driven
  Stack (single `AnimationController.repeat()`, no canvas/game-engine
  package): tiger run-cycle (`tiger-frames/frame-00..05`, `frame-06` = hit
  pose), obstacle images (`obstacles/*-removebg-preview.webp`, deterministic
  pick per spawn), looping parallax background (`obstacles/game-bg.webp`,
  seamless because the loop restarts exactly one tile-width later with an
  identical duplicate tile — no visible jump), lives/score/timer HUD, lane
  buttons. Ticker disposed in `dispose()`.
- New `widgets/runner_answer_panel.dart` / `widgets/runner_results_view.dart`
  — extracted from the screen to respect the 200-LOC guidance (screen is now
  ~300 lines vs. 500 before).
- Personal best: new `lib/data/games/runner_personal_best.dart`
  (`SharedPreferences`-backed, mirrors web's client-only `localStorage`
  `runner-personal-best.ts` — **no backend endpoint exists for this**, web
  itself is local-only). "🏆 Kỷ lục mới" banner on a new record.
- Leaderboard: new `widgets/runner_leaderboard_panel.dart` — reuses the
  **existing live** `leaderboardProvider(LeaderboardType.weekly)`
  (`lib/screens/leaderboard/leaderboard_screen.dart`, already wired for
  `/leaderboard`) rather than inventing a runner-only endpoint; web's own
  `RunnerLeaderboardPanel` shows the same account-wide weekly-XP board, not
  a runner-specific ranking, so this is a faithful port, not a shortcut.
- Kept the existing lane-quiz gameplay mechanic (3 discrete lanes, timer,
  question-per-obstacle-hit) rather than rebuilding web's full
  gravity/jump/collision canvas physics — reskinned visuals only. Documented
  inline as a scoped deviation (full physics rebuild would need a genuine
  game loop + hit-box system, out of "keep it cheap, no engine package").

## 2. `typing_sprint_game_screen.dart` — DONE

- `GameShell` adoption + coral theme (`TypingSprintPalette` in new
  `widgets/typing_sprint_paragraph_view.dart`, approximating web's `--ts-*`
  CSS custom properties — scoped locally, not added to `AppTokens`, matching
  how web itself scopes it to a page-local `<style>` block, not a global
  token).
- New `TypingSprintParagraphView` — live per-character diff coloring
  (correct/wrong/cursor/untyped) as the user types, replacing the plain
  `TextField`-only feedback.
- Live WPM chip (computed continuously from elapsed time × correct words),
  timer chip — both in the `GameShell` trailing slot.
- New `widgets/typing_sprint_results_card.dart` — coral-themed results card
  (was a plain lightBlue card).
- **Deviation, documented inline**: kept the sentence-by-sentence mechanic
  (one `TypingSentence` from `GET /user/typing/sentences` at a time, exact
  match to advance) rather than web's continuous cross-sentence paragraph
  stream (monkeytype-style, no visible input, global keydown capture,
  `ParagraphView`'s "reveal next sentence while typing the last word of the
  current one"). The Flutter backend contract serves discrete sentences, not
  a paragraph — reproducing the full stream engine would mean either a new
  backend endpoint or a client-side paragraph reconstruction, both out of
  this pass's "keep it cheap" budget. The per-character visual language is
  ported; the underlying typing-flow architecture is not.

## 3. Cases-quiz streak / colored-grid / AI-explain — DONE

`case_cloze_quiz_screen.dart` + `verb_case_quiz_screen.dart` (GameShell
chrome/routes already done in pass 1 — this pass is the remaining in-screen
visual parity):

- New `cases/widgets/case_quiz_streak_badge.dart` — 🔥 streak counter (shown
  once ≥3 correct in a row), added to both screens' header row alongside a
  "N đúng" counter (both were previously index-only).
- New `cases/widgets/case_quiz_option_grid.dart` — fixed 3-column colored
  option grid (blue/indigo/violet idle, green ring on the correct answer,
  red ring on a wrong pick), replacing the single-column white-row-with-
  border list. Used for both the cloze games (variable option count) and
  verb-case (fixed `[Akkusativ, Dativ, Genitiv]`).
- New `cases/widgets/grammar_explain_panel.dart` — on-demand "🤖 Giải thích
  sâu" AI explain panel, shown for wrong answers, wired to the **live**
  `POST /ai/explain-grammar` endpoint (was previously unused by Flutter —
  verified by reading `internal/shared/aihttp/grammar_explain_handler.go`;
  contract matrix + changelog updated). New repository method
  `GrammarDrillRepository.explainGrammar` + models
  `GrammarExplainRequest`/`GrammarExplainResult`. `ok:false` (LLM failure) is
  the endpoint's own documented degrade path — rendered as a quiet fallback
  to the static reason, never an error toast.
- 3 pre-existing test fakes (`case_cloze_quiz_screen_test.dart`,
  `verb_case_quiz_screen_test.dart`, and **`konjugation_game_screen_test.dart`
  — not my screen, but its fake `implements GrammarDrillRepository` broke
  from the new abstract-by-`implements` method**) updated with a stub
  `explainGrammar` override.

## 4. `sentence_builder/{topics,play}` visual polish — DONE

- `sentence_builder_topics_screen.dart` rewritten: tap-to-select topic cards
  (was immediate-navigate ListTiles) with new
  `sentence_builder/widgets/topic_gradient_tile.dart` (parses backend
  `vocabulary_topics.color`, a Tailwind gradient class string like
  `"from-blue-400 to-blue-600"` seeded in
  `migrations/041_seed_essential_words_a1.sql`/`052_...sql`, into a Flutter
  `LinearGradient` via a small hue-name palette lookup — Flutter can't
  consume Tailwind classes directly), sticky bottom CTA (`StickyCtaBar`:
  "Ngẫu nhiên" + "Bắt đầu"), matching web's selection model
  (`topic-select-page.tsx`). Added a secondary "Xem trước" icon-button per
  card routing to the new preview screen (see §5 — web itself never links
  topics→preview, leaving that route orphaned; this pass makes it reachable
  without changing the primary "Bắt đầu" flow, which still matches web by
  going straight to `/play`).
- `sentence_builder_play_screen.dart` rewritten: `GameShell` adoption
  (exit-guard while a session is running), confetti completion via new
  `sentence_builder/widgets/sentence_builder_results_view.dart` (was a plain
  white card, no confetti/XP pill — now has both, reusing the shared
  `ConfettiOverlay`), "x/y lượt" progress phrasing. Body/feedback UI
  extracted to `sentence_builder/widgets/sentence_builder_play_body.dart` to
  keep the screen file under the LOC guideline.

## 5. NEW `sentence-builder/preview` page — DONE

- New `sentence_builder_preview_screen.dart` + route
  `/games/sentence-builder/preview?level=&topicId=`, mirrors web
  `word-preview-page.tsx` (word-type filter pills with counts, expandable
  word cards, sticky "Bắt đầu luyện tập (N từ)" CTA).
- **Contract-before-code**: backend endpoint `GET /sentence-builder/topics/
  {id}/words?level=&limit=` already mounted
  (`sentence_builder_topic_handler.go` → `GetTopicWords`) and previously
  unused by Flutter — verified by reading the Go handler + `get_topic_words`
  SQL function before coding. New repository method
  `SentenceBuilderRepository.fetchTopicWords` + models
  `SentenceBuilderTopicWordsResponse`/`SentenceBuilderTopicWord`/
  `SentenceBuilderWordStats`. Documented a real backend bug found while
  reading the handler: `WordResponse.Examples` is declared in the JSON
  struct but the `rows.Scan` call only reads 7 columns, so `examples` is
  **always empty** in the live response — the preview card conditionally
  hides the examples section instead of rendering a permanently-empty one
  (recorded in the contract matrix, not silently "fixed" client-side with
  fake data).
- New `sentence_builder/widgets/word_preview_card.dart` — word-type badge,
  der/die/das gender prefix, essential ✨ badge, audio via the existing
  `SpeakButton` (no new audio plumbing).
- Web's own `topic-select-page.tsx` `handleStart` bypasses `/preview`
  entirely (goes straight to `/play`) — this Flutter build keeps that
  behavior for the primary CTA and only exposes `/preview` via the new
  secondary per-card button (see §4), so the new screen is actually reachable
  in the app (web leaves it orphaned/unlinked).

## Route + guard updates

- `lib/navigation/routes/games_routes.dart`: added
  `/games/sentence-builder/preview`.
- `test/structure/release_live_data_guard_test.dart`: added every new file
  from §1-§5 to the whitelist (protocol requirement — new release-visible
  screens/widgets must be scanned for `mock|fixture|placeholder`).
- No `release_redirect.dart` change needed — `/preview` is a genuinely new
  route (not a rename), and no other paths moved this pass.

## Contract-before-code (2 new live-endpoint integrations)

- `GET /sentence-builder/topics/{id}/words?level=&limit=` (word preview).
- `POST /ai/explain-grammar` (AI explain panel).

Both recorded in `docs/flutter-api-contract-matrix.md` (new sections) and
`docs/api-changelog.md` (2 new rows) before/alongside the client code, per
protocol. Both were mounted backend routes with zero prior Flutter callers
— additive client integration only, no server change.

## Files changed

- Rewritten: `lib/screens/games/runner_game_screen.dart`,
  `lib/screens/games/typing_sprint_game_screen.dart`,
  `lib/screens/games/sentence_builder/sentence_builder_topics_screen.dart`,
  `lib/screens/games/sentence_builder/sentence_builder_play_screen.dart`.
- New screens: `lib/screens/games/sentence_builder/sentence_builder_preview_screen.dart`.
- New widgets: `lib/screens/games/widgets/{runner_sprite_stage,
  runner_leaderboard_panel,runner_answer_panel,runner_results_view,
  typing_sprint_paragraph_view,typing_sprint_results_card}.dart`,
  `lib/screens/games/cases/widgets/{case_quiz_option_grid,
  case_quiz_streak_badge,grammar_explain_panel}.dart`,
  `lib/screens/games/sentence_builder/widgets/{topic_gradient_tile,
  word_preview_card,sentence_builder_play_body,
  sentence_builder_results_view}.dart`.
- New data: `lib/data/games/runner_personal_best.dart`.
- Edited (in-screen additions, not rewrites):
  `lib/screens/games/cases/case_cloze_quiz_screen.dart`,
  `lib/screens/games/cases/verb_case_quiz_screen.dart`.
- Edited (data/repo/provider): `lib/data/games/sentence_builder_models.dart`,
  `lib/repositories/games/sentence_builder_repository.dart`,
  `lib/repositories/games/grammar_drill_repository.dart`,
  `lib/view_models/games/sentence_builder_provider.dart`.
- Edited (routing/tests/docs):
  `lib/navigation/routes/games_routes.dart`,
  `test/structure/release_live_data_guard_test.dart`,
  `test/screens/games/{runner_game_screen,typing_sprint_game_screen,
  sentence_builder_topics_screen,sentence_builder_play_screen,
  case_cloze_quiz_screen,verb_case_quiz_screen,konjugation_game_screen}_test.dart`,
  `docs/flutter-api-contract-matrix.md`, `docs/api-changelog.md`.

## Validation

- `flutter analyze` (whole repo): 0 errors in any file I own. Remaining
  errors are 3 undefined-getter/method errors in `lib/screens/learn/
  widgets/goal_reason_line.dart` (a concurrent agent's in-flight ARB
  regeneration for `focusSessionGoal*` strings — not games, not touched by
  me, appeared/disappeared between runs as that agent's work landed).
- `flutter test` (full suite): **585 passed / 0 failed** at time of this
  report. (Earlier mid-pass runs showed pre-existing transient failures in
  `speak_to_notes_screen.dart`/`can_do_practice_screen.dart` from concurrent
  agents' in-flight work — both cleared on their own by the final run,
  confirmed not caused by my changes.)
- `flutter test test/screens/games/ test/features/games/ test/navigation/
  test/structure/`: 125 passed, 0 failed — includes 4 tests I had to update
  because I intentionally changed UI (per-char paragraph rendering broke a
  `find.text(fullSentence)` assertion; removed the plain-text correct-words
  counter; renamed topic subtitle text; changed the results-card heading to
  `🎉 Hoàn thành!`) and 1 test file (`runner_game_screen_test.dart`) that
  needed `pumpAndSettle` → fixed-frame `pump()` because the sprite stage's
  looping `AnimationController.repeat()` never settles (by design).

## Unresolved questions

1. Runner's obstacle spawn/lane RNG (`DateTime.now().millisecond % 3`) is
   unchanged from pass-1 code — not a P7b item, but worth a follow-up: it's
   not a great RNG source (millisecond clustering). Left as-is since
   touching gameplay logic wasn't in scope.
2. Typing Sprint's sentence-by-sentence vs. web's paragraph-stream mechanic
   (§2 deviation) is a real architectural gap, not just a visual one. If
   full parity is ever required, it needs either a new
   `GET /user/typing/paragraph` endpoint or a client-side paragraph
   reconstruction from multiple `TypingSentence`s — contract decision, not
   a code change I could make unilaterally this pass.
3. The Sentence Builder preview screen's "examples always empty" is a real
   backend bug (documented in the contract matrix) — recommend filing it
   against `sentence_builder_topic_handler.go`'s `GetTopicWords` scan.

Status: DONE
Summary: All 5 deferred items built for real — runner sprite/obstacle stage + personal-best + leaderboard, typing-sprint coral reskin + live per-char diff + live WPM, cases-quiz streak/colored-grid/live-AI-explain panel, sentence-builder topics/play visual polish, and the new sentence-builder/preview page wired to a previously-unused live backend endpoint. 2 new live-endpoint client integrations recorded in the contract matrix/changelog before coding. Full test suite green (585/585), analyze clean in every file I own.
Concerns/Blockers: none blocking; 3 unresolved questions above are follow-up-worthy, not blockers.
