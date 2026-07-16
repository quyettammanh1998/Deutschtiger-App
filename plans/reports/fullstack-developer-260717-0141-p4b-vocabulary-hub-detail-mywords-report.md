# Phase 4b — vocabulary hub, detail (topic word-list), MyWordsOverview

Plan: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-04-vocabulary-practice.md`
Prior pass: `plans/reports/fullstack-developer-260717-0107-p4-vocabulary-practice-report.md` (4 practice-view round types + primitives — reused here, not rebuilt).

## Scope executed (3 targets, all DONE)

### 1. `/vocabulary` hub — `lib/features/vocabulary/presentation/vocabulary_screen.dart`
Rebuilt web-parity: AppBar-less header (back + "Kho từ vựng" + `{n} từ · 6 cấp độ`, literal 6 like web's `CEFR_LEVELS.length`, not `levelCounts.length`) → `PageIntro` (pageKey `vocabulary`) → 4-tab gradient segmented control (🎯/🧭/📚/⭐) → tab content → tip card → word-sprint card.
- **Goal tab** (`widgets/vocabulary_goal_tab.dart`): all **13** goals ported from web `GOAL_VOCAB_PATHS` (`domain/goal_vocab_path.dart`) — dropdown select + active-goal card with topic-count badge + topic chips (labelVi from `topicLevelCounts`) linking to `/vocabulary/topic-{key}`. Only goals with ≥1 topic having data are offered (matches web `.filter`).
- **Level tab** (`widgets/vocabulary_level_tab.dart`): left-border color + emoji + level pill + top-6-topic chip row per level (was missing before).
- **Topic tab** (`widgets/vocabulary_topic_tab.dart`): main-topic dropdown + sub-topic grid, each cell showing `L·count` level chips (was flat ListTiles before).
- **⭐ Của tôi tab**: embeds `MyWordsOverview()` directly (see #3).
- Tip card (`widgets/vocabulary_tip_card.dart`) and word-sprint card (`widgets/vocabulary_word_sprint_card.dart`) render on every tab, unconditionally, matching web (siblings of the `{view === X}` blocks, not nested inside them).
- Gradient tabs read `context.tokens.primary` only (no deprecated statics).

**Deviation**: web's `LearningTipCard` reads a rotating tip from a dedicated tips backend (`useRandomTip`) that has no Flutter data layer. Ported the amber-card chrome + rotate-on-tap UX with a small static VN tip set instead (documented in the widget doc-comment) — wiring a new tips API is out of this pass's "no new backend endpoint" scope.

### 2. `/vocabulary/:slug` — `lib/features/vocabulary/presentation/vocabulary_detail_screen.dart`
Full rebuild to the correct concept: a **topic/level/collection word-LIST**, not the old single-word hero view (that view now lives only at `/vocabulary/word/:itemId`, owned by a concurrent agent — see Coordination below).
- **Slug resolution** (`widgets/vocabulary_detail_scope_resolver.dart`): `topic-{key}` / `level-{level}` / bare collection slug, resolved client-side from already-fetched `vocabularyTopicsProvider` + `wordCollectionsProvider` — verified route contract, no new endpoint.
- **Mastery strip** (`widgets/vocabulary_detail_mastery_strip.dart`): emerald progress bar + `{graduated}/{total} đã thuộc` + `Danh sách`/`Từ của tôi` tabs + search + red "Yếu" weak-filter toggle.
- **Item list** (`widgets/vocabulary_detail_item_list.dart`): paginated rows with a mastery-bucket dot; weak filter and "Từ của tôi" both widen the fetch to a 150-item sample and either client-filter (weak) or group by mastery bucket (mine tab, web's `VocabMyWordsTab` simplified to a grouped list since Flutter has no per-item "source/context" join beyond what my-words already covers).
- **Sticky bottom bar** (`widgets/vocabulary_detail_sticky_bar.dart`, on `StickyCtaBar`): pager + 4 practice-mode buttons (cloze/listening/matching/writing) + "Học từ mới" gradient CTA (topic scope only — level/collection scopes have no Flutter lesson-batch route yet).
- **Practice launcher** (`widgets/vocabulary_practice_launcher.dart`): fetches scope-specific items via the existing `VocabularyRepository` methods, maps to `PracticeRoundItem`, and opens them through the **already-existing** `PracticeRouteScaffold` + `Practice{Cloze,Listening,Matching,Writing}View` from the prior P4 pass (`lib/screens/practice/widgets/*`) — imported and reused as public APIs, not modified, not reimplemented.
- **Mastery data** (`domain/graduation_stats.dart` + 2 new `VocabularyRepository` methods): wires the **existing live** backend endpoints `/user/srs/graduated{,-by-topic,-by-level}` and `POST /user/srs/states` (verified against `thamkhao/deutschtiger-frontend/src/lib/srs/srs-service.ts` — web already calls these; this is wiring, not a new contract).
- Route: `lib/navigation/routes/vocabulary_routes.dart` — old `detail/:topicKey` child route replaced by `:slug` (declared last so static `lesson/`, `word/` siblings still win); `lib/navigation/release_redirect.dart` gets one minimal append-only block redirecting old `/vocabulary/detail/{key}` → `/vocabulary/topic-{key}`.
- `Riverpod` correctness fix: `itemMasteryStatesProvider`'s family key was `List<String>` (identity-`==`, would cache-miss/refetch every rebuild); wrapped in `ItemMasteryQuery` with content equality (`vocabulary_provider.dart`).

**Deviation**: desktop-only web elements (admin add/import bars, `TopicSwitcherSheet`, `VocabularyGamePanel` right panel, `RelatedTopicsStrip`, `NextTopicCard`) are out of scope — plan explicitly scopes to mobile viewport (`md:`/`lg:` ignored) and these are `hidden lg:block`/admin-gated on web.

### 3. MyWordsOverview — `lib/features/my_words/presentation/my_words_overview.dart` (new) + `my_words_screen.dart` (rewritten)
- `MyWordsOverview` is now the embeddable content (no `Scaffold`/`AppBar`): 3 emoji-headed groups (🔁 Trong Ôn tập / 📔 Trong Sổ từ / 👀 Đã gặp), each with a true server-count badge, `nguồn: {source}` tag (VN lookup table, `my_words_source_label.dart` — mirrors web's `SOURCE_VI`), italic last-context quote, "+N từ nữa" overflow line, and empty/error states. Embedded directly in the vocabulary hub's ⭐ tab.
- `my_words_screen.dart` (route `/my-words`) is now a **thin wrapper** (`Scaffold` + `AppBar` + `MyWordsOverview()`) — the old `SegmentedButton` toggle is gone.
- **Kept the `/my-words` route** (did not delete it): two files outside my ownership (`lib/screens/home/widgets/pinned_shortcuts.dart`, `lib/widgets/dashboard/quick_actions_data.dart`, both owned by a concurrent home-fidelity phase) still deep-link to it. Deleting the route would 404 their shortcuts without coordination. Documented as an intentional, safety-first deviation from "no standalone my-words screen" — content-wise it now matches the web embed exactly, only the route wrapper is extra.

## Files changed

**New**: `lib/features/vocabulary/domain/{goal_vocab_path,graduation_stats}.dart`, `lib/features/vocabulary/presentation/widgets/vocabulary_{goal_tab,level_tab,topic_tab,tip_card,word_sprint_card,detail_item_list,detail_mastery_strip,detail_sticky_bar,detail_scope_resolver,practice_launcher}.dart`, `lib/features/my_words/presentation/{my_words_overview,my_words_source_label}.dart`.
**Rewritten**: `lib/features/vocabulary/presentation/vocabulary_screen.dart`, `lib/features/vocabulary/presentation/vocabulary_detail_screen.dart`, `lib/features/my_words/presentation/my_words_screen.dart`.
**Modified**: `lib/features/vocabulary/data/vocabulary_repository.dart` (+2 methods), `lib/features/vocabulary/presentation/vocabulary_provider.dart` (+providers, +`ItemMasteryQuery`), `lib/navigation/routes/vocabulary_routes.dart`, `lib/navigation/release_redirect.dart` (append-only), `lib/l10n/app_{vi,en,de}.arb` + generated l10n (ran `flutter gen-l10n`), `test/screens/vocabulary/{vocabulary_detail_localization_test,vocabulary_screen_localization_test}.dart` (updated to match rebuilt screens).
**Light touch-up, my ownership**: `lib/features/vocabulary/presentation/vocabulary_word_screen.dart` — one internal `onOpenDetail` navigation target updated (`/vocabulary/detail/*` → `/vocabulary/topic-*`). **Note**: a concurrent agent has since substantially rewritten this same file (word-page rebuild, screen B4 in the plan table — not one of my 3 assigned targets); my one-line change is preserved inside their rewrite (verified via the file-change notice). I did not touch it further.

## Coordination / concurrent work observed

`git status` shows `lib/features/vocabulary/presentation/vocabulary_lesson_screen.dart` and several new files (`vocab_lesson_utils.dart`, `vocab_lesson_session_controller.dart`, `widgets/lesson/*`, `vocab_word_provider.dart`, `widgets/word/*`) are being actively edited by another agent right now, in the same working tree, for the lesson/word screens (B3/B4 in the plan table) — **not part of my 3 assigned targets**. `test/screens/vocabulary/vocabulary_lesson_localization_test.dart` and part of `test/features/vocabulary/vocabulary_interaction_test.dart` currently fail against that in-flight work; verified via `git status` + diff that none of the failures trace to my files.

## Validation

- `flutter analyze` (whole repo): **0 errors** (4 pre-existing `info`-level `prefer_initializing_formals` lints elsewhere, not mine).
- `flutter gen-l10n`: ran after ARB edits; generated files updated, not hand-edited.
- `flutter test` — my scope all green: `test/screens/vocabulary/vocabulary_screen_localization_test.dart`, `test/screens/vocabulary/vocabulary_detail_localization_test.dart` (rewritten for the new list-screen concept + 200% German text-scale check), `test/features/vocabulary/vocabulary_repository_test.dart`, `test/navigation/release_redirect_test.dart`, `test/structure/release_live_data_guard_test.dart` (unchanged — my 3 targets were already listed, no new top-level route screens added).
- Failures confirmed **not mine**: `test/screens/vocabulary/vocabulary_lesson_localization_test.dart` (2 cases) + `test/features/vocabulary/vocabulary_interaction_test.dart` (1 case) — all target `VocabularyLessonScreen`/`VocabularyWordScreen`, the concurrent agent's in-flight files.

## Unresolved questions

1. `/my-words` standalone route kept alive (not deleted) because two out-of-ownership files still deep-link to it — confirm with the home-fidelity phase owner whether those shortcuts should be repointed at `/vocabulary?view=mine` once both passes land, so the route can be retired per plan's "no standalone my-words screen" decision.
2. Tip card ships a static VN tip set instead of the web's dynamic tips-backend rotation — flag if a future pass should wire a real tips API.
3. Sticky-bar practice buttons launch the 4 shared round-type views scoped to the topic/level/collection (via existing repository fetches), not the web's dedicated `/games/{cloze,listening,...}` standalone routes with `fromVocabulary` state passthrough — functionally equivalent (same views, scoped data) but XP/analytics attribution to "started from vocabulary detail" isn't tagged; note if that provenance matters later.
4. Level/collection-scoped "Học từ mới" (start lesson) is omitted from the sticky bar — Flutter's `VocabularyLessonScreen` only accepts a `topicKey`, no level/collection-batch lesson mode exists yet.

Status: DONE
Summary: Rebuilt the vocabulary hub (4 tabs incl. ⭐ Của tôi, 13 goals, gradient tabs, PageIntro, tip + word-sprint cards), the vocabulary-detail screen (correct topic/level/collection word-list concept with mastery bar, tabs, weak filter, sticky practice bar, wired to existing live SRS endpoints), and MyWordsOverview (3 emoji groups, embedded in the vocabulary hub, standalone route kept as a thin wrapper for cross-phase link safety). `flutter analyze` 0 errors repo-wide; all tests in my 3 files' scope green; the only failing tests trace to a concurrent agent's in-flight lesson/word-screen rebuild, verified unrelated.
Concerns/Blockers: none blocking; 4 documented scoping deviations above, none silently dropped.
