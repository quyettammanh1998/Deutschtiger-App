---
phase: 8
title: "Navigation Layer"
status: pending
priority: P2
effort: 1h
dependencies: [phase-07-l10n]
---

# Phase 8: Navigation Layer

## Overview
Move `lib/core/router/app_router.dart` to `lib/navigation/`.

## Requirements
- Functional: Move router to navigation directory
- Non-functional: Keep router pattern with go_router

## Architecture
```
lib/navigation/
├── app_router.dart              # From core/router/
└── navigation.dart              # Barrel export
```

## Implementation Steps

### 8.1: Write Tests First
```dart
// test/structure/navigation_layer_test.dart
test('lib/navigation/ directory exists', () {
  expect(Directory('lib/navigation').existsSync(), true);
});
test('app_router.dart moved to navigation/', () {
  expect(File('lib/navigation/app_router.dart').existsSync(), true);
});
```

### 8.2: Move Router
```bash
git mv lib/core/router/app_router.dart lib/navigation/
rmdir lib/core/router 2>/dev/null || true
```

### 8.3: Create Barrel Export
```dart
// lib/navigation/navigation.dart
export 'app_router.dart';
```

## Success Criteria
- [ ] Router moved to lib/navigation/
- [ ] Tests pass

## Rollback
```bash
git checkout HEAD -- lib/navigation/ lib/core/router/
```

## Risk Assessment
- **Risk:** Low - Single file move
- **Mitigation:** Update import in app.dart (Phase 9)
