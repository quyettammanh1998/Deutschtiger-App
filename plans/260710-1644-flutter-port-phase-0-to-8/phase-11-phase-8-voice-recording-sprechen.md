---
phase: 11
title: "Phase 8: GĐ2 — Voice Recording + Sprechen + Pronunciation + Voice AI"
status: pending
priority: P1
effort: "3w"
dependencies: [10]
---

# Phase 11: Phase 8 — Voice + Sprechen + Pronunciation

## Overview

Lần đầu xin mic permission. Update này cần `NSMicrophoneUsageDescription` + Data Safety update (audio gửi server). Màn: F1–F6, J3–J5.

## Requirements

- Recording: `record` package + `permission_handler`
- Permission flow mềm: giải thích trước khi xin — deny thì graceful fallback
- STT: upload audio → BE grading (default); Soniox streaming nếu conversation cần live captions
- Sprechen exams (F1–F3): TELC + Goethe recording → AI grading
- Pronunciation (F4): hub + umlaute/ich-ach/r-sound/sp-st + PronunciationPracticePanel
- Conversation voice AI (J3–J4): turn-taking voice scenario
- Tiger AI FAB global (J5): đã có placeholder, wire thật
- Speaking games (F5–F6): speaking game + konjugation

## Architecture

```
lib/features/voice/
├── data/
│   ├── recording_service.dart     # record package wrapper
│   ├── stt_service.dart           # STT: upload|Soniox|on-device
│   └── grading_service.dart       # POST /ai/grade-speaking
├── domain/
│   └── voice_providers.dart
└── presentation/
    ├── sprechen_screen.dart        # F1/F2 TELC + Goethe
    ├── pronunciation_hub_screen.dart # F4
    ├── conversation_scenario_screen.dart # J3
    └── widgets/
        ├── record_button.dart      # hold-to-record / tap-toggle
        ├── audio_waveform.dart     # visual feedback
        ├── score_result_card.dart
        └── pronunciation_practice_panel.dart # P8
```

## Implementation Steps

### 1. Recording nền tảng
```dart
// pubspec.yaml: record: ^5.x, permission_handler: ^11.x
// Permission flow:
// 1. Màn giải thích: "DeutschTiger cần mic để chấm bài nói của bạn"
// 2. Xin quyền: await Permission.microphone.request()
// 3. Denied → graceful: ẩn nút record, hiện message "Cần cấp quyền mic"
// 4. Denied forever → link Settings
```
iOS: `NSMicrophoneUsageDescription` = "Ghi âm bài nói để chấm điểm phát âm"
Android: `RECORD_AUDIO` permission trong manifest

### 2. Data Safety + Info.plist update
- Data Safety: thêm Audio → uploaded to server → AI processing, not retained
- `ios/Runner/Info.plist`: NSMicrophoneUsageDescription (rõ ràng, không mơ hồ)

### 3. STT strategy decision (đầu phase)
```
Option A (default): upload audio → BE STT → trả transcript
  - Dùng cho: sprechen grading (không cần realtime)
  - BE đã có endpoint grading
  
Option B (conversation): Soniox streaming SDK nếu available Flutter
  - POC trước khi commit: test Flutter + Soniox streaming API
  - Fallback: speech_to_text on-device (on Google/Apple STT)
```

### 4. F1–F3 — Sprechen Exams
```dart
// SvrechenScreen: prompt + timer (2 phút chuẩn bị, 3 phút nói)
// RecordButton: hold-to-record hoặc toggle
// AudioWaveform: visual feedback khi đang ghi
// Sau record: POST /api/v1/ai/grade-speaking → score + feedback
// ScoreResultCard: điểm per criterion (grammar, vocab, coherence, pronunciation)
// Cache grading response (tránh re-grade cùng attempt)
```

### 5. F4 — Pronunciation Hub
```dart
// PronunciationHubScreen: list trainers
// Trainers:
// - UmlauteTrainer (ä/ö/ü): đã có umlaute_trainer_page.dart → verify + refine
// - IchAchTrainer: ich-sound vs ach-sound
// - RSoundTrainer: r-sound (uvular vs alveolar)
// - SpStTrainer: sp/st pronunciation
// - MinimalPairsTrainer: word pairs (lang/lank, Bahn/Bann)
// PronunciationPracticePanel (P8): record → playback → AI score
```

### 6. J3–J4 — Conversation Voice AI
```dart
// ConversationScenarioScreen: chọn scenario (Café / Arzttermin / ...)
// Turn-taking loop:
// 1. AI speaks (TTS)
// 2. User record response
// 3. STT → AI processes → next AI turn
// 4. Repeat N turns → summary + score
// Exit guard: "Bạn có muốn thoát? Tiến trình sẽ bị mất"
// Custom scenarios (J4): tạo scenario riêng (GĐ2, ẩn nếu chưa sẵn)
```

### 7. J5 — Tiger AI FAB
```dart
// AppShell: FAB _TigerAiFab đã có → wire: onPressed → push /ai-tutor/chat
// Drawer: AI quick actions (Chat / Conversation / Practice) → bottom sheet
// Visibility toggle: ẩn khi đang ở player routes (MinimalShell)
```

### 8. F5/F6 — Speaking Games
```dart
// speaking_game_screen.dart: đã có sơ → verify + hoàn thiện
// Konjugation game: đã có → verify end-to-end với GameCompletionScreen
```

## Success Criteria

- [ ] Mic permission flow: giải thích → xin → deny graceful → ẩn tính năng record
- [ ] F1 Sprechen: record 30s → POST grading → score card hiển thị đúng
- [ ] F4 Umlaut trainer: record → playback → AI feedback hiển thị
- [ ] J3 Conversation: hoàn thành 1 scenario 3 turns không crash
- [ ] J5 FAB: mọi màn AppShell thấy FAB, tap → AI chat
- [ ] Info.plist NSMicrophoneUsageDescription rõ ràng
- [ ] Data Safety update: audio → server declared

## Risk Assessment

- Echo/gain recording khác web → benchmark cùng 1 file audio giữa app/web
- Apple reject NSMicrophoneUsageDescription mơ hồ → copy exact string đã approve (nhiều app dùng)
- Soniox streaming SDK Flutter chưa verified → POC tuần đầu, fallback on-device STT ngay nếu fail
