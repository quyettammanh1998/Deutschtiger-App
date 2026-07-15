---
phase: 5
title: "Phase 3b: FSRS Daily Review + Flashcards + Learn Hub (C5–C7, B2–B3)"
status: in_progress
priority: P0
effort: "included in phase 3"
dependencies: [4]
---

# Phase 5: Phase 3b — FSRS + Learn Hub

## Overview

Hoàn thiện FSRS daily review (C5), Sổ từ (C6), Practice deck (C7), Learn hub (B2), Mission session (B3). Đã có các file cơ bản, cần verify + refine round-trip với BE.

## Requirements

- C5 `DailyReviewScreen`: đã có `daily_review/daily_review_screen.dart` — verify FSRS round-trip BE; server là authority cho due time và scheduling
- C6 Sổ từ của tôi: `decks/deck_list_screen.dart` có, verify contract backend hiện tại `/user/my-words?filter=saved|seen|reviewing` hoặc migrate cả hai client/server trong một contract change
- C7 Practice deck: `flashcard/flashcard_review_screen.dart` có, verify grading
- B2 Learn hub: `journey/journey_screen.dart` có, verify "Phiên hôm nay" data
- B3 Mission runner: port state machine từ `mission-session-runner.tsx`
- P5 GameCompletionScreen: end-of-session screen (đã plan phase 2)

## Implementation Steps

### 1. C5 — Daily Review FSRS verify
```dart
// Verify round-trip:
// GET /api/v1/user/srs/queue → queue
// POST /api/v1/user/srs/review → rating + response_time_ms (KHÔNG tính client-side)
// Due timestamps/timezone được server quyết định; client chỉ render timestamp có timezone.
// Test: review trên app → open web cùng account → due cards giảm đúng
```
- `review_session_view.dart` đã có — check FlipCard animation + rating bar
- Hardest-word detector → endpoint BE đã live, verify call đúng

### 2. C6 — Sổ từ của tôi
```dart
// GET /api/v1/user/my-words?filter=saved|seen|reviewing
// 3 status tabs phải map trực tiếp enum backend; đổi copy chỉ khi API contract được cập nhật đồng bộ.
// Deck list: GET /api/v1/user/flashcard-decks → list user decks
// Tap deck → C7 practice
```

### 3. C7 — Practice Deck
```dart
// flashcard_review_screen.dart: verify endpoint calls and selected-deck scope
// FlashcardView (đã có): front = từ Đức / back = nghĩa + ví dụ
// RatingBar (đã có): Again / Hard / Good / Easy → POST /srs/review
// End of deck → GameCompletionScreen (P5)
```

### 4. B2 — Learn Hub "Phiên hôm nay"
```dart
// journey_screen.dart → đọc endpoint GET /api/v1/learn/session-today
// Hiển thị: mission list cho ngày, số từ đã học, XP earned
// CTA: "Bắt đầu phiên" → B3 mission runner
```

### 5. B3 — Mission Session Runner
Port `mission-session-runner.tsx` state machine:
```
States: idle → starting → in_word_intro → in_practice → between_words → completed
```
- Mỗi mission step = 1 widget (WordIntroView, PracticeView, ResultView)
- Mission funnel tracking: giữ nguyên tên event như web (`mission-funnel-tracking.ts`)
- End of mission → GameCompletionScreen → back to learn hub

## Success Criteria

- [ ] C5: Review 5 từ trên app → mở web cùng account → due count giảm đúng
- [ ] C6: My Words hiển thị đúng ba status backend + count từ cùng filter
- [ ] C7: Deck practice: deck ID đi qua route/provider; queue không chứa card ngoài deck; rate → `POST /user/srs/review` đúng params
- [ ] B2: Learn hub hiển thị đúng mission hôm nay từ BE data
- [ ] B3: Mission chạy trọn vẹn 1 session không crash
- [ ] GameCompletionScreen mở sau khi hoàn thành deck/mission

## Risk Assessment

- FSRS grading: tuyệt đối không tính client-side — mọi logic qua BE
- Timezone: dùng `timezone` package, không `DateTime.now()` naive
