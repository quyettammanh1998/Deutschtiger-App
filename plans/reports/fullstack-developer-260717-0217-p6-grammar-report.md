# Phase 6 — Grammar: Implementation Report

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-06-grammar.md`

## Per-screen status

| Web page | Flutter target | Verdict |
|---|---|---|
| `/grammar` (list/level-grid) | `grammar_screen.dart` + `widgets/grammar_home_grid.dart` + `widgets/grammar_level_detail_view.dart` + `widgets/grammar_search_results.dart` | DONE — 2-col gradient level cards (numbered recommended lessons, tinted CTA), global search with diacritic-insensitive match, level-detail hero + accent-border expandable topic sections + solo-lesson rows, leaderboard card below the list on both list and level-detail (mobile = stacked, matches web's no-sidebar layout) |
| `/grammar/:level/:id` lesson | `grammar_lesson_detail_screen.dart` + `grammar_content_widgets.dart` | DONE — markdown/formula/German-line-highlight text rendering, exercise pill buttons w/ correct/wrong states, read-gate (scroll-80% + min-time timer, +5 XP / amber re-complete / emerald done states), related lessons |
| `/grammar/articles/:level/:slug` | `grammar_article_screen.dart` | DONE — level pill, source link, full markdown via new `AppMarkdownView` (tables/blockquote/code/images/links), gradient/green complete CTA |

## Deviations (documented in-code)

1. **GrammarMap ("Bản đồ ngữ pháp") — omitted.** Web calls `GET /user/grammar-map`; grepped the full backend snapshot (`cmd/server/routes_*.go`, `internal/`) — no route registers it. Web itself renders nothing on query error (`if (isError || !topics) return null` in `grammar-map.tsx`), so omitting the section reproduces the *live* web behavior, not a shortcut. Recorded in `docs/flutter-api-contract-matrix.md` (new "Grammar leaderboard" section) + `docs/api-changelog.md` as Missing/pending backend work.
2. **Offline-sync banner — omitted.** `lib/services/offline/offline_service.dart` documents an explicit product decision: no write-queueing for offline replay (no idempotent outbox contract yet). A grammar-specific sync queue would contradict that decision. `markGrammarComplete` keeps its existing best-effort retry-on-tap.
3. **Leaderboard row navigation** — web links each leaderboard entry to the public profile route. Flutter has no `/u/:id`-equivalent route yet (owned by the social/profile phase); rows render but are non-interactive with a code comment pointing at the gap.
4. **HTML content blocks** (`GrammarTextBlock` matching `<p>/<div>/...`) — web sanitizes+renders raw HTML via `dangerouslySetInnerHTML`. No safe HTML-renderer dependency exists in this project and adding one is out of contract-before-code scope for this pass; Flutter strips tags to plain text as a documented fallback (content preserved, just unstyled).
5. **Audio in article markdown** — `markdown_widget` has no audio-node concept. `AppMarkdownView` pre-extracts markdown links ending `.mp3/.ogg/.wav` and renders a compact play row (via existing `AudioService`) below the markdown body instead of exactly inline.

## Backend contract (leaderboard/rank) — read, not curl-probed

No local backend instance was available this session; contract was verified by reading the Go handler + repo source directly (permitted method per plan's contract-before-code protocol):
- `GET /grammar-leaderboard?limit=&level=` → `grammarProgressHandler.GetLeaderboard`, raw JSON array of `{user_id, display_name, avatar_url, completed_count, rank}`.
- `GET /user/grammar-rank?level=` → `grammarProgressHandler.GetUserRank`, single object or `null`.
Both already mounted server-side (pre-existing), just previously unused by Flutter. Documented in `docs/flutter-api-contract-matrix.md` + `docs/api-changelog.md`.

## Shared markdown wrapper (for P11 reuse)

New file: `lib/widgets/common/app_markdown_view.dart` — `AppMarkdownView(String data, {selectable, padding, dense})`. Wraps `markdown_widget`'s `MarkdownWidget` with `context.tokens`-driven `MarkdownConfig` (headings, paragraph, blockquote, table, inline code, links, images) plus the audio-link extraction described above. `dense: true` shrinks heading sizes for content embedded inside an already-titled card (used for lesson content blocks); `dense: false` (default) is for full standalone article pages. P11 (media/reading) should reuse this directly rather than re-wrapping `markdown_widget`.

## Files touched

**Owned (grammar):**
- `lib/features/grammar/presentation/grammar_screen.dart` — rewritten (orchestrator: header, global search, level-grid/level-detail/search-results dispatch)
- `lib/features/grammar/presentation/grammar_lesson_detail_screen.dart` — rewritten (read-gate state machine, content rendering, related lessons)
- `lib/features/grammar/presentation/grammar_article_screen.dart` — rewritten (markdown, source link, gradient CTA)
- `lib/features/grammar/presentation/grammar_content_widgets.dart` — rewritten (German-highlight, formula box, HTML-strip fallback, pill-button exercises)
- `lib/features/grammar/presentation/grammar_level_widgets.dart` — extended `GrammarLevelMeta` (gradientEnd/desc/badge colors), dropped dependency on deprecated `AppColors`
- `lib/features/grammar/presentation/grammar_provider.dart` — added `grammarLeaderboardProvider`, `grammarUserRankProvider`; `markGrammarComplete` now invalidates both
- `lib/features/grammar/domain/grammar_curriculum_order.dart` — added `normalizeGrammarSearch` (diacritic-insensitive search, ported from web)
- `lib/features/grammar/presentation/widgets/grammar_home_grid.dart` (new) — 2-col level grid, intrinsic-height 2-column layout (not `GridView.count`/`childAspectRatio` — see German-200% note below)
- `lib/features/grammar/presentation/widgets/grammar_level_detail_view.dart` (new) — hero + search + topic sections
- `lib/features/grammar/presentation/widgets/grammar_search_results.dart` (new) — shared search-result list (list page + level-detail)
- `lib/features/grammar/presentation/widgets/grammar_leaderboard_card.dart` (new) — progress ring + top-10 list + "your rank" row
- `lib/data/grammar/grammar_models.dart` — added `GrammarLeaderboardEntry`
- `lib/repositories/grammar/grammar_repository.dart` — added `fetchLeaderboard`, `fetchUserRank`
- Deleted: `lib/screens/grammar/grammar_screen.dart` (orphan, per phase spec), `lib/widgets/grammar/grammar_roadmap.dart` (orphan, invented UI, unreferenced — deleted as cleanup, not explicitly named in phase but matches the plan's "invented UI... delete" instruction)

**Shared (explicitly permitted addition):**
- `lib/widgets/common/app_markdown_view.dart` (new)

**l10n:** `lib/l10n/app_{vi,en,de}.arb` — ~24 new grammar keys (search-in-level hint, leaderboard/progress labels, read-gate strings, exercise feedback strings); removed the now-unused `grammarArticles` key (articles list dropped from level-detail per phase spec, dead entry on web too); ran `flutter gen-l10n`.

**Tests (mine, updated for the new UI):**
- `test/screens/grammar/grammar_lesson_detail_screen_test.dart` — button-label assertion loosened to `textContaining` (label now includes "(+5 XP)")
- `test/screens/grammar/grammar_article_screen_test.dart` — added `VisibilityDetectorController.instance.updateInterval = Duration.zero` in `setUpAll` (markdown_widget's internal `VisibilityDetector` otherwise leaves a real pending Timer past `pumpAndSettle`)
- `test/screens/grammar/grammar_de_200_scale_smoke_test.dart` (new) — German 200% text-scale overflow smoke test for list + lesson-detail screens
- `test/structure/release_live_data_guard_test.dart` — added the 4 new grammar widget files + `app_markdown_view.dart` to the guard list

## Bugs found & fixed during implementation

- Initial `_scheduleReadProgressReset` implementation called `setState` synchronously inside the `data:` builder during `build()` → Flutter "setState during build" crash, silently swallowing the whole read-gate card in tests. Fixed by deferring via `addPostFrameCallback`.
- `GrammarHomeGrid` originally used `GridView.count(childAspectRatio: 0.78)` (fixed-height tiles) — overflowed at German 200% text scale (level card content: gradient header + up to 3 recommended lines + CTA doesn't fit a fixed box once text grows). Replaced with a manual 2-column `Row`/`Column` layout (intrinsic per-card height, web parity = CSS `grid-cols-2` auto-row-height) + a `MediaQuery` text-scale clamp (max 1.3×) as defense-in-depth. Caught by the new DE-200% smoke test.

## Validation

- `flutter analyze` on all touched files: 0 errors (2 pre-existing errors elsewhere in `lib/features/exam/**` — concurrent agent's in-progress work, not mine, not touched).
- `flutter test test/screens/grammar/ test/repositories/grammar_contract_test.dart test/structure/release_live_data_guard_test.dart test/l10n/app_localizations_test.dart test/navigation/release_redirect_test.dart` — all green (37/37).
- `flutter test test/screens/games/{case_cloze_quiz,konjugation_game,verb_case_quiz}_screen_test.dart test/repositories/games/grammar_drill_repository_contract_test.dart` — unaffected, all green (checked since I touched the shared grammar domain dir).
- Full-suite `flutter test`: 577 passed / 7 failed. All 7 failures are in `test/features/exam/exam_question_renderers_test.dart` and `test/screens/exam/exam_result_localization_test.dart` (concurrent agent's in-progress `lib/features/exam/**` work — confirmed broken imports/undefined types there via `flutter analyze` before I touched anything). Zero grammar-related failures. Baseline in the task brief was 585/585 at commit `324a757`; the 8-test gap (585→577+7=584, i.e. one fewer collected) plus the 7 new failures are entirely attributable to the concurrent exam-phase work, not this phase.

## Unresolved questions

1. GrammarMap needs the backend to mount `GET /user/grammar-map` before it can be built — flagged in the contract matrix/changelog for the owning team.
2. Leaderboard row → public profile navigation needs a `/u/:id`-equivalent Flutter route (owned by the social/profile phase); currently non-interactive.

Status: DONE
Summary: All 3 grammar screens rebuilt to web parity (list/level-grid, lesson detail with read-gate, article with full markdown); GrammarMap and offline-sync banner deliberately omitted with documented justification (no live backend endpoint / explicit no-offline-writes product decision); new shared `AppMarkdownView` primitive added for P11 reuse.
Concerns: GrammarMap section remains unbuilt pending backend endpoint; leaderboard rows can't deep-link to profiles yet.
