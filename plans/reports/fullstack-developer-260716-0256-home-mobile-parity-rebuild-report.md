# Home/Dashboard mobile parity rebuild — report

## What changed
Reordered `lib/screens/home/home_screen.dart` to match web
`mobile-dashboard-layout.tsx` block order, and added 4 new widgets +
1 new repo/model/provider trio for the exam-goal countdown.

## Final block order (after header)
1. `MobileDashboardHeader`
2. `DashboardSearchBar`
3. `DashboardContinueLearningSection` (daily-path hero) — promoted from last to first content block
4. `ExamCornerCard` (new) — countdown strip, `SizedBox.shrink()` when no goal/loading/error
5. `PinnedShortcuts` (new) — up to 10 shortcuts, 5-col grid, flag-gated
6. `DashboardMissionsSection` (existing)
7. `MobileStatsCard` (moved below missions)
8. `WeeklyLeaderboardCompact` (moved below stats)
9. "Khám phá" heading + `QuickActions` (heading added)
10. `PremiumBanner` (new) — gated on `ReleaseFeatureFlags.premium` (off by default → `SizedBox.shrink()`)
11. `CommunityLinks` (new) — static Zalo + Facebook cards

## New files
- `lib/data/learn/learn_goal.dart` — plain Dart model (manual `fromJson`, no freezed per instructions) for `GET /user/learn/goals`; parses only the `YYYY-MM-DD` head of `target_date` (mirrors web's RFC3339-slice comment) as local midnight.
- `lib/repositories/learn/learn_goal_repository.dart` — `fetchGoal()` via existing `ApiClient` pattern.
- `lib/screens/home/widgets/exam_corner_card.dart` — compact single-row strip: headline (còn N ngày / thi hôm nay / đã qua) + "Độ sẵn sàng" link (`/exam/readiness`) + CTA button (`/exam`, or "Đặt mục tiêu mới" when overdue). Renders `SizedBox.shrink()` on loading/error/no-`target_date` — no fake data ever shown.
- `lib/screens/home/widgets/pinned_shortcuts.dart` — 10-item shortcut grid mirroring web `PINNED_SHORTCUTS`; each item's `enabled` is driven by the existing `ReleaseFeatureFlags` (aiTutor, sentenceBuilder, listening ×2, games, journey); disabled items are skipped, not shown greyed-out (matches existing more-features-sheet pattern). "Xem tất cả" reuses `MoreFeaturesSheet.show(context)`.
- `lib/screens/home/widgets/community_links.dart` — static Zalo (`https://zalo.me/g/sijofs162`) + Facebook (`https://www.facebook.com/deutschtigervn`) cards, `url_launcher` (existing dependency), same open/error pattern as `SettingsActions.openUrl`.
- `lib/screens/home/widgets/premium_banner.dart` — gated on `ReleaseFeatureFlags.premium` (currently `false`) and `isPremiumUser` (wired from `myProfileProvider`'s `isPremium`); renders `SizedBox.shrink()` when either is true — currently always shrink in production builds since the flag is off.

## Modified files
- `lib/screens/home/home_screen.dart` — reordered Column, added imports, added "Khám phá" section heading, wired `PremiumBanner(isPremiumUser: ...)`.
- `lib/view_models/providers.dart` — added `learnGoalRepositoryProvider` + `learnGoalProvider` (FutureProvider, refetches on auth change like `dashboardProvider`).
- `lib/l10n/app_vi.arb`, `app_en.arb`, `app_de.arb` — added 18 new keys (pinned-shortcut labels, explore heading, exam-corner strings, premium banner CTA, community-links strings); ran `flutter gen-l10n` to regenerate the 4 generated `lib/l10n/app_localizations*.dart` files. Reused existing keys where present (`examPractice`, `dailyReview`, `vocabulary`, `myWords`, `gamePractice`, `seeAll`, `couldNotOpenLink`).

## ExamCorner contract wiring status
Live — `GET /user/learn/goals` confirmed against
`learning/learn_goals_handler.go` (always 200, synthesized default row when
none exists). Repository/provider wired through the standard `ApiClient` DI
chain. No mock data: absent `target_date` (default/no-goal state) renders
nothing, matching the release-live-data guard.

## Simplifications vs. web (scope-appropriate, noted per instructions)
- Web's `ExamCornerCard` swaps in an inline `ExamGoalSetterCard` modal when
  no goal exists; the Flutter spec explicitly said render `SizedBox.shrink()`
  in that case instead — no goal-setter UI was built (out of Home's scope;
  goal creation isn't otherwise wired into this app yet).
- The provider-specific "continue exam" deep link (`ExamCornerContinueCta`,
  routes into a specific Goethe/telc/ÖSD flow) is simplified to `context.push('/exam')`
  (the exam hub) — no per-provider routing data was available to port safely.
- `PremiumBanner` uses an icon+gradient strip instead of web's static
  `/images/premium-banner.webp` asset (no such asset ships in this app).

## Analyze / test results
- `flutter analyze`: clean — 0 new issues; only the pre-existing 5 info lints remain (unrelated files: `de_thi_practice_screen.dart` deprecated Radio API, 3 test files `prefer_initializing_formals`).
- `flutter test test/features/home/ test/structure/ test/l10n/`: **80/80 passed**, including `release_live_data_guard_test.dart` (no mock/fixture/placeholder literals in `home_screen.dart`) and `app_localizations_test.dart` (l10n keys resolve/reflow correctly across locales, "Home quick actions use the active localization").

## Unresolved questions
None — scope was clear from the web reference; simplifications above were made per explicit spec instructions (SizedBox.shrink() fallback for exam corner) or due to missing app-side equivalents (goal-setter flow, provider-specific exam routing, banner image asset).

Status: DONE
Summary: Home reordered to match web mobile layout exactly (path hero → exam corner → pinned shortcuts → missions → stats → leaderboard → Khám phá/quick actions → premium banner → community links); 4 new widgets + live exam-goal repo/provider added; analyze clean, 80/80 relevant tests pass.
Concerns/Blockers: none.
