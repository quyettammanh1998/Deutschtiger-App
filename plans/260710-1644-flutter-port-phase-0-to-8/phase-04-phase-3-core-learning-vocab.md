---
phase: 4
title: "Phase 3a: Core Learning — Vocabulary Hub + Lesson + Word + Detail (C1–C4)"
status: in_progress
priority: P0
effort: "2.5w"
dependencies: [3]
---

# Phase 4: Phase 3a — Vocabulary (C1–C4)

## Overview

Port 4 màn từ vựng chính (C1–C4) từ web. Đây là tính năng lõi — vocab flywheel. C2/C3/C4 chưa có trong Flutter, cần port từ web source.

## Requirements

- C1 `VocabularyScreen` (hub): đã có `vocabulary/presentation/vocabulary_screen.dart`, verify + refine
- C2 Vocabulary Lesson (web: `vocabulary-lesson-page.tsx` 821 LOC): học theo bài
- C3 Vocabulary Word (web: `word-page.tsx` 847 LOC): chi tiết 1 từ
- C4 Vocabulary Detail (web: `detail-page.tsx` 1031 LOC): fullscreen detail + practice

## Architecture

```
lib/features/vocabulary/
├── data/
│   ├── vocabulary_service.dart     # API calls
│   └── vocabulary_model.dart       # freezed models
├── domain/
│   └── vocabulary_providers.dart   # Riverpod providers
└── presentation/
    ├── vocabulary_screen.dart       # C1 hub ✅ refine
    ├── vocabulary_lesson_screen.dart # C2 ❌ tạo
    ├── vocabulary_word_screen.dart   # C3 ❌ tạo
    ├── vocabulary_detail_screen.dart # C4 ❌ tạo
    └── widgets/
        ├── vocab_lesson_card.dart
        ├── vocab_word_card.dart
        ├── vocab_practice_view.dart  # map từ vocabulary-practice-views.tsx
        └── vocab_word_sub_view.dart  # map từ vocabulary-word-sub-components.tsx
```

## Related Code Files

- Modify: `lib/features/vocabulary/presentation/vocabulary_screen.dart` — C1 hub
- Create: `lib/features/vocabulary/presentation/vocabulary_lesson_screen.dart` — C2
- Create: `lib/features/vocabulary/presentation/vocabulary_word_screen.dart` — C3
- Create: `lib/features/vocabulary/presentation/vocabulary_detail_screen.dart` — C4
- Modify: `lib/navigation/app_router.dart` — add C2/C3/C4 routes

## Implementation Steps

### 1. C1 — Vocabulary Hub (refine)
- Đọc `thamkhao/.../pages/vocabulary/vocabulary-page.tsx`
- Verify: level filter tabs (A1/A2/B1/B2), lesson grid, progress indicator
- Thêm: empty state khi chưa có vocab data

### 2. C2 — Vocabulary Lesson (821 LOC web → chia nhỏ)
Web `vocabulary-lesson-page.tsx` chia thành:
- `VocabularyLessonScreen`: top-level scaffold + lesson info
- `VocabLessonCard`: card từng từ trong bài — swipe left/right reveal
- `VocabLessonProgress`: progress bar + word count
- `VocabLessonEndView`: kết thúc bài → show stats + CTA (review/next lesson)

### 3. C3 — Vocabulary Word (847 LOC web → chia nhỏ)
Map từ `vocabulary-word-sub-components.tsx`:
- `VocabWordHeader`: từ + pronunciation + SpeakButton
- `VocabWordMeaning`: nghĩa + ví dụ + GrammarInfo
- `VocabWordExamples`: câu ví dụ dùng TappableSentence → tap word → WordLookupSheet
- `VocabWordPractice`: practice mode inline (multiple choice, fill-blank)
- `SaveCardButton` hiển thị ở top-right

### 4. C4 — Vocabulary Detail (1031 LOC web — phức tạp nhất)
Map từ `detail-page.tsx` sub-views:
- Main detail view: flashcard front/back flip animation
- Related words section
- Usage examples (TappableSentence)
- Practice panel: FSRS quick-review inline
- Audio player cho native speaker recordings

### 5. Navigation + routing
```dart
// app_router.dart routes
GoRoute(path: '/vocabulary/lesson/:id', builder: ...),
GoRoute(path: '/vocabulary/word/:id', builder: ...),
GoRoute(path: '/vocabulary/detail/:id', builder: ...),
```

### 6. Data layer
```dart
// vocabulary_service.dart:
// GET /api/v1/vocabulary/lessons — list lessons by level
// GET /api/v1/vocabulary/lesson/:id — lesson detail + words
// GET /api/v1/vocabulary/word/:id — word detail
// GET /api/v1/vocabulary/search?q= — search
```

## Success Criteria

- [ ] C1: Vocabulary hub load list bài học, filter theo level
- [ ] C2: Lesson screen mở được, swipe qua từng từ trong bài
- [ ] C3: Word screen hiển thị phonetic + nghĩa + TappableSentence clickable
- [ ] C4: Detail screen flip animation đúng, có SaveCardButton
- [ ] SpeakButton trong C3/C4 phát âm từ được
- [ ] Route navigation: hub → lesson → word → detail liền mạch
- [ ] `flutter analyze` 0 error

## Risk Assessment

- C4 là màn phức tạp nhất (1031 LOC) — chia thành widget modules nhỏ <200 LOC mỗi file
- Không tính toán FSRS client-side — mọi grading qua BE endpoints
