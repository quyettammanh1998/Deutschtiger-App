# Reading surface → live API — implementation report

Date: 2026-07-16

## Scope executed

Chuyển `lib/screens/reading/` từ mock (`kMockReadingArticles`/`kMockReadingBodies`)
sang live API, thêm Reading Feed screen, bật `DEUTSCHTIGER_ENABLE_READING`.

## Backend contract used (verified against source, not guessed)

- `GET /api/v1/reading/articles?level=&limit=` → `{articles:[...], total}` (video/reading_handler.go List)
- `GET /api/v1/reading/articles/{level}/{slug}` → `{article:{...body, body_vi, glossary, glossary_items, audio_url}}` (GetBySlug)
- `GET /api/v1/reading/levels`, `/topics` — not consumed (not needed by current UI; hub groups client-side)
- `GET /api/v1/reading-feed?levels=&limit=` → `{articles:[...], coverage_ready}` (readingfeed/handler.go)
- `GET/POST /api/v1/user/reading-progress` (readingprogress/reading_progress_handler.go)
- `GET /api/v1/reading/audio/{level}/{file}` — streamed via `just_audio`, host resolved from `ApiClient` base URL
- Out of scope (not surfaced): `GET /reading-leaderboard`, `GET /user/reading-rank` (web has a leaderboard tab; Flutter has none anywhere yet — not part of this task's file list). Also web's per-slug quiz exercises (`reading-exercises-*.ts`, local frontend data, no backend contract) are not ported.

## Files

### Created
- `lib/data/reading/reading_models.dart` — DTOs: `ReadingArticleSummary`, `ReadingArticle` (+ `paragraphs` getter splitting body/body_vi, discards translation on paragraph-count mismatch instead of guessing), `ReadingGlossaryItem`, `ReadingDetailArgs`, `ReadingFeedArticle`/`ReadingFeedFit`/`ReadingFeedResult`, `readingLevelColor`.
- `lib/repositories/reading/reading_repository.dart` — `fetchArticlesByLevel`, `fetchArticle`, `fetchFeed` (levels as CSV `String`, not `List` — see gotcha below), `fetchCompletedIds` (swallows errors → `[]`, same pattern as `GrammarRepository`), `markComplete`, `resolveAudioUrl`.
- `lib/screens/reading/reading_feed_screen.dart` — new "Đọc vừa sức" screen mirroring `reading-feed-page.tsx` (level filter chips, fit badges, coverage%).
- `test/repositories/reading_contract_test.dart` — 9 cases (list/detail/paragraph-align/paragraph-mismatch/completed-ids/completed-ids-error/mark-complete/feed/feed-legacy-array/resolveAudioUrl).
- `test/screens/reading/{reading_hub_screen_test, reading_detail_screen_test, reading_feed_screen_test}.dart` — happy/empty/error per screen (9 widgets tests total).

### Modified
- `lib/screens/reading/reading_hub_screen.dart` — live `readingArticlesProvider` (fetches all levels in one request, groups client-side like before), skeleton loading, `ErrorView`, empty state, pull-to-refresh, feed entry-point icon in AppBar.
- `lib/screens/reading/reading_detail_screen.dart` — rewritten around `level`/`slug` (not a full mock object); `readingArticleProvider` (family, autoDispose), `readingCompletedIdsProvider`; wires `POST /user/reading-progress`; real audio playback via `just_audio` (`_ReadingAudioLink`).
- `lib/screens/reading/widgets/reading_cards.dart` — `ReadingArticleCard` now takes `ReadingArticleSummary`, navigates with `ReadingDetailArgs`.
- `lib/screens/reading/widgets/reading_detail_widgets.dart` — `ReadingParagraph` import moved to `data/reading`; `ReadingAudioBar` takes real `progress` (was hardcoded `0.4`); paragraph translation only renders when `vi` is non-empty.
- `lib/navigation/app_router.dart` — `/reading/detail` now passes `ReadingDetailArgs` (level+slug+title) instead of a full mock object; added `/reading/feed` route.
- `lib/core/release/release_feature_flags.dart` — `reading` defaultValue → `true`.
- `docs/flutter-live-data-inventory.md` — reading row reclassified `Blocked` → `Live`.
- `docs/api-changelog.md` — gap-log entry (no BE change needed).
- `test/l10n/app_localizations_test.dart`, `test/features/home/release_navigation_gates_test.dart` — updated 2 hardcoded assertions tied directly to the `reading` flag flip (`isFalse`→`isTrue`; daily-path `reading` step now resolves to `/reading` instead of `/learn`). Scoped strictly to the reading flag consequence, not touched otherwise.

### Deleted
- `lib/screens/reading/reading_models.dart`, `lib/screens/reading/reading_body.dart` (superseded by `lib/data/reading/reading_models.dart`).

## Gotchas resolved

1. `FutureProvider.family<T, List<String>>` — `List` has identity equality by default, so a widget-built list argument never matches a test override with a different (but content-equal) list instance, silently falling through to the real (unmocked) repository. Fixed by using a CSV `String` key for the feed provider (which also matches the actual `levels=` query param 1:1).
2. `find.text(...)` in `flutter_test` does **not** match `RichText` by default (`TappableSentence` renders via `RichText`, not `Text`) — needed `find.text(..., findRichText: true)` in the detail-screen paragraph assertion.

## Tests

- `flutter analyze` on all touched files: clean.
- `flutter test test/repositories/reading_contract_test.dart test/screens/reading/ test/structure/release_live_data_guard_test.dart test/l10n/app_localizations_test.dart test/features/home/release_navigation_gates_test.dart test/navigation/release_redirect_test.dart`: all green (37 tests).
- Full `flutter test` run once at the end: **1 pre-existing failure unrelated to reading** — `test/services/api/sse_client_test.dart: SseClient stops delivering events once the subscriber cancels` times out after 30s. This file is untracked (`git status` shows `??`), was not touched by me, and is unrelated to any file I own — looks like another agent's in-flight SSE/listening work. Not fixed per instructions (not my domain).
- Full `flutter analyze` run once at the end: 15 new `undefined_method`/`undefined_getter` errors in `lib/screens/learn/focus_session_screen.dart`, `lib/screens/learn/widgets/can_do_card.dart`, `lib/screens/practice/widgets/practice_mode_selector.dart`, `lib/screens/practice/widgets/practice_results_view.dart` — missing generated `AppLocalizations` members (`canDoStatus*`, `practiceMode*`, etc.). None of these touch reading; this is ARB/l10n contention from another concurrent agent (matches the "shared files contended" warning in the task brief). Reported here, not fixed.

## Unresolved / follow-ups

- Reading leaderboard/rank and per-article quiz exercises (web-only local data `reading-exercises-*.ts`) are intentionally out of scope — no Flutter UI added for them; flagged in `docs/api-changelog.md`.
- `GET /reading/levels`/`/topics` unused; current hub still filters client-side from the full article list (parity with previous mock UX), which is well within backend's documented "≤59 texts per level, fetch all at once" design.

Status: DONE_WITH_CONCERNS
Summary: Reading hub/detail + new feed screen fully live on `GET /reading/articles*`, `/reading-feed`, `/user/reading-progress`; `DEUTSCHTIGER_ENABLE_READING` now defaults true with the 2 directly-dependent tests updated; repo/widget tests (37) and the release live-data guard test all pass.
Concerns/Blockers: One pre-existing unrelated test failure (`sse_client_test.dart`, untracked, timeout) and 15 pre-existing unrelated analyzer errors (missing `AppLocalizations` members in `learn`/`practice` screens) surfaced during the mandated final full-suite run — both from concurrent agents' in-flight work, not caused by or fixable within this task's file ownership.
