# Phase 12 — Social, AI, profile, leaderboard, stats, settings + deletion sweep + QA

Scout: `scout-260716-2324-ui-fidelity-social-ai-report.md` +
`scout-260716-2324-ui-fidelity-home-settings-stats-report.md`.

**Chạy 2 wave (v2):** Wave A = các màn bảng dưới (sau P1, song song P2–P11).
Wave B = deletion sweep + QA (chỉ sau khi P2–P11 merge hết).

## Màn

| Web | Flutter | Việc |
|---|---|---|
| `ai-chat-page` | `ai_chat_page.dart` | Residuals: bubble/send màu primary cam (tự khỏi sau P1), markdown render, feature-action chips, limit cards, SpecialCharBar, history inline panel; image attach + voice gate flag |
| `social/profile-page` (/u/:id) | `social/profile_page.dart` | Cover gradient, premium crown/badge, online status, XP bar, journey grid, achievements grid, activity timeline |
| — | `/profile` (`ProfileScreen`+`EditProfileScreen`, app_router 764-769) | v2: `/profile` render public-profile view của chính mình (màn trên); EditProfile gộp vào profile-edit card của settings root; xóa 2 màn cũ + redirect |
| `friends-page` | `friends_page.dart` | Segmented tabs card-on-muted, online/offline sections, suggestions, unread badge, Lv·streak, card-sm rows |
| `messages-page` | `messages_page.dart` | Flat rows, back+subtitle, "Bạn:" prefix |
| `chat-page` | `chat_page.dart` | Online/activity status, time/ticks ngoài bubble, reactions/stickers/attachments UI (contract có sẵn mới wire; không mock) |
| `duel-lobby/-play` | `duel_*.dart` (flag-gated) | v2: rebuild **UI shell only** theo web (room-code lobby, timer bar, score overlay, result overlay) — XÓA logic mock Random/bot cũ, KHÔNG viết mock mới; live loop + report/block thuộc GĐ2 P3, flag off tới khi GĐ2 P3 wire |
| `challenges-page` | `challenges_page.dart` | Web cũng ẩn route → giữ gate, style theo web khi hiện |
| `leaderboard-page` | `leaderboard_screen.dart` | Podium+crown, tabs Toàn cầu/Bạn bè (tab Bạn bè gate flag social), hall of fame, countdown, rank delta, breakdown chips (WeeklyScoreBreakdownChips), detail sheet (WeeklyScoreDetailSheet); field: `weekly_score ?? weekly_xp` (đã verify weekly-leaderboard.tsx:112 — không cần probe) |
| `stats-page` | `stats_screen.dart` | Đủ ~13 blocks web (progress cards, online time, review stats, suggestions, SRS explainer, CEFR, achievements grid, leaderboard table) |
| `error-patterns-page` | `error_patterns_page.dart` | PageIntro, per-type drill CTA; bỏ sort menu thừa |
| `settings-page` root | `settings_screen.dart` | Profile-edit card + 6 nav rows + feedback + logout đỏ; giữ mục app-only đã chốt (#3) style theo web |
| `settings-security` | `security_screen.dart` | Password-change card; GIỮ delete-account (store) |
| `settings-notifications` | `notification_preferences_screen.dart` | Timezone line, nút "Gửi thử", permission banners |
| `settings-learning` | `learning_preferences_screen.dart` | 5 goal checkboxes, minute presets, XP calc, review-display toggles; chips thay sliders |
| `settings-appearance`, `settings-app-update` | mới (tách trang) | Trang riêng như web |
| `settings-ai-memory` | `ai_settings_page.dart` | Diff chi tiết + route `/settings/ai-memory` |
| Announcements | thay `announcements_page.dart` | Port `AnnouncementBanner` amber vào dashboard/exam; xóa page |

## Deletion sweep (chốt cùng Quyết định #3)

Xóa: `moments_page.dart`, `social_screen.dart`, `moments_feed.dart`,
`groups_page.dart`, `group_detail_page.dart`, `features/{social,ai,ai_tutor}` dirs
rỗng, `progress_analytics_screen.dart`, `reminder_settings_screen.dart`,
`achievements_screen.dart` (grid vào stats), home orphans
(`daily_goal_card/mission_list/quick_stats_row`, `mobile_stats_card`, `quick_actions`
nếu web đã bỏ), empty dirs (`features/{social,ai,ai_tutor}/`,
`features/auth/presentation/`), cùng mọi file các phase trước đánh dấu.
GIỮ: notification center (style lại; badge trên header đếm notifications —
web badge là Messages icon đếm notifications+messages, dùng pattern web),
delete-account, onboarding. Mỗi lần xóa: cập nhật guard list + redirect theo
protocol plan.md.

## QA cuối (sau P2–P11)

1. Route sweep: mọi path web (trừ ngoài-scope) có màn hoặc redirect; deep-link test.
2. Dark-mode audit toàn app (không còn static light token).
3. Visual pass: screenshot 390×844 light+dark từng màn so web (checklist từ 9
   scout reports); cập nhật `docs/web-feature-parity-matrix.md` + fidelity docs.
4. Full `flutter analyze` + toàn bộ test suite + release-live-data guard.

## Validation per-màn

- Social poll-based giữ nguyên data layer live; duel giữ flag off.
- analyze + tests social/stats/settings; l10n vi/en/de.
