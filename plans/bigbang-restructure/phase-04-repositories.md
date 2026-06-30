---
phase: 4
title: "Repositories Layer"
status: pending
priority: P1
effort: 2h
dependencies: [phase-03-data]
---

# Phase 4: Repositories Layer

## Overview
Move repository implementations from `features/*/data/` to `lib/repositories/`.

## Requirements
- Functional: Consolidate all repository files
- Non-functional: Maintain interface + implementation pattern

## Architecture
```
lib/repositories/
├── auth_repository.dart       # From core/identity/
├── profile_repository.dart    # From core/identity/
├── ai/
│   ├── ai_repository.dart
│   └── mock_data.dart
├── exam/
│   ├── exam_repository.dart
│   └── mock_data.dart
├── flashcard/
├── journey/
├── listening/
├── social/
├── speaking/
├── stats/
├── affiliate/
├── decks/
├── home/
├── interview/
├── vocabulary/
└── repositories.dart           # Barrel export
```

## Repository Files to Move
| Source | Target |
|--------|--------|
| `features/ai/data/*_repository.dart` | `lib/repositories/ai/` |
| `features/ai_tutor/data/*_repository.dart` | `lib/repositories/ai/` |
| `features/exam/data/*_repository.dart` | `lib/repositories/exam/` |
| `features/flashcard/data/*_repository.dart` | `lib/repositories/flashcard/` |
| `features/journey/data/*_repository.dart` | `lib/repositories/journey/` |
| `features/listening/data/*_repository.dart` | `lib/repositories/listening/` |
| `features/social/data/*_repository.dart` | `lib/repositories/social/` |
| `features/speaking/data/*_repository.dart` | `lib/repositories/speaking/` |
| `features/stats/data/*_repository.dart` | `lib/repositories/stats/` |
| `features/affiliate/data/*_repository.dart` | `lib/repositories/affiliate/` |
| `features/decks/data/*_repository.dart` | `lib/repositories/decks/` |
| `features/home/data/*_repository.dart` | `lib/repositories/home/` |
| `features/interview/data/*_repository.dart` | `lib/repositories/interview/` |
| `features/vocabulary_search/data/*_repository.dart` | `lib/repositories/vocabulary/` |
| `core/identity/profile_repository.dart` | `lib/repositories/` |

## Implementation Steps

### 4.1: Write Tests First
```dart
// test/structure/repositories_layer_test.dart
test('lib/repositories/ai/ exists', () {
  expect(Directory('lib/repositories/ai').existsSync(), true);
});
test('lib/repositories/auth_repository.dart exists', () {
  expect(File('lib/repositories/auth_repository.dart').existsSync(), true);
});
```

### 4.2: Create Repository Subdirectories
```bash
mkdir -p lib/repositories/{ai,exam,flashcard,journey,listening,social,speaking,stats,affiliate,decks,home,interview,vocabulary}
```

### 4.3: Move Repositories
```bash
git mv lib/features/ai/data/* lib/repositories/ai/
git mv lib/features/ai_tutor/data/* lib/repositories/ai/
# ... repeat for all features
git mv lib/core/identity/profile_repository.dart lib/repositories/
```

### 4.4: Remove Empty Data Directories
```bash
find lib/features -type d -name data -empty -delete
```

### 4.5: Create Barrel Export
```dart
// lib/repositories/repositories.dart
export 'auth_repository.dart';
export 'profile_repository.dart';
export 'ai/ai_repository.dart';
// ... etc
```

## Success Criteria
- [ ] All repositories moved to lib/repositories/
- [ ] Original data/ directories empty or removed
- [ ] Tests pass
- [ ] `flutter analyze` passes

## Rollback
```bash
git checkout HEAD -- lib/features/ lib/repositories/ lib/core/identity/
```

## Risk Assessment
- **Risk:** Medium - 17 repository files
- **Mitigation:** Phase 9 handles import updates
