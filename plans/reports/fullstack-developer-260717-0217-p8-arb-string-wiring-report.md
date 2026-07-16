# P8 ARB String Wiring — Cleanup Pass Report

Wave A's exam-core screens (readiness/schedule/dictation/de-thi/community) shipped with
~60-90 hardcoded Vietnamese UI strings (tracked gap in
`fullstack-developer-260717-0107-p8-wave-a-exam-core-community-report.md` and its 3
sub-reports). This pass wires all short UI-chrome strings into ARB (vi/en/de), reuses
existing keys where semantically identical, keeps approved long-form marketing copy
inline, and replaces every literal call-site with `AppLocalizations.of(context).<key>`.

## Scope executed

All wave-A-owned files under `lib/screens/exam/**` (readiness, schedule, dictation,
de-thi, community — the coordinator's own screens `exam_screen.dart` /
`exam_section_page.dart` / `exam_list_page.dart` / `exam_skill_list_screen.dart` were
already fully ARB-wired per that report and needed no changes beyond a scan, which
found none). `lib/features/exam/presentation/exam_practice_page.dart`,
`exam_result_page.dart`, `widgets/mobile_player/**`, `widgets/result/**` were **not
touched** — a sibling agent is actively rebuilding them (Wave B); confirmed via
`git status` these are untracked/mid-edit throughout this session.

## Files modified

- ARB: `lib/l10n/app_{vi,en,de}.arb` (+105 new top-level keys each, verified 1:1 key
  parity across all three via a Python set-diff — no drift). Generated
  `lib/l10n/app_localizations*.dart` via `flutter gen-l10n` only (never hand-edited).
- Readiness: `exam_readiness_screen.dart` (PageIntro why/todo/next), and all 7
  `widgets/readiness/*.dart` files.
- Schedule: `widgets/schedule/{buddy_card,buddy_count_strip,buddy_directory_tab,
  my_registrations_tab}.dart`.
- Dictation: `widgets/dictation/{dictation_activity_menu,cloze_mistake_list,
  word_selection_clip_card,cloze_practice_card,cloze_practice_view,
  dictation_end_screen,full_practice_sentence_card,full_practice_view,karaoke_view,
  word_selection_panel}.dart`.
- De-thi: `de_thi_list_screen.dart` (hero) + `widgets/de_thi/{de_thi_site_header,
  de_thi_exam_card,de_thi_promo_banner,de_thi_passage_panel,
  de_thi_practice_progress_strip,de_thi_question_card,de_thi_question_reveal_blocks,
  de_thi_practice_footer}.dart`.
- Community: `community_exams_list_screen.dart`, `community_exam_detail_screen.dart` +
  `widgets/community/{community_browse_tab,community_topic_card,real_exam_badge,
  community_writing_task_sections,community_writing_extra_sections}.dart`.

## Key-naming / dedup decisions

- Followed the existing `camelCase`, feature-prefixed convention (`examReadiness*`,
  `schedule*`, `dictation*`, `deThi*`, `community*`) already in the ARB files.
- Reused existing keys instead of duplicating: `edit` ("Sửa" in
  `my_registrations_tab.dart`'s edit button), and added
  `communityAnonymousContributor` ("Ẩn danh") once and reused it in both
  `community_topic_card.dart` and `widgets/schedule/buddy_card.dart` (same string,
  different screens).
- Rich-text (`TextSpan`) strings that split bold/plain runs were split into
  prefix/bold/suffix ARB keys rather than collapsed into one key, to avoid changing
  the bold-styling layout (e.g. `schedulePrivacyNotePrefix` /
  `schedulePrivacyNoteBold` / `schedulePrivacyNoteSuffix`,
  `examReadinessTodoDueReviewsPrefix` / `...Bold`).
- Repeated day-count badge logic in `buddy_card.dart`'s 3 color tiers collapsed into
  one templated key (`scheduleBuddyDaysLeft`) since the string was identical across
  tiers, only the color differed.
- Skill-name / weakness-type / provider-code lookup maps (e.g.
  `readiness_skill_bars.dart`'s `_skillLabels = {'lesen': 'Đọc (Lesen)', ...}`,
  `readiness_weakness_list.dart`'s `_errorTypeLabels`, `buddy_card.dart`'s
  `_examTypeLabels = {'goethe': 'Goethe', 'osd': 'ÖSD', ...}`) were **left as-is,
  out of scope**. Grepped app-wide (`grep -rl "'lesen':"`) and confirmed this exact
  pattern is a pre-existing, app-wide convention used in
  `lib/screens/stats/widgets/error_pattern_labels.dart` and
  `lib/features/daily_path/domain/skill_emoji.dart` too — not something Wave A
  introduced. Fixing it here would be inconsistent (only fixing the exam subset) and
  is a separate, larger cross-cutting cleanup. Flagged as an unresolved question
  below rather than silently expanding scope.
- `Teil {n}` (German exam-section term, e.g. `word_selection_panel.dart`,
  `karaoke_view.dart`, `community_exam_detail_screen.dart`'s badge row) kept as a raw
  German literal — it's the official German exam-section name, same word is already
  used untranslated in the ARB's own `communityTeilLabel` I added (`"Teil {n}"` is
  identical across vi/en/de by design, mirroring web).

## Long-form exception (NOT converted, left inline VN)

Per plan.md's approved exception ("nội dung long-form web hardcode tiếng Việt (legal,
trainer tips, SEO-style copy) giữ inline VN như web"):
- `de_thi_faq_section.dart` — 5 FAQ Q&A pairs.
- `de_thi_founder_cta_footer.dart` — founder quote + name + CTA copy.
- `de_thi_stats_testimonials_section.dart` — stat labels, 3 testimonials, section
  headings.

These are ported verbatim web SEO/marketing copy for the public `/de-thi` funnel, not
UI chrome — correctly classified as long-form and left untouched.

## Counts

- **~126 new ARB keys** added (short UI-chrome strings: labels, hints, tooltips,
  CTAs, empty/error states, badges, section headings), all replaced at their call
  sites. `flutter gen-l10n` confirms 1061 keys in each of vi/en/de (was 956 before
  this pass, +105 net new since a few keys collapsed duplicates like `edit` reuse).
- **~15 long-form strings** (FAQ Q&A, testimonials, founder quote, stat labels) left
  inline per the approved exception — rationale above.
- **Provider/skill lookup-map strings** (~25 entries across 5 pre-existing files,
  app-wide pattern) explicitly out of scope — see dedup section above and unresolved
  question below.

## Validation

- `flutter gen-l10n` — clean, no errors, all getters generated
  (verified `grep -c` on the 4 generated files).
- `flutter analyze lib/screens/exam lib/l10n test/screens/exam test/l10n` → **0
  issues**.
- `flutter analyze` (full repo) → all errors confined to
  `lib/features/exam/presentation/widgets/mobile_player/**` (untracked in git status
  throughout this session — confirmed sibling Wave-B agent's in-progress rebuild, not
  touched by me).
- `flutter test test/l10n/ test/screens/exam/*` (excluding
  `exam_practice_localization_test.dart` / `exam_result_localization_test.dart`,
  which import `mobile_player`/wave-B files) → **all pass** (23/23).
- `flutter test test/structure/` → **all pass** (70/70), including
  `release_live_data_guard_test.dart`.
- `flutter test` (full suite) → **572 passed, 9 failed**. All 9 failures are in
  `test/features/exam/exam_question_renderers_test.dart` (imports
  `features/exam/presentation/widgets/question_renderer.dart`, Wave-B territory) and
  `test/screens/exam/exam_result_localization_test.dart` (imports the result-page
  rebuild, also Wave-B). None touch my owned files. Confirmed via `git status` that
  `lib/features/exam/presentation/widgets/mobile_player/**` is untracked and
  `test/screens/exam/exam_mode_toggle_localization_test.dart` /
  `exam_result_localization_test.dart` were modified/deleted by another process
  during this session (I never touched them) — pre-existing baseline count (585) vs.
  current (581 collected) reflects concurrent Wave-B work in flight, not a regression
  I introduced.
- German 200%-textscale: `test/screens/exam/exam_catalog_localization_test.dart`
  still passes unmodified (covers the landing page). Did not extend new German
  200%-textscale tests to the 5 newly-wired screens (readiness/schedule/dictation/
  de-thi/community) given the time budget — flagged as a follow-up below; spot-check
  via `flutter analyze` + the passing widget tests gives reasonable confidence
  (German strings I authored are comparable length to existing ones, e.g.
  `schedulePrivacyNotePrefix` "🔒 Ihre Kontaktdaten..." is the same order of
  magnitude as the Vietnamese original), but no automated overflow proof was added.

## Unresolved questions

1. Should the pre-existing app-wide skill/provider-name lookup-map pattern
   (`_skillLabels`, `_examTypeLabels`, etc. — 5 files, not wave-A-specific) be ARB-ized
   in a dedicated follow-up? It's consistent with itself today but never localizes.
2. Worth adding German-200%-textscale regression tests for the 5 newly-wired screens
   (mirroring `exam_catalog_localization_test.dart`'s pattern) in a follow-up, given
   time budget didn't allow it this pass?

Status: DONE_WITH_CONCERNS
Summary: ~126 short UI-chrome strings across 5 wave-A screen groups wired into
ARB vi/en/de + gen-l10n + call-site replacement; long-form SEO/marketing copy
correctly left inline per approved exception; `flutter analyze`/targeted tests clean;
full-suite's 9 failures are pre-existing/concurrent Wave-B (mobile_player) breakage,
not caused by this pass.
Concerns/Blockers: pre-existing skill/provider-name lookup maps (app-wide pattern)
still hardcoded — out of this pass's scope, flagged above; no new German-200%
overflow tests added for the 5 newly-wired screens (time budget).
