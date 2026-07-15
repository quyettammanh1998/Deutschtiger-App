---
phase: 7
title: "Phase 4: Exam Player Lesen+Hören (D1–D5) — Màn khó nhất"
status: in-progress
priority: P0
effort: "3w"
dependencies: [6]
---

# Phase 7: Phase 4 — Exam Player Lesen+Hören

## Overview

Port exam player cho Lesen + Hören. GĐ1 không cần Schreiben/Sprechen (GĐ2). Đây là màn phức tạp nhất (153 components web). Chiến lược: chia theo question-type renderer, mỗi type = 1 widget module + 1 fixture + 1 golden test.

## Requirements

- D1: Exam landing/hub — `exam_hub_screen.dart` đã có, refine
- D2: Section per level (A1–C2) — `exam_list_page.dart` verify
- D3: Exam list — có, refine
- D4: Exam player (3 mode: practice/test/review) — `exam_practice_page.dart` rất sơ khai → rebuild
- D5: Exam result — `exam_result_page.dart` verify + refine
- Question types GĐ1: MC, matching, richtig/falsch, sprachbausteine, anzeigen cards
- Audio: max_plays/audio_plays enforcement
- Timer, autosave attempt, resume, abandoned-attempt
- Review mode: highlight đúng/sai

## Architecture

```
lib/features/exam/
├── data/
│   ├── exam_service.dart           # API calls
│   └── exam_models.dart            # freezed models
├── domain/
│   ├── exam_providers.dart         # Riverpod notifiers
│   └── exam_player_notifier.dart   # state machine
└── presentation/
    ├── exam_hub_screen.dart        # D1 ✅ refine
    ├── exam_list_screen.dart       # D2/D3 ✅ refine
    ├── exam_player_screen.dart     # D4 ❌ rebuild
    ├── exam_result_screen.dart     # D5 ✅ refine
    └── widgets/
        ├── exam_chrome/            # timer, nav, progress, palette
        │   ├── exam_timer.dart
        │   ├── exam_nav_bar.dart
        │   └── exam_progress.dart
        └── question_renderers/     # 1 file per question type
            ├── mc_question.dart
            ├── matching_question.dart
            ├── richtig_falsch_question.dart
            ├── sprachbausteine_question.dart
            └── anzeigen_cards_question.dart
```

## Implementation Steps

### 1. Player State Machine (Riverpod notifier)
Port `hooks/exam/use-exam-player.ts` → `ExamPlayerNotifier`:
```dart
enum ExamMode { practice, test, review }
enum ExamStep { loading, playing, reviewing, submitting, completed }

class ExamPlayerState {
  final ExamMode mode;
  final ExamStep step;
  final Map<int, dynamic> answers; // questionIndex → answer
  final Duration timeRemaining;
  final bool isAutosaving;
  final String? attemptId;
}
```

### 2. Exam Chrome (timer, nav, palette)
- `ExamTimer`: countdown khi mode = test; stopwatch khi practice; ẩn khi review
- `ExamNavBar`: previous/next question, palette toggle
- `ExamPalette`: grid câu hỏi (answered/unanswered/flagged color-coded)
- Submit confirm dialog: "X câu chưa trả lời, bạn có muốn nộp?"

### 3. Question Renderers (Lesen types)

**MC (multiple choice):**
```dart
// Render: question text + 4 options (A/B/C/D chips)
// State: unselected / selected / correct (review) / incorrect (review)
// Đúng fix: correct_answer = 0-based index (exam-scoring.ts:17)
```

**Matching:**
```dart
// 2 columns: left items + right items, drag-and-drop hoặc tap-to-pair
// Flutter: GestureDetector + CustomPaint cho connecting lines
```

**Richtig/Falsch:**
```dart
// Statement + R/F toggle buttons
// Review: highlight đúng/sai
```

**Sprachbausteine:**
```dart
// Blanks in text + dropdown per blank
// Dropdown options list từ question data
```

**Anzeigen Cards (Teil 3):**
```dart
// Fix: anzeigen[] shape đúng theo contract (không dùng web shape cũ)
// Cards swipe hoặc scroll horizontal
```

### 4. Hören Audio Player
```dart
// just_audio: load audio URL từ question.audio_url
// max_plays enforcement: track play count local + compare với question.max_plays
// Disable play button khi đã đủ lượt
// audio_plays = số lần đã nghe (lưu trong attempt state)
// Replay button: enabled/disabled theo max_plays
```

### 5. Autosave + Resume
```dart
// Autosave: debounce 5s sau mỗi answer change
// POST /api/v1/exam/attempts/:id/answers → save partial answers
// Resume: GET /api/v1/exam/attempts/:id → restore answers + timeRemaining
// Abandoned semantics: attempt status = 'abandoned' sau X phút không hoạt động
```

### Backend-readiness gate (trước khi xây UI autosave/resume)

Server hiện chỉ có `POST /api/v1/user/exam-attempts` và `GET /api/v1/user/exam-attempts`; POST ghi attempt đã submit, không có draft lifecycle. Phase 4 cần contract được triển khai và test trước:

- create draft (một `attempt_id`, status `in_progress`),
- fetch one attempt của chính user,
- idempotent `PATCH` partial answers/time remaining/audio plays/last activity,
- final submit một lần với server-side validation/grading và immutable result,
- deterministic expiry → `abandoned`.

Chi tiết migration, route tests và Flutter handoff nằm ở `plans/260715-flutter-contract-reconciliation/phase-03-close-learning-and-exam-gaps.md`. Không giả lập resume chỉ trong local state.

Progress 2026-07-15 (source/test evidence only): Flutter has an
`ExamPlayerNotifier`, per-question canonical persistence keys,
timer/autosave/resume wiring and retryable draft submit. The bundled Go backend
mounts create/get/PATCH/submit draft routes and implements immutable
normalized-content scoring snapshots plus idempotent mutation receipts. This
keeps Phase 4 **in progress**, not complete: no disposable migrated
Postgres/API run or physical-device resume/audio evidence exists yet, so the
source and automated checks do not prove the live lifecycle.

### 6. Review Mode
```dart
// Highlight: đúng = green background / sai = red background
// TextSpan styling cho text questions
// Correct answer overlay + explanation (nếu có)
// KHÔNG cho sửa đáp án trong review mode
```

### 7. D5 — Result Screen
```dart
// Score per section (Lesen: X/225, Hören: X/225)
// Pass: ≥135 tổng VÀ ≥45 mỗi phần (telc calibration)
// Chart: fi_chart breakdown per task
// CTA: Xem lại đề / Về trang thi / Làm đề khác
```

## Success Criteria

- [ ] Làm trọn 1 đề telc B1 Lesen trên app, kết quả khớp web cùng attempt
- [ ] Làm trọn 1 đề Hören: audio max_plays enforcement đúng, không replay được khi hết lượt
- [ ] Autosave: tắt app giữa chừng → mở lại → `GET` attempt draft trả đúng vị trí, answers, timer và audio play count
- [ ] Review mode: highlight đúng/sai rõ ràng
- [ ] Timer đếm ngược đúng, nộp tự động khi hết giờ
- [ ] D1/D2/D3/D5 hiển thị đúng data từ BE

## Risk Assessment

- 153 components web → chỉ port types Lesen+Hören (ước ~60%). Types khác GĐ2.
- Audio buffer Android yếu → test thiết bị thật sớm, dùng cache file với just_audio
- Anzeigen correct_answer 0-based index → dễ off-by-one → fixture test per type
