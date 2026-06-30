---
phase: 7
title: "L10n Layer"
status: pending
priority: P2
effort: 1h
dependencies: [phase-06-viewmodels]
---

# Phase 7: L10n Layer

## Overview
Move `lib/core/i18n/` to `lib/l10n/` for localization standardization.

## Requirements
- Functional: Move i18n service to l10n directory
- Non-functional: Use flutter_localizations pattern

## Architecture
```
lib/l10n/
├── i18n_service.dart           # From core/i18n/
├── l10n.dart                   # Localizations config
└── arb/                       # ARB translation files (future)
```

## Implementation Steps

### 7.1: Write Tests First
```dart
// test/structure/l10n_layer_test.dart
test('lib/l10n/ directory exists', () {
  expect(Directory('lib/l10n').existsSync(), true);
});
test('i18n_service moved to l10n/', () {
  expect(File('lib/l10n/i18n_service.dart').existsSync(), true);
});
```

### 7.2: Move i18n Directory
```bash
git mv lib/core/i18n lib/l10n/
```

### 7.3: Update Imports
```bash
# Update import in app.dart and main.dart
sed -i "s|import 'lib/core/i18n/|import 'lib/l10n/|g" lib/app.dart lib/main.dart
```

## Success Criteria
- [ ] i18n moved to l10n
- [ ] Tests pass
- [ ] `flutter analyze` passes

## Rollback
```bash
git checkout HEAD -- lib/core/i18n/ lib/l10n/
```

## Risk Assessment
- **Risk:** Low - Single directory move
- **Mitigation:** Update imports in Phase 9

## Open Questions
- Implement flutter_localizations properly?
