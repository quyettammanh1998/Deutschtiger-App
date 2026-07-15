---
phase: 6
title: "Phase 3c: Dashboard (B1) — Chốt 1 bản + 23 widgets + Streak + Heartbeat"
status: in_progress
priority: P0
effort: "included in phase 3"
dependencies: [5]
---

# Phase 6: Phase 3c — Dashboard B1

## Overview

Dashboard là màn chủ — có 2 bản (`home_screen.dart` + cũ). Phase này chốt 1 bản, port 23 dashboard widgets từ web, kết nối streak claim modal + heartbeat provider.

## Requirements

- Chốt 1 bản duy nhất giữa 2 file home_screen (Phase 0 cleanup)
- Port 23 dashboard widgets từ `components/dashboard/*` web
- Widget trỏ GĐ2 → ẩn theo feature flag
- Streak claim modal + heartbeat timer nền khi app foreground
- Dashboard data từ real BE endpoints (không mock)

## Related Code Files

- Modify: `lib/screens/home/home_screen.dart` — hoàn thiện, kết nối providers
- Modify: `lib/screens/home/widgets/dashboard_sections.dart`
- Modify: `lib/screens/home/widgets/resume_section.dart`
- Modify: `lib/widgets/dashboard/mobile_dashboard_header.dart` — kết nối real data
- Modify: `lib/widgets/dashboard/mobile_stats_card.dart`
- Modify: `lib/widgets/dashboard/quick_actions.dart`
- Modify: `lib/widgets/dashboard/streak_claim_modal.dart`
- Modify: `lib/widgets/heartbeat_bootstrap.dart`
- Create: `lib/features/heartbeat/heartbeat_provider.dart`

## Implementation Steps

### 1. Chốt 1 bản HomeScreen
- Đọc cả 2 bản → giữ bản có nhiều nội dung hơn
- Xoá bản còn lại + update router

### 2. Kết nối real data providers
Thay mock constants (`_streak = 7`, `_dailyXp = 150`) bằng providers:
```dart
// Providers cần:
// - gamificationProvider: GET /api/v1/user/gamification → streak, XP, level
// - dashboardProvider: GET /api/v1/dashboard → missions, progress, quick-stats
// - heartbeatProvider: POST /api/v1/heartbeat mỗi 60s khi foreground
```

### 3. Port 23 dashboard widgets
Đọc `components/dashboard/*` web → map sang Flutter widgets:
- `StreakCard`: streak số ngày + flame icon + calendar mini
- `DailyGoalCard`: XP progress bar (daily/goal)
- `TodayMissionCard`: mission list với progress
- `QuickActionsCard`: 4 action buttons (Học / Ôn / Thi / AI)
- `ContinueLearningCard`: card resume last activity
- `WeeklyStatsCard`: bar chart 7 ngày dùng `fl_chart`
- `AchievementHighlightCard` (GĐ1 only — show earned achievements)
- Widgets GĐ2 (streak freeze, premium banner) → ẩn hoàn toàn với flag

### 4. Streak claim modal
```dart
// streak_claim_modal.dart: hiện khi user chưa claim streak hôm nay
// POST /api/v1/user/claim-streak → increment streak
// Animation: confetti burst + streak number count-up
// Dismiss: tap outside hoặc "Đã nhận"
```

### 5. Heartbeat provider
```dart
// Chạy khi app foreground, dừng khi background (AppLifecycleState)
// POST /api/v1/heartbeat mỗi 60s → BE track online_seconds
// Port logic từ use-heartbeat.ts web
```

## Success Criteria

- [ ] Dashboard load real streak + XP data từ BE (không còn mock constants)
- [ ] Streak claim modal hiện đúng lúc (một lần/ngày), confetti animation
- [ ] Heartbeat gửi đúng 60s interval khi foreground, dừng khi background
- [ ] Quick actions navigate đúng (Học → `/learn`, Ôn → `/daily-review`, Thi → `/exam`, AI → `/ai-tutor`). `/learn` là route AppShell hiện tại; chỉ đổi sang `/lessons` trong một IA migration có router contract test.
- [ ] Widgets GĐ2 không hiện trong build GĐ1
- [ ] Pull-to-refresh hoạt động

## Risk Assessment

- Heartbeat không được gây lag UI → chạy trong isolate hoặc Timer.periodic không block
- `_dailyXp` mock → phải có BE endpoint gamification trước phase này
