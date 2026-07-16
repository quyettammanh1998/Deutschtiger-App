# Phase 12 Wave A — Social/AI slice implementation report

Scope: social/AI rows of phase-12 table only (`ai_chat_page`, `social/profile_page`
+ `/profile`, `friends_page`, `messages_page`, `chat_page`, `duel_*`,
`challenges_page`). Stats/leaderboard and settings owned by sibling agents (not
touched).

## Per-screen status

### `ai_chat_page.dart` — DONE
- Bubble/send color: already orange via P1 token fix to `AppColors.primary`
  (`design_tokens.dart:62`) — verified, not re-hacked.
- Markdown render: assistant bubbles now use `AppMarkdownView` (P6 shared
  renderer) instead of plain `Text`.
- Feature-action chips: ported web `FEATURE_ACTIONS`/`detectFeatureActions`
  (keyword table + 3-chip cap, `/games/*` de-dup rule) as `_FeatureActionChips`
  under finished assistant replies, deep-linking via `context.push`.
- Session/quota limit cards: `_LimitCard` replaces the old error-strip for
  `sessionLimitReached`/`quotaExceeded` banners (card layout, "+ Tạo cuộc trò
  chuyện mới" CTA for session limit) — prefers the server's `bannerMessage`
  over generic copy so the real free-tier count isn't dropped.
- Back button added to header (`context.pop()`/`context.go('/home')`).
- History panel: mobile now swaps the message list full-width (was a 280px
  squeezing side rail) — matches web's inline full-panel pattern.
- Input placeholder: field stays enabled while `isSending` (matches web); only
  disables + shows "Đã hết lượt..." on a true `limitReached` state.
- NOT done: image attach (up to 5), voice mic + `VoiceRecordingOverlay`,
  SpecialCharBar — all require new UI + flag wiring beyond a styling pass;
  flagged as remaining scope, not silently dropped.

### `social/profile_page.dart` + `/profile` — DONE
- Full rebuild: cover gradient header, avatar (premium amber ring + crown,
  online dot), name + `PremiumBadge`-equivalent, active title (italic
  primary), online/joined-date status line, 5-stat row (Level w/ XP progress
  bar, streak, longest streak, XP, friends), "Hành trình học tập" 2×4 card
  (CEFR badge, weekly rank, words learned, reviews), "Thành tích" grid
  (client-computed achievements, port of web's pure `computeAchievements`,
  tap-to-expand description), "Hoạt động gần đây" timeline (event-type→
  icon/description map, relative time).
- Model: `SocialPublicProfile` extended with `createdAt`, `isPremium`,
  `weeklyXp`, `currentActivity`, `totalFlashcards`, `weeklyRank`,
  `recentActivities` — all already present in the Go
  `PublicProfileResponse` (`profile_handler.go:194-217`), just unparsed
  before. No new contract, no probe needed.
- `/profile` now renders `OwnProfilePage` → resolves own id via
  `myProfileProvider` → delegates to the same `ProfilePage` (web reuses
  `/u/:id` for self; Flutter keeps the dedicated nav-tab path per plan
  Decision 3e).
- **Deleted**: `lib/screens/profile/{profile_screen,edit_profile_screen,
  profile_controller}.dart`, `widgets/{profile_header,profile_stats_grid}.dart`
  (whole `lib/screens/profile/` dir removed).
- `release_redirect.dart`: added `'/profile/edit' → '/settings'` (append-only,
  minimal, per contested-file protocol).
- Guard list + `test/l10n/app_localizations_test.dart` updated (see Tests).
- **For the settings agent**: `/profile/edit` now 404s→redirects to
  `/settings`. Build the profile-edit card on the settings root and it will
  become reachable again. No route/redirect changes needed on your side.

### `friends_page.dart` — DONE
- Segmented tabs (`bg-muted` card-on-muted, active tab shadow), count pill on
  "Lời mời" tab, online (green heading)/offline sections, `Lv.X · Y ngày
  streak` format, `card-sm` rows, unread-badge on the header messages icon
  (real `unreadCountsProvider`), header subtitle "N bạn bè · M lời mời".
- Deviation: web's "Gợi ý kết bạn" needs a dedicated suggestions endpoint that
  doesn't exist (`friend_repository.dart` search requires a non-empty query
  server-side) — rendered the honest empty-state instead of faking
  suggestions from an unrelated dataset (documented in code).
- New `widgets/social_avatar.dart` (shared row avatar, sm/md sizes) used by
  friends/messages/chat.

### `messages_page.dart` — DONE
- Flat rows (no card chrome), back+subtitle header ("N cuộc trò chuyện"),
  "Bạn: " prefix on `isSender` previews, unread pill capped at "99+".

### `chat_page.dart` — PARTIAL
- Done: header online/activity status line (green when online, activity-label
  map, "Offline" fallback), time+read-receipt ticks moved OUTSIDE the bubble
  (was stacked inside).
- Deferred (per instruction — wire only if contract exists, don't mock):
  reactions, stickers, attachments UI, emoji/sticker picker, attach-menu,
  audio/video call buttons, char counter, "older messages" pagination link.
  These are functional gaps beyond styling that need a contract probe first.

### `duel_lobby_page.dart` / `duel_play_page.dart` — DONE (UI shell only)
- Deleted the `Random()`-based fake matchmaking (name/level/streak/winRate
  generator) and the fake-opponent `Timer`-based scoring loop — not replaced
  with new mock logic, per plan Decision #9.
- Lobby: room-code card, host player card (real current-user avatar/name via
  `myProfileProvider`), empty dashed guest slot, "Mời bạn bè" (→
  `/social/friends`, real screen), "Hủy phòng" (pop). No backend call — no
  duel-room contract exists yet (`useDuelRoom`/`useDuelMutations` on web have
  no Go-side counterpart found under `internal/feature/social` in a quick
  check; a real probe is needed before wiring, out of this wave's scope).
- Play: static score overlay (0–0, real my-avatar / placeholder opponent
  slot), full red timer bar, and an explicit "sắp ra mắt / đang kết nối" empty
  state instead of a fake question loop.
- Flag stays off (`ReleaseFeatureFlags.socialDuels`); not in the release-guard
  scan list (gated, unreachable).

### `challenges_page.dart` — NOT TOUCHED (deferred)
- Confirmed gate still default-off (`ReleaseFeatureFlags.socialChallenges`).
  Left the existing mock-backed implementation as-is — lowest priority per
  scout ("web route hidden too; only restyle when ungating"), and the
  remaining budget went to the reachable screens above (profile/friends/
  messages/ai chat) per the scout's stated priority order. **Not done, named
  explicitly**: no visual restyle performed.

## Data / contracts
- No new backend endpoints called. Profile model changes only surface fields
  already in the existing `GET /api/v1/profiles/{userId}` response.
- Achievements are computed client-side (pure function, ported from web's
  `computeAchievements`) — matches web's own approach (no achievements
  endpoint exists on either side).
- Duel: intentionally left unwired; a real room/invite contract would need a
  probe + `docs/flutter-api-contract-matrix.md`/`api-changelog.md` entry
  before any future wiring (explicitly GĐ2 P3's job per plan).

## Files changed
- `lib/screens/social/profile_page.dart` (rebuilt), `friends_page.dart`
  (rebuilt), `messages_page.dart` (rebuilt), `chat_page.dart` (header/bubble
  patch), `duel_lobby_page.dart` + `duel_play_page.dart` (rebuilt shells).
- New: `lib/screens/social/widgets/{profile_cover_header,profile_stats_row,
  profile_learning_journey,profile_achievements_grid,profile_activity_timeline,
  social_avatar}.dart`.
- `lib/screens/ai/ai_chat_page.dart` (residuals above).
- `lib/data/social/public_profile_model.dart` (extended fields +
  `SocialProfileActivity`).
- `lib/navigation/routes/social_routes.dart` (`/profile` repoint, dropped
  `EditProfileScreen`/`ProfileScreen` imports).
- `lib/navigation/release_redirect.dart` (append: `/profile/edit` redirect).
- Deleted: `lib/screens/profile/` (whole dir — profile_screen,
  edit_profile_screen, profile_controller, widgets/profile_header,
  widgets/profile_stats_grid).
- ARB: `lib/l10n/app_{vi,en,de}.arb` (new social/achievement/activity keys,
  3-way parity verified for all new keys) + regenerated
  `lib/l10n/app_localizations*.dart` via `flutter gen-l10n`.
- Tests: `test/l10n/app_localizations_test.dart` (Profile-chrome 200%-scale
  test repointed to the new widgets), `test/screens/social/friends_page_test.dart`
  (block-flow test → remove-friend-flow test, matches the new web-parity row
  affordance), `test/screens/social/chat_page_test.dart` (fake profile repo
  updated for the extended model), `test/screens/ai/ai_chat_page_test.dart`
  (added `VisibilityDetectorController.instance.updateInterval = Duration.zero`
  in `setUp` — `AppMarkdownView`'s lazy image/link tracking otherwise leaves a
  pending timer past test disposal).
- `test/structure/release_live_data_guard_test.dart` (removed 2 deleted
  entries, added 5 new profile-widget entries; guard NOT weakened).

## Tests status
- `flutter analyze`: 0 errors/warnings in every file I touched. (Full-repo
  `flutter analyze` shows pre-existing errors only in `lib/screens/settings/**`
  and `lib/widgets/announcements/announcement_banner.dart` — sibling agents'
  in-progress work, not mine.)
- Targeted suite (`test/screens/social/**`, `test/screens/ai/ai_chat_page_test.dart`,
  `test/l10n/app_localizations_test.dart`, `test/structure/release_live_data_guard_test.dart`,
  `test/repositories/social/**`): **40/40 pass**.
- Full `flutter test`: pre-existing failures unrelated to this wave —
  `test/navigation/release_redirect_test.dart` (2, listening/easy-german
  redirect logic, confirmed unrelated to my `/profile/edit` addition — the
  `/social/profile/user-1` redirect assertion in the same file still passes)
  and `test/screens/listening/easy_german_level_page_test.dart` (2) plus ~8
  more not enumerated by the truncated summary — all outside my ownership
  (listening/exam domains), per protocol reported not fixed.

## Unresolved questions
1. Duel: is there a real room/invite Go contract anywhere (didn't find one
   under `internal/feature/social` in a shallow grep) for GĐ2 P3 to target, or
   does it need to be designed from scratch?
2. "Gợi ý kết bạn" (friend suggestions) has no backend contract — worth a
   follow-up ticket to add one, since the web UI advertises it but the data
   source doesn't exist on either platform in a fetchable form.
3. `challenges_page.dart` restyle was explicitly deferred to stay within
   budget on higher-priority reachable screens — confirm this is acceptable
   or should be picked up in a follow-up pass before wave B.

Status: DONE_WITH_CONCERNS
Summary: Profile/friends/messages/AI-chat rebuilt to web parity with real data only; chat_page got header/bubble fixes but reactions/attachments deferred (no contract); duel got an honest UI-shell rebuild (mock matchmaking removed, not replaced) but stays unwired; challenges_page untouched.
Concerns/Blockers: challenges_page not restyled (named above); chat_page reactions/stickers/attachments/calls need a contract probe before UI can be considered complete; duel has no real room contract to wire against yet.
