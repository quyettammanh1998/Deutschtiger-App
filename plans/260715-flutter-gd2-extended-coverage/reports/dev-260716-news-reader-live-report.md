# News Reader (live) — implementation report

Date: 2026-07-16

## Scope

New Flutter surface: news list + detail (`/news`, `/news/:slug`) + progress +
week stats. Flutter had zero prior news screens. Contract sourced from real
handlers (not guessed):
- `internal/feature/content/video/news_handler.go` — list/story-by-slug/topics.
- `internal/feature/content/newsprogress/news_progress_handler.go` — progress + week stats.
- `deutschtiger-frontend/src/lib/news/news-service.ts` — field-name ground truth (matched 1:1).

## Files

Create:
- `lib/data/news/news_models.dart` — plain `fromJson` DTOs (no freezed/json_serializable — avoids build_runner race with other agents).
- `lib/repositories/news/news_repository.dart` — `fetchList`, `fetchTopics`, `fetchStoryBySlug`, `fetchCompletedIds`, `markComplete`, `fetchWeekStats`.
- `lib/screens/news/news_list_screen.dart` + `widgets/news_cards.dart` — paginated archive, level/topic filters, weekly ring, empty/error/skeleton states.
- `lib/screens/news/news_detail_screen.dart` + `widgets/news_detail_widgets.dart` + `widgets/news_quiz.dart` — level switcher, audio (normal/slow), sentence reader (tap word → reuse `showWordLookupSheet`/`TappableSentence`), quiz (client-side grading), vocab list, Goethe exam prompts.
- `test/repositories/news_contract_test.dart` (8 tests) — GET/POST paths, query params, error-swallow contracts.
- `test/screens/news/news_list_screen_test.dart` (4), `test/screens/news/news_detail_screen_test.dart` (4).

Edit (narrow, contended files):
- `lib/navigation/app_router.dart` — added `/news`, `/news/:slug` (`NewsDetailArgs` extra, query-param fallback for deep links).
- `lib/core/release/release_feature_flags.dart` — new `news` flag (`DEUTSCHTIGER_ENABLE_NEWS`, default `true`), added to `allowsMoreFeature`.
- `lib/navigation/release_redirect.dart` — gate `/news` behind the flag, redirect `/learn`.
- `lib/shared/widgets/more_features_sheet.dart` — entry tile in "Luyện thêm" group.
- `lib/l10n/app_{vi,en,de}.arb` + regenerated `app_localizations*.dart` — added `newsReading` key only.
- `test/structure/release_live_data_guard_test.dart` — added 7 news source files to the mock/fixture-marker guard scope.
- `docs/flutter-live-data-inventory.md` — new `/news`, `/news/:slug` row.
- `docs/api-changelog.md` — new changelog row documenting contract + scope decisions.

## Scope decisions (not gaps)

- Leaderboard (`GET /news-leaderboard`) and user rank (`GET /user/news-rank`) intentionally NOT wired — spec explicitly scoped to list + detail + progress + week stats.
- Quiz grading is client-side (backend has no dedicated news-quiz grading endpoint, only raw `question/options/correct/explanation_vi`) — same precedent as `/exam/dictation`.
- Word lookup reuses existing `showWordLookupSheet`/`TappableSentence` (same pattern as `/reading/detail`) — no new dictionary code written.

## Tests

- Contract: 8/8 pass (`test/repositories/news_contract_test.dart`).
- Widget: 8/8 pass (list 4 + detail 4).
- Guard: `release_live_data_guard_test.dart` passes with news files added to scope (no mock/fixture markers).
- Full suite: `flutter test` → 435/435 pass, zero failures (other agents' domains untouched and green at time of this run).
- `flutter analyze`: 0 issues in touched files; repo-wide only 2 pre-existing unrelated info-level deprecation notices (`lib/screens/exam/de_thi_practice_screen.dart`, not touched by this task).

## Unresolved questions

None — contract fully verified against backend handler source and web service before writing DTOs.

Status: DONE
Summary: News list + detail surface built live end-to-end (list/detail/progress/week-stats), wired into router + More-sheet + release flag, contract/widget tests green, full suite 435/435 pass.
Concerns/Blockers: none.
