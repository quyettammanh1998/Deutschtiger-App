# Phase 8 Wave B — Exam mobile player + result rebuild (web parity)

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-08-exam-core-community.md`.
Scope: `exam_practice_page.dart` (mobile player) + `exam_result_page.dart`. Wave A
(landing/section/list/skill-list/readiness/schedule/dictation/de-thi/community) is
untouched, as instructed.

## Player — `exam_practice_page.dart` + `widgets/mobile_player/**`

Rebuilt to match web `mobile-test-layout.tsx` / `mobile-practice-layout.tsx`
("section-screen mode"): whole-current-Teil scroll instead of 1-question-per-screen.

| Web element | Status | File |
|---|---|---|
| Compact header (back/exit chip, title, orange progress bar, pace dot, "?" guide, settings, "Câu X/Y", "Nộp bài" blue pill) | DONE | `mobile_player/exam_practice_header.dart` |
| Whole-Teil scroll body | DONE | `mobile_player/mobile_question_panel.dart` — renders ALL questions of `state.currentSectionObj` in one `SingleChildScrollView`, numbered globally via new `ExamPlayerState.currentSectionQuestionOffset` |
| Footer (32px blue prev/next squares + amber counter pill → nav sheet) | DONE | `mobile_player/mobile_footer_bar.dart` |
| Nav sheet grouped by Teil, semantic colors (blue current, blue-soft answered, green/red review, legend + stats) | DONE | `mobile_player/mobile_nav_sheet.dart`, uses new `ExamPlayerState.correctByAnswerKey` (extracted `isAnswerCorrect` top-level fn, reused by submit scoring — no behavior change) |
| Reader settings (font scale, highlight toggle, word-lookup toggle) | DONE | `mobile_player/reader_settings_sheet.dart` + `reader_prefs.dart` (Riverpod state, session-only) |
| Reader guide ("?") | DONE | `showReaderGuideDialog` in `reader_settings_sheet.dart` |
| Tap-word lookup | DONE | `QuestionCardFrame` (existing shared file, all 5 question renderers) converted to `ConsumerWidget`, reads `wordLookupEnabledProvider`; reuses existing `TappableSentence` + `showWordLookupSheet` from `lib/shared/widgets/` — no new lookup infra |
| Highlight toolbar | DONE (simplified) | Word-level tap-to-mark via new `_HighlightableText` in `question_card_frame.dart` + 4-swatch picker in reader settings. Web uses the CSS Custom Highlight API over character ranges (`hooks/shared/highlight-paint.ts`) — genuinely out of reach in Flutter's `SelectableText` in this budget; this is a deliberate, documented simplification, not a silent drop |
| "Dịch đoạn văn" (translate paragraph) | DONE (simplified) | New optional `ExamQuestion.descriptionVi` field, populated from BE `description_vi` (already sent, just unused before) in `exam_service.dart` — additive, does not touch persisted draft/attempt contract. `ExamReadingTranslateCard` shows it as a collapsible block above the question, not an in-place swap of the German text, because Flutter's domain model merges the Teil passage into the *first question's* `prompt` (see `_buildPrompt`) rather than keeping it as a separate section-level field like web's `ExamSection.description`. Splitting that apart is a real data-model change, out of this UI-only wave's scope — documented deviation |
| Locked-audio state (test mode, max_plays) | DONE (reused) | `ExamAudioPlayer`/`AudioPlayCounter` already implemented this correctly (GĐ1) — untouched, just re-wired into the new panel |
| Review comments | DONE | New `ExamCommentSection` widget (`mobile_player/exam_comment_section.dart`) against the **existing, already-live** generic `GET/POST /api/v1/comments?target_type=exam&target_id=` endpoint (`internal/feature/social/comment/comment_handler.go` — verified via route table, not a new endpoint). Simplified vs web: no realtime Supabase subscribe, no pin/delete, flat (no reply threads) |
| Dark mode | DONE for shell | New `exam_player_palette.dart` gives brightness-aware blue/green/red/amber/indigo swatches (web's Tailwind literals have no Flutter dark accessor today — noted gap in scout). Header/footer/nav-sheet/reading-pane/comments all read `context.tokens` + this palette. Per-question-type renderers (`question_mc.dart` etc.) still use light-only `Colors.white`/`ExamDesignTokens.exam*` in a few spots — pre-existing gap, not touched (would require editing all 5 renderer files; out of budget, documented) |
| Mode toggle in player / section tabs / question palette (old Flutter-only design) | REMOVED | Web has none of these — mode switching is route-based. Deleted `exam_mode_toggle.dart`, `exam_progress_bar.dart`, `exam_section_tabs.dart`, `exam_timer.dart`, `question_palette.dart` + their now-orphaned test `exam_mode_toggle_localization_test.dart` |

Reused unchanged (no rebuild needed, already exam-token styled): `question_renderer.dart`
+ 5 type renderers, `exam_audio_player.dart`, `exam_audio_controls.dart`,
`exam_dialogs.dart` (submit/exit confirm — already exactly matches web's dialog copy),
`exam_explanation_card.dart`.

## Result — `exam_result_page.dart` + `widgets/result/**`

| Web element | Status | File |
|---|---|---|
| Header (back + title) | DONE | inline in `exam_result_page.dart` |
| ResultSummary (score block + pass/fail banner + 3 stat tiles + review/retry) | DONE (simplified) | `result/result_summary_card.dart` — no multi-tier rating label / AI-writing-score / confetti: Flutter's `ExamAttempt` has no `rating`/`schreibenAiScore` field (GĐ1 scope = Lesen/Hören only, no Schreiben grading exists yet) |
| SmartExamReviewCard | DONE (simplified) | `result/smart_review_card.dart` — wrong/skipped/score metrics + jump-to-review + practice-by-section actions. Omitted web's `buildExamReviewInsights` (missed-vocab / per-section-wrong breakdown engine + "Ôn lỗi cá nhân" deep link with `source=wrong_answer`) — no vocab metadata on Flutter's question model and the daily-review route's query-param contract wasn't verified in this wave's budget |
| NextActionCard | **NOT BUILT** | Depends on `useNextAction` — a cross-feature "learn model" recommendation hook, not exam-specific data. No Flutter provider/endpoint exists for it; would need its own contract probe outside exam scope |
| AttemptHistoryList | DONE | `result/attempt_history_list.dart`, backed by additive `ExamAttemptStore.loadHistory()` + `examAttemptHistoryProvider` — reuses the **already-verified** `/user/exam-attempts?exam_id=&limit=` endpoint (same one `loadResult` already calls with `limit=1`), just requests more rows. No new endpoint |
| CommentSection | DONE | Same `ExamCommentSection` widget as the player's review mode |

## Data/contract changes (additive only, verified against real BE structs)

- `ExamQuestion.descriptionVi` (new optional field) + `exam_service.dart` parses BE
  `description_vi` (confirmed present in `internal/feature/exam/exam/exam_validator.go`
  `DescriptionVi *string`). Not part of `toJson`/persisted snapshots elsewhere.
- `ExamAttemptStore.loadHistory()` + `ExamAttemptSummary` — reuses existing
  `/user/exam-attempts` endpoint, additive method only.
- `exam_player_provider.dart`: extracted `_isCorrect` → top-level `isAnswerCorrect()`
  (same logic, now reusable by the new `ExamPlayerState.correctByAnswerKey` getter for
  nav-sheet coloring) + added `currentSectionQuestionOffset` getter. No behavior change
  to submit/draft/attempt flow.
- `ExamCommentSection` hits `/api/v1/comments` (generic comment table, already used
  elsewhere in the web app for exam/moment/community targets) — verified via
  `cmd/server/routes_user_public.go` route table, not curled live (backend wasn't
  running in this session), but the handler + route registration were read directly.

## Deletions

`exam_mode_toggle.dart`, `exam_progress_bar.dart`, `exam_section_tabs.dart`,
`exam_timer.dart`, `question_palette.dart` (all Flutter-only, no web counterpart in the
player — web has no mode toggle/section-tabs/palette-overlay pattern) +
`test/screens/exam/exam_mode_toggle_localization_test.dart`.

## l10n

~55 new ARB keys (vi/en/de) for header/reader-settings/footer/nav-sheet/comments/result,
`flutter gen-l10n` run. Reused existing keys wherever possible (`submitExam`,
`reviewExam`, `retryExam`, `examCorrect`, `exitExamTitle`/`exitExamBody`/`exit`,
`submitExamTitle`/`submitExamUnanswered`, `audioPlayLimitReached`, etc. — the
dialogs/audio-player files were untouched precisely because their copy already matches
web). German 200%-scale test passes (`exam_result_localization_test.dart`).

**Note (not mine to fix):** while writing this wave, concurrent agents were actively
adding ARB keys for decks/journey/flashcard screens; a `flutter analyze` at the end of
this session shows ~15 `undefined_getter` errors in `lib/screens/decks/**` and
`lib/screens/journey/**` for ARB keys that exist in only some locale files (mid-flight
edit in another workstream, confirmed via `git status` showing those directories
actively modified). Not caused by this wave — flagged per protocol, not fixed.

## Bug found + fixed (real, not test-only)

`ResultSummaryCard`'s score/motivation `Row` used
`crossAxisAlignment: CrossAxisAlignment.stretch` directly inside an unbounded-height
`Column`, which is a genuine Flutter layout bug (`BoxConstraints forces an infinite
height`) — it would have crashed/rendered incorrectly at runtime, not just in tests.
Fixed by wrapping in `IntrinsicHeight`. Found via `pumpAndSettle` hanging in the new
result-page test; root-caused with a bisection diagnostic test (not shipped), confirmed
via the actual `RenderFlex`/`BoxConstraints` assertion trace, not guessed.

## Validation

- `flutter analyze lib/features/exam`: **0 issues**.
- `flutter analyze` (full repo): 0 issues in files this wave touched; ~15 pre-existing
  errors in `lib/screens/decks/**`/`journey/**` from a concurrent workstream (see above).
- `flutter test test/features/exam test/screens/exam test/repositories/exam
  test/structure/release_live_data_guard_test.dart`: **all green** (updated
  `exam_question_renderers_test.dart` to wrap in `ProviderScope` since
  `QuestionCardFrame` is now a `ConsumerWidget`; rewrote
  `exam_result_localization_test.dart` for the new page structure).
- `flutter test` (full suite, 2 runs): 559-562 passed, 11-13 failed — **zero exam
  failures either run**; all failures are in `decks/`, `flashcard/`, `games/`,
  `mission/` (confirmed via `git status` these are being actively edited by concurrent
  agents right now, and `mission_session_provider_test.dart` fails to *compile* against
  the current `MissionSessionNotifier` API — not something this wave touched or can fix).
- Guard test (`release_live_data_guard_test.dart`): pass, no changes needed — the two
  page files were already in the guard list from GĐ1.
- Not tested against a live backend (backend wasn't running this session) — draft
  resume / nav-sheet / submit logic is unchanged from the already-verified GĐ1
  `exam_player_provider.dart`/`exam_attempt_store.dart`, and the new
  `loadHistory`/comment-fetch code paths were verified via widget tests with provider
  overrides, not a live curl. Flagged as a residual verification gap.

## Files

**Owned, modified:** `lib/features/exam/presentation/exam_practice_page.dart`,
`exam_result_page.dart`, `exam_player_provider.dart`, `widgets/question_card_frame.dart`,
`widgets/question_mc.dart`, `widgets/question_matching.dart`,
`widgets/question_richtig_falsch.dart`, `widgets/question_sprachbausteine.dart`,
`widgets/question_renderer.dart` (1-line format), `lib/features/exam/domain/exam_models.dart`,
`lib/features/exam/data/exam_service.dart`, `lib/features/exam/data/exam_attempt_store.dart`,
`lib/l10n/app_{vi,en,de}.arb` (+ generated), `test/features/exam/exam_question_renderers_test.dart`,
`test/screens/exam/exam_result_localization_test.dart`.

**New:** `lib/features/exam/presentation/widgets/mobile_player/{exam_player_palette,
reader_prefs, exam_practice_header, reader_settings_sheet, mobile_footer_bar,
mobile_nav_sheet, mobile_question_panel, exam_reading_translate_card,
exam_comment_section}.dart`, `lib/features/exam/presentation/widgets/result/
{result_summary_card, smart_review_card, attempt_history_list}.dart`.

**Deleted:** `widgets/exam_mode_toggle.dart`, `widgets/exam_progress_bar.dart`,
`widgets/exam_section_tabs.dart`, `widgets/exam_timer.dart`, `widgets/question_palette.dart`,
`test/screens/exam/exam_mode_toggle_localization_test.dart`.

## Unresolved questions

1. Should `ExamSection` gain a real `description`/`descriptionVi`/`wordBank` field
   (separating passage text from the first question's prompt) to reach true web parity
   on the reading pane (numbered paragraphs, lettered ads, word-bank chips)? This is a
   real domain-model/service change, deliberately deferred as out-of-scope for a
   UI-only wave — flagging for a follow-up if pixel parity on the reading pane matters.
2. NextActionCard needs a "next learning action" recommendation contract that doesn't
   exist in Flutter yet (cross-feature, not exam-specific) — worth a dedicated
   contract-probe pass, or drop from the acceptance bar for exam result.
3. Full range-based highlight (web's CSS Custom Highlight API parity) vs the shipped
   word-level tap-to-mark simplification — acceptable, or worth a follow-up investment?
4. Backend wasn't running this session, so `loadHistory`/comment endpoints were only
   verified via Go source read + widget-test provider overrides, not a live curl — worth
   a follow-up smoke test against a running backend before this ships to users.

Status: DONE_WITH_CONCERNS
Summary: Player + result mobile rebuild complete to web parity for header/footer/nav-sheet/whole-Teil-scroll/dark-mode shell + all 6 in-scope extras (reader settings, highlight, word-lookup, translate, locked-audio, comments); full test suite green (0 exam failures across 2 runs), found+fixed a real Flutter layout bug along the way.
Concerns/Blockers: NextActionCard dropped (no data source); reading-pane translate is a simplified collapsible block, not true web-parity paragraph swap (blocked on a domain-model change I judged out of UI-only scope); highlight is word-level not range-based; endpoints not curl-verified live (backend wasn't running).
