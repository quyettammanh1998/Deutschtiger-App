# YouTube tracker + watch, Video library — implementation report

Date: 2026-07-16. Scope: phase-01 (media/video), narrowed per assignment to
YouTube tracker + watch + video-library (tracker/watch), dictation/shadowing
stubbed with gap notes.

## Files created

- `lib/data/youtube/youtube_video.dart` — `YouTubeVideo`, `YouTubePopularVideo`, `YouTubeStats`, `YouTubeContributionDay`.
- `lib/data/youtube/video_library.dart` — `VideoLibraryConfig`, `VideoLibraryGroup`, `VideoLibraryPathVideo`, `LibraryVideo`, `LibraryGroupProgress`, `LibraryStats`.
- `lib/repositories/youtube/youtube_repository.dart` — one repo, reused by both surfaces (same backend table `youtube_videos`, library scoped by `library_slug`/`group_id`). Library learning-path config read from the public Supabase Storage bucket `video-libraries` (mirrors web `videoLibraryConfig` — pre-existing non-backend pattern, not new).
- `lib/view_models/youtube/youtube_provider.dart` — Riverpod providers for both surfaces.
- `lib/screens/youtube/youtube_tracker_screen.dart`, `youtube_watch_screen.dart`, `youtube_dictation_screen.dart` (stub), `youtube_shadowing_screen.dart` (stub), `widgets/youtube_video_card.dart`, `youtube_url_utils.dart`.
- `lib/screens/video_library/video_library_tracker_screen.dart`, `video_library_watch_screen.dart`.
- Tests: `test/repositories/youtube_contract_test.dart`, `test/screens/youtube/youtube_tracker_screen_test.dart`, `test/screens/video_library/video_library_tracker_screen_test.dart`.

## Files modified

- `lib/widgets/interview/transcript_panel.dart` — added `_TappableSentence` (word-level tap → existing `showWordLookupSheet`, no new dictionary code). Shared by interview `/learn/group/*/watch/*` and both new YouTube/library watch screens (DRY, per spec's explicit "Modify" list for this file).
- `lib/navigation/app_router.dart` — added `youtube`, `youtube/watch`, `youtube/dictation`, `youtube/shadowing` under existing `/listening` branch (inherits the `listening` flag gate via `release_redirect.dart`'s prefix match — no new flag needed); added top-level `/library/:slug`, `/library/:slug/watch`.
- `test/structure/release_live_data_guard_test.dart` — added the 9 new release-visible files (narrow append, contended file — resolved cleanly alongside 2 other agents' concurrent additions).
- `docs/flutter-live-data-inventory.md`, `docs/api-changelog.md` — new rows + gap notes (see below).

Files explicitly NOT touched: `pubspec.yaml` (`youtube_player_iframe: ^6.0.2` already present), all 3 ARB files (this domain's screens use hardcoded Vietnamese strings, matching the existing `lib/screens/interview/*` convention — no l10n keys needed), `lib/core/release/release_feature_flags.dart` (reused `listening` flag instead of adding a new one).

## Key decisions / scope cuts (per plan's explicit permission)

1. **Tracker + watch prioritized; dictation/shadowing stubbed.** Both stub screens render `ListeningComingSoon` and are wired into the router so nothing 404s; shadowing additionally needs Phase 8 mic-permission before it can go live.
2. **No cinema/fullscreen-landscape mode, no draggable floating bilingual subtitle, no continue-watching resume, no achievements/leaderboard.** Web's `youtube-watch-page.tsx` (767 LOC) has all of these; porting them was out of budget for this pass. Logged as a gap in `docs/api-changelog.md`.
3. **`sprechen-b1`/`sprechen-b2` NOT rewired.** Their web equivalent is a hardcoded 44+101-video list component with its own tabs + leaderboard — not a video-library slug, so "redirect cheaply to the new watch screen" (as the assignment allowed if cheap) did not apply cleanly; still show `ListeningComingSoon`.
4. **`/library/:slug` has no flag gate and no linked entry point yet** — it's reachable only by direct deep link today (nothing in the app navigates to it). Left live-with-gap rather than adding a speculative flag for an unlinked route.
5. Word lookup reused `lib/shared/widgets/word_lookup_sheet.dart` as-is (no new dictionary code), per instruction.

## Tests

- `flutter analyze` — clean for all touched/created files (0 issues); repo-wide analyze shows only pre-existing issues in other agents' domains (exam/de_thi deprecation, unused imports in ai/exam test files) — none introduced by this work.
- `flutter test` (full suite, run once) — my new tests all pass. Suite-wide failures are unrelated to this work: `test/l10n/app_localizations_test.dart`, `test/screens/ai/ai_chat_page_test.dart` (timeout), `test/screens/journey/course_detail_screen_test.dart`, `test/screens/journey/course_lesson_screen_test.dart` — all in other agents' active domains (ai, journey-courses), not youtube/video-library.
- Widget tests mock the player layer entirely (no `YoutubePlayerController` mounted in tests) by only exercising the tracker screens (list/loading/empty/error states); the watch screens were not widget-tested since `youtube_player_iframe` needs a real webview platform channel not available in `flutter_test` — consistent with how the pre-existing `video_player_screen.dart` (interview) also has no widget test.

## Unresolved questions

- None blocking. Open item for a future pass: whether `/library/:slug` should get its own release flag once something in the app actually links to it (e.g. if `sprechen-b1`/`sprechen-b2` get properly ported onto the video-library pattern later).

Status: DONE_WITH_CONCERNS
Summary: YouTube tracker+watch and video-library tracker+watch are live against the real backend contract, generalizing the existing interview transcript/notes/word-lookup widgets (DRY, interview untouched functionally). Dictation/shadowing are stubbed with gap notes as explicitly permitted; cinema mode/floating subtitle/achievements were cut for budget and logged as gaps, not silently dropped.
Concerns: sprechen-b1/b2 stay coming-soon (their web shape doesn't fit a cheap redirect); `/library/:slug` has no flag gate yet since nothing links to it.
