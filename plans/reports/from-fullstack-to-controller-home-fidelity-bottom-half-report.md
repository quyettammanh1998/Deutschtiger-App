# Home bottom-half visual-fidelity report (Agent 2/2)

Scope: missions, stats, leaderboard, quick_actions (Khám phá), community_links, premium_banner.
Did not touch header/search/hero/exam/shortcuts (Agent 1 territory).

## 1. Daily missions — `lib/screens/home/widgets/dashboard_sections.dart`
Full rework of `DashboardMissionsSection`/`DashboardMissionCard`/`DashboardMission` (search bar class untouched).
- Heading "🎁 Nhiệm vụ thưởng" 16px bold, header right shows `completed/total` (+ ✓ when all done) + a
  chevron that rotates and collapses the list (now `StatefulWidget`). Removed the "Xem tất cả" button/prop
  entirely (dropped `onSeeAllTap`).
- Aggregate progress bar (h6, amber `0xFFF59E0B` → `DesignTokens.emerald600` when all complete).
- Card: radius-12 row, H12/V10 padding, 32px icon box, 4-color palette cycling by index (exact hexes from
  spec), `+N XP` amber pill, `current/target` ratio text, completed → check icon + strikethrough + opacity 0.6.
- `DashboardMission` simplified to real fields only: `title, icon, xpReward, currentProgress, targetCount,
  isCompleted` (dropped unused `subtitle/progress/color` — nothing else referenced them, verified via grep).
- `home_screen.dart _mapMissions` now maps all 4 new fields and a new `_missionIcon()` switch translating the
  backend's real `Mission.icon` string (pencil/headphones/cards/book/zap/target/play/clipboard/gamepad) to
  Material icons — mirrors web `ICON_MAP`, replaces the old derived-from-completion icon.

## 2. Stats card — `lib/widgets/dashboard/mobile_stats_card.dart`
- `intl` `NumberFormat.decimalPattern(l10n.localeName)` for word/lookup counts (thousands separators).
- Tile layout: small icon beside the label, big number stacked below (dropped the left icon-box tile).
- Icons: words `menu_book_rounded`, lookups `description_outlined` (not the magnifier), online `access_time`;
  blue tint on words/lookups, emerald on the clock.
- Decorative blurred blue circle top-right (cheap `Positioned` + circle `Container`).
- Streak: big orange number + separate "ngày" label; online value emerald bold, same 24px size as streak.

## 3. Weekly leaderboard — `lib/screens/home/widgets/weekly_leaderboard_compact.dart`
- Header "🏆 Tuần này" 14px bold + "Xem đầy đủ →" link (arrow appended via l10n value, not hardcoded).
- Score: raw number, no " XP" suffix.
- Rank medals 🥇🥈🥉 for 1-3 (`_rankMedal`).
- Avatar fallback: `DesignTokens.primary` tint (10%) + primary text, replacing orange.
- Current-user highlight: `bg-primary/5` + `ring-primary/40` — computed client-side by comparing each
  entry's `user_id` (already in the `/leaderboard/weekly` payload) against
  `ref.watch(authServiceProvider).currentUser?.id`. **Not** derived from a backend `is_current_user` flag
  (that field exists in `LeaderboardEntry.fromJson` but the weekly backend response never populates it —
  verified against `WeeklyLeaderboardEntry` Go struct, which has no such JSON key).
- My-rank row when outside top 3: added `myWeeklyRankProvider` (new `FutureProvider` in this file) calling
  the **real, already-live** `GET /user/leaderboard/weekly-rank` endpoint (confirmed in
  `leaderboard_handler.go` / `routes_user_progress.go` on the backend — returns the user's own
  `WeeklyLeaderboardEntry` incl. `rank`). Backend responds with a literal JSON `null` body when the user has
  no weekly score yet; since `ApiClient._request` treats an empty body as `ApiException`, the provider
  catches that and resolves to `null` (renders nothing) rather than surfacing an error. This is real backend
  data, not fabricated — no data gap here.
- Empty state: two-line message (title + "Học hôm nay để trở thành người đầu tiên! 🔥").
- Encouragement footer switches between in-top-3 ("🎉") and not-in-top-3 ("🔥") copy, matching web.

## 4. Quick actions "Khám phá" — `lib/widgets/dashboard/quick_actions.dart` + new
`lib/widgets/dashboard/quick_actions_data.dart`
Full rework, split into a companion data file (both < 210 LOC) to keep the registry separate from rendering:
- `quick_actions_data.dart`: `QuickActionCatalogItem`/`QuickActionGroup` + `buildExploreGroups()` — mirrors
  web `EXPLORE_GROUPS`. Groups: 🎓 Luyện thi (lead), Từ vựng & Ôn tập, Nghe & Xem, Viết & Nói (AI), Khác.
  11 items total, each gated by the same `ReleaseFeatureFlags` used elsewhere in Home (listening, news,
  sentenceBuilder, aiTutor, games, affiliate); gated items are filtered out and empty groups are dropped.
- `quick_actions.dart`: category tab pills (lead pill = orange gradient when active; others = dark pill when
  active, card+border when inactive) + trailing "Tất cả →" pill that opens the existing
  `MoreFeaturesSheet.show(context)`. Below: 2-column grid of the active group's tiles (40px tinted icon
  square + title 14px + subtitle 11px muted, card+border, `context.push(item.route)`).
- **Deliberate omission (accepted gap, not fabricated)**: web's registry also has "Khóa học" (course) and
  "Phỏng vấn" (interview) items. Flutter has no `/course` or `/course/interview` routes
  (verified via `grep` on `lib/navigation/app_router.dart`) — rather than link to a non-existent screen,
  these two items are omitted entirely from `buildExploreGroups`. Everything else maps to real, existing
  Flutter routes (`/exam`, `/vocabulary`, `/my-words`, `/daily-review`, `/listening/youtube`, `/listening`,
  `/news`, `/games/sentence-builder`, `/ai-tutor/chat`, `/games`, `/affiliate`).
- Constructor changed: `QuickActions({totalWords})` replacing `onLearnTap/onReviewTap/onExamTap/showAi/
  onAiTap` — navigation now lives per-tile via GoRouter instead of parent-supplied callbacks. Updated
  `home_screen.dart` call site (`QuickActions(totalWords: dash.wordsLearned)`) and removed the now-dead
  `QuickActionItem`/`_QuickActionButton` old API.

## 5. Community links — `lib/screens/home/widgets/community_links.dart`
- `flutter_svg` `SvgPicture.string()` with the exact Zalo/Facebook SVG path data copied from web
  `community-links.tsx` (white glyph on colored square), replacing the generic Material icons.
- Zalo square color → `0xFF3B82F6` (blue-500, matches web; web deliberately does not use Zalo's own brand
  blue). Facebook stayed `0xFF1877F2` (already correct).
- Heading rendered via `l10n.communityLinksTitle.toUpperCase()` (web applies CSS `uppercase`; kept the l10n
  string itself unchanged and transform at render time — no new key needed).

## 6. Premium banner — `lib/screens/home/widgets/premium_banner.dart`
No functional change (per plan). Added a doc comment recording the accepted image-parity gap: web renders a
full-width `premium-banner.webp` (not in this repo) vs. the current gradient placeholder; harmless today
since `ReleaseFeatureFlags.premium` is off (block never renders). Flag gate left untouched (release decision).

## New tokens / l10n / files
- No new `DesignTokens` needed — reused Agent-1's orange500/600, emerald50/600/700, amber100/700, plus
  existing `primary`/`border`/`foreground`. Mission-card palette hexes are inline consts in
  `dashboard_sections.dart` (per plan).
- New l10n keys (added to `app_vi.arb`/`app_en.arb`/`app_de.arb`, ran `flutter gen-l10n`):
  `dailyMissionsHeading`, `weeklyLeaderboardInTop3`, `noWeeklyLeaderboardSubtitle`, `qaTab{Exam,Vocab,
  Listen,Ai,Other,All}`, `qa{Exam,Vocab,Notes,Review,Youtube,Listen,News,SentenceAi,AiTutor,Games,
  Affiliate}{Title,Subtitle}` (13 pairs). Edited existing-value-only (no test depended on old text, verified
  via grep): `weeklyLeaderboard`, `seeFull`, `learnMoreToRank`, `noWeeklyLeaderboard` text updated to match
  web copy (emoji/arrow). Left `todayMissions`/`seeAll` keys defined-but-unused-here since
  `app_localizations_test.dart` asserts `todayMissions` verbatim and `seeAll` is still used by
  `pinned_shortcuts.dart`/`stats_screen.dart` (Agent-1/other-owned files).
- New file: `lib/widgets/dashboard/quick_actions_data.dart`.

## Tests
- Updated `test/features/home/release_navigation_gates_test.dart` and `test/l10n/app_localizations_test.dart`
  for the changed `QuickActions`/`DashboardMissionsSection` constructors (old API is gone by design). No
  coverage was removed — each rewritten assertion still exercises the same behavior class (gated-affordance
  hiding, 200%-text-scale reflow, localization) against the new API/copy.
- `flutter gen-l10n`: clean.
- `flutter analyze` (full project): 0 new issues — only the 5 pre-existing infos (RadioGroup deprecation in
  `de_thi_practice_screen.dart`, `prefer_initializing_formals` in 3 unrelated test files).
- `flutter test` (full suite, 550 tests) + targeted `test/features/home/ test/l10n/ test/structure/` (96
  tests): all pass, including `release_live_data_guard_test.dart` and the architecture/structure tests.

## Unresolved questions
- None blocking. One judgment call worth flagging: the web "AI Tutor" quick-action tile links to
  `conversation-hub` (a voice-practice concept); Flutter has no equivalent screen, so I routed it to
  `/ai-tutor/chat` (text chat) instead and used a more accurate subtitle ("Trò chuyện cùng AI" vs web's
  "Luyện nói cùng AI") to avoid overclaiming a voice feature that doesn't exist yet.

Status: DONE
Summary: Reworked missions/stats/leaderboard/quick-actions/community-links for web parity, added a real (not
fabricated) my-weekly-rank data source, documented the premium-banner and course/interview quick-action gaps
as accepted, all tests/analyze green.
Concerns/Blockers: none.
