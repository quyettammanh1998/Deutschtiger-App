---
phase: 8
title: "Phase 5: Màn GĐ1 còn lại — Reading, Grammar, Games, AI Chat, Stats, Settings"
status: pending
priority: P1
effort: "2w"
dependencies: [7]
---

# Phase 8: Phase 5 — Remaining GĐ1 Screens

## Overview

Hoàn thiện ~13 màn GĐ1 còn lại: H1 Reading, H3 Grammar, I1–I2 Games, J1–J2 AI chat, K4 Leaderboard, M1 Stats, N1–N3 N6 Settings, O3 Premium gate. Song song được với Phase 4.

## Requirements

- H1 Reading hub + detail (TappableSentence + WordLookupSheet)
- H3 Grammar: hub + article + lesson
- I1 Game hub (GĐ2 games ẩn), I2 Word sprint end-to-end
- J1 Conversation hub, J2 AI chat text + quota + **nút report AI (bắt buộc R7)**
- K4 Leaderboard, M1 Stats (fl_chart)
- N1 Settings main, N2 Security (device mgmt + xoá tài khoản), N3 Appearance (dark mode), N6 Feedback sheet
- O3 Premium gate trung tính ("Sắp ra mắt") — KHÔNG giá/link web

## Implementation Steps

### 1. H1 — Reading Hub + Detail
```dart
// reading_hub_screen.dart: list articles by level/topic
// reading_detail_screen.dart: article text dùng TappableSentence
// Audio đọc article: SpeakButton per paragraph hoặc autoplay
// Đọc endpoint: GET /api/v1/reading/articles
```

### 2. H3 — Grammar (3 màn)
```dart
// grammar_screen.dart (hub): list articles/topics (đã có sơ, verify)
// grammar_article_screen.dart: article detail (markdown render)
// grammar_lesson_screen.dart: lesson với drill inline (fill-blank/MC)
// 483 LOC web → chia thành 3 files <200 LOC
```

### 3. I1/I2 — Games
**I1 Game Hub:**
- `game_hub_screen.dart` đã có, verify layout grid
- Games GĐ2 → ẩn hoàn toàn (không disabled, không "coming soon" — Apple reject)
- Chỉ hiện: Word Sprint, Article Game, Matching (GĐ1 confirmed games)

**I2 Word Sprint (end-to-end):**
```dart
// word_sprint_game_screen.dart: đã có, verify + hoàn thiện
// Timer countdown (60s default), streak counter, score
// Word prompt → type answer → Enter → next word
// End: GameCompletionScreen với score + streak + words/min
// High score: POST /api/v1/games/word-sprint/score
```

### 4. J1/J2 — AI Chat
**J1 Conversation Hub:**
- `conversation_hub_page.dart` đã có, verify scenario cards
- Voice scenarios → ẩn GĐ1 (chưa có mic), chỉ hiện text chat

**J2 AI Chat (text + nút report — BẮT BUỘC R7):**
```dart
// ai_tutor_chat_screen.dart: đã có, cần bổ sung:
// 1. Streaming response nếu BE hỗ trợ SSE
// 2. Quota indicator (X câu còn lại cho free user)
// 3. REPORT BUTTON: IconButton(icon: Icons.flag) per AI message
//    → ReportDialog: chọn lý do (harmful/inappropriate/wrong) → POST /feedback/report-ai
// 4. Quota exceeded → gate trung tính (không upsell GĐ1)
```

### 5. K4 — Leaderboard
```dart
// leaderboard_screen.dart: verify + kết nối real data
// GET /api/v1/leaderboard?period=weekly|monthly|all
// User rank highlight, avatar, streak/XP display
// fl_chart: không cần ở màn này (chỉ list)
```

### 6. M1 — Stats
```dart
// stats_screen.dart: verify + kết nối real data
// fl_chart BarChart: activity 7 ngày
// fl_chart LineChart: XP progression
// Thống kê: words_learned, total_reviews, streak, time_studied
// GET /api/v1/user/stats
```

### 7. N1/N2/N3/N6 — Settings
**N1 Main Settings:**
- List tiles: Tài khoản / Bảo mật / Giao diện / Thông báo / Phản hồi / Về app
- App version từ `package_info_plus`

**N2 Security:**
- Device management list (từ Phase 2)
- "Xoá tài khoản" entry point (từ Phase 2)
- Change password (supabase.auth.updateUser)

**N3 Appearance:**
- Dark mode toggle → ThemeController (Riverpod)
- Persist theme choice: SharedPreferences `theme_mode`

**N6 Feedback sheet:**
- BottomSheet: text field + category (Bug / Góp ý / Khác)
- POST /api/v1/feedback

### 8. O3 — Premium gate (trung tính)
```dart
// PremiumGateWidget: "Tính năng này sẽ có trong bản cập nhật sắp tới"
// KHÔNG: link web / giá / "nâng cấp ngay"
// Áp dụng cho: content premium-gated trong GĐ1
// Audit toàn bundle: grep "79k\|premium\|pricing\|upgrade" → 0 hits user-visible
```

## Success Criteria

- [ ] Reading hub + detail: TappableSentence tap word → WordLookupSheet
- [ ] Grammar 3 màn load đúng content, drill inline hoạt động
- [ ] Word sprint: timer + score + GameCompletionScreen
- [ ] AI chat: report button hiện per AI message, POST report hoạt động
- [ ] AI quota: free user thấy còn X câu, hết quota → gate trung tính
- [ ] Leaderboard + Stats: real data từ BE, không mock
- [ ] Dark mode toggle persist sau restart app
- [ ] Feedback form: POST thành công
- [ ] `grep -r "79k\|pricing\|Nâng cấp ngay" lib/` = 0 kết quả

## Risk Assessment

- AI chat streaming: nếu BE chưa SSE → dùng POST polling thay thế tạm
- Games GĐ2 phải ẩn hoàn toàn (không visible, không tap-to-nothing) — Apple reject "placeholder features"
