# P9 Wave 3 — Luyện-viết generic suite (6 screens)

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-09-exam-writing.md` (W3 only, §3)

## Scope executed

All 6 W3 screens built and routed. None dropped. Screens live at
`lib/screens/exam/writing/**` (flat, sibling to W1/W2's files — matches W2's
established convention, no parallel `luyen_viet/` structure).

1. `writing-catalog` (`/luyen-viet`) — 3 tabs, rubric sheet, criteria trend, filter bar, submission list.
2. `writing-level-topics` (`/exam/:providerLevel/writing`).
3. `writing-level-practice` (`/exam/:providerLevel/writing/:slug/practice`).
4. `writing-community-topic` (`/exam/:providerLevel/writing/community/:teil/:slug`) — version selector, add-version wizard, comments.
5. `writing-custom` (`/luyen-viet/tu-nhap`) — chip selectors, 2 textareas, ✨ AI-polish, 2-phase flow.
6. `writing-session-detail` (`/writing-practice/:id`) — read-only + "Luyện lại" + grading timeline.

## Files

**New — `lib/features/writing/` (additive to W1/W2)**
- `domain/writing_offering.dart` — `WritingOffering`/`kWritingCatalog`/`findWritingOffering` (port of web `writing-catalog.ts`).
- `domain/official_writing_topic.dart` — `OfficialWritingTopic` DTO for `GET /exams/official` (already present on disk when I started this wave, matching content I'd have written — kept as-is).
- `domain/community_writing_topic.dart` — write-capable `CommunityWritingTopic` DTO (id/userId/versions/voteCount/isVoted/defaultVersionId/…), a deliberate additive sibling to P8's read-only `CommunityExamTopic` (`data/exam/exam_ecosystem_models.dart`), not an edit to that file.
- `domain/writing_exam_id_parser.dart` — `parseWritingExamId`, `buildOfficialWritingExamId`, `buildCustomWritingExamId`, `generateCustomWritingSlug`, `isCustomWritingSet`, `teilFromWritingSet` (port of web `exam-id-builder.ts` parse side; W1's `writing_exam_id.dart` only had the Goethe-B1 builder).
- `domain/writing_submission_meta.dart` — `getWritingSubmissionMeta` (port of web `writing-submission-meta.ts`).
- `data/official_writing_topic_repository.dart` — `GET /exams/official`, degrades to `[]` on error.
- `data/community_writing_write_repository.dart` — canonical+versions read, `generate`/`create`/`upsertMyVersion`/`vote`/`unvote`/`report`.
- `presentation/widgets/writing_comment_section.dart` — `WritingCommentSection`, reuses the existing generic `/comments?target_type=` endpoint (2nd call site, same pattern as `ExamCommentSection`).
- `presentation/writing_practice_panel.dart` — 1-line fix: "Bài của tôi →" link now `context.push('/luyen-viet')` (resolves W1 deviation #5, route now exists).

**New — screens `lib/screens/exam/writing/`**
- `writing_catalog_page.dart` + `widgets/hub/{writing_hub_tabs,writing_start_tab,writing_community_tab,examiner_rubric_sheet}.dart` + `widgets/hub/submissions/{writing_submission_list_item,writing_submissions_filter_bar,writing_criteria_trend}.dart` + `writing_submissions_tab.dart`.
- `writing_level_topics_page.dart`, `writing_level_practice_page.dart`.
- `writing_community_topic_page.dart` + `widgets/community_topic/{community_version_selector,community_version_card,community_add_version_sheet}.dart`.
- `writing_custom_page.dart`.
- `writing_session_detail_page.dart` + `widgets/session_detail/grading_attempt_timeline.dart`.

**Modified**
- `lib/navigation/routes/exam_routes.dart` — new `luyenVietRoutes` list (`/luyen-viet`, `/luyen-viet/tu-nhap`, `/writing-practice` redirect, `/writing-practice/:id`) + nested `writing`/`writing/:slug/practice`/`writing/community/:teilNum/:slug` under the generic `:providerLevel` branch (append-only, before the `:slug` catch-all, same pattern as `a-rap`).
- `lib/navigation/app_router.dart` — 1-line append `...luyenVietRoutes,` (same splice pattern as the existing `...deThiRoutes,`).
- `lib/l10n/app_{vi,en,de}.arb` + generated `app_localizations*.dart` — 78 new `writing*` keys, `flutter gen-l10n` run last, 3-way parity verified (2168 keys × 3 locales).
- `test/structure/release_live_data_guard_test.dart` — added all 25 new release-visible file paths.
- `docs/flutter-api-contract-matrix.md` — new "Writing / Schreiben ecosystem (P9 wave 3)" section, 8 endpoint rows.
- `docs/api-changelog.md` — one changelog row.

**New tests**
- `test/features/writing/{writing_exam_id_parser,writing_submission_meta}_test.dart` — 11 unit tests.
- `test/screens/exam/writing/{writing_catalog_page,writing_level_topics_page,writing_session_detail_page}_test.dart` — 6 widget tests.

## Per-screen status

- **writing-catalog**: DONE. 3 tabs, "📋 Cách chấm" rubric bottom sheet (static VN copy, approved exception), criteria trend (simplified — see deviation), filter bar (provider/level/teil chips + search + sort), pagination, empty/no-match states.
- **writing-level-topics**: DONE. Official topic list (live `GET /exams/official`) + community section + "➕ Đóng góp đề" → tu-nhap prefill. Goethe B1 redirects to its dedicated feature (matches web).
- **writing-level-practice**: DONE. Thin `WritingPracticePanel` wrapper, topic found by slug from the already-fetched offering topic list (same approach as web).
- **writing-community-topic**: DONE. Version selector (chip row), version card (task/points/contributor/vote/report/add-version), comments (reused generic endpoint). Add-version is a simplified single-step sheet, not web's multi-step wizard (see deviation).
- **writing-custom**: DONE. Provider/level/Teil chip selectors, 2 textareas, ✨ AI-polish toggle (calls the community `generate` endpoint, same as web's polish call), 2-phase flow (setup → practice), "📤 Đóng góp đề này cho cộng đồng".
- **writing-session-detail**: DONE. Read-only task/answer blocks, score badge, "Luyện lại" (routes back to the right practice screen or re-opens tu-nhap with a prefill), grading-attempt timeline (hidden until ≥2 attempts, matches criteria-trend's honest-min-sample precedent).

## Deviations (documented, not silent)

1. **`writing-community-topic`'s create/add-version UI is a single-step sheet** (`community_add_version_sheet.dart`: task textarea + points textarea + AI-polish toggle), not web's multi-step `CommunityTopicCreateWizard` (title/task/points/exam-date/exam-location as separate steps). Same backend endpoints (`create`/`upsertMyVersion`), simpler UI. Named follow-up if pixel parity is wanted here.
2. **Vote self-block / rate-limit errors surface as a generic snackbar**, not web's specifically-worded toasts ("Không thể tự vote đề của bạn" etc.) — the backend messages are available via `ApiException.message` but I didn't wire per-code copy this wave.
3. **`WritingCriteriaTrend` and the submissions filter bar are simplified** vs web (same data/thresholds — ≥2 graded submissions, weakest-first sort, 4 criteria — but plain progress bars instead of a chart library, and single-select chips instead of web's multi-select-capable facets). Functionally equivalent, visually simpler.
4. **AI-generate 503 (`AI not configured`) has no dedicated retry-with-cooldown UX** for the community-write path — `WritingRepository.gradeSchreiben`/`rewriteSchreiben` map this to `AiUnavailableException`; `CommunityWritingWriteRepository.generate` does not (surfaces as a plain error string). Named follow-up.
5. **`PageIntro pageKey="luyen-viet"`** (web's orienting strip on the catalog page) omitted — that P1 primitive lives under `lib/shared/widgets/` and wiring a new `pageKey` felt like scope creep on a contested shared widget without a clear "my file" boundary; the tab bar + rubric sheet cover the same orienting job. Named follow-up.
6. **Sprint card on the "Bắt đầu" tab is inert** (shows a "coming soon" snackbar) — matches W1/W2's precedent for cross-links into not-yet-built W4 scope.
7. **`community_add_version_sheet.dart`'s "AI polish" reuses the community `generate` endpoint's response shape directly** (`generated_data.task.de`/`taskAnalysis.points[].de`) rather than adding a new grading-focused polish endpoint — this is the same endpoint web's `writing-custom-page.tsx` calls for its own AI-polish, so no new contract was needed.
8. A few files run past the 200-LOC guideline after splitting as far as reasonably cohesive: `writing_custom_page.dart` (~340, single 2-phase state machine — same shape/reasoning as W1's `writing_practice_panel.dart` justification), `writing_level_topics_page.dart` (~250, one screen + not-found fallback), `writing_submissions_tab.dart` (~230, filter+sort+paginate state machine).

## Validation

- `flutter analyze` on all touched/new files: **0 errors**. A handful of pre-existing-style `info` lints (`use_null_aware_elements` on the `if (x != null) 'key': x` pattern already used throughout W1/W2's repositories, `use_build_context_synchronously` on `mounted`-guarded async callbacks) — left as-is for consistency with the rest of the codebase.
- Repo-wide `flutter analyze`: 0 errors anywhere (checked after this wave's edits landed, including concurrent P8/P10/P11/P12 in-flight changes visible in the tree).
- `flutter test test/structure/release_live_data_guard_test.dart test/features/writing test/screens/exam/writing test/l10n`: **55/55 passed** (17 new: 11 unit + 6 widget).
- `flutter gen-l10n`: regenerated cleanly, 3-locale key parity verified (2168 keys × vi/en/de, JSON-valid).

## Concurrent-agent note

Mid-session I found `lib/features/writing/domain/official_writing_topic.dart`
already present on disk with content essentially identical to what I was
about to write (same fields, same `taskPromptDe`/`writingPoints` getter
pattern) — before I had written it myself. `test/structure/
release_live_data_guard_test.dart` was also updated externally once (other
phases' entries appended) mid-session. Both are consistent with the "many
concurrent phase agents append-only editing shared files" protocol — no
conflict, my entries were intact in both cases after the external edits, and
I proceeded without special handling beyond re-checking before my own edits.

## Unresolved questions

1. Should the community add-version flow get the full multi-step wizard
   (deviation #1) in a follow-up, or is the single-sheet version an accepted
   permanent simplification for mobile?
2. `AI not configured` (503) on the community `generate` endpoint — worth
   mapping to the same `AiUnavailableException` retry UX `WritingRepository`
   uses (deviation #4), or is a plain error acceptable since this is a
   lower-traffic path than the main grading flow?
3. `PageIntro` on `/luyen-viet` (deviation #5) — who owns wiring new
   `pageKey`s into that P1 shared widget across phases; is there a
   coordination point for this, or should each phase just do it directly?

Status: DONE
Summary: All 6 W3 luyện-viết screens built and routed, reusing W1's `WritingPracticePanel` and P8's read-only community-exam stack unmodified; new additive write-capable community-writing repository (generate/create/vote/report/add-version) backs the custom-prompt and community-topic-detail write flows against 8 newly-documented live backend endpoints; 78 new ARB keys; 0 analyze errors; 55/55 tests green (17 new).
Concerns/Blockers: none blocking. 8 documented deviations above (mostly UI-simplification of the community write flows and criteria-trend chart) are candidates for a later polish pass; none are silent data-loss or contract violations.
