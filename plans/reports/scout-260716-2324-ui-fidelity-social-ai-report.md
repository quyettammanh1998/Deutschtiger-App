# UI Fidelity Scout — Social / Profile / AI Chat (mobile viewport)

Scout date: 2026-07-16. Source of truth: `thamkhao/deutschtiger-frontend` (synced from prod). Mobile = default tailwind classes; `md:`/`lg:` ignored.

Global context that affects every verdict below:

- **Web theme tokens**: light `--primary: hsl(32,93%,54%)` ≈ `#F7911D` (= Flutter `tigerOrange #F7931E`); **dark `--primary: hsl(200,85%,65%)` (light blue)**. Web `bg-background` light = `hsl(25,47%,97%)`, card = white.
- **Flutter `AppColors.primary` = `#FF8FA3` (pink)** — NOT web primary. Anything Flutter paints `AppColors.primary` (AI user bubble, send button base, chat icon) diverges from web's orange/blue primary. `AppColors.tigerOrange` is the correct light-mode equivalent of web `bg-primary`.
- **Flutter is light-only** (`app_colors.dart`: "V1 chỉ dùng light; dark để sẵn cho sau"). Web has full dark mode with a different primary hue. Dark-mode parity fails globally, not per-page.
- Flutter social pages use `AppColors.authBackground (#FFFBF5)` + Material `AppBar` with orange bold title + white `Card` elevation — web mobile uses flat page scroll (`bg-background px-4 pt-3 pb-5`), a `BackButton` + bold `text-xl` heading row, and flat `card-sm` rows (white bg, subtle border/shadow, radius ~12).
- Release gating (Flutter `lib/navigation/release_redirect.dart`): `/social` gated by `ReleaseFeatureFlags.social`; `/social/groups|group|challenges|duel` gated independently (mock data). Web: `ChallengesPage` route is commented out ("temporarily hidden"); duel routes live.

---

## 1. AI Chat — `/ai-chat`

- **Web**: `src/pages/ai/ai-chat-page.tsx` → `src/components/ai/ai-chat-panel.tsx` (mode=fullscreen), `voice-recording-overlay.tsx`, `chat-history-sidebar.tsx` (`hidden md:flex` → desktop-only, ignore).
- **Flutter**: `lib/screens/ai/ai_chat_page.dart` (recently rebuilt). Verdict: **CLOSE with residual diffs**.

Web mobile structure (top→bottom): header card (`bg-card border-b shadow-sm`, top 2px accent gradient `from-primary via-rose-500 to-primary/30`; BackButton→home; 36px tiger icon tile with `from-primary/15 to-rose-500/10` gradient, `tiger-icon.svg`; title "Deutschtiger AI" bold 16; emerald status dot + "N/M lượt còn lại"/"Trợ lý học tiếng Đức"; 3 stacked icon+9px-label buttons: Lịch sử (clock), Chat mới (pencil)) → messages scroll (assistant: 28px tiger avatar tile + `card-sm rounded-2xl rounded-tl-sm` bubble with **markdown**; user: `bg-primary` white `rounded-2xl rounded-tr-sm`; typing bounce dots) → suggestion chips (4 pills, `pl-9`) → inline session-warning / limit cards → input bar (`border-t bg-card`; SpecialCharBar on focus; image attach button; pill textarea `min-h-44 rounded-2xl border`; right circle button 44px: send `bg-primary` paper-plane / mic `bg-primary` / stop `bg-red-500`).

Matches in Flutter (verified): header accent line, tiger tile gradient, title+status dot+remaining count, icon+label header buttons, welcome message text, 4 suggestion chips (`pl-36`), bubble corner radii (tl-sm assistant / tr-sm user), typing dots, stop button red circle, 44px circular action button, input pill.

Residual diffs (concrete):

| # | Diff | Web | Flutter |
|---|------|-----|---------|
| 1 | **User bubble + send color** | `bg-primary` = orange `#F7911D` light | `AppColors.primary` = pink `#FF8FA3`; send uses `AppColors.primaryGradient` (orange→rose gradient — web send is solid primary) |
| 2 | **Assistant markdown** | ReactMarkdown (gfm, breaks) in `chat-markdown` | plain `Text` — bold/lists/tables render as raw `**` |
| 3 | **Feature action chips** (`FEATURE_ACTIONS`) under assistant messages (pill `border-primary/30 bg-primary/5 text-primary` + chevron) | present | missing |
| 4 | **Back button** in header (headerLeft → home) | present | missing (page lives in tab shell?) — verify nav context |
| 5 | **Session limit UX**: warning at 25 msgs (amber card + "+ Tạo cuộc trò chuyện mới"), full at 30 (card, orange gradient CTA), daily-limit cards (`LimitReachedCard` w/ "Nâng cấp Trọn đời" gradient CTA) rendered inline in message list | present | only `_ErrorBanner` strip above input + `_QuotaBanner` (extra, not on web) |
| 6 | **Image attach** (up to 5, previews w/ ✕, uploads) | present when logged in | missing (renders attachments in bubbles only) |
| 7 | **Voice input** mic button + fullscreen `VoiceRecordingOverlay` (waveform, pause/resume, transcript) | present | missing |
| 8 | **SpecialCharBar** (ä ö ü ß) above input on focus | present | missing |
| 9 | **History panel**: mobile = full-width inline panel replacing messages (card-sm session rows, ring-2 on active) | inline panel | 280px side rail squeezing the chat (desktop pattern) — `lib/widgets/ai/chat_history_sidebar.dart` |
| 10 | Input placeholder while streaming | textarea stays enabled placeholder "Nhập tin nhắn..."; "Đã hết lượt..." only on limit | Flutter disables field and shows "Đã hết lượt..." whenever `isSending` |

Assets: `public/tiger-icon.svg` (already ported as `assets/logo/…` + `TigerIcon`).

---

## 2. Public profile — `/u/:id`

- **Web**: `src/pages/social/profile-page.tsx` + `src/components/profile/*` (cover-header, stats-row, learning-journey, achievements-grid, activity-timeline), `user-avatar.tsx` (premium crown, online dot), `premium-badge`.
- **Flutter**: `lib/screens/social/profile_page.dart`. Verdict: **DIVERGENT (major)**.

Web mobile structure: page header (back + "Hồ sơ" bold) → hero card `card p-0`: **cover gradient `h-24 from-orange-500/80 to-orange-600/80`**, 56px avatar overlapping center (-bottom-10, online dot, premium ring amber + crown), name bold 20 + PremiumBadge, active title *italic text-primary*, status line (green activity / "Đang online" / "Tham gia {date}") → actions centered (`card-interactive rounded-xl` — own: "Cài đặt" gear; other: FriendActionButton [Kết bạn = orange gradient / Huỷ kết bạn / Đã gửi lời mời] + "Nhắn tin" ChatText) → stats row (5 columns 2xl bold: Level w/ 10px XP progress bar, 🔥 Streak, 🏆 Dài nhất, XP, Bạn bè) → **"Hành trình học tập" card** (2-col grid mobile: CEFR LevelBadge/primary academic-cap icon, BXH tuần amber trophy `#{n}`, Từ đã học emerald book, Lần ôn tập blue refresh) → **"Thành tích" card** (count pill `bg-primary/10 text-primary`, 1px progress bar, 4-col grid: earned = `bg-primary/10` emoji, locked = `bg-muted opacity-40 grayscale` 🔒, tap-to-expand description) → **"Hoạt động gần đây" timeline** (emoji + description + relative time).

Flutter has: AppBar + report/block menu, 96px centered avatar, name, activeTitle (muted, not italic primary), 4 stat chips (Level/XP/Streak/Friends — plain 18px, no progress bar, no longest streak), Chat + Friend buttons (Material Outlined/Elevated). **Missing entirely: cover gradient header, premium badge/crown, online dot/status, joined date, XP progress, learning-journey card, achievements grid, activity timeline.** Extra vs web: report-user menu item (keep — mobile store requirement).

---

## 3. Friends — `/friends`

- **Web**: `src/pages/social/friends-page.tsx` + `friend-list.tsx`, `friend-request-card.tsx`, `friend-search.tsx`, `user-avatar.tsx`. Phosphor icons: `ChatText`, `Users`, `MagnifyingGlass`.
- **Flutter**: `lib/screens/social/friends_page.dart`. Verdict: **DIVERGENT**.

Web mobile: header row (back→home; "Bạn bè" xl bold + subtitle "N bạn bè · M lời mời"; right ChatText icon button w/ **red unread badge** `bg-red-500 text-[9px]`) → **segmented tab bar** `bg-muted p-1 rounded-xl`, active tab = `bg-card shadow-sm`, "Lời mời" tab shows count pill `bg-primary` → content:
- Bạn bè: **"Đang online — N"** section (green dot + green uppercase heading, activity labels in green) then "Offline — N"; rows = `card-sm p-3`: avatar (40px, online dot border-card), name semibold, sub "Lv.X · Y ngày streak" or green activity; right = ChatText 32px round hover + **"Huỷ kết bạn" plain text link** (hover red). Empty state: Users icon 48 + text.
- Lời mời: `card-sm` rows with "Chấp nhận" (`btn-primary` xs) + "Từ chối" (`bg-muted` xs).
- Tìm kiếm: input `card-sm pl-9` with magnifier icon inside; **"Gợi ý kết bạn" suggestions (online-first, up to 10) shown before typing**; result rows with status badge ("Bạn bè" green / "Đã gửi" / "Kết bạn" btn-primary).

Flutter: AppBar w/ orange title (no back/subtitle/unread badge), TabBar with **filled orange indicator + white label** (web = card-on-muted segmented), friend rows = elevated white `Card` with 56px avatar, streak🔥+XP row (web shows Lv+streak), chat IconButton (pink), PopupMenu (remove/block); requests = Outlined red "Từ chối" + orange Elevated "Chấp nhận" (shape ok, style off); search = plain filled TextField, **no suggestions**, ListTile results with text buttons. No online/offline sections, no activity labels, no `Lv.` prefix format.

---

## 4. Messages — `/messages`

- **Web**: `src/pages/social/messages-page.tsx` + `conversation-list.tsx`.
- **Flutter**: `lib/screens/social/messages_page.dart`. Verdict: **DIVERGENT (moderate)**.

Web mobile: back + "Tin nhắn" xl bold, subtitle "N cuộc trò chuyện"/"Chưa có tin nhắn nào" → **flat list** (`rounded-xl p-3`, no card chrome, hover bg-muted): 40px avatar + online dot; name semibold (`text-foreground/80` when read); relative time `xs muted` right ("Vừa xong"/"5p"/"3h"/"2d"); preview xs with **"Bạn: " prefix when is_sender**, bold-ish when unread; unread pill `bg-primary` (= orange) `text-[10px]`, "99+" cap. Empty: ChatText 48 thin + two lines.

Flutter: white elevated Cards (should be flat rows), AppBar orange title (no subtitle), no "Bạn:" prefix, unread badge tigerOrange (color ok), time format similar. Structure fine; chrome/typography off.

---

## 5. Chat thread — `/messages/:friendId`

- **Web**: `src/pages/social/chat-page.tsx` + `chat-header.tsx`, `message-bubble.tsx`, `message-input.tsx`, `emoji-picker.tsx`. Phosphor: `Phone`, `VideoCamera`, `Smiley`, `Paperclip`, `PaperPlaneTilt`, `Check`, `CheckCircle`, `File`, `Image`.
- **Flutter**: `lib/screens/social/chat_page.dart`. Verdict: **DIVERGENT**.

Web mobile: header `bg-card border-b px-4 py-3`: back→messages, avatar w/ online dot, name semibold sm, **status line green "Đang online"/activity or muted "Offline"**, right **audio + video call buttons** → messages: "Xem tin nhắn cũ hơn" pagination link; bubbles max-w-75%: sent = `bg-primary text-white rounded-2xl rounded-br-sm`, received = `bg-card border rounded-bl-sm`; **attachments** (image/audio/video/document card), **stickers** (emoji `text-7xl`, no bubble), **reaction chips** below bubble (`bg-primary/10 text-primary` when mine), **time + read receipts OUTSIDE bubble** (`text-[10px]`, Check muted → CheckCircle primary when read), hover Smiley react button → input: pending-file preview strip w/ progress bar; row `p-3`: Smiley toggle (emoji+sticker panel with pack tabs, 5-col grid), Paperclip w/ popup menu ("Ảnh & Video" blue icon / "Tài liệu" amber icon), textarea `bg-muted card-sm rounded` + char counter (2000), send = **`rounded-xl` (square-ish) `bg-primary` 40px PaperPlaneTilt**.

Flutter: white AppBar w/ avatar+name (no online/activity status, no call buttons; has block menu), bubbles tigerOrange/white with correct br-sm/bl-sm radii **but time+ticks INSIDE the bubble** (web: outside), Material done/done_all icons (web: Check/CheckCircle circle style), no reactions/stickers/attachments/emoji picker/attach menu/char counter/pagination; input = muted pill radius-24 + bare send IconButton (web: boxed rounded-xl primary button). Sent-bubble color coincidentally correct (tigerOrange ≈ web light primary).

---

## 6. Duel lobby — web `/duel/:roomId` vs Flutter `/social/duel/lobby`

- **Web**: `duel-lobby-page.tsx` + `duel-lobby.tsx`, `duel-countdown.tsx`, `duel-invite-modal.tsx`. Real room: header back + "Trận đấu trực tiếp"; room-code card (mono, tracking-wider); PlayerCard 64px avatars + "Chủ phòng"/"Khách" pills; "VS" + bouncing dots while waiting; dashed-border circle + Plus icon for empty guest slot; "Mời bạn bè" orange-gradient CTA + "Hủy phòng" secondary; fullscreen 3-2-1 countdown (`bg-primary/10 text-primary` circle → green "Bắt đầu!").
- **Flutter**: `lib/screens/social/duel_lobby_page.dart` — **fake matchmaking with `Random()`-generated opponents**, orange gradient hero ("Live Vocabulary Duel", +50 XP/5min/10Q badges), opponent list w/ Challenge buttons, "Find Random Opponent", English hardcoded strings. **Verdict: DIVERGENT — total rebuild needed** (flag-gated `socialDuels=false`, so currently unreachable in release).

## 7. Duel play — web `/duel/:roomId/play` vs Flutter `/social/duel/play`

- **Web**: `duel-play-page.tsx` + `duel-score-overlay.tsx` (fixed top bar: my avatar circle `bg-primary/20` + score vs opponent, backdrop-blur), `duel-result-screen.tsx` (fullscreen overlay: emoji 👑/🤝/😤, colored result heading, +XP, score card with VS, orange-gradient "Chơi lại"). Body: timer bar (red ≤10s), score card 4xl, DE word card w/ green/red feedback tint, VI answer input, "Xác nhận" orange-gradient.
- **Flutter**: `lib/screens/social/duel_play_page.dart` — mock questions (`_generateQuestions`, random opponent bot). **Verdict: DIVERGENT — rebuild** (flag-gated).

## 8. Challenges — web route **commented out** ("temporarily hidden") vs Flutter `/social/challenges`

- **Web**: `challenges-page.tsx` exists (back + "Thách đấu", segmented tabs Chờ xử lý/Đang chơi/Hoàn thành, `challenge-card.tsx` card-sm rows w/ status pill + CaretRight, BottomSheet detail w/ `challenge-result.tsx`, accept = orange gradient) but is NOT routed in prod.
- **Flutter**: `lib/screens/social/challenges_page.dart` uses `social_legacy_mock_models.dart` (mock). Flag-gated (`socialChallenges=false`). **Verdict: N/A in release — keep gated or delete; if enabling later, rebuild against web page.**

## 9. Moments / Announcements / Activity feed

- **Web moments**: `moment-card/compose/feed.tsx` exist in `src/components/social/` but are **imported by no page** — dead code. There is **no moments surface in prod web**. Same for `notification-list.tsx` and `activity-feed` UI components (only the activity-feed *service* is used to log events from practice/games pages).
- **Web announcements**: only `announcement-banner.tsx` (amber card: Megaphone icon, amber-800 title, mini-markdown body, dismiss ✕, localStorage-dismissed) embedded on dashboard + exam-landing. **No announcements page.**
- **Flutter**: `moments_page.dart` + `social_screen.dart` (Moments/Friends tab hub) + `announcements_page.dart` (plain Card list) + `widgets/moments_feed.dart` — **no web counterpart pages**. If web parity is the goal: remove/hide moments hub tab + announcements page, and instead port `AnnouncementBanner` (amber style) into Flutter home/exam screens.

---

## Flutter screens with NO active web counterpart (delete/rebuild candidates)

| Flutter file | Status |
|---|---|
| `lib/screens/social/social_screen.dart` (hub w/ Moments+Friends tabs) | No web equivalent (web has no social hub; friends/messages are standalone). Restructure. |
| `lib/screens/social/moments_page.dart` + `widgets/moments_feed.dart` | Web moments UI is dead code, unrouted. Delete/hide. |
| `lib/screens/social/announcements_page.dart` | Web = banner only. Replace with banner on dashboard/exam. |
| `lib/screens/social/groups_page.dart`, `group_detail_page.dart`, `widgets/study_groups_list.dart` | Mock data; web has unused components, no page/route. Delete (already gated). |
| `lib/screens/social/challenges_page.dart`, `widgets/challenges_list.dart` | Mock; web route hidden. Keep gated. |
| `lib/screens/social/duel_lobby_page.dart`, `duel_play_page.dart` | Mock matchmaking; web is room-based (`/duel/:roomId`). Rebuild if ungating. |
| `lib/screens/ai/ai_settings_page.dart` | No web AI-settings page. Verify necessity. |
| `lib/features/social/`, `lib/features/ai/`, `lib/features/ai_tutor/` | data/presentation subdirs contain **no dart files** (empty scaffolding). Delete. |

Own-profile tab (`lib/screens/profile/profile_screen.dart`) has no dedicated web page (web reuses `/u/:id` + settings); it is a mobile-navigation surface — not a fidelity target, but its header/stat styling should adopt the same card language.

## Assets needed from `public/`

- `tiger-icon.svg` — already ported.
- Premium crown SVG (`components/shared/premium-crown.tsx` inline SVG) + `PremiumBadge` — needed for profile/avatar parity.
- No other page-specific images; all icons are inline SVG/Phosphor (map to closest Material or custom SVG: ChatText, Phone, VideoCamera, Smiley, Paperclip, PaperPlaneTilt, Check/CheckCircle, Users, MagnifyingGlass, Megaphone, CaretRight, Plus).

## Priority order (visual impact)

1. Public profile rebuild (cover header, stats row, journey, achievements, timeline) — biggest gap on a reachable surface.
2. Chat thread (header status/call icons, time-outside bubbles, read receipts, input bar layout).
3. Friends page (segmented tabs, online sections, suggestions, row styling).
4. AI chat residuals (primary color of user bubble/send, markdown, feature chips, limit cards).
5. Messages list (flat rows, "Bạn:" prefix, subtitle).
6. Gated surfaces (duel/challenges) — only when ungating.

## Unresolved questions

1. Should Flutter adopt web's dark palette (dark primary = blue hsl(200,85%,65%)) now, or stay light-only for V1? Global decision, blocks "100% identical" claim.
2. Is `AppColors.primary` (pink #FF8FA3) intentional Flutter branding, or should primary-painted surfaces switch to tigerOrange to match web `--primary`?
3. Moments/announcements: confirm product intent — web parity says remove; Flutter phase docs say they're deliberate mobile-only live surfaces.
4. Chat extras (reactions, stickers, attachments, calls) are functional gaps beyond styling — in scope for fidelity work or separate feature phase?
