# P9 Wave 4 (FINAL) — Sprint v2 + telc schreiben-view convergence

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-09-exam-writing.md` (§4 + §5)

## Scope executed

§4 Sprint v2 (4 screens) + §5 telc `schreiben-view` convergence (redirect, no
new screen) + the 3 deletions (`ai_writing_practice_page.dart`,
`goethe_b1_writing_page.dart`, `writing_topics_list.dart`) + guard-list
updates + ARB + contract matrix/changelog.

## Files

**New — `lib/features/writing/domain/sprint/`**
- `sprint_types.dart` — `SRMode`, `SRRating`, `SRCardState`, `SprintEssayResult`/`SprintEssayErrorItem` (web `MockResult`, renamed — see Deviations), `SRQueue`, plus read-only content DTOs `SprintTopicData`/`SpeedrunContent`/`Outline3`/`MiniModel`/`RedemittelItem`/`SprintCluster`.
- `sm2_scheduler.dart` — `scheduleMarathon`/`scheduleDaily`/`applySrRating`/`intervalLabel`, port of `sm2-scheduler.ts`. Added a 3650-day interval cap not present in web (see Deviations).
- `sr_card_queue.dart` — `buildQueue`/`nextDueCard`/`rateCard`/`queueStats`/`pickSprintEssayTopics` (web `pickMockTopics`)/`setSprintEssayResult`/`setEssayDraft`.
- `redemittel_aggregator.dart` — `aggregateTopRedemittel`/`groupByFunction`/`kRedemittelFunctionLabels`.
- `sr_keyword_match.dart` — `extractKeywords`/`normalizeGerman`/`levenshtein`/`checkKeywordMatch`/`matchBullet` (merge of web's `keyword-extractor.ts` + `keyword-matcher.ts`).
- `common_mistakes.dart` — `kCommonMistakes`/`kVerbKasusReference` (static DE/VI pedagogical content, approved inline exception).

**New — `lib/features/writing/data/sprint/`**
- `sprint_repository.dart` — `SprintRepository.fetchClusters`/`fetchTopicsForSlugs`, `SprintGradingRepository.grade` + providers.
- `sr_queue_store.dart` — `SrQueueStore` (SharedPreferences JSON persistence, key `sprint_goethe_b1_writing_sr_queue_v2`).

**New — screens `lib/screens/exam/writing/sprint/`**
- `exam_writing_sprint_page.dart` — mode picker (Marathon/Daily) + Start/Resume/Start-fresh CTAs + links to mini-exam + cheatsheet.
- `exam_writing_sprint_session_page.dart` — sticky progress bar + `SrCard` + session-done state.
- `exam_writing_sprint_mock_page.dart` — dot progress, `EssayInput`, `EssayResultCard`, AI grading via `POST /sprint/grade-essay`.
- `exam_writing_sprint_cheatsheet_page.dart` — cluster overview + 3 Teil tables + Redemittel top-40 + common mistakes, single scrollable page.
- `widgets/{sr_mode_picker,sr_rating_bar,sr_card,sr_card_front,sr_card_back,essay_input,essay_result_card,cheatsheet_overview_section,cheatsheet_redemittel_mistakes_section}.dart`.

**Modified**
- `lib/navigation/routes/exam_routes.dart` — nested `sprint`/`sprint/session`/`sprint/thi-thu`/`sprint/cheatsheet` under `goethe-b1/writing`; `a-rap` gains `schreiben/:slug` redirect; `writing-topics` (mock, deleted) now redirects to `writing`.
- `lib/navigation/routes/ai_routes.dart` — `/ai-tutor/writing` (mock, deleted) now redirects to `/luyen-viet`. **Cross-boundary edit**: this file is P12's, not mine — unavoidable since deleting `ai_writing_practice_page.dart` was explicitly in my task scope and this was its only remaining reference; kept to a 2-line surgical diff with a comment.
- `lib/l10n/app_{vi,en,de}.arb` + generated `app_localizations*.dart` — 57 new `writingSprint*` keys, `flutter gen-l10n` run last, 3-way parity verified (2020 keys × 3 locales, JSON-valid).
- `test/structure/release_live_data_guard_test.dart` — added 17 new release-visible file paths (8 domain/data + 9 screen/widget), noted the 3 deletions in a comment. Guard NOT weakened.
- `docs/flutter-api-contract-matrix.md` — new "P9 wave 4" section (3 endpoint rows + telc-convergence note + route-naming-deviation note + mindmap-risk-resolved note).
- `docs/api-changelog.md` — one changelog row.

**Deleted**
- `lib/screens/ai/ai_writing_practice_page.dart`
- `lib/screens/exam/goethe_b1_writing_page.dart`
- `lib/screens/exam/widgets/writing_topics_list.dart`

**New tests**
- `test/features/writing/sprint/{sm2_scheduler,sr_card_queue,sr_queue_store,sr_keyword_match,redemittel_aggregator}_test.dart` — 32 unit tests.
- `test/screens/exam/writing/sprint/{exam_writing_sprint_page,exam_writing_sprint_cheatsheet_page,exam_writing_sprint_mock_page}_test.dart` — 3 widget tests.

## Per-screen status

- **exam-writing-sprint** (mode picker): DONE. Marathon/Daily cards, resume detection on mount, start/start-fresh/resume all persist through `SrQueueStore`, links to mini-exam + cheatsheet.
- **exam-writing-sprint-session**: DONE. Sticky progress header, `SrCard` front (task+points+3 outline textareas)→back (keyword-match result+outline diff+audio+mini-model+Redemittel+rating bar) phase machine, redirects to entry if no queue, session-done celebration state.
- **exam-writing-sprint-mock**: DONE. Dot progress, `EssayInput` (50–120 word target, debounced autosave), AI grading (`POST /sprint/grade-essay`), `EssayResultCard` (rubric bars, error list, essay toggle, re-grade). Route segment renamed `thi-thu` (see Deviations).
- **exam-writing-sprint-cheatsheet**: DONE, content-complete. Cluster overview, 3 Teil tables, Redemittel top-40 grouped by function, common-mistakes + verb/Kasus reference. No print pagination (Flutter has no print pipeline) — single scrollable page instead of web's `window.print()` A4 layout.
- **schreiben-view (telc legacy)**: Converged, not ported. `GoRoute` redirect from `/exam/telc-b1/a-rap/schreiben/:slug` → `/exam/telc-b1/writing/{slug}/practice` (W1's `WritingPracticePanel` via W3's generic writing-level-practice flow). Falls back to that page's own graceful not-found state if the slug isn't in the official telc-b1 topic set.

## Deviations (documented, not silent)

1. **`MockResult`/`MockErrorItem`/`mock-result-card.tsx` renamed to `SprintEssayResult`/`SprintEssayErrorItem`/`EssayResultCard`** and the mini-exam route segment renamed from web's literal `mock` to `thi-thu`. Reason: `test/structure/release_live_data_guard_test.dart` forbids the literal word "mock" anywhere in release-visible screen source (`\b(?:mock\w*|fixture\w*|placeholder\w*)\b`, case-insensitive) — a blunt-but-mandatory guard I was told not to weaken. Web's own naming would trip it. All identifiers/route segments renamed; UI-facing copy (button labels, screen titles) is unaffected since those come from ARB, not hardcoded Dart strings.
2. **SM-2 daily interval capped at 3650 days (~10 years)**, not present in web. Discovered via a unit test: unbounded consecutive "easy" ratings grow the interval geometrically; JS `Date` tolerates arbitrarily large offsets silently, but Dart's `DateTime.add` throws `RangeError` past ~275,000 years from epoch reached surprisingly fast at this growth rate. Cap is a defensive fix with zero effect on any realistic B1-exam-prep review horizon.
3. **`cluster-mindmap`/`global-mindmap` risk resolved as a non-issue, not built.** Verified via `grep` across `thamkhao/deutschtiger-frontend/src/pages` and `src/app/routes.tsx`: neither markmap/mermaid component is imported by any currently-live page or route — dead code from the retired Sprint v1 flow (`85aadef`). No WebView/custom-tree decision was needed since there is nothing to port for the *current* Sprint v2 UI.
4. **`SrRatingBar` is not CSS-sticky** at the bottom of the viewport (web: `sticky bottom-0`). It renders at the natural end of the back-face scroll content instead — Flutter has no direct sticky-within-scrollview primitive without extra plumbing (`Stack`+manual positioning), and the back face is short enough on a phone that the rating bar is reachable without much scrolling. Named follow-up if pixel parity is wanted.
5. **`MockResultCard`'s inline `<mark>` essay-highlighting is simplified** to a plain toggle + the existing itemized error list (already shows each wrong/correction/explanation triple) instead of highlighting error snippets inline inside the rendered essay text. Flutter has no cheap equivalent to the web version's DOM `indexOf`-based `<mark>` wrapping without a custom `TextSpan` range-finder; the itemized list already surfaces the same information.
6. **`SprintTopicData` is a new, richer DTO**, not an extension of W1/W2's `GoetheB1WritingTopicSummary`. The `/goethe-b1-writing/teil/{n}` endpoint (already Live per W1/W2) embeds the FULL topic payload including `speedrun`, which the existing summary DTO doesn't model. Adding a parallel Sprint-only DTO avoids widening a contract 2 prior waves already established for a different purpose.
7. **telc `schreiben-view` is a redirect, not a ported screen** — its content was a static JSON file bundled only in web's `public/data/exams/telc/b1/a-rap/{slug}/schreiben.json`, confirmed via `grep` to have zero backing handler anywhere in `thamkhao/deutschtiger-backend`. Porting it would mean hardcoding exam content into a release screen, which the plan's data rules forbid; the plan's own §5 decision endorses converging onto `WritingPracticePanel` instead.
8. **`ai_routes.dart` touched** (P12's file, not mine) — unavoidable 2-line diff to remove the now-dead `ai_writing_practice_page.dart` import/route and add a redirect; deletion was explicitly in my task's "Xóa" scope and this was the file's only remaining reference.

## Bug found + fixed during testing

`ExamWritingSprintMockPage._pickTopics` originally called `setState()` from
inside the `AsyncValue.data` callback invoked directly from `build()` — an
illegal "setState() during build" call that would throw on first frame once
`sprintTopicsProvider` resolved. Caught by a widget test
(`exam_writing_sprint_mock_page_test.dart`) written specifically to exercise
this path; fixed by mutating the picked-topics field directly (no `setState`)
since the same build pass reads it immediately after.

## Validation

- `flutter analyze` (repo-wide): **0 errors**. Same pre-existing info/warning lints as before this wave (`use_null_aware_elements`, `use_build_context_synchronously`, `prefer_initializing_formals` — none touch my files).
- `flutter test test/structure/release_live_data_guard_test.dart test/features/writing test/screens/exam test/l10n`: **116/116 passed** (35 new: 32 unit + 3 widget for this wave; W1-W3's 81 still green).
- SR queue restart-safety proven directly: `sr_queue_store_test.dart` persists a queue via one `SrQueueStore` instance, then loads it via a *brand-new* `SrQueueStore` instance (simulating a fresh app process) and asserts the absolute `due` timestamp, `seenCount`, and `lastRating` survive unchanged.
- `flutter gen-l10n`: regenerated cleanly, 3-locale key parity verified (2020 keys × vi/en/de, JSON-valid).
- Flow check: W1-W3's pick-teil → topic → detail → practice → grade → session-detail path is untouched by this wave (read-only per file-ownership boundary) and its existing tests (81 tests across `test/screens/exam/writing`, `test/features/writing`) still pass unchanged after the route-file edits and deletions.

## Unresolved questions

1. Route-segment rename `mock`→`thi-thu` (deviation #1) — worth a matching rename on the web side someday for cross-platform URL consistency, or accepted as a permanent Flutter-only naming difference? Not a functional gap either way.
2. `SrRatingBar` non-sticky (deviation #4) — worth building a proper sticky-bottom wrapper in a later polish pass, or is natural-scroll-position acceptable given phone screen sizes?
3. Should the release-live-data guard's regex (`\bmock\w*\b`) get a documented allowlist mechanism (e.g. an inline `// guard-allow: mock` comment) for cases like this where "mock" is legitimate product vocabulary (mock exam) rather than fixture data? Currently the only fix is renaming everything, which is what I did.

Status: DONE
Summary: All 4 Sprint v2 screens (mode picker, SR session, mini-exam, Redemittel cheatsheet) built and routed under `/exam/goethe-b1/writing/sprint/**`; telc `schreiben-view` converged onto W1's `WritingPracticePanel` via a redirect per the plan's §5 decision; all 3 planned deletions done with their 2 remaining route references redirected; SR persistence proven restart-safe via absolute timestamps (no background timer); cluster-mindmap/global-mindmap risk resolved as dead code, nothing to port; 0 analyze errors, 116/116 tests green including the un-weakened release-live-data guard.
Concerns/Blockers: none blocking. 8 documented deviations above (mostly the mandatory "mock"-word rename forced by the guard, plus 2 UI-simplifications) are candidates for later polish; none are silent data loss or contract violations. This is the plan's final build wave for Phase 9 — all 5 numbered sections (§1-§5) plus the "Xóa" cleanup are now complete across W1-W4.
