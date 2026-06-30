---
phase: 6
title: "ViewModels Layer"
status: pending
priority: P1
effort: 2h
dependencies: [phase-05-screens-widgets]
---

# Phase 6: ViewModels Layer

## Overview
Move provider files from `features/*/presentation/` and `core/` to `lib/view_models/`.

## Requirements
- Functional: Consolidate all Riverpod providers
- Non-functional: Maintain provider pattern

## Architecture
```
lib/view_models/
├── providers.dart              # Main provider exports
├── theme_provider.dart         # From core/theme/
├── preferences_provider.dart  # From core/preferences/
├── ai/
│   └── ai_provider.dart
├── ai_tutor/
│   └── ai_tutor_provider.dart
├── auth/
├── decks/
│   └── deck_provider.dart
├── exam/
│   └── exam_provider.dart
├── flashcard/
│   └── review_provider.dart
├── home/
│   └── home_provider.dart
├── interview/
│   ├── interview_provider.dart
│   ├── transcript_provider.dart
│   └── video_note_provider.dart
├── journey/
│   └── journey_provider.dart
├── listening/
│   └── podcast_provider.dart
├── profile/
├── quiz/
├── settings/
├── social/
│   └── social_provider.dart
├── speaking/
│   └── speaking_provider.dart
├── stats/
│   └── stats_provider.dart
├── affiliate/
│   └── affiliate_provider.dart
└── view_models.dart            # Barrel export
```

## Provider Files to Move
| Source | Target |
|--------|--------|
| `core/providers.dart` | `lib/view_models/providers.dart` |
| `core/theme/theme_provider.dart` | `lib/view_models/theme_provider.dart` |
| `core/preferences/preferences_provider.dart` | `lib/view_models/preferences_provider.dart` |
| `features/ai/presentation/ai_provider.dart` | `lib/view_models/ai/ai_provider.dart` |
| `features/ai_tutor/presentation/ai_tutor_provider.dart` | `lib/view_models/ai_tutor/ai_tutor_provider.dart` |
| `features/decks/presentation/deck_provider.dart` | `lib/view_models/decks/deck_provider.dart` |
| `features/exam/presentation/exam_provider.dart` | `lib/view_models/exam/exam_provider.dart` |
| `features/flashcard/presentation/review_provider.dart` | `lib/view_models/flashcard/review_provider.dart` |
| `features/home/presentation/home_provider.dart` | `lib/view_models/home/home_provider.dart` |
| `features/interview/presentation/*_provider.dart` | `lib/view_models/interview/` |
| `features/journey/presentation/journey_provider.dart` | `lib/view_models/journey/journey_provider.dart` |
| `features/listening/presentation/podcast_provider.dart` | `lib/view_models/listening/podcast_provider.dart` |
| `features/speaking/presentation/speaking_provider.dart` | `lib/view_models/speaking/speaking_provider.dart` |
| `features/social/presentation/social_provider.dart` | `lib/view_models/social/social_provider.dart` |
| `features/stats/presentation/stats_provider.dart` | `lib/view_models/stats/stats_provider.dart` |
| `features/affiliate/presentation/affiliate_provider.dart` | `lib/view_models/affiliate/affiliate_provider.dart` |

## Implementation Steps

### 6.1: Write Tests First
```dart
// test/structure/view_models_layer_test.dart
test('lib/view_models/providers.dart exists', () {
  expect(File('lib/view_models/providers.dart').existsSync(), true);
});
test('Feature providers in subdirectories', () {
  expect(Directory('lib/view_models/ai').existsSync(), true);
});
```

### 6.2: Create ViewModels Subdirectories
```bash
mkdir -p lib/view_models/{ai,ai_tutor,auth,decks,exam,flashcard,home,interview,journey,listening,profile,quiz,settings,social,speaking,stats,affiliate}
```

### 6.3: Move Providers
```bash
# Core providers
git mv lib/core/providers.dart lib/view_models/
git mv lib/core/theme/theme_provider.dart lib/view_models/
git mv lib/core/preferences/preferences_provider.dart lib/view_models/

# Feature providers
git mv lib/features/ai/presentation/ai_provider.dart lib/view_models/ai/
git mv lib/features/ai_tutor/presentation/ai_tutor_provider.dart lib/view_models/ai_tutor/
# ... repeat for all features
```

### 6.4: Create Barrel Export
```dart
// lib/view_models/view_models.dart
export 'providers.dart';
export 'theme_provider.dart';
export 'preferences_provider.dart';
export 'ai/ai_provider.dart';
// ... etc
```

## Success Criteria
- [ ] All providers moved to lib/view_models/
- [ ] Original provider locations updated
- [ ] Tests pass

## Rollback
```bash
git checkout HEAD -- lib/view_models/ lib/core/
```

## Risk Assessment
- **Risk:** Medium - 20 provider files
- **Mitigation:** Barrel exports simplify imports
