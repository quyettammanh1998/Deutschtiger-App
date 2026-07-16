# P7 Games — Web-Mobile UI Fidelity — Implementation Report

Phase: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-07-games.md`.

## Inherited cleanup (mandatory, done)

- Deleted `lib/screens/games/writing_sentence_game_screen.dart` + its test
  `test/screens/games/writing_sentence_game_screen_test.dart`.
- Removed `/games/writing-sentence` route from `games_routes.dart`, its import,
  and its redirect-gate entry in `release_redirect.dart` — **no** redirect
  added (web has no counterpart, per plan §Quyết định 3). `ReleaseFeatureFlags.
  writingSentenceGame` (core, off-limits) is now an unused orphan constant —
  flagged, not removed (not my file).
- `test/structure/release_live_data_guard_test.dart`: removed the deleted
  screen's entry.
- `test/navigation/release_redirect_test.dart`: removed
  writing-sentence assertions from the shared exemption test.
- Verified zero remaining references (`grep`) except: `lib/screens/games/
  game_hub_screen.dart` (fixed, rebuilt below) and `lib/navigation/routes/
  practice_routes.dart` comment (P4-owned, stale mention now — noted as
  unresolved question below, not touched per file-ownership boundary).

## Per-screen status

| Web | Flutter | Status |
|---|---|---|
| `/games` hub | `game_hub_screen.dart` | **REBUILT** — grouped-by-skill cards (7 groups matching web `GAME_GROUPS`), gradient icon tiles, `LevelTip`, `PageIntro`, DB quote card (`quoteHistoryProvider`), mascot "Bắt đầu nhanh" (random game), Shadowing banner (gated `speaking` flag), shuffle-random trailing action. Split into `widgets/game_hub_group_grid.dart` + `widgets/game_hub_level_tip.dart` to stay under LOC guidance. New test `test/screens/games/game_hub_screen_test.dart`. |
| `/games/runner` | `runner_game_screen.dart` | **DEFERRED** — not touched. Web needs tiger-sprite frame animation, obstacle-lane canvas, leaderboard panel, personal-best banner; P1 bundled the raw assets but wiring a canvas-equivalent animation controller + leaderboard endpoint integration is a multi-file, multi-hour build on its own, well beyond remaining session budget after the rest of the table. Named explicitly rather than silently skipped. |
| `/games/artikel` | `article_game_screen.dart` | **DONE** — adopted `GameShell` (removed AppBar + non-web level dropdown, title "Der / Die / Das" matches web h1), route renamed `/games/article` → `/games/artikel` with legacy redirect. |
| `/games/wortstellung` | `word_order_game_screen.dart` | **DONE** — `GameShell` + read-only level chip (`AppPill`) in trailing, matches web's non-editable `userLevel` chip. Route renamed `/games/word-order` → `/games/wortstellung` + redirect. |
| `/games/konjugation` | `konjugation_game_screen.dart` | **DONE** — `GameShell`, title "Konjugationstrainer (Chia động từ)" per phase spec, removed non-web level dropdown from body row. |
| `/games/listening` | `listening_game_screen.dart` | **DONE** — `GameShell`, shuffle-toggle trailing action, wrong-answer tracking + "Làm lại N câu sai" retry-wrong CTA on a custom completion view (kept in-file rather than editing the shared `GameCompletionScreen`, which is out of my ownership). |
| `/games/typing-sprint` | `typing_sprint_game_screen.dart` | **DEFERRED** — not touched. Web's per-character coral typing surface, live WPM chips, `ResultsModal`, key-sound feedback is a themed rebuild (custom `--ts-*` palette, char-level diffing) distinct from the current plain-TextField implementation; out of budget this pass. |
| `/games/word-sprint` | `word_sprint_game_screen.dart` | **DONE** — `GameShell`, "Đổi chủ đề" shuffle trailing action; completion now routed through `GameShell.showCompletion` (fixed a build-time misuse caught by `flutter analyze`/tests during implementation — completion is triggered from `_endGame()`, not from `build()`). |
| `/games/speaking` | `speaking_game_screen.dart` | **PARTIAL** — `GameShell` chrome adopted (header/exit-guard/score trailing). Web's `?daily=1` mission variant + avg-score completion screen requires real AI pronunciation grading, which is MASTER P8 (voice/STT wiring) scope per the plan's own dependency note, not P7 UI. Screen stays behind the blanket `games` flag (default off, not release-visible / not in the live-data guard list) so this is low risk. Documented inline in the file. |
| `/games/cases-mastery` | `cases/cases_mastery_hub_screen.dart` | **REBUILT** — gradient icon tiles (was flat tint), 2-paragraph bold-span banner with dark-mode colors (was single-para light-only), token-driven card (was hardcoded white). Route renamed `/games/cases` → `/games/cases-mastery`. |
| `/games/cases-{akk-dat,adjektiv,wechselprep}` | `cases/case_cloze_quiz_screen.dart` | **PARTIAL** — `GameShell` adopted, removed the dead/unused `_LevelPicker` dropdown (was declared but web doesn't show one). Routes renamed to hyphenated web paths (`/games/cases-akk-dat` etc). Streak counter, colored 3-col option ring grid, AI-explain panel, intro screen (`GrammarDrillIntro`) — **not built**; the existing single-column white-row-with-border quiz UI and results screen are untouched. This is the single largest deferred visual gap in the table. |
| `/games/cases-verb-case` | `cases/verb_case_quiz_screen.dart` | **PARTIAL** — same treatment as above (`GameShell` + route rename `/games/cases/verb-case` → `/games/cases-verb-case`); same streak/AI-explain gap deferred. |
| `/games/sentence-builder` topics | `sentence_builder/sentence_builder_topics_screen.dart` | **NOT TOUCHED** — route already matched web; visual gap (topic icon-gradient cards, sticky CTA, level pill gradient) not addressed this pass. |
| `/games/sentence-builder/preview` | — | **NOT BUILT** (new page, explicitly flagged "đang bị skip" in the plan). Requires a new word-preview screen wired to a filter/audio/example-expansion flow — scoped as new work, not a rename/wrap; deferred with the rest of the sentence-builder visual pass. |
| `/games/sentence-builder/play` | `sentence_builder/sentence_builder_play_screen.dart` | **NOT TOUCHED** — route correct; plays-counter, confetti, sticky blur header, exit-guard-via-GameShell gaps remain. |

## Route renames + redirects (web-path alignment)

`lib/navigation/routes/games_routes.dart`:
- `/games/article` → `/games/artikel`
- `/games/word-order` → `/games/wortstellung`
- `/games/cases` → `/games/cases-mastery`
- `/games/cases/{akk-dat,adjektiv,wechselprep,verb-case}` → `/games/cases-{akk-dat,adjektiv,wechselprep,verb-case}`
- `/games/writing-sentence` removed, no redirect.

`lib/navigation/release_redirect.dart`: added explicit old→new redirects for
every rename above (legacy deep links / other agents' stale hrefs still
resolve); kept per-game flag-exemption gates, re-keyed to the new paths.

Known stale references left untouched (protected by the new redirects, files
outside my ownership): `lib/shared/widgets/more_features/
more_features_catalog.dart`, `lib/screens/exam/widgets/readiness/
readiness_weakness_list.dart` (both still `context.push('/games/cases/...')`
style old paths — now correctly redirected, not broken).

## Files changed

- Deleted: `lib/screens/games/writing_sentence_game_screen.dart`, `test/screens/games/writing_sentence_game_screen_test.dart`.
- Rewritten: `lib/screens/games/game_hub_screen.dart`, `lib/screens/games/cases/cases_mastery_hub_screen.dart`.
- New: `lib/screens/games/widgets/game_hub_group_grid.dart`, `lib/screens/games/widgets/game_hub_level_tip.dart`, `test/screens/games/game_hub_screen_test.dart`.
- Edited (GameShell adoption + route-path fixes): `lib/screens/games/article_game_screen.dart`, `lib/screens/games/word_order_game_screen.dart`, `lib/screens/games/konjugation_game_screen.dart`, `lib/screens/games/listening_game_screen.dart`, `lib/screens/games/word_sprint_game_screen.dart`, `lib/screens/games/speaking_game_screen.dart`, `lib/screens/games/cases/case_cloze_quiz_screen.dart`, `lib/screens/games/cases/verb_case_quiz_screen.dart`.
- Edited: `lib/navigation/routes/games_routes.dart`, `lib/navigation/release_redirect.dart`.
- Edited (test upkeep for the above): `test/navigation/release_redirect_test.dart`, `test/structure/release_live_data_guard_test.dart`.

## Validation

- `flutter analyze` (whole repo): 1 pre-existing error in `lib/features/exam/
  presentation/widgets/mobile_player/reader_settings_sheet.dart` (`activeThumbColor`,
  exam-agent-owned, not touched by me) — **0 errors in any file I own**. Only
  info-level `prefer_final_fields` lints in my files (harmless style, mirrors
  a pattern already present pre-change).
- `flutter test` (full suite): 575 passed / 7 failed, all 7 in `test/features/
  exam/**` and `test/screens/exam/**` (exam-agent scope, matches the analyze
  error above) — confirmed unrelated by content of the failure list.
- `flutter test test/screens/games/ test/features/games/ test/navigation/
  test/structure/`: **124 + 87 = all green**, including the new
  `game_hub_screen_test.dart` and updated redirect/guard tests.

## Unresolved questions

1. `runner_game_screen.dart`, `typing_sprint_game_screen.dart`, cases-quiz
   streak/AI-explain grid, and `sentence-builder/{topics,play,preview}` visual
   parity are the remaining gaps — each is a substantial standalone rebuild
   (canvas animation, themed typing surface, AI-explain panel wiring, new
   preview page). Recommend a follow-up pass scoped to just these 5 items.
2. `lib/navigation/routes/practice_routes.dart` (P4-owned) has a stale header
   comment referencing `writing_sentence_game_screen.dart` "stays, owned by
   P7" — now inaccurate since I deleted it. Flagging for P4 to fix since I
   can't touch that file.
3. Speaking game's `?daily=1` variant and avg-score screen depend on real AI
   pronunciation grading (MASTER P8 scope) — confirm this stays out of P7
   before any future pass attempts it.

Status: DONE_WITH_CONCERNS
Summary: Mandatory writing-sentence cleanup + guard/redirect updates done; hub and cases-mastery hub fully rebuilt; 8 games (artikel, wortstellung, konjugation, listening, word-sprint, speaking, case-cloze ×3, verb-case) got GameShell adoption + web-path route renames with redirects; all touched-scope tests/analyze green, no regressions outside exam-agent's pre-existing failures. Runner, typing-sprint, cases-quiz streak/AI-explain UI, and sentence-builder topics/play/preview visual parity explicitly deferred as oversized standalone rebuilds.
Concerns/Blockers: 5 deferred items listed above and in the per-screen table — each needs its own focused pass.
