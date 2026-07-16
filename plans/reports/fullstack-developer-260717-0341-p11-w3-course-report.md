# P11 Wave 3 — Course (hub/detail/lesson)

Scope: `plans/260716-2324-web-mobile-ui-100-fidelity/phase-11-media-reading-news.md` §W3 only.
Web source read per-page before coding (`thamkhao/deutschtiger-frontend/src/pages/course/*.tsx`).

## Status per screen

| Screen | Verdict before | Work done | Verdict now |
|---|---|---|---|
| `courses_hub_screen.dart` | DIVERGENT | Full rebuild: back+title+"N khoá · M+ bài học" stats bar, search field (client-side name/nameVi filter), level-jump pills (scroll via `GlobalKey`+`Scrollable.ensureVisible`), "Khoá học của tôi"/"Nổi bật" sections (poster `CourseCard`s, expand-after-4 `CourseGridExpandable`), premium lock badges + upsell banner, per-level sections. Route moved `/journey/courses` → `/course`. | CLOSE |
| `course_detail_screen.dart` | DIVERGENT | Full rebuild: poster-less bordered lesson-row list (thumbnail 80×48, "Bài NN", name/nameVi, emerald "Đã hoàn thành"/amber "N%"/muted "Chưa học"/lock "Premium" pill), premium upsell banner, numbered pagination (page buttons + "Trang x/y · Hiển thị a–b"), "Tiến độ học" progress-ring card. Route moved `/journey/courses/:slug` → `/course/:slug`. | CLOSE (no leaderboard — see deviations) |
| `course_lesson_screen.dart` | DIVERGENT (major — no playback at all) | Full rebuild: video playback (mp4 self-hosted via WebView, YouTube iframe fallback), lesson-switcher strip ("Danh sách bài", horizontal chips), completion button gated on 80%-watched (amber hint pill before threshold), collapsible transcript (DE/VI toggle, copy DE/copy VI, tap-to-seek, active-segment highlight+auto-scroll), paginated vocab (4/page) with per-word audio (`SpeakButton` reuse), notes (kept from old screen, re-themed), comments (new, `target_type=course_lesson`). Route moved `/journey/courses/:slug/lessons/:num` → `/course/:slug/lessons/:num`. Mark-complete awards XP via existing `POST /user/gamification/award-xp`. | CLOSE (see deviations) |

## Files

**New**: `lib/screens/journey/widgets/{course_card,course_grid_expandable,course_hub_header,course_hub_sections,course_hub_my_featured_sections,course_premium_upsell_banner,course_lesson_row,course_numbered_pagination,course_progress_ring_card,course_video_player,course_lesson_strip,course_transcript_panel,course_transcript_segment_tile,course_vocab_paginated,course_comment_section,course_notes_section,course_lesson_body}.dart`, `lib/navigation/routes/course_routes.dart`, tests `test/screens/journey/course_german_200_percent_test.dart`.

**Rewritten**: `lib/screens/journey/{courses_hub_screen,course_detail_screen,course_lesson_screen}.dart`, `test/screens/journey/{courses_hub_screen_test,course_detail_screen_test,course_lesson_screen_test}.dart` (updated assertions for the new structure — "check icon" → status-pill text, "3 bài tập" hint removed since web itself has the exercise engine commented out).

**Appended**: `lib/view_models/journey/journey_provider.dart` (+`courseCanAccessAllProvider`, reads `ReleaseFeatureFlags.premium` + reuses read-only `premiumProvider` from `lib/features/premium/**`), `lib/repositories/journey/journey_repository.dart` (+`awardLessonVideoXp()`), `lib/navigation/app_router.dart` (+import/spread `courseRoutes`), `lib/navigation/release_redirect.dart` (+`/journey/courses*` → `/course*` redirect), `test/structure/release_live_data_guard_test.dart` (added all new/rewritten course files), `docs/flutter-api-contract-matrix.md` (+course XP row), `docs/api-changelog.md` (+row), `docs/web-feature-parity-matrix.md` (updated `course` row).

**Edited (scoped, not owned)**: `lib/navigation/routes/journey_routes.dart` — removed the 3 course sub-routes (file's `Owner: P3` comment kept; only `/journey` top route remains). Necessary to align routes to web `/course/*` per plan; flagged for P3 sibling coordination below.

**Not touched**: any listening/podcast/sprechen (W1), youtube/video-library/interview (W2), reading/news (W4) files, `lib/core/**`, `lib/widgets/common/**`, `lib/shared/widgets/**`, `pubspec.yaml`, `lib/screens/journey/journey_screen.dart`/other journey widgets, `lib/screens/home/**` (pinned_shortcuts.dart still links `/journey/courses` — works transparently via the new redirect, no edit needed).

## Reuse (confirmed before writing new widgets)

`context.tokens` (`AppTokens`) throughout. `AppButton`/`AppGradientButton` (mark-complete + upsell CTA), `AppPill`-style inline pills (own small `_Pill`/`_Badge` widgets for the specific emerald/amber/blue/DW badge palette — no generic token for per-CEFR-level colors, matches W2's precedent of literal hex for status badges), `PremiumGateCard` (locked-lesson full-page gate, same widget W2 used for interview `PurchaseGate`), `SpeakButton` (`lib/shared/widgets/speak_button.dart` — vocab audio, URL→TTS fallback, no new audio code needed), `LoadingView`/`ErrorView` (`async_state_views.dart`). W2's `lib/screens/youtube/widgets/*` were reviewed but NOT reused directly — course hub/detail have a fundamentally different visual language (poster grid + search + level-jump vs. W2's tracker/filter-bar family) and W2 itself flagged its `VideoCollection*` set as W1-specific already; a 3rd course-specific variant would have been worse than purpose-built small widgets here.

## Deviations (documented per plan requirement)

1. **No `video_player` package** (pre-existing constraint, not addable — `pubspec.yaml` is DO-NOT-TOUCH): self-hosted mp4 playback uses `webview_flutter` (already a dependency) loading a minimal HTML5 `<video controls>` page with a JS bridge (`addJavaScriptChannel`) posting `time:cur:dur`/`ended` events for the 80%-watch completion gate and tap-to-seek. YouTube fallback (rare for DW courses — `youtubeId` is effectively unused by this content source; only `interview` kind, owned by W2, uses it) reuses the same WebView with an `<iframe>` embed — official player, no download/cache, same compliance posture as `youtube_player_iframe`.
2. **80%-watch gate simplified**: uses `currentTime/duration` ratio at each JS-bridge ping rather than web's accumulated-actual-playtime anti-skip tracker (a user could scrub to the end without watching to trigger it). Documented trade-off for the WebView-based player; not a security-sensitive gate (just a UX nudge), so accepted.
3. **No periodic 30s auto-save timer**: progress saves on toggle-complete + an explicit "Lưu tiến độ" button (web has both an interval timer and manual button). Matches the plan's KISS principle; last-watched-seconds is best-effort, not lost on natural exit since toggle-complete always persists.
4. **Floating subtitle overlay dropped** (`CourseFloatingSubtitle` on web): same reasoning W2 used for YouTube's cinema/floating-subtitle mode — no safe way to overlay video chrome without a native player control surface we don't have. The collapsible transcript panel with tap-to-seek + auto-scroll covers the plan table's "transcript" requirement.
5. **Course-detail leaderboard (`CourseLeaderboard`) deferred**: same "shared widget doesn't exist yet" gap W2 already flagged for news/podcast/easy-german/interview/video-library — not duplicating a 6th one-off leaderboard widget in this wave.
6. **Course comments are an own-copy widget** (`course_comment_section.dart`, `target_type=course_lesson`), not shared with `lib/features/exam/presentation/widgets/mobile_player/exam_comment_section.dart` (`target_type=exam`) — that file is outside my file-ownership boundary this wave; both hit the same live `/comments` endpoint contract. Flagged for a future generic-comment-widget consolidation pass (W2 flagged the same gap for video comments).
7. **Exercises engine not built**: web's own `course-lesson-page.tsx` has `ExerciseSection` commented out (`// import { ExerciseSection }`) — matching web's actual shipped state, not a Flutter gap. `DwLessonDetail.exercises`/`exerciseCount` stay unused on this surface (pre-existing model comment already documented this).
8. **Premium lock UI gated by `ReleaseFeatureFlags.premium`** (default off): when off, `courseCanAccessAllProvider` short-circuits to `true` — no lock badges/upsell banner render at all, same precedent as `lib/screens/home/widgets/premium_banner.dart` (`if (!ReleaseFeatureFlags.premium) return SizedBox.shrink()`). When the flag turns on, it reads the real `premiumProvider` (RevenueCat entitlement, `lib/features/premium/**`, read-only reuse).
9. **l10n**: all new UI strings routed through ARB (vi/en/de) + `flutter gen-l10n` — unlike W2's precedent (which left the sibling youtube/video-library family hardcoded, citing an existing pattern in that directory), the `journey/course` family had no such precedent, so this wave stays ARB-clean.

## Route/coordination note

`lib/navigation/routes/journey_routes.dart` carries a header comment `Owner: P3 (learn-journey)`. Per this wave's explicit grant ("FILES YOU OWN: ... the course route block"), I removed only the 3 nested course routes from that file (leaving `/journey` itself untouched) and created the new top-level `lib/navigation/routes/course_routes.dart`. This is a genuine cross-boundary edit — flagging for the P3 sibling agent to confirm no conflict when P3's phase lands. `lib/navigation/app_router.dart` got one import + one spread line added (same low-risk pattern W2 used for `mediaRoutes`).

## Contract work

No new backend contract — `awardLessonVideoXp()` reuses the already-live/documented `POST /user/gamification/award-xp` (first probed by P11 W2 for dictation XP; this is the second Flutter caller). Documented in `docs/flutter-api-contract-matrix.md` §Generic XP award and `docs/api-changelog.md`.

## Validation

- `flutter analyze` on all touched/new files: 0 issues. Full-repo `flutter analyze`: 132 pre-existing issues, none in `lib/screens/journey/**`, `lib/navigation/**`, or any `course_*` file (confirmed via grep — all in concurrent agents' in-progress `lib/screens/exam/writing/**` / `lib/view_models/settings/**` work).
- `flutter test`: `test/screens/journey/**` (35 tests incl. rewritten `courses_hub_screen_test.dart`/`course_detail_screen_test.dart`/`course_lesson_screen_test.dart` + new `course_german_200_percent_test.dart`), `test/repositories/journey_course_contract_test.dart`, `test/structure/release_live_data_guard_test.dart`, `test/l10n/app_localizations_test.dart` — all green.
- German 200% text-scale: dedicated smoke test added for all 3 screens (fixed several real `RenderFlex` overflows found by it — course-card bottom row, level/featured section headers, lesson-row status pill, lesson strip, transcript panel header action cluster which needed a `FittedBox(fit: scaleDown)` since even a `Wrap` reflow wasn't enough for the 3-button cluster at 2x).
- Video mp4 playback is NOT exercised by widget tests (`webview_flutter` asserts on `WebViewPlatform.instance`, only registered on-device) — `CourseVideoPlayer` now guards `WebViewController` construction so lessons with `video: null` or a video with neither `mp4` nor `youtubeId` never touch the platform channel, keeping the rest of the lesson screen fully testable; the actual video code path needs on-device/manual verification.
- All new/rewritten files kept under 200 LOC (split `courses_hub_screen.dart` into `course_hub_sections.dart` + `course_hub_my_featured_sections.dart`; split `course_transcript_panel.dart`'s item builder into `course_transcript_segment_tile.dart`).

## Unresolved questions

1. `journey_routes.dart` route removal — needs P3 sibling confirmation (no code conflict found via `flutter analyze`, but the file's ownership comment predates this wave's grant).
2. Course/detail leaderboard + video comments — same "who builds the shared widget" question W2 already raised; now 3 features (news/podcast/interview/video-library from W2, course from W3) are waiting on it.
3. `mp4` self-hosted playback via WebView is functionally new territory for this codebase (no prior precedent) — recommend an on-device smoke test before this wave is considered fully verified, since widget tests structurally cannot exercise it.

Status: DONE
Summary: All 3 W3 course screens rebuilt with live data (routes aligned to web `/course/*`), video playback added where there was none before (WebView-based mp4 + YouTube-iframe fallback, since no `video_player` dep exists), transcript/paginated-vocab-audio/notes/comments/premium-locks/pagination all shipped; leaderboard and shared comment-widget consolidation deferred with W2's same rationale.
Concerns/Blockers: none blocking — see Unresolved questions above for follow-up coordination.
