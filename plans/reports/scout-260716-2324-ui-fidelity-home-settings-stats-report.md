# UI Fidelity Scout — Home / Quotes / Leaderboard / Stats / Notifications / Settings

Scope: web mobile viewport (<768px, default tailwind classes) vs Flutter. Web = source of truth:
`/home/qtm/Desktop/Deutschtiger-App/thamkhao/deutschtiger-frontend`. Date: 2026-07-16.

## Global finding — dark mode broken by design in Flutter

- Web: every surface has `dark:` variants (bg-card, border-border, orange-400 accents…).
- Flutter: `lib/core/theme/app_theme.dart` defines a dark ThemeData and `DesignTokens` has `dark*` colors, BUT all rebuilt home/dashboard/settings widgets hardcode light `static const` tokens (`DesignTokens.card` = white, `foreground` = dark gray). In dark mode these screens will render light cards on dark scaffold. Needs a theme-aware token accessor (e.g. `DesignTokens.of(context)`) before dark parity is possible anywhere.

---

## 1. Dashboard / Home — CLOSE overall, 4 structural diffs remain

- Route: `/` → `src/pages/dashboard/dashboard-page.tsx` + `src/components/dashboard/mobile-dashboard-layout.tsx`.
- Flutter: `lib/screens/home/home_screen.dart` + `lib/screens/home/widgets/*`, `lib/widgets/dashboard/*`.

Web mobile block order (mobile-dashboard-layout.tsx):
1. `MobileDashboardHeader` (cream card: avatar | greeting | messages+settings icon buttons; row 2 = encouragement + streak chip) + `MobileVocabSearch` bar below
2. `DashboardHeroSection` — **branching**: exam goal set → `ExamHeroCard` (readiness ring + countdown badge + full-width orange CTA) THEN `DailyPathHeroCard deemphasized` (secondary CTA `border-border bg-muted`, no countdown badge); no goal → `DailyPathHeroCard` (XP ring + orange CTA + mini-stepper) THEN `ExamCornerCard`/`ExamGoalSetterCard`
3. `PinnedShortcuts` (card, 2×5 grid)
4. `DailyMissionsSection` (collapsible header + amber/emerald progress bar + 4-color palette rows)
5. `PremiumBanner` (`/images/premium-banner.webp`, rounded-xl)
6. `ContinueLearningSection` — "Tiếp tục học" heading (text-lg bold) + up to 3 resume-recommendation rows (emoji tile bg-orange-50, title, reason · ~min, thin orange progress bar, →)
7. `WeeklyLeaderboardCompact` ("🏆 Tuần này", top-3 + own-rank row, footer encouragement; "Xem đầy đủ" expands full `WeeklyLeaderboard` inline below)
8. `CommunityLinks` (uppercase label + Zalo/Facebook cards)
Also page-level: OfflineBanner (init error), AnnouncementBanner, PushPermissionPrompt (delayed bottom sheet card), StreakClaimModal.

Flutter order today: header → search → path hero → exam corner → shortcuts → missions → **MobileStatsCard** → leaderboard → **"Khám phá" QuickActions grid** → PremiumBanner → CommunityLinks.

Residual diffs (ordered by impact):
1. **Missing ExamHeroCard branch** — Flutter always renders daily-path hero + compact exam-corner strip. Web goal-users get exam-first hero (readiness ring `stroke-orange-500 r=16 w=3.5`, "Còn N ngày" amber badge when ≤28d, CTA "📝 Tiếp tục đề · slug" / "Luyện {skill} (N%)", links "Độ sẵn sàng / Đổi mục tiêu") and the path card demoted (secondary CTA, no countdown badge). Flutter `exam_corner_card.dart` only mirrors the (nearly dead on web) compact strip.
2. **Missing "Tiếp tục học" ContinueLearningSection** (resume recommendations, `GET learn recommendations`). Instead Flutter still renders the web-deleted "Khám phá" QuickActions grid (`lib/widgets/dashboard/quick_actions.dart` + `quick_actions_data.dart`) — web moved the catalog into MoreFeaturesSheet only. Delete grid, add resume section.
3. **Extra MobileStatsCard** (`lib/widgets/dashboard/mobile_stats_card.dart`) — web mobile has no stats card; wordsLearned lives in header row 2 ("📚 Đã học N từ vựng" when > 0, else "Sẵn sàng chinh phục tiếng Đức? 🚀"). Flutter header always shows the static string (`headerEncouragement`) and never the words-learned variant.
4. **PremiumBanner position** — web places it right after missions (block 5), Flutter near the end.

Minor diffs:
- Missions: no red expiry badge (`<1h`, `bg-red-100 text-red-700`); loading/empty ghost-card states missing (Flutter shows plain text). Mission row: web full colored bg via CSS vars (rounded-xl, shadow-sm); Flutter approximates with bg + 3px left border — acceptable.
- Compact leaderboard: Flutter shows 🥇🥈🥉 medals; web shows plain rank digits (xs bold muted). "Xem đầy đủ" web = muted text; Flutter default TextButton (primary blue). Web score = `weekly_score ?? weekly_xp` (composite); Flutter uses `weekly_xp`. No PremiumBadge on rows. Web expand shows full board inline; Flutter navigates to /leaderboard (acceptable native pattern, flag only).
- Search bar: web `rounded-2xl` (16) with live inline results dropdown + level/gender chips + special-char bar; Flutter `DesignTokens.radius` pill that navigates to /vocabulary. Idle look close; radius differs; live search missing (functional, not visual).
- Goal setter: web = inline expandable card (selects for Kỳ thi/Trình độ/Ngày thi, gradient save button); Flutter = modal bottom sheet (`exam_goal_setter_sheet.dart`). Presentation differs.
- Missing page-level: offline banner, announcement banner (both live-data surfaces).
- Header/pinned shortcuts/community links/premium banner/daily path hero pieces: verified CLOSE (colors, emoji titles, gradients, radial glow, SVG brand marks all mirrored).

Assets: `assets/images/premium-banner.webp` already added ✓.

## 2. Daily Quote — DIVERGENT (full rebuild needed)

- Web: route `/daily-quote` → `src/pages/quotes/daily-quote-page.tsx` + `src/components/quotes/quote-slide.tsx`.
- Flutter: `lib/screens/stats/daily_quote_page.dart` (route `/stats/daily-quote`).

Web mobile = TikTok-style **full-screen vertical snap feed**: fetch 30 random quotes (`/api/v1/quotes/random?limit=30`), each slide = full-height photo (`/images/quotes/quote-01..20.webp`, shuffled non-repeating) with `rounded-bl-[5rem]` bottom-left mega-corner + black gradient overlay; bottom card on `#f5f0e6` (dark: bg-card) with 3 sage dots (`#a8c686`), sage double-quote SVG, DE quote (text-lg semibold), VI italic muted, "🌿 category" in `#7a9a5a`, first slide "Vuốt lên để xem tiếp" hint; floating icon BackButton top-left (safe-area).

Flutter = totally different: SliverAppBar gradient header "Câu nói hôm nay" + purple/orange gradient quote card + share icon + 2-col mini-card grid of extra quotes. **Nothing matches.** Verdict: rebuild as PageView(vertical, snap) feed.

Assets needed: `images/quotes/quote-01.webp … quote-20.webp` — NOT present in synced `public/` (served from prod; fetch from `https://deutschtiger.com/images/quotes/quote-XX.webp`).

## 3. Leaderboard — DIVERGENT

- Web: `/leaderboard` → `leaderboard-page.tsx` → `weekly-leaderboard.tsx` (+ `hall-of-fame.tsx`, `weekly-score-breakdown-chips.tsx`, `weekly-score-detail-sheet.tsx`).
- Flutter: `lib/screens/leaderboard/leaderboard_screen.dart` + `widgets/leaderboard_tile.dart`.

Web mobile structure: back(header)+`Bảng xếp hạng` (text-xl bold) + subtitle "So tài XP tuần với cộng đồng và bạn bè." → header row (purple Trophy chip `bg-purple-100`, "BXH tuần", right "Reset {Nd Nh}" countdown) → segmented tabs **Toàn cầu | Bạn bè** (`bg-muted p-1`, active `bg-card shadow-sm`) → collapsible **Hall of Fame "Tuần trước"** (3 medal cards yellow/gray/orange) → **Top-3 podium card** (#1 center, amber Crown, h-14 avatar ring-purple-400; #2/#3 h-11, rank badges amber/blue/purple, dark `bg-gray-800` score pill, breakdown chips) → rows #4–5 (`04`-padded rank, rank delta ▲/▼/Mới for self, avatar ring-border, PremiumBadge, "Mới" dampened badge, breakdown chips) → own-rank row outside top5 (gradient `from-primary/10` ring-primary/50 after ··· divider) → tap any row opens `WeeklyScoreDetailSheet`.

Flutter: Material AppBar (orange title), segmented **Tuần này | Tất cả** (all-time tab does not exist on web; friends tab missing), flat ListView of tiles. Missing: podium, crown, hall of fame, reset countdown, rank delta, breakdown chips, detail sheet, own-rank pinned row, premium/new badges, page subtitle/back header pattern. Verdict: rebuild.

## 4. Stats — DIVERGENT (Flutter has ~1/3 of the web blocks)

- Web: `/stats` → `stats-page.tsx` + `src/components/stats/*` (12 blocks).
- Flutter: `lib/screens/stats/stats_screen.dart` + `widgets/srs_stats_card.dart`.

Web mobile order (all `card p-4`, headers `text-base font-bold`):
1. Header: back + "Thống kê học tập" + subtitle.
2. `StatsOverviewCards` — 1-col (sm:2) stat cards.
3. `StatsProgressCards` — 2 cards `border-l-4 border-l-primary` / `border-l-amber-500` (level XP progress, daily goal).
4. "XP 7 ngày qua" card + `StatsXpBarChart` (day label + primary xp value per bar).
5. `StatsOnlineTimeCard` "Thời gian online 7 ngày" (teal values), when data.
6. `ReviewStats` "Thống kê ôn tập" (colored gradient stat tiles, white text).
7. `StatsSuggestionsCard` "Gợi ý cải thiện" (💪/🎧/🔥 rows).
8. `StatsSpacedRepetitionCard` "Spaced Repetition hoạt động thế nào?" explainer.
9. `MasteryOverview` "Độ nhớ từ vựng" (2-col grid of 4 tiles + "Ôn tập 30 ngày qua" mini-chart).
10. `StatsCefrLevelCard` "Hồ sơ năng lực".
11. `StatsNearAchievementsCard` "Thành tựu sắp đạt".
12. `StatsAchievementsGrid` "Bộ sưu tập thành tựu" (2-col mobile grid).
13. `StatsLeaderboardTable` "Bảng xếp hạng" (with "Bạn" chip, ··· divider row).

Flutter has: 4 overview stat cards (≈ block 2, different card style: border+icon chip), XP bar chart (CustomPaint, no per-bar xp value), mastery/SRS card, **error-patterns preview section (not on web stats page)**, Material AppBar instead of back+title+subtitle header. Missing blocks: 3, 5–8, 10–13. Verdict: major rebuild/extension; achievements grid + leaderboard table belong here (web has no standalone achievements page).

## 5. Error Patterns — DIVERGENT (moderate)

- Web: `/stats/error-patterns`? → actually route `ROUTE_PATHS` `error-patterns` under stats — `error-patterns-page.tsx`. Flutter: `lib/screens/stats/error_patterns_page.dart` (route `/stats/error-patterns` ✓).

Web mobile: back + "Lỗi hay gặp" + subtitle → `PageIntro` card (why/todo/next + "Luyện viết" link) → pattern cards: colored bullet `•` + label + `(labelVi)` muted, right "N lần" plain semibold muted; example line `strikethrough → green corrected`; footer row = **drill CTA link** (primary, per-type route: Luyện Der/Die/Das, Luyện xếp từ, Luyện chính tả…) + source pills (`bg-muted rounded-full text-[11px]`). Empty state: 📝 + 2 buttons (btn-secondary "Luyện xếp từ", btn-primary "Làm bài thi").

Flutter: AppBar + sort PopupMenu (extra, not on web); cards use colored bordered label chip + solid colored count pill + Divider + "Ví dụ" heading; **no PageIntro, no drill CTA links**, empty state lacks the two CTA buttons. Colors per error type exist (`error_pattern_labels.dart`) — verify they match web's tailwind text-500 palette.

## 6. Notifications — web has NO notification-center page

- Web `src/components/notification/` = only `push-permission-prompt.tsx` (delayed fixed bottom card: Bell/DeviceMobile icon, enable CTA → subscribes + navigates to settings; iOS A2HS guide variant). `src/components/social/notification-list.tsx` exists but is imported nowhere (dead code).
- Flutter `lib/screens/notifications/notification_center_screen.dart` (+ `widgets/notification_tile.dart`) at `/notifications` = **no web counterpart** → candidate to remove from release surface (header badge on web attaches to the Messages icon, not a bell). Native push-permission UX can stay OS-level; no visual parity target exists.

## 7. Settings root — DIVERGENT (different IA)

- Web: `/settings` → `settings-page.tsx`. Flutter: `lib/screens/settings/settings_screen.dart`.

Web mobile: back + "Cài đặt" + subtitle "Tùy chỉnh ứng dụng" →
1. `SettingsProfileSection` card — avatar (tap = crop-upload modal), display-name input, email, premium badge, save button + "Đã lưu!" message.
2. Nav-rows card (`card divide-y`): Mục tiêu học tập 🎓 / Giao diện 🌙 / Nhắc nhở từ vựng 🔔 / Đổi mật khẩu 🔒 / Tiger AI Memory ✨ (flag-gated) / Cập nhật ứng dụng 🔄 — each = outline icon (muted) + label + chevron.
3. "Góp ý & báo lỗi" card row.
4. Logout card row (red icon+text, hover red-50).

Flutter: Material AppBar + 9 inline sections (theme tile, sound sliders, language picker, notification toggles inline, learning, security+export, AI, feedback, About/version/ToS/help/rate). **No profile editor, no logout row**, extra sections web doesn't have (Âm thanh, Ngôn ngữ, Về ứng dụng). Verdict: rebuild to profile-card + nav-rows + feedback + logout; native-only extras (app language, version/ToS) need a product decision on placement.

## 8. Settings subpages

| Web page | Web content (mobile) | Flutter | Verdict |
|---|---|---|---|
| `settings-security-page.tsx` (`/settings/security`) "Bảo mật" | Card "ĐỔI MẬT KHẨU" (2 password inputs `bg-muted rounded-xl`, orange gradient submit) + `SettingsDevicesSection` ("Thiết bị đăng nhập" list, green "hiện tại" pill, btn-secondary sign-out per device) | `security_screen.dart`: devices + **delete account**; **no password form** | DIVERGENT — add password card; web has no delete-account UI (keep? unresolved) |
| `settings-notifications-page.tsx` "Thông báo" | `SettingsNotificationSection`: permission warning banners (amber/red), big toggle (h-8 w-14 primary), time input + timezone line, "Nội dung thông báo" mode options, save btn + message, "Gửi thử" test button | `notification_preferences_screen.dart`: toggle + time + content-mode chips | CLOSE — missing timezone line, test-send button, permission banners |
| `settings-learning-page.tsx` "Mục tiêu học tập" | `SettingsLearningPreferencesSection`: CEFR chips, 5 learning-goal checkboxes (goethe/communication/medical/work/other), daily-minutes options (5/10/15/30) + computed XP/words-per-day, save; + `SettingsReviewDisplaySection` (3 toggles: auto-advance, 4-button, context) | `learning_preferences_screen.dart`: CEFR chips + 2 free sliders (minutes 5–120, XP goal) | DIVERGENT — missing goals, minute presets, XP calc display, review-display toggles |
| `settings-appearance-page.tsx` "Giao diện" | `SettingsAppearanceSection`: dark-mode toggle + "Âm thanh & hiệu ứng" toggle (card, uppercase muted h2) | no dedicated screen (theme tile inline in root) | MISSING page |
| `settings-ai-memory-page.tsx` "Tiger AI Memory" | `SettingsAIMemorySection` (+ ai-profile-form, ai-mistakes-card components) | `lib/screens/ai/ai_settings_page.dart` at `/ai-tutor/settings` | UNVERIFIED — needs dedicated diff (AI scope) |
| `settings-app-update-page.tsx` "Cập nhật ứng dụng" | `SettingsAppUpdateSection`: card "ỨNG DỤNG" + description + btn-primary update link | root-settings tile + dialog (`ForceUpdateService`) | MISSING page (native store-update semantics OK, flag for decision) |

## 9. Flutter screens in scope with NO web counterpart (delete/decide)

- `lib/screens/notifications/notification_center_screen.dart` + widgets — no web page.
- `lib/screens/achievements/achievements_screen.dart` (routed `/achievements`) — web renders achievements inside /stats only.
- `lib/screens/progress/progress_analytics_screen.dart` — **orphaned, not routed** → delete.
- `lib/screens/reminders/reminder_settings_screen.dart` — **orphaned, not routed** (superseded by notification prefs) → delete.
- `lib/widgets/dashboard/mobile_stats_card.dart`, `lib/widgets/dashboard/quick_actions.dart` (+ `quick_actions_data.dart` explore-grid usage) — web-deleted dashboard blocks.
- `lib/screens/home/widgets/daily_goal_card.dart`, `mission_list.dart`, `quick_stats_row.dart` — check for orphaned status after home rebuild (imported nowhere in home_screen.dart).

## Assets needed from web `public/`

- `images/quotes/quote-01..20.webp` — not in synced repo; fetch from prod (`https://deutschtiger.com/images/quotes/quote-XX.webp`).
- (already copied) `images/premium-banner.webp`.

## Unresolved questions

1. Exam readiness endpoint (`useExamReadiness`) — is there a Flutter provider for the ExamHeroCard readiness ring, or does that API integration need building first?
2. Web has no delete-account UI; Flutter security screen has one (likely App Store requirement) — keep as native-only extra?
3. Flutter-only settings sections (app language picker, sound sliders, About/version/ToS/rate) — keep as native extras or hide for 1:1 parity?
4. Leaderboard "Bạn bè" tab depends on social/friends feature flag (`ReleaseFeatureFlags.social`) — build tab now or gate?
5. `weekly_score` composite vs `weekly_xp` in Flutter leaderboard rows — confirm backend field the app should display.
6. Notification center screen removal: home header badge currently counts notifications; web counts notifications+messages on the Messages button — where should the Flutter badge deep-link once center is removed?

Status: DONE
