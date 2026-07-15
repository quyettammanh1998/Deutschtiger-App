---
phase: 2
title: "Phase 1: Design System + Shell + Shared Widgets (P1–P7)"
status: in_progress
priority: P0
effort: "1w"
dependencies: [1]
---

# Phase 2: Phase 1 — Design System + Shell + Shared Widgets

## Overview

Hoàn thiện AppShell (đã có 5-tab), xây 8 shared widgets (P1–P7), api_client interceptor hoàn chỉnh, CI green.

## Requirements

- `AppShell` 5-tab đã có → verify sheet "Thêm" grid 4 cột 4 nhóm đúng layout web
- `MinimalShell` cho player routes (exam, game runner, speaking scenario)
- 8 shared widgets P1–P7: WordLookupSheet, TappableSentence, SaveCardButton, BottomSheet base, SpeakButton+audio chain, GameCompletionScreen, Skeleton/OfflineBanner/ConfirmDialog/Confetti, LevelBadge/PremiumCrown/BackButton/PageIntro
- `api_client.dart` (Dio): bearer interceptor + 401 device-kicked handling + X-App-Version header + Crashlytics init

## Architecture

```
lib/
├── shared/
│   └── widgets/
│       ├── word_lookup_sheet.dart       # P1
│       ├── tappable_sentence.dart       # P1
│       ├── save_card_button.dart        # P2
│       ├── base_bottom_sheet.dart       # P3
│       ├── speak_button.dart            # P4 — wraps just_audio chain
│       ├── game_completion_screen.dart  # P5
│       ├── skeleton_loader.dart         # P6
│       ├── offline_banner.dart          # P6
│       ├── confirm_dialog.dart          # P6
│       ├── confetti_burst.dart          # P6
│       ├── level_badge.dart             # P7
│       ├── premium_crown.dart           # P7
│       ├── page_intro.dart              # P7
│       └── more_features_sheet.dart     # đã có, verify
├── core/
│   └── api/
│       └── api_client.dart              # Dio + interceptors
```

## Related Code Files

- Modify: `lib/widgets/common/app_shell.dart` — verify MoreFeaturesSheet grid đúng
- Modify: `lib/services/api_client.dart` → move to `lib/core/api/api_client.dart`
- Create: tất cả shared widgets trong `lib/shared/widgets/`
- Modify: `lib/navigation/app_router.dart` — thêm MinimalShell shell route

## Implementation Steps

### 1. Verify + hoàn thiện AppShell
- Đọc `thamkhao/.../more-features-sheet.tsx` → map 4 cột 4 nhóm vào `MoreFeaturesSheet`
- GĐ2 items → ẩn theo feature flag (đừng hiện disabled — Apple reject "beta/incomplete")
- MinimalShell: shell không có bottom nav, dùng cho exam/game/speaking player routes

### 2. SpeakButton + audio chain (P4) — làm TRƯỚC vì P1 dùng
```dart
// lib/shared/widgets/speak_button.dart
// Chain: recorded URL → cached TTS endpoint → flutter_tts fallback de-DE
// Single-active-audio: pause trước khi play mới
```
Port logic từ `lib/tts/audio-service.ts` + `speak-de.ts` web.

### 3. WordLookupSheet + TappableSentence (P1)
- TappableSentence: wrap text thành `InlineSpan` clickable per word
- WordLookupSheet: bottom sheet tra từ → call dictionary endpoint → show phonetic/meaning/examples
- Nút "Lưu từ" / "Lưu câu" → gọi save endpoint
- Dùng `DraggableScrollableSheet` cho sheet expandable

### 4. SaveCardButton (P2)
```dart
// 3 variants: button | compact | star
// deck picker dialog khi tap → chọn deck + "mở deck →"
```

### 5. Shared UI widgets (P3, P6, P7)
- `BaseBottomSheet`: wrapper chuẩn với handle bar, drag-to-close
- `SkeletonLoader`: shimmer animation cho loading states
- `OfflineBanner`: persistent banner khi `connectivity_plus` trả về no connection
- `ConfirmDialog`: title + body + cancel/confirm buttons
- `ConfettiBurst`: wrap `confetti` package, trigger onSuccess
- `LevelBadge`: chip hiển thị A1/A2/B1/B2 level
- `PremiumCrown`: crown icon overlay cho premium content
- `PageIntro`: title + subtitle + optional icon header

### 6. GameCompletionScreen (P5)
Port `game-completion-screen.tsx`: confetti + score + words learned + CTA (play again / back)

### 7. api_client hoàn chỉnh
```dart
// Dio interceptors:
// - Bearer token từ supabase session
// - 401 → check if "device_kicked" → emit DeviceKickedEvent → navigate /login
// - X-App-Version header (lấy từ package_info_plus)
// - Retry 1 lần nếu 401 do token expired (refresh trước)
```

## Success Criteria

- [ ] Sheet "Thêm" mở đúng grid layout, items GĐ2 ẩn hoàn toàn
- [ ] MinimalShell route hoạt động (exam route không có bottom nav)
- [ ] SpeakButton phát âm từ "Hund" qua chain recorded→TTS
- [ ] WordLookupSheet tra được từ "Haus" hiển thị nghĩa
- [ ] TappableSentence tap word → WordLookupSheet mở
- [ ] OfflineBanner xuất hiện khi tắt wifi
- [ ] api_client 401 device-kicked → emit event đúng
- [ ] `flutter analyze` 0 error

## Risk Assessment

- SpeakButton phụ thuộc BE TTS endpoint — nếu chưa có, fallback flutter_tts trước
- WordLookupSheet phụ thuộc dictionary API — mock response nếu chưa có endpoint
