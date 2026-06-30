---
phase: 3
title: "Data Layer (DTOs)"
status: pending
priority: P1
effort: 3h
dependencies: [phase-01-baseline]
---

# Phase 3: Data Layer (DTOs)

## Overview
Create `lib/data/` and move DTOs from `features/*/domain/` directories.

## Requirements
- Functional: Move all DTOs from features/*/domain/ to lib/data/
- Non-functional: Each DTO has test coverage

## Architecture
```
lib/data/
├── ai/             # From features/ai/domain/, features/ai_tutor/domain/
├── exam/           # From features/exam/domain/
├── flashcard/      # From features/flashcard/domain/
├── journey/        # From features/journey/domain/
├── listening/      # From features/listening/domain/
├── social/         # From features/social/domain/
├── speaking/       # From features/speaking/domain/
├── stats/          # From features/stats/domain/
├── affiliate/     # From features/affiliate/domain/
├── decks/          # From features/decks/domain/
├── games/          # From features/games/domain/
├── grammar/        # From features/grammar/domain/
├── vocab/          # From features/vocabulary_search/domain/
├── interview/      # From features/interview/domain/
└── data.dart       # Barrel export
```

## DTO Files to Move
| Source | Target |
|--------|--------|
| `features/ai/domain/*.dart` | `lib/data/ai/*.dart` |
| `features/ai_tutor/domain/*.dart` | `lib/data/ai/*.dart` |
| `features/exam/domain/*.dart` | `lib/data/exam/*.dart` |
| `features/flashcard/domain/*.dart` | `lib/data/flashcard/*.dart` |
| `features/journey/domain/*.dart` | `lib/data/journey/*.dart` |
| `features/listening/domain/*.dart` | `lib/data/listening/*.dart` |
| `features/social/domain/*.dart` | `lib/data/social/*.dart` |
| `features/speaking/domain/*.dart` | `lib/data/speaking/*.dart` |
| `features/stats/domain/*.dart` | `lib/data/stats/*.dart` |
| `features/affiliate/domain/*.dart` | `lib/data/affiliate/*.dart` |
| `features/decks/domain/*.dart` | `lib/data/decks/*.dart` |
| `features/games/domain/*.dart` | `lib/data/games/*.dart` |
| `features/grammar/domain/*.dart` | `lib/data/grammar/*.dart` |
| `features/vocabulary_search/domain/*.dart` | `lib/data/vocab/*.dart` |
| `features/interview/domain/*.dart` | `lib/data/interview/*.dart` |

## Implementation Steps

### 3.1: Write Tests First
```dart
// test/structure/data_layer_migration_test.dart
test('lib/data/ai/ exists with models', () {
  expect(Directory('lib/data/ai').existsSync(), true);
});
test('DTOs moved from features/*/domain/', () {
  // Original domain dirs should be empty
});
```

### 3.2: Create Data Subdirectories
```bash
mkdir -p lib/data/{ai,exam,flashcard,journey,listening,social,speaking,stats,affiliate,decks,games,grammar,vocab,interview}
```

### 3.3: Move DTO Directories
```bash
git mv lib/features/ai/domain/* lib/data/ai/
git mv lib/features/ai_tutor/domain/* lib/data/ai/
# ... repeat for all features
```

### 3.4: Remove Empty Domain Directories
```bash
find lib/features -type d -name domain -empty -delete
```

### 3.5: Create Barrel Export
```dart
// lib/data/data.dart
export 'ai/ai_models.dart';
export 'exam/exam_models.dart';
// ... etc
```

## Success Criteria
- [ ] All DTOs moved to lib/data/
- [ ] Empty domain directories removed
- [ ] Tests pass
- [ ] `flutter analyze` passes

## Rollback
```bash
git checkout HEAD -- lib/features/ lib/data/
```

## Risk Assessment
- **Risk:** Medium - 15+ DTO directories to move
- **Mitigation:** Batch move with shell glob patterns

## Open Questions
- Generated files (.freezed.dart, .g.dart) - move or leave in place?
