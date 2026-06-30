---
phase: 5
title: "Screens & Widgets Flattening"
status: pending
priority: P1
effort: 4h
dependencies: [phase-04-repositories]
sub_phases: [5a, 5b, 5c]
---

# Phase 5: Screens & Widgets Flattening

**⚠️ SPLIT INTO 3 SUB-PHASES** (Risk Mitigation from Validation Report)

This phase is high-risk due to many files. Splitting into sub-phases allows for:
- Easier rollback per sub-phase
- Better error isolation
- Clearer progress tracking

---

## Phase 5a: Screens Only

### Overview
Move screens from `features/*/presentation/` to `lib/screens/`.

### Architecture - Screens
```
lib/screens/
├── ai/
│   ├── ai_chat_page.dart
│   ├── ai_writing_practice_page.dart
│   └── ai_settings_page.dart
├── auth/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   └── welcome_screen.dart
├── exam/
│   ├── exam_screen.dart
│   ├── exam_list_page.dart
│   └── ...
├── flashcard/
├── games/
├── home/
├── interview/
├── journey/
├── listening/
├── profile/
├── settings/
├── social/
├── speaking/
├── stats/
├── affiliate/
├── decks/
├── grammar/
├── legal/
├── leaderboard/
├── pronunciation/
├── quiz/
├── reminders/
└── webview/  ⚠️ ADDED (Gap 6)
```

### Complete Feature List (including missing Gap 6 - webview)
- `ai`, `ai_tutor`, `auth`, `exam`, `flashcard`, `games`, `home`, `interview`, `journey`, `listening`, `profile`, `settings`, `social`, `speaking`, `stats`, `affiliate`, `decks`, `grammar`, `legal`, `leaderboard`, `pronunciation`, `quiz`, `reminders`, `webview`

### Implementation Steps

#### 5a.1: Write Tests First
```dart
// test/structure/screens_layer_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Screens Layer Migration', () {
    test('lib/screens/ai/ exists', () {
      expect(Directory('lib/screens/ai').existsSync(), true);
    });
    
    test('lib/screens/webview/ exists', () {
      expect(Directory('lib/screens/webview').existsSync(), true);
    });
    
    test('lib/screens/exam/ exists', () {
      expect(Directory('lib/screens/exam').existsSync(), true);
    });
    
    test('Presentation directories emptied', () {
      final presentationDirs = [
        'lib/features/ai/presentation',
        'lib/features/exam/presentation',
        'lib/features/flashcard/presentation',
        'lib/features/home/presentation',
        'lib/features/webview/presentation',  // ADDED - Gap 6
      ];
      for (final dir in presentationDirs) {
        if (Directory(dir).existsSync()) {
          final dartFiles = Directory(dir).listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.dart'))
              .toList();
          expect(dartFiles.isEmpty, true, reason: '$dir should be empty');
        }
      }
    });
  });
}
```

#### 5a.2: Create Subdirectories
```bash
mkdir -p lib/screens/{ai,ai_tutor,auth,exam,flashcard,games,home,interview,journey,listening,profile,settings,social,speaking,stats,affiliate,decks,grammar,legal,leaderboard,pronunciation,quiz,reminders,webview}
```

#### 5a.3: Move Screens
```bash
# Move all presentation files
for feature in ai ai_tutor auth exam flashcard games home interview journey listening profile settings social speaking stats affiliate decks grammar legal leaderboard pronunciation quiz reminders webview; do
  if [ -d "lib/features/$feature/presentation" ]; then
    git mv lib/features/$feature/presentation/* lib/screens/$feature/ 2>/dev/null || true
  fi
done
```

#### 5a.4: Create Barrel Exports
```dart
// lib/screens/screens.dart
export 'ai/ai_chat_page.dart';
export 'auth/login_screen.dart';
export 'webview/webview_lesson_screen.dart';
// ... etc
```

### Success Criteria
- [ ] All screens moved to lib/screens/
- [ ] Presentation directories empty
- [ ] Tests pass

### Rollback
```bash
git checkout HEAD -- lib/features/ lib/screens/
```

---

## Phase 5b: Feature Widgets

### Overview
Move widgets from `features/*/presentation/widgets/` and `features/*/widgets/` to `lib/widgets/`.

### Widget Directories to Move
| Source | Target |
|--------|--------|
| `features/*/widgets/*.dart` | `lib/widgets/{feature}/*.dart` |
| `features/*/presentation/widgets/*.dart` | `lib/widgets/{feature}/*.dart` |

### Complete Widget Directory List (Gap 2 fix)
- `lib/features/ai/widgets/` → `lib/widgets/ai/`
- `lib/features/speaking/widgets/` → `lib/widgets/speaking/`
- `lib/features/flashcard/presentation/widgets/` → `lib/widgets/flashcard/` ⚠️ ADDED
- `lib/features/ai_tutor/presentation/widgets/` → `lib/widgets/ai_tutor/` ⚠️ ADDED

### Implementation Steps

#### 5b.1: Write Tests First
```dart
// test/structure/widgets_layer_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Feature Widgets Migration', () {
    test('lib/widgets/ai/ exists', () {
      expect(Directory('lib/widgets/ai').existsSync(), true);
    });
    
    test('lib/widgets/flashcard/ exists with presentation widgets', () {
      expect(Directory('lib/widgets/flashcard').existsSync(), true);
    });
    
    test('lib/widgets/ai_tutor/ exists with presentation widgets', () {
      expect(Directory('lib/widgets/ai_tutor').existsSync(), true);
    });
    
    test('Original presentation/widgets directories emptied', () {
      final widgetDirs = [
        'lib/features/flashcard/presentation/widgets',
        'lib/features/ai_tutor/presentation/widgets',
      ];
      for (final dir in widgetDirs) {
        if (Directory(dir).existsSync()) {
          final dartFiles = Directory(dir).listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.dart'))
              .toList();
          expect(dartFiles.isEmpty, true, reason: '$dir should be empty');
        }
      }
    });
  });
}
```

#### 5b.2: Move Feature Widgets
```bash
# Create feature widget directories
mkdir -p lib/widgets/{ai,auth,dashboard,exam,flashcard,grammar,home,interview,journey,listening,profile,quiz,social,speaking,stats,ai_tutor}

# Move from features/*/widgets/
for feature in ai auth dashboard exam flashcard grammar home interview journey listening profile quiz social speaking stats; do
  if [ -d "lib/features/$feature/widgets" ]; then
    mkdir -p lib/widgets/$feature
    git mv lib/features/$feature/widgets/* lib/widgets/$feature/ 2>/dev/null || true
  fi
done

# Move from features/*/presentation/widgets/ (ADDED - Gap 2)
for feature in flashcard ai_tutor speaking; do
  if [ -d "lib/features/$feature/presentation/widgets" ]; then
    mkdir -p lib/widgets/$feature
    git mv lib/features/$feature/presentation/widgets/* lib/widgets/$feature/ 2>/dev/null || true
  fi
done
```

### Success Criteria
- [ ] All feature widgets consolidated in lib/widgets/
- [ ] Original widget directories empty or removed
- [ ] Tests pass

### Rollback
```bash
git checkout HEAD -- lib/features/ lib/widgets/
```

---

## Phase 5c: Shared Widgets

### Overview
Move widgets from `lib/shared/widgets/` to `lib/widgets/common/`.

### Implementation Steps

#### 5c.1: Write Tests First
```dart
test('lib/widgets/common/ exists', () {
  expect(Directory('lib/widgets/common').existsSync(), true);
});

test('shared/widgets/ moved', () {
  expect(Directory('lib/shared/widgets').existsSync(), false);
});
```

#### 5c.2: Move Shared Widgets
```bash
# Create common widgets directory
mkdir -p lib/widgets/common

# Move shared widgets
git mv lib/shared/widgets/* lib/widgets/common/ 2>/dev/null || true

# Verify no other shared subdirs
ls lib/shared/  # Should be empty or only have non-widget dirs

# Remove empty shared directory
rmdir lib/shared/widgets 2>/dev/null || true
rmdir lib/shared 2>/dev/null || true
```

#### 5c.3: Create Barrel Exports
```dart
// lib/widgets/widgets.dart
export 'common/app_shell.dart';
export 'common/auth_card.dart';
export 'common/tiger_logo.dart';
// ... etc
```

### Success Criteria
- [ ] All shared widgets in lib/widgets/common/
- [ ] lib/shared/ deleted
- [ ] Tests pass

### Rollback
```bash
git checkout HEAD -- lib/shared/ lib/widgets/common/
```

---

## Phase 5 Rollback Summary

```bash
# Full Phase 5 rollback
git checkout HEAD -- lib/features/ lib/screens/ lib/widgets/ lib/shared/
# If directories were deleted, restore from previous commit
git checkout HEAD~1 -- lib/features/
```

## Risk Assessment
- **Risk:** High - Many files to move
- **Mitigation:** Split into 3 sub-phases for easier rollback and error isolation
