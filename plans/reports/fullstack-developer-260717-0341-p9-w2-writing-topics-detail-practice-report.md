# P9 Wave 2 — Writing topic-list, detail reader, practice wrapper, community list

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-09-exam-writing.md` (W2 only, §2 c–f)

## Scope executed

All 4 W2 screens built and wired to routes. None dropped.

1. `goethe-b1-writing-topic-list` — `/exam/goethe-b1/writing/:teilNum`
2. `goethe-b1-writing-detail` — `/exam/goethe-b1/writing/:teilNum/:slug`
3. `goethe-b1-writing-practice` — `/exam/goethe-b1/writing/:teilNum/:slug/practice`
4. `goethe-b1-community-writing-list` — `/exam/goethe-b1/writing/community/:teilNum`

## Files

**New domain (additive to `lib/features/writing/`)**
- `domain/writing_exam_id.dart` — `buildGoetheB1WritingExamId` (resolves W1 unresolved Q1).
- `domain/goethe_b1_writing_topic_summary.dart` — `GoetheB1WritingTopicSummary`, `GoetheB1WritingTeilData`.
- `domain/goethe_b1_writing_topic.dart` — full topic-detail DTO, composes:
  - `domain/writing_topic/{audio_sentence,task_section,phrases_samples_models,grammar_wortschatz_mistakes,uebungen_exercise,writing_source}.dart`.
- `domain/goethe_b1_writing_access.dart` — free-tier gating (port of web `access.ts`).
- `domain/goethe_b1_writing_leaderboard_entry.dart`.
- `presentation/widgets/writing_audio_play_button.dart` — shared exclusive-play button (`AudioService`-backed).

**Modified (additive)**
- `data/goethe_b1_writing_repository.dart` — added `fetchTeil`, `fetchTopic`, `fetchResultsForTeil`, `upsertResult`, `fetchLeaderboard` + matching providers.

**New screens — `lib/screens/exam/writing/`**
- `goethe_b1_writing_topic_list_page.dart` (+ `widgets/topic_list/{topic_row,leaderboard_card,community_folder_card}.dart`)
- `goethe_b1_writing_detail_page.dart` (+ `widgets/detail/*` — 16 files: header, provenance, task, task-analysis, text-structure, useful-phrases, sample-sentences, model-answers, grammar-focus, wortschatz, common-mistakes, uebungen-section, floating-toc, complete/lock views, typing-practice-start-card, collapsible-section, vi-translation-toggle)
- `widgets/uebungen/*` — cloze/word-order/match/error-correction/mini-write exercise views + shared result banner (6 files)
- `widgets/typing_practice/{collect_practice_sentences,typing_practice_sheet}.dart`
- `goethe_b1_writing_practice_page.dart` (+ `widgets/practice/practice_prompt_card.dart`)
- `goethe_b1_community_writing_list_page.dart` — thin reuse of P8's `communityExamListProvider`/`CommunityTopicCard`/`CommunityExamDetailScreen`.

**Routes** — `lib/navigation/routes/exam_routes.dart`: nested `writing` → `community/:teilNum`, `:teilNum` → `:slug/practice`, `:slug` (append-only, 2-line-comment-documented diff).

**l10n** — `lib/l10n/app_{vi,en,de}.arb` + regenerated `app_localizations*.dart`: 86 new `writing*` keys (search/topic-list/detail-header/all section titles/exercises/typing-practice/lock/complete-CTA copy). `flutter gen-l10n` run last, 3-way parity verified (86 keys × 3 locales, JSON-valid).

**Docs**
- `docs/flutter-api-contract-matrix.md` — new "P9 wave 2 additions" subsection, 6 rows (3 new writing-data endpoints + reused community/translate endpoints).
- `docs/api-changelog.md` — one row.

**Tests**
- `test/features/writing/{goethe_b1_writing_topic_test,goethe_b1_writing_access_test,writing_exam_id_test}.dart` — 12 unit tests (full-payload DTO parse, malformed-payload defaults, all 5 exercise-kind discriminants, access/free-tier sort+lock logic, exam-id format).
- `test/screens/exam/writing/{goethe_b1_writing_topic_list_page_test,goethe_b1_writing_detail_page_test,goethe_b1_writing_practice_page_test,goethe_b1_community_writing_list_page_test}.dart` — 8 widget tests.
- `test/structure/release_live_data_guard_test.dart` — added all 44 new release-visible file paths (guard unchanged/not weakened).

## Per-screen status

- **topic-list**: DONE. Search (client-side, DE/VI/slug-normalized), Sprint 10h pill (inert — see deviation), community folder card, topic rows (position/lock/completed badge, HOT ★≥5, difficulty pill, stars), sidebar leaderboard, free-limit banner.
- **detail reader**: DONE, with documented simplifications (below) on autoplay, 2 of 5 exercise types, typing-practice suite, wortschatz filter pills. All 30+ spec'd sections/data fields are read and rendered somewhere — nothing silently dropped.
- **practice wrapper**: DONE. Thin — reads full topic, renders `PracticePromptCard` + `WritingPracticePanel` unmodified (W1's public API untouched).
- **community-writing-list**: DONE. 100% reuse of the existing P8 community-exam stack, filtered to `provider=goethe skill=writing teil={n}`.

## Deviations (documented, not silent)

1. **No official-DB topic merge.** Web's topic-list merges `useOfficialWritingTopics` (a separate `official-topic-service` backend surface) into the legacy manifest. No Flutter equivalent exists anywhere in the codebase (`grep` confirmed zero hits) — building it was out of scope for W2's file ownership and not in the contract matrix. Both topic-list and detail read only the legacy `teil/{n}`/`topic/{n}/{slug}` endpoints (matches W1's "Live" baseline). `isOfficialLocked` field is modeled but always `false` from this path.
2. **"Nhóm theo chủ đề" (cluster-grouping toggle) omitted** on topic-list — frequency-sort only. Named follow-up.
3. **Autoplay simplified.** Web: sequential prev/pause/next fixed transport bar, karaoke sub-sentence highlighting, auto-scroll, force-open-all. Flutter: single "Phát toàn bộ" pill that opens all sections and plays up to 30 sentences back-to-back via the shared exclusive `AudioService` player — no transport controls, no highlighting/auto-scroll.
4. **TOC follows DOM order** (grammatik → fehler → wortschatz), not the web's TOC-vs-DOM mismatch — per the spec's own unresolved-question recommendation for pixel parity.
5. **`taskVariant`** ("🔀 Biến thể đề thi") not rendered.
6. **Task-analysis "approaches"** render always-expanded instead of behind a "💡 N cách triển khai" toggle. Content fully present either way.
7. **Wortschatz card**: no filter pills (Tất cả/der/die/das), no per-genus counts — every genus group renders directly. "🌐 Dịch ví dụ" is rerouted through the existing backend `TranslationService` (`POST /ai/translate-sentences`) instead of client-side Google Translate, per the plan's explicit guidance for this exact case.
8. **Error-correction / mini-write exercises are reveal-only, not AI-graded.** Web calls `/ai/grade-sentence`(-batch) with a 1.5s idle prefetch; this wave ships type-then-"Xem đáp án"/"Xem câu mẫu" instead (no AI call). Cloze/word-order/match are fully locally graded per spec. **Named follow-up**: wire batch AI grading for these 2 exercise kinds.
9. **Typing-practice suite simplified** to a single-flow runner (no group picker, no cross-restart resume, no masked/reveal toggle or word-diff highlighting) — plain textfield + exact-match-after-normalize check, prev/next, completion stats. Collects task + sample sentences + model-answer sentences (not grammar/wortschatz/phrase groups yet — **named follow-up**).
10. **`AskAiAboutTopicButton`** (practice page's `footer` slot) omitted — no Flutter topic-chat-context bridge exists yet; W1's `footer` extension point is available for whoever builds it.
11. **`ReportContentButton`** omitted from the practice prompt card — no Flutter content-reporting flow exists.
12. **Community-writing-list**: no contributor/vote sort tabs, no in-place topic-detail preview (web's `CommunityWritingList` component) — reuses the existing generic `CommunityTopicCard`/`CommunityExamDetailScreen` navigation instead. Same data, fewer UI affordances.
13. **`hasFullAccess = premiumProvider` only** — no `hasModule('exam')` concept in this app (web's separately-purchasable modules); matches W1's precedent, not a new gap.
14. **Sprint 10h pill** is visible but shows a "coming soon" snackbar (W4 not built yet) — matches W1's precedent for not-yet-built cross-links.

## Validation

- `flutter analyze` on all touched/new files: **0 errors**, 4 pre-existing-style `info` lints (same `if (x != null) 'key': x` pattern as W1, left as-is for consistency).
- Repo-wide `flutter analyze`: 103 pre-existing errors, all in `lib/screens/{leaderboard,settings,stats}/**` + matching tests — confirmed via `git diff HEAD` these files were already modified/broken (in-progress ARB extraction) **before this session started** (visible in the initial `git status` snapshot). None touch writing files. Not mine, not fixed, per protocol.
- `flutter test test/features/writing test/screens/exam/writing test/screens/exam/goethe_b1_hub_page_test.dart test/screens/exam/goethe_b1_writing_teil_pick_page_test.dart test/structure/release_live_data_guard_test.dart`: **31/31 passed** (20 new + 11 existing W1, all still green after the ARB/route changes).
- `flutter gen-l10n`: regenerated cleanly, 3-locale key parity verified via JSON load.

## Unresolved questions

1. Wave 4's Sprint SR mode picker will want to replace the topic-list's inert "Sprint 10h" pill with a real navigation target — no action needed from W2, just a heads-up for whoever builds W4.
2. Should the official-DB topic-merge (deviation #1) be picked up as a dedicated follow-up phase, or is the legacy-only endpoint an accepted permanent simplification for mobile? Same open question as W1's unresolved #3 (rubric bands) in spirit — a product call, not an engineering blocker.
3. AI batch grading for error-correction/mini-write (deviation #8) — worth a small follow-up phase reusing the existing `/ai/grade-sentence` pattern (already used elsewhere, e.g. writing-sentence game), or accept reveal-only as the mobile baseline?

Status: DONE
Summary: All 4 W2 screens built and routed (topic-list, 30+-component detail reader, practice wrapper, community list), reusing W1's `WritingPracticePanel` unmodified and P8's community-exam stack unmodified; 6 new/extended live backend endpoints documented in the contract matrix; 86 new ARB keys across vi/en/de; 0 analyze errors on touched files; 31/31 tests green (20 new).
Concerns/Blockers: none blocking. 14 documented deviations above (mostly simplification of the detail reader's most complex sub-features — autoplay, 2 exercise kinds' AI grading, typing-practice suite) are the main things a later pass may want to deepen; none are silent data-loss, all named as follow-ups.
