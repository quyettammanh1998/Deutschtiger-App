# P11 Wave 4 — Reading + News + Read-Listen Hub (5 screens)

Scope: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-11-media-reading-news.md` §W4 only.
Web read per-page before coding: `thamkhao/deutschtiger-frontend/src/{pages,components}/{reading,news}/*`.

## Status per screen

| Screen | Verdict before | Work done | Verdict now |
|---|---|---|---|
| `reading_hub_screen.dart` | DIVERGENT (major) | Full rebuild: tab shell (Tin tức\|Truyện, navigates to `/news`), 2-col gradient level grid A1–C2 (emoji, progress ring, 3 recommended-unread mini list, "Xem tất cả →" button), level detail (in-place swap, gradient hero ring, search, flat article list, `ReadingLeaderboardCard`). | CLOSE (topic accordion not ported — see deviations) |
| `reading_detail_screen.dart` | DIVERGENT | Removed `ReadingHeader`; added level pill + inline "Đã đọc" chip, sky translate button + tap-word hint inline (was AppBar icon), `SaveArticleWordsCta`, kept audio/paragraphs/glossary/mark-read. | CLOSE (exercises quiz gate not built — no backend route, see deviations) |
| `reading_feed_screen.dart` | CLOSE | Added 64px thumbnail, orange level chip (was theme-color badge), solid-pill level filter (was `ChoiceChip`), empty-state CTA card ("Học từ mới" → `/vocabulary`). | CLOSE→MATCH |
| `read_listen_hub_screen.dart` (NEW) | MISSING | Tab shell Đọc/Nghe/Tin tức mounting existing `ReadingFeedScreen`/`ListeningHubScreen` (W1, read-only reuse)/`NewsListScreen` unchanged, route `/doc-nghe`. | CLOSE |
| `news_list_screen.dart` | CLOSE→DIVERGENT (minor) | Added tab shell (Truyện\|Tin tức), `NewsLeaderboardCard`; weekly ring moved from top to below the list (stacked with leaderboard, matches mobile web). | CLOSE→MATCH |
| `news_detail_screen.dart` | CLOSE | Added "Chọn trình độ đọc" label + tip box (only when >1 level), `SaveArticleWordsCta`, image now 16:9 `AspectRatio` capped at 448px width (was fixed 180px). | CLOSE→MATCH |

## Files

**New**: `lib/screens/reading/widgets/{reading_level_theme,reading_leaderboard,save_article_words_cta}.dart`, `lib/screens/reading/read_listen_hub_screen.dart`, `lib/screens/news/widgets/news_leaderboard.dart`, `test/screens/reading/read_listen_hub_screen_test.dart`.

**Rewritten**: `lib/screens/reading/{reading_hub_screen,reading_detail_screen}.dart`, `lib/screens/news/news_list_screen.dart` (major); `lib/screens/reading/reading_feed_screen.dart`, `lib/screens/news/news_detail_screen.dart` (targeted edits).

**Deleted**: `lib/screens/reading/widgets/reading_cards.dart` (`ReadingArticleCard`/`ReadingLevelBadge` — superseded, zero references after rebuild); `ReadingHeader` class removed from `reading_detail_widgets.dart` (per plan's explicit delete list — Flutter-only stats header, no web equivalent).

**Appended (not owned outright, minimal/necessary plumbing)**: `lib/repositories/reading/reading_repository.dart` (+`fetchLeaderboard`, `fetchUserRank`, `saveWordsBatch`), `lib/repositories/news/news_repository.dart` (+`fetchLeaderboard`, `fetchUserRank`), `lib/data/reading/reading_models.dart` (+`ReadingLeaderboardEntry`), `lib/data/news/news_models.dart` (+`NewsLeaderboardEntry`) — needed to back the leaderboard/save-words widgets the plan explicitly requires; no other wave touches these files.

**Routes/redirects (append-only, minimal, reading/news block only)**: `lib/navigation/routes/media_routes.dart` — `/reading` sub-route `detail` → `:level/:slug` (web-aligned), new top-level `/reading-feed` (was `/reading/feed`), new `/doc-nghe`. `lib/navigation/release_redirect.dart` — `/reading/feed` → `/reading-feed` redirect, gate additions for `/reading-feed`/`/doc-nghe` reusing the existing `reading` flag.

**Docs**: `docs/flutter-api-contract-matrix.md` (+§Reading/News leaderboards + batch word-save), `docs/api-changelog.md` (+wave-11 row), `docs/web-feature-parity-matrix.md` (reading/news rows updated).

**Tests updated for the new UI** (pre-existing, now-stale assertions): `test/screens/reading/reading_hub_screen_test.dart` (empty-state text changed — hub no longer blocks on empty, shows 6 empty level cards), `test/screens/reading/reading_detail_screen_test.dart` ("Đã đọc" now renders twice — chip + disabled button, matches web).

**Guard**: `test/structure/release_live_data_guard_test.dart` — added all reading screens/widgets/repo/model (were previously entirely absent from the guard list) + `news_leaderboard.dart`.

**Not touched**: `lib/screens/listening/**`, `lib/screens/youtube/**`, `lib/screens/video_library/**`, `lib/screens/interview/**` (W1/W2), `lib/screens/journey/**` (W3/course), `lib/core/**`, `lib/widgets/common/**`, `lib/shared/widgets/**`, `pubspec.yaml`.

## Reuse (confirmed before writing new widgets)

- `context.tokens` (`AppTokens`) throughout all rewritten/new files.
- `lib/shared/widgets/word_lookup_sheet.dart` + `tappable_sentence.dart` — unchanged, reused as-is for tap-word lookup (both reading and news already had this pre-wave; kept).
- No markdown renderer needed — reading/news bodies are plain paragraph text, not markdown, on both web and Flutter.
- W2's `lib/screens/youtube/widgets/**` — read-only reused indirectly: `ListeningHubScreen` (W1's screen) is mounted unmodified inside the new read-listen hub; did not touch or duplicate any W1/W2 widget family.

## Deviations (documented per plan requirement)

1. **Reading topic-accordion grouping** — web groups a level's articles into collapsible topic sections via `reading-topics.ts`, a hardcoded slug→topic map (hundreds of entries per level, A1–C1, no backend source). Porting this content wholesale is disproportionate to a UI-fidelity pass and isn't logic — it's static content duplication across two frontends. Level detail instead shows a flat, searchable article list (index/check circle, done-state tint, tap→detail) — search, read-state, and leaderboard all work; only the topic/accordion segmentation is missing.
2. **Reading-detail exercises quiz** (web gates completion on `ReadingExercises`, ≥60% pass) — `GET /reading/articles/{level}/{slug}/exercises` is **not mounted** on this backend (`reading_handler.go` only exposes List/Levels/Topics/Get/GetBySlug/Audio, confirmed by reading the route table + handler file directly). Web itself falls back to a bundled static TS dataset on 404 (`src/data/reading-exercises-*.ts`); per "contract trước code" + no-new-mocks, Flutter does not build UI against a route that doesn't exist and doesn't bundle a duplicate content dataset. Every article keeps the manual "Đánh dấu đã đọc" button (web's own no-exercises fallback path), applied universally instead of conditionally.
3. **Selection-lookup (drag-select phrase → floating "Tra nghĩa" pill)** — attempted via Flutter's `SelectionArea`/`contextMenuBuilder`, but wrapping the paragraph body (which already uses `TappableSentence`'s own tap-gesture recognizers for single-word lookup) risked breaking that working interaction via gesture-arena conflicts. Deferred rather than risk regressing the tap-to-lookup flow already shipped; single-word tap lookup (both reading and news) is unaffected and is the primary interaction web itself leads with (tap is default, drag-select is a secondary affordance).
4. **`SaveArticleWordsCta` batch endpoint** — web calls `POST /user/srs/add-batch`, which is **not mounted** on this backend (verified against `routes_user_learning.go`'s `/srs` route group — only `/add` exists, no `/add-batch`; this is a dead/stale call in the web frontend). Used the live, functionally-equivalent `POST /user/word-reviews/add-batch` instead (same batch `{learning_item_id, source}` insert semantics). Documented in the contract matrix rather than silently reproducing a 404.
5. **l10n** — like every pre-existing file in `lib/screens/reading/**` and `lib/screens/news/**` (verified: 0 `AppLocalizations` references anywhere in either dir before this change), all new/rewritten UI strings stayed hardcoded Vietnamese — same documented precedent as W2's youtube/video-library/interview report for the sibling media family. Not a new gap; flagged as pre-existing, cross-file, better done in one pass for the whole media area.
6. **Old `/reading/feed` route** — `lib/shared/widgets/more_features/more_features_catalog.dart:127` still points at the old path; that file is DO-NOT-TOUCH (`lib/shared/widgets/**`). Not broken (the new redirect `/reading/feed` → `/reading-feed` covers it), but its owner should update the literal to the canonical path when next touching that file.

## Contract work

Probed by reading the Go route tables/handlers directly (no local backend running in this sandbox, no live curl). All 4 leaderboard/rank endpoints and the word-reviews batch endpoint already exist and are already called by web — first Flutter callers, not new backend contracts. `GET /reading/articles/{level}/{slug}/exercises` and `POST /user/srs/add-batch` were probed and found **not mounted** — documented as dead/missing contracts rather than built against. Full detail in `docs/flutter-api-contract-matrix.md` §Reading/News leaderboards + batch word-save.

## Validation

- `flutter analyze` on all touched files (`lib/screens/reading`, `lib/screens/news`, `lib/repositories/{reading,news}`, `lib/data/{reading,news}`, `lib/navigation/routes/media_routes.dart`, `lib/navigation/release_redirect.dart`, guard test): 0 issues.
- Full-repo `flutter analyze`: all remaining errors are in concurrent agents' in-progress ARB work (P9 writing, P11 W3 course) — confirmed via grep, none touch my files.
- `flutter test test/screens/reading test/screens/news test/structure/release_live_data_guard_test.dart`: 19/19 pass (2 pre-existing tests updated to match new, intentional UI — see Files).

## Unresolved questions

1. Should the reading topic-accordion content (`reading-topics.ts`) be ported to Dart in a follow-up, or should this classification move server-side (single source of truth for both frontends) instead of being duplicated a third time?
2. `GET /reading/articles/{level}/{slug}/exercises` — is authoring this backend route + content in scope for a future wave, or is the reading-comprehension quiz feature intentionally web-only?
3. `POST /user/srs/add-batch` (web) vs `POST /user/word-reviews/add-batch` (used here) — should the web frontend's dead call be fixed to point at the working endpoint, flagged separately to the backend/frontend owners?

Status: DONE_WITH_CONCERNS
Summary: All 5 W4 screens rebuilt/shipped with live data only (no new mocks); two structural gaps (topic-accordion content, exercises-quiz backend route) are genuinely missing upstream contracts/content, not skipped work, and are documented rather than faked.
Concerns/Blockers: see Unresolved questions above; none block merging this wave's own screens.
