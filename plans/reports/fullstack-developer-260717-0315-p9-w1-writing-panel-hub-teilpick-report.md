# P9 Wave 1 — WritingPracticePanel foundation + Goethe B1 hub + teil-pick

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-09-exam-writing.md` (W1 only)

## Scope executed

1. `WritingPracticePanel` shared core — `lib/features/writing/**` (new)
2. `goethe_b1_hub_page.dart` — rebuilt per web spec (removed mock English body)
3. `goethe-b1-writing-teil-pick` — `/exams/goethe-b1/writing` (new screen)

## Files

**New — `lib/features/writing/`**
- `domain/schreiben_grading_result.dart` — `SchreibenGradingResult`, `WritingCorrection`, `WritingSuggestion`, `GoetheRawScores`, `AiUnavailableException`. `fromJson`/`toJson`, malformed-field-tolerant.
- `domain/writing_submission.dart` — `WritingSubmission`, `WritingGradingAttempt`.
- `domain/goethe_b1_writing_manifest.dart` — `GoetheB1WritingManifest(Teil)`, `GoetheB1WritingResult`.
- `data/writing_repository.dart` — `WritingRepository` (grade/rewrite/submissions/gradings) + `writingRepositoryProvider`.
- `data/goethe_b1_writing_repository.dart` — manifest + results + providers.
- `data/writing_draft_store.dart` — `WritingDraftStore`/`WritingDraft` (SharedPreferences, 3s debounce, `dispose()` flush).
- `presentation/writing_practice_panel.dart` — **the public API** (see below).
- `presentation/widgets/practice_editor_card.dart` + `practice_editor_actions.dart` + `practice_editor_buttons.dart` — editor, submit/grade/submitted rows, mini buttons/banners.
- `presentation/widgets/practice_rewrite_section.dart` — rewrite-from-feedback block, reuses `AnswerDiffView`.
- `presentation/widgets/grading_result_card.dart` + `_bars.dart` + `_lists.dart` + `_layout.dart` + `grading_error_type_labels.dart` — AI grade card.
- `presentation/widgets/writing_history_sheet.dart` — past-submissions bottom sheet.

**New — screens**
- `lib/screens/exam/goethe_b1_writing_teil_pick_page.dart`
- `lib/screens/exam/widgets/writing_teil_pick/{teil_pick_hero,teil_pick_card}.dart`
- `lib/screens/exam/widgets/hub/goethe_b1_hub_row_card.dart`

**Modified**
- `lib/screens/exam/goethe_b1_hub_page.dart` — full rewrite.
- `lib/navigation/routes/exam_routes.dart` — `writing` sub-route builder swapped to the new teil-pick screen (2-line targeted diff + comment).
- `lib/l10n/app_{vi,en,de}.arb` + generated `app_localizations*.dart` (`flutter gen-l10n`) — ~65 new keys (`writing*`, `goetheB1Hub*`, `goetheB1Writing*`).
- `test/structure/release_live_data_guard_test.dart` — added all 21 new release-visible file paths.
- `docs/flutter-api-contract-matrix.md` — new "Writing / Schreiben ecosystem (P9 wave 1)" section, 7 endpoints.
- `docs/api-changelog.md` — one changelog row.

**New tests**
- `test/features/writing/{schreiben_grading_result,writing_draft_store,goethe_b1_writing_manifest}_test.dart` (11 unit tests).
- `test/screens/exam/{goethe_b1_hub_page,goethe_b1_writing_teil_pick_page}_test.dart` (3 widget tests).

## WritingPracticePanel public API (for W2/W3/W4)

```dart
WritingPracticePanel({
  required String examId,          // opaque draft/submission/history key, caller owns namespacing
  required String taskPromptDe,    // German task prompt sent to the AI grader
  required List<String> writingPoints,
  String level = 'B1',
  String provider = 'goethe',      // 'goethe' | 'telc' — grading rubric/scale
  int? teilNum,                    // 1-3, AI grading context only
  Widget? footer,                  // extra content below editor (e.g. "Ask AI" button)
})
```
Owns: draft autosave (debounced, restore/discard prompt), submit, AI grade (`WritingRepository.gradeSchreiben`), grading-attempt history persistence, AI rewrite + diff comparison (reuses `AnswerDiffView`), umlaut bar (reuses `UmlautInputBar`), history sheet. All async/loading/error state lives in `_WritingPracticePanelState` — wrapper pages pass only the 3 required + optional params above. Deliberately excluded from the API surface (no Flutter data layer yet): save-to-deck, community metadata, learning-activity time tracking — W2+ should extend via `footer`, not new panel params.

## Per-screen status

- **WritingPracticePanel**: DONE. Not yet wired into any screen (that's W2/W3/W4's job) — validated via unit tests on its data layer only; the full interactive flow (submit→grade→rewrite) has no widget test in W1 since there's no host screen yet to exercise it end-to-end.
- **goethe_b1_hub_page.dart**: DONE. Readiness card + 1 card/3 VN rows (official/writing/sprechen), English mock body removed.
- **goethe-b1-writing-teil-pick**: DONE. Hero (badges/pitch/3 stat cards), umbrella nav links, 3 `TeilPickCard`s with live progress bars.

## Deviations (documented, not silent)

1. **Readiness data source changed**: web spec says "`ExamReadinessCard provider=goethe level=b1`". The Flutter hub page previously used `lib/view_models/exam/exam_provider.dart` → `ExamRepository`, which is 100% hardcoded in-memory data (`_mockHubs` etc., not backend-backed) — reusing it would have shipped new hardcoded content on a release screen. Switched to the live `GET /exam-readiness` endpoint (`exam_ecosystem_providers.dart`, already backs `ExamReadinessScreen`) + its existing `ReadinessBandCard`/`ReadinessBandEmptyCard` widgets. This endpoint is account-wide, not per-hub — acceptable substitute since Goethe B1 is currently the only exam provider with data.
2. **Rewrite diff uses `AnswerDiffView` (word-level diff), not web's two-panel before/after layout.** The plan mandates reusing the P4 diff-view primitive rather than hand-rolling a new comparison widget; `AnswerDiffView`'s inline green/amber/red chips are also more mobile-appropriate at phone width than two stacked full-text panels. Documented in the widget's doc comment.
3. **Goethe rubric "band X / points to next band" chips omitted** from `GradingResultCard` (web shows `bandForScore` per category). Score bars + comments are ported; the band math (`b1-rubric.ts`) is a secondary refinement not required for W1's foundation mandate — noted as a gap for whoever polishes the grading card later.
4. **No learning-activity time tracking.** Web's panel calls `useLearningActivityTracker` on grade completion; no Flutter equivalent exists anywhere in the codebase (`grep` confirmed zero hits) — out of scope to invent one in W1. `writingTracker.complete()` call is simply absent.
5. **"Bài của tôi →" link and the teil-pick page's "← Tất cả kỳ thi luyện viết" / "Bài của tôi →" links point at `/luyen-viet`, which doesn't exist until W3.** Kept per web parity (GoRouter shows its default not-found page rather than crashing); the top link inside the panel itself is currently a no-op (`onPressed: () {}`) since there's no target route yet — will need wiring once W3 lands.
6. **`SaveWritingToDeckButton` equivalent not built.** `PracticeEditorCard.saveSlot` is a plain optional `Widget?` slot (currently always null from the panel) rather than a wired save-to-deck button — no Flutter deck-save-from-writing repository exists yet.
7. Long-form Vietnamese hero copy (`goetheB1WritingHeroPitch`/`HeroDesc`) went through ARB anyway (not left inline) for consistency with the rest of the new strings, even though the approved exception would have allowed inline.
8. A few files exceed the 200-LOC guideline after splitting as far as reasonably possible without fragmenting cohesive state machines: `writing_practice_panel.dart` (347, single state-machine orchestrator — the explicit "public API" the task asked for), `practice_editor_card.dart` (269), `grading_result_card.dart` (220), `schreiben_grading_result.dart` (243, mostly `fromJson`/`toJson` boilerplate for 5 nested types).

## Concurrent-agent conflicts observed (not mine, not fixed)

- `lib/screens/exam/goethe_speaking_page.dart` was deleted mid-session by what appears to be a concurrent speaking/P10 agent (confirmed via `git log`/`git status`, not caused by my edits); it briefly broke `exam_routes.dart` compilation, then was resolved by that same agent adding `GoetheSprechenOverviewPage` in its place before I finished. Final `flutter analyze` confirms `exam_routes.dart` is clean.
- `lib/screens/exam/widgets/community/community_writing_{extra,task}_sections.dart`, `lib/screens/games/writing_sentence_game_screen.dart` (deleted, matches plan §3 decision) — touched by other concurrent agents, not this task.

## Validation

- `flutter analyze` on all touched/new files: **0 errors, 0 warnings** (2 pre-existing-style `info` lints in `writing_repository.dart` matching the exact `if (x != null) 'key': x` pattern used throughout the rest of the codebase — left as-is for consistency).
- Repo-wide `flutter analyze`: 3 pre-existing errors, all in `lib/screens/decks/guided_lesson_screen.dart` (decks phase, explicitly out of my ownership) — not mine.
- `flutter test test/features/writing test/screens/exam test/l10n test/structure/release_live_data_guard_test.dart`: **41/41 passed**.
- `flutter gen-l10n` regenerated cleanly from the merged ARB files (vi/en/de key counts match).

## Unresolved questions

1. Should `WritingPracticePanel`'s `examId` namespacing convention be centrally documented/enforced (e.g. a small builder function) before W2-W4 each invent their own scheme? Currently it's just "caller-owned opaque string" per the public API doc comment.
2. `lib/screens/exam/widgets/exam_readiness_card.dart` (the old mock-backed `ExamReadinessCard` widget) is now orphaned — no remaining callers after this change. Left in place (out of my file ownership to delete); candidate for the plan's later "Xóa" cleanup pass.
3. Goethe rubric band-to-next-band chips (deviation #3) — worth porting in a later wave, or accepted as permanently simplified for mobile?

Status: DONE
Summary: WritingPracticePanel foundation (draft autosave, submit, AI grade/rewrite, history sheet) built with a documented stable public API; goethe_b1_hub_page and the new teil-pick screen rebuilt to web parity on live backend data (readiness + manifest + results), replacing the old English/mock hub body. 0 analyze errors on all touched files, 41/41 new+existing tests green, contract matrix/changelog/ARB/guard updated.
Concerns/Blockers: none blocking; see deviations #1-#8 and unresolved questions above for W2-W4 follow-up.
