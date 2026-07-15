# Courses/Journey mock → live report

Status: DONE
Date: 2026-07-16

## Summary

Chuyển DW course catalog (hub/detail/lesson) sang live API, xoá hoàn toàn
roadmap A1-C2 giả lập không có backend contract, bật flag `journey`.

## Backend contracts used

- Public: `GET /courses`, `GET /courses/{slug}`, `GET /courses/{slug}/lessons/{num}`, `GET /featured-courses`
- Auth: `GET /user/courses/my-courses`, `GET/PUT /user/courses/{slug}/progress`+`/lessons/{num}/progress`, `GET/PUT /user/courses/{slug}/lessons/{num}/notes`
- Verified against `internal/feature/content/video/course_handler.go`, `featuredcourses`, `internal/feature/learning/courseprogress`, route registration in `routes_public.go`/`routes_user_public.go`/`routes_user_media.go`.
- `/user/courses/*` are gated by `premiumChecker.RequireModule(ModuleCourse)` server-side — repository treats 401/403 as "not started"/empty (matches web `courseProgressService`/`courseLessonNotesService` blanket catch).

## Decision: removed the old A1-C2 roadmap instead of faking it live

`journey_roadmap_screen.dart`, `learning_browser_screen.dart`,
`widgets/chapter_detail_screen.dart` + `widgets/journey_roadmap.dart` and the
`JourneyChapter`/`JourneyLesson`/`LearningItem`/`JourneyProgress` mock models
had no backend equivalent at all (no "chapter"/"A1-C2 roadmap" concept exists
server-side; that was 100% client fixture data). Per "endpoint thiếu → bỏ
section", deleted rather than left as fake-live. Vocabulary browsing already
lives at `/vocabulary` (`lib/features/vocabulary/`, separate completed
domain) so nothing was lost.

Domain name kept as `journey` (dir/route prefix) — renaming to `course`
would have touched contended `lib/navigation/app_router.dart` import lines
disproportionately for a cosmetic rename; noted here per instructions.

## Files Modified/Created

- Rewrite: `lib/repositories/journey/journey_repository.dart` (ApiClient-backed, no `/api/v1` prefix duplication — `ApiClient.baseUrl` already contains it, matched `podcast_repository`/`features/vocabulary` convention, NOT the `repositories/vocab/vocabulary_repository.dart` double-prefixed pattern)
- Delete: `lib/repositories/journey/mock_data.dart`
- Rewrite: `lib/features/journey/domain/course_models.dart` (manual `fromJson`, no Freezed — matches file's pre-existing "simplified without Freezed" convention)
- Delete: `lib/features/journey/data/course_provider.dart` (static DW data folded into the live repository/providers)
- Rewrite: `lib/view_models/journey/journey_provider.dart` (single provider source: catalog, featured, my-courses, course detail, course/lesson progress, lesson content, lesson notes)
- Delete: `lib/data/journey/journey_models.dart` (+ `.freezed.dart`/`.g.dart`), `lib/screens/journey/journey_roadmap_screen.dart`, `lib/screens/journey/learning_browser_screen.dart`, `lib/screens/journey/widgets/{chapter_detail_screen,journey_roadmap}.dart`
- Rewrite: `lib/screens/journey/courses_hub_screen.dart` (featured + my-courses + catalog by level, live)
- Create: `lib/screens/journey/course_detail_screen.dart` (lesson list + per-lesson progress)
- Create: `lib/screens/journey/course_lesson_screen.dart` (video placeholder, vocab, mark-complete, notes)
- Modify: `lib/screens/journey/journey_screen.dart` (added "Khoá học" entry tile → `/journey/courses`)
- Modify: `lib/navigation/app_router.dart` (replaced `/journey/roadmap|browse|chapter/:id` with `/journey/courses`, `/journey/courses/:slug`, `/journey/courses/:slug/lessons/:num`)
- Modify: `lib/core/release/release_feature_flags.dart` (`journey` default → `true`)
- Modify: `lib/l10n/app_{vi,en,de}.arb` + generated sources (new `courses*` keys)
- Modify: `docs/flutter-live-data-inventory.md`, `docs/api-changelog.md` (gap notes below)
- Modify: `test/l10n/app_localizations_test.dart` (flip the one assertion tied to the flag default I was asked to flip)
- Create: `test/repositories/journey_course_contract_test.dart` (8 cases: catalog/detail/lesson parsing, featured, my-courses swallow-on-403, lesson-progress null-on-401/not-started, upsert progress/notes PUT contracts)
- Create: `test/screens/journey/{courses_hub,course_detail,course_lesson}_screen_test.dart` (happy/empty/error per screen, 9 widget tests)

## Documented gaps (no fake data added)

1. Interactive DW lesson exercises (`exercises`/`inquiries` — cloze, dictation, MC) not rendered; only exercise count + "available on web" hint. Needs a dedicated exercise engine, out of this phase's scope.
2. Self-hosted lesson video (`video.mp4`) does not play in-app — no `video_player`/`chewie` dependency in `pubspec.yaml` (only `youtube_player_iframe`, unsuitable for mp4). Shows a placeholder instead of adding a new dependency mid-phase. YouTube-sourced lesson video is explicitly out of scope (media/video-library phase owns that).
3. Course leaderboard (`GET /courses/{slug}/leaderboard`) not surfaced.

## Tests Status

- `flutter analyze`: clean (3 pre-existing issues in `de_thi_practice_screen.dart` deprecation + `news_contract_test.dart` unused import — both other agents' domains, unrelated).
- `flutter test` (full suite, run once after all changes): 427 passed. One transient failure (`test/l10n/app_localizations_test.dart: release flags map every gated More-sheet route family`) was the direct, expected consequence of flipping `journey` default to `true` — updated that one assertion.
- New tests: 8 repository contract + 9 widget tests, all green.

## Unresolved questions

- None blocking. Course leaderboard and interactive exercises are flagged as documented gaps, not open questions.
