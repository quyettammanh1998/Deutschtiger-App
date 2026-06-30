---
title: "Big Bang Directory Restructure"
description: "Restructure lib/ to match reference repo pattern with flat screens/, widgets/, view_models/, repositories/, data/, services/, navigation/, l10n/"
status: pending
priority: P1
effort: 3d
branch: main
tags: [refactor, architecture, directory-structure, tdd]
created: 2026-06-30
resolved_questions:
  - id: Q1
    question: "Generated files (.freezed.dart, .g.dart) handling"
    decision: "Keep generated files in original location after move, regenerate with build_runner post-Phase 9"
  - id: Q2
    question: "lib/features/ directory - delete or keep empty?"
    decision: "Keep as empty directory for rollback reference, delete after Phase 10 verification"
  - id: Q3
    question: "Barrel exports - maintain or remove?"
    decision: "Maintain barrel exports - matches reference repo pattern and reduces Phase 9 import changes"
  - id: Q4
    question: "Feature subdirectories in lib/screens/"
    decision: "Keep subdirectories (lib/screens/ai/, lib/screens/exam/) - matches reference repo"
  - id: Q5
    question: "lib/core/ cleanup after all moves"
    decision: "Keep as lib/core/ - matches reference repo pattern"
  - id: Q6
    question: "Widget categorization"
    decision: "Use feature subdirectories (lib/widgets/ai/, lib/widgets/exam/) - matches plan architecture"
  - id: Q7
    question: "lib/shared/ directory handling"
    decision: "Move widgets to lib/widgets/common/, verify no other subdirs, delete empty parent"
  - id: Q8
    question: "Provider imports in lib/core/providers.dart"
    decision: "Update Phase 2 to include lib/core/providers.dart import fixes alongside services move"
---

# Big Bang Directory Restructure Plan

## Context

**Goal:** Restructure entire `lib/` to match reference repo pattern from `/home/qtm/Desktop/flutter-accelerator-ai`

**Current State:**
- 250 Dart files in lib/
- Features in `features/` with subdirs: `domain/`, `data/`, `presentation/`, `widgets/`
- Core in `lib/core/`: auth, config, i18n, notifications, router, theme
- Shared widgets in `lib/shared/`

**Target Structure:**
```
lib/
├── core/           # Design tokens, theme, config
├── data/           # DTOs (centralized from features/*/domain/)
├── l10n/           # Localization (flutter_localizations)
├── main.dart
├── navigation/     # Navigation controller
├── previews/       # Widget previews
├── repositories/   # Data access layer (from features/*/data/)
├── screens/        # Screens (flattened from features/*/presentation/)
├── services/       # Platform services (from core/)
├── view_models/    # State management (Riverpod providers)
└── widgets/        # Reusable UI components
```

## Verification Checklist

- [x] Explicit data flows: import chains mapped in Phase 1
- [x] Dependency graph: Phase order prevents circular deps
- [x] Risk per phase: rollback plans defined
- [x] Backwards compatibility: git history preserved for all moves
- [x] Test matrix: import tests + structure tests per phase
- [x] Rollback: `git checkout` to previous state per phase (updated for Phases 3-8)
- [x] File ownership: no parallel phases touch same files
- [x] Success criteria: `flutter analyze` 0 errors, `flutter test` all pass

### Validation Report Gaps Addressed
- [x] Gap 1: lib/core/identity/ documented (Phase 4)
- [x] Gap 2: Feature widgets subdirectories enumerated (Phase 5b)
- [x] Gap 3: home/domain/ documented (Phase 3)
- [x] Gap 4: vocabulary_search data/domain documented (Phases 3, 4)
- [x] Gap 5: interview/data/transcript_service.dart documented (Phase 4)
- [x] Gap 6: webview feature documented (Phase 5a)

### Open Questions Resolved
- [x] Q1: Generated files (.freezed.dart, .g.dart) - Keep in place, regenerate post-Phase 9
- [x] Q2: lib/features/ - Keep empty for rollback, delete after Phase 10
- [x] Q3: Barrel exports - Maintain for backward compatibility
- [x] Q4: Feature subdirs in lib/screens/ - Keep (matches reference)
- [x] Q5: lib/core/ - Keep as-is (matches reference)
- [x] Q6: Widget categorization - Feature subdirs
- [x] Q7: lib/shared/ - Move widgets to common/, delete empty parent
- [x] Q8: providers.dart imports - Update in Phase 2 before services move

---

## Phase 1: Baseline & Preparation

### Phase 1a: Establish Baseline

**Requirements:**
- Functional: Record current `flutter analyze` and `flutter test` output
- Non-functional: Must establish failure threshold (current errors = baseline)

**Implementation Steps:**

1. Run `flutter analyze > baseline_analysis.txt 2>&1`
2. Run `flutter test > baseline_test_results.txt 2>&1`
3. Commit baseline state: `git add -A && git commit -m "chore: capture pre-restructure baseline"`

**Success Criteria:**
- [ ] `baseline_analysis.txt` captures all current warnings/errors
- [ ] `baseline_test_results.txt` captures test pass/fail status

**Risk Assessment:**
- **Low Risk** - Read-only operations

---

### Phase 1b: Create Directory Structure Tests (TDD)

**Requirements:**
- Functional: Tests verify target directory structure
- Non-functional: Tests MUST fail before directories exist

**Implementation Steps:**

1. Create `test/structure/directory_structure_test.dart`:

```dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final libPath = 'lib';
  
  group('Target Directory Structure', () {
    test('core/ directory exists', () {
      expect(Directory('$libPath/core').existsSync(), true);
    });
    
    test('data/ directory exists', () {
      expect(Directory('$libPath/data').existsSync(), true);
    });
    
    test('repositories/ directory exists', () {
      expect(Directory('$libPath/repositories').existsSync(), true);
    });
    
    test('screens/ directory exists', () {
      expect(Directory('$libPath/screens').existsSync(), true);
    });
    
    test('view_models/ directory exists', () {
      expect(Directory('$libPath/view_models').existsSync(), true);
    });
    
    test('widgets/ directory exists', () {
      expect(Directory('$libPath/widgets').existsSync(), true);
    });
    
    test('services/ directory exists', () {
      expect(Directory('$libPath/services').existsSync(), true);
    });
    
    test('navigation/ directory exists', () {
      expect(Directory('$libPath/navigation').existsSync(), true);
    });
    
    test('l10n/ directory exists', () {
      expect(Directory('$libPath/l10n').existsSync(), true);
    });
  });
}
```

2. Create `test/structure/import_verification_test.dart`:

```dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Import Resolution Tests', () {
    test('All dart files can be parsed', () {
      final files = _getAllDartFiles('lib');
      for (final file in files) {
        final content = File(file).readAsStringSync();
        // Extract imports
        final importRegex = RegExp(r"import\s+['\"]([^'\"]+)['\"]");
        final matches = importRegex.allMatches(content);
        // Verify no broken relative imports
        for (final match in matches) {
          final importPath = match.group(1)!;
          if (importPath.startsWith('../') || importPath.startsWith('./')) {
            expect(_pathExists(file, importPath), true,
                reason: 'Broken import in $file: $importPath');
          }
        }
      }
    });
  });
}
```

3. Create empty directories (will fail tests first):
```bash
mkdir -p lib/data lib/repositories lib/screens lib/view_models \
         lib/services lib/navigation lib/l10n
```

4. Run tests to verify they fail

**Success Criteria:**
- [ ] Tests fail (directories don't exist yet)
- [ ] Tests are meaningful (will pass when structure is correct)

**Risk Assessment:**
- **Low Risk** - Adding test files only

---

## Phase 2: Core Layer Consolidation

### Phase 2a: Move Services from core/ to lib/services/

**Requirements:**
- Functional: Move auth, notifications, audio, network services
- Non-functional: Keep design_tokens.dart, app_colors.dart, app_theme.dart in core/

**Files to Move:**
| Source | Target | Type |
|--------|--------|------|
| `lib/core/auth/auth_service.dart` | `lib/services/auth_service.dart` | Move |
| `lib/core/auth/disabled_auth_service.dart` | `lib/services/disabled_auth_service.dart` | Move |
| `lib/core/auth/token_provider.dart` | `lib/services/auth_provider.dart` | Move+Rename |
| `lib/core/notifications/*.dart` | `lib/services/notifications/` | Move dir |
| `lib/core/audio/*.dart` | `lib/services/audio_service.dart` | Move |
| `lib/core/network/api_client.dart` | `lib/services/api_client.dart` | Move |
| `lib/core/offline/*.dart` | `lib/services/offline_service.dart` | Move |
| `lib/core/config/app_config.dart` | `lib/services/config/app_config.dart` | Move |

**Files to KEEP in core/:**
| File | Reason |
|------|--------|
| `lib/core/design_tokens.dart` | Centralized design constants |
| `lib/core/theme/app_colors.dart` | Color definitions |
| `lib/core/theme/app_theme.dart` | Theme definitions |
| `lib/core/theme/theme_provider.dart` | Theme state |
| `lib/core/i18n/i18n_service.dart` | [Pending Phase 7] |

**CRITICAL: Update lib/core/providers.dart Imports (Gap 8)**
The `lib/core/providers.dart` file has relative imports that will break after services move:

1. Before Phase 2 completes, update `lib/core/providers.dart` imports:
```dart
// OLD (relative imports - will break)
import 'audio/audio_service.dart';
import 'auth/auth_service.dart';
import 'auth/token_provider.dart';

// NEW (package imports - maintain after move)
import 'package:deutschtiger/services/audio_service.dart';
import 'package:deutschtiger/services/auth_service.dart';
import 'package:deutschtiger/services/auth_provider.dart';
```

**Implementation Steps:**

1. **Write Test First (TDD):**
```dart
// test/structure/core_to_services_migration_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Services Migration', () {
    test('AuthService moved to services/', () {
      expect(File('lib/services/auth_service.dart').existsSync(), true);
    });
    
    test('NotificationService moved to services/', () {
      expect(Directory('lib/services/notifications').existsSync(), true);
    });
    
    test('ApiClient moved to services/', () {
      expect(File('lib/services/api_client.dart').existsSync(), true);
    });
    
    test('design_tokens.dart remains in core/', () {
      expect(File('lib/core/design_tokens.dart').existsSync(), true);
    });
  });
}
```

2. **Update providers.dart imports FIRST** (before moving files):
```bash
# Update to package imports before the services move
sed -i "s|import 'audio/audio_service.dart'|import 'package:deutschtiger/services/audio_service.dart'|g" lib/core/providers.dart
sed -i "s|import 'auth/auth_service.dart'|import 'package:deutschtiger/services/auth_service.dart'|g" lib/core/providers.dart
sed -i "s|import 'auth/token_provider.dart'|import 'package:deutschtiger/services/auth_provider.dart'|g" lib/core/providers.dart
```

3. Move files using git mv (preserves history):
```bash
git mv lib/core/auth/auth_service.dart lib/services/
git mv lib/core/auth/disabled_auth_service.dart lib/services/
git mv lib/core/auth/token_provider.dart lib/services/auth_provider.dart
git mv lib/core/notifications lib/services/
git mv lib/core/audio/audio_service.dart lib/services/
git mv lib/core/network/api_client.dart lib/services/
git mv lib/core/offline lib/services/
git mv lib/core/config lib/services/config/
```

4. Update barrel exports:
   - Create `lib/services/services.dart`:
```dart
export 'auth_service.dart';
export 'disabled_auth_service.dart';
export 'auth_provider.dart';
export 'notifications/notification_service.dart';
export 'notifications/notification_contract.dart';
export 'notifications/local_notification_service.dart';
export 'notifications/fcm_notification_service.dart';
export 'audio_service.dart';
export 'api_client.dart';
export 'offline/offline_service.dart';
export 'config/app_config.dart';
```

**Success Criteria:**
- [ ] All services moved to lib/services/
- [ ] design_tokens, colors, theme remain in lib/core/
- [ ] lib/core/providers.dart uses package imports
- [ ] Tests pass
- [ ] `flutter analyze` passes

**Rollback:**
```bash
git checkout HEAD -- lib/core/ lib/services/
```

**Risk Assessment:**
- **Medium Risk** - Import statements need updating
- **Mitigation:** Update providers.dart imports BEFORE moving services

---

## Phase 3: Data Layer (DTOs)

### Phase 3a: Create lib/data/ with DTOs

**Requirements:**
- Functional: Move DTOs from features/*/domain/ to lib/data/
- Non-functional: Each DTO file must have corresponding test

**DTO Files to Move:**
| Source | Target |
|--------|--------|
| `features/*/domain/*.dart` | `lib/data/{feature}/*.dart` |

**Existing DTOs (from domain directories):**
- `features/ai/domain/ai_models.dart`
- `features/ai_tutor/domain/ai_tutor_models.dart`
- `features/exam/domain/exam_models.dart`
- `features/flashcard/domain/review_item.dart`
- `features/home/domain/dashboard_data.dart` ⚠️ ADDED (Gap 3)
- `features/interview/domain/transcript_models.dart`
- `features/interview/domain/video_note.dart`
- `features/journey/domain/journey_models.dart`
- `features/listening/domain/podcast_models.dart`
- `features/social/domain/social_models.dart`
- `features/speaking/domain/speaking_models.dart`
- `features/stats/domain/stats_models.dart`
- `features/affiliate/domain/affiliate_models.dart`
- `features/decks/domain/deck_models.dart`
- `features/games/domain/game_models.dart`
- `features/grammar/domain/grammar_models.dart`
- `features/vocabulary_search/domain/vocab_models.dart` ⚠️ ADDED (Gap 4)

**NOTE on Generated Files (Q1 Resolution):**
- `.freezed.dart` and `.g.dart` files stay in original location after move
- Regenerate with `dart run build_runner build` after Phase 9
- This avoids breaking relative imports during transition

**Subdirectory Structure:**
```
lib/data/
├── auth/           # Auth-related DTOs
├── profile/        # Profile DTOs
├── settings/       # Settings DTOs
├── ai/             # AI feature DTOs
├── exam/           # Exam feature DTOs
├── flashcard/      # Flashcard DTOs
├── home/           # Dashboard DTOs (ADDED)
├── journey/        # Journey DTOs
├── listening/      # Listening DTOs
├── social/         # Social feature DTOs
├── speaking/       # Speaking DTOs
├── vocab/          # Vocabulary search DTOs (ADDED)
└── ...             # Other feature DTOs
```

**Implementation Steps:**

1. **Write Test First:**
```dart
// test/structure/data_layer_migration_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Data Layer Migration', () {
    test('lib/data/ai/ exists with models', () {
      expect(Directory('lib/data/ai').existsSync(), true);
    });
    
    test('lib/data/home/ exists with dashboard models', () {
      expect(Directory('lib/data/home').existsSync(), true);
    });
    
    test('lib/data/vocab/ exists with vocabulary models', () {
      expect(Directory('lib/data/vocab').existsSync(), true);
    });
    
    test('DTOs moved from features/*/domain/', () {
      // Original domain dirs should be empty or contain only imports
      final domainDir = Directory('lib/features/ai/domain');
      if (domainDir.existsSync()) {
        final files = domainDir.listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .where((f) => !f.path.endsWith('.freezed.dart'))
            .where((f) => !f.path.endsWith('.g.dart'));
        expect(files.isEmpty, true,
            reason: 'Non-generated files should be moved: ${files.map((f)=>f.path)}');
      }
    });
  });
}
```

2. Move DTO directories:
```bash
# Create data subdirectories
mkdir -p lib/data/{ai,exam,flashcard,home,journey,listening,social,speaking,stats,affiliate,decks,games,grammar,vocab}

# Move domain directories to data
git mv lib/features/ai/domain/* lib/data/ai/
git mv lib/features/ai_tutor/domain/* lib/data/ai/  # AI tutor uses same models
git mv lib/features/exam/domain/* lib/data/exam/
git mv lib/features/flashcard/domain/* lib/data/flashcard/
git mv lib/features/home/domain/* lib/data/home/  # ADDED - Gap 3
git mv lib/features/journey/domain/* lib/data/journey/
git mv lib/features/listening/domain/* lib/data/listening/
git mv lib/features/social/domain/* lib/data/social/
git mv lib/features/speaking/domain/* lib/data/speaking/
git mv lib/features/affiliate/domain/* lib/data/affiliate/
git mv lib/features/decks/domain/* lib/data/decks/
git mv lib/features/games/domain/* lib/data/games/
git mv lib/features/grammar/domain/* lib/data/grammar/
git mv lib/features/vocabulary_search/domain/* lib/data/vocab/  # ADDED - Gap 4
```

3. Remove empty domain directories:
```bash
find lib/features -type d -name domain -empty -delete
```

4. Create barrel exports:
```dart
// lib/data/data.dart
export 'ai/ai_models.dart';
export 'exam/exam_models.dart';
export 'flashcard/review_item.dart';
export 'home/dashboard_data.dart';
export 'vocab/vocab_models.dart';
// ... etc
```

**Success Criteria:**
- [ ] All DTOs moved to lib/data/
- [ ] Empty domain directories removed
- [ ] Tests pass
- [ ] `flutter analyze` passes

**Rollback:**
```bash
git checkout HEAD -- lib/features/ lib/data/
# NOTE: If domain directories were deleted, restore from previous commit
git checkout HEAD~1 -- lib/features/
```

**Risk Assessment:**
- **Medium Risk** - 15+ DTO files to move
- **Mitigation:** Batch move with glob pattern

---

## Phase 4: Repositories Layer

### Phase 4a: Consolidate Repositories

**Requirements:**
- Functional: Move repository implementations from features/*/data/ to lib/repositories/
- Non-functional: Keep repository interfaces alongside implementations

**Repository Files to Move:**
| Source | Target |
|--------|--------|
| `features/*/data/*_repository.dart` | `lib/repositories/{feature}/` |
| `features/*/data/mock_data.dart` | `lib/repositories/{feature}/` |
| `features/*/data/data.dart` | `lib/repositories/{feature}/` |

**Existing Repositories:**
- `features/ai_tutor/data/ai_tutor_repository.dart`
- `features/vocabulary_search/data/vocabulary_repository.dart`
- `features/vocabulary_search/data/vocab_notes_repository.dart` ⚠️ ADDED (Gap 4)
- `features/interview/data/video_notes_repository.dart`
- `features/interview/data/interview_repository.dart`
- `features/interview/data/transcript_service.dart` ⚠️ ADDED (Gap 5)
- `features/speaking/data/speaking_repository.dart`
- `features/listening/data/podcast_repository.dart`
- `features/ai/data/ai_repository.dart`
- `features/social/data/social_repository.dart`
- `features/flashcard/data/review_repository.dart`
- `features/decks/data/deck_repository.dart`
- `features/decks/data/data.dart`
- `features/journey/data/journey_repository.dart`
- `features/stats/data/stats_repository.dart`
- `features/exam/data/exam_repository.dart`
- `features/affiliate/data/affiliate_repository.dart`
- `features/home/data/dashboard_repository.dart`
- `core/identity/profile_repository.dart` ⚠️ ADDED (Gap 1)

**NOTE on lib/core/identity/ Directory (Gap 1):**
- `lib/core/identity/profile_repository.dart` → `lib/repositories/profile_repository.dart`
- `lib/core/identity/app_user.dart` → Keep in original location (no domain/ to move to)
- Delete empty `lib/core/identity/` directory after moves

**Subdirectory Structure:**
```
lib/repositories/
├── auth_repository.dart          # From core/identity/
├── profile_repository.dart       # From core/identity/
├── ai/
│   ├── ai_repository.dart
│   └── mock_data.dart
├── exam/
│   ├── exam_repository.dart
│   └── mock_data.dart
├── flashcard/
│   ├── review_repository.dart
│   └── mock_data.dart
├── journey/
│   ├── journey_repository.dart
│   └── mock_data.dart
├── listening/
│   ├── podcast_repository.dart
│   └── mock_data.dart
├── social/
│   ├── social_repository.dart
│   └── mock_data.dart
├── speaking/
│   ├── speaking_repository.dart
│   └── mock_data.dart
├── vocab/
│   ├── vocabulary_repository.dart    # ADDED - Gap 4
│   └── vocab_notes_repository.dart   # ADDED - Gap 4
└── ...
```

**Implementation Steps:**

1. **Write Test First:**
```dart
// test/structure/repositories_layer_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Repositories Layer Migration', () {
    test('lib/repositories/ai/ exists', () {
      expect(Directory('lib/repositories/ai').existsSync(), true);
    });
    
    test('lib/repositories/vocab/ exists', () {
      expect(Directory('lib/repositories/vocab').existsSync(), true);
    });
    
    test('lib/repositories/auth_repository.dart exists', () {
      expect(File('lib/repositories/auth_repository.dart').existsSync(), true);
    });
    
    test('lib/repositories/profile_repository.dart exists', () {
      expect(File('lib/repositories/profile_repository.dart').existsSync(), true);
    });
    
    test('lib/core/identity/ directory is empty or deleted', () {
      final identityDir = Directory('lib/core/identity');
      if (identityDir.existsSync()) {
        final files = identityDir.listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .where((f) => !f.path.endsWith('.freezed.dart'))
            .where((f) => !f.path.endsWith('.g.dart'));
        expect(files.isEmpty, true, reason: 'lib/core/identity/ should be empty');
      }
    });
    
    test('Original data/ directories emptied', () {
      final dataDirs = [
        'lib/features/ai/data',
        'lib/features/exam/data',
        'lib/features/flashcard/data',
        'lib/features/vocabulary_search/data',  # ADDED - Gap 4
      ];
      for (final dir in dataDirs) {
        if (Directory(dir).existsSync()) {
          final files = Directory(dir).listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.dart'))
              .where((f) => !f.path.endsWith('.freezed.dart'))
              .where((f) => !f.path.endsWith('.g.dart'));
          expect(files.isEmpty, true, reason: '$dir should be empty: $files');
        }
      }
    });
  });
}
```

2. Move repositories:
```bash
# Create repository subdirectories
mkdir -p lib/repositories/{ai,exam,flashcard,journey,listening,social,speaking,stats,affiliate,decks,home,interview,vocab}

# Move repositories
git mv lib/features/ai/data/* lib/repositories/ai/
git mv lib/features/ai_tutor/data/* lib/repositories/ai/
git mv lib/features/exam/data/* lib/repositories/exam/
git mv lib/features/flashcard/data/* lib/repositories/flashcard/
git mv lib/features/journey/data/* lib/repositories/journey/
git mv lib/features/listening/data/* lib/repositories/listening/
git mv lib/features/social/data/* lib/repositories/social/
git mv lib/features/speaking/data/* lib/repositories/speaking/
git mv lib/features/stats/data/* lib/repositories/stats/
git mv lib/features/affiliate/data/* lib/repositories/affiliate/
git mv lib/features/decks/data/* lib/repositories/decks/
git mv lib/features/home/data/* lib/repositories/home/
git mv lib/features/interview/data/* lib/repositories/interview/
git mv lib/features/vocabulary_search/data/* lib/repositories/vocab/  # ADDED - Gap 4

# Move from core/identity/ (Gap 1)
git mv lib/core/identity/profile_repository.dart lib/repositories/
rmdir lib/core/identity 2>/dev/null || true
```

3. Create barrel exports:
```dart
// lib/repositories/repositories.dart
export 'auth_repository.dart';
export 'profile_repository.dart';
export 'ai/ai_repository.dart';
export 'exam/exam_repository.dart';
export 'vocab/vocabulary_repository.dart';
export 'vocab/vocab_notes_repository.dart';
// ... etc
```

**Success Criteria:**
- [ ] All repositories moved to lib/repositories/
- [ ] Original data/ directories empty or removed
- [ ] lib/core/identity/ directory deleted
- [ ] Tests pass
- [ ] `flutter analyze` passes

**Rollback:**
```bash
git checkout HEAD -- lib/features/ lib/repositories/ lib/core/identity/
# NOTE: If directories were deleted, restore from previous commit
git checkout HEAD~1 -- lib/features/ lib/core/
```

**Risk Assessment:**
- **Medium Risk** - 17+ repository files
- **Mitigation:** Verify imports in Phase 9

---

## Phase 5: Screens & Widgets Flattening

**⚠️ SPLIT INTO SUB-PHASES** (Risk Mitigation from Validation Report)

This phase is high-risk due to many files. Splitting into sub-phases allows for:
- Easier rollback per sub-phase
- Better error isolation
- Clearer progress tracking

### Phase 5a: Screens Only

**Requirements:**
- Functional: Move screen/page widgets from features/*/presentation/ to lib/screens/
- Non-functional: Keep feature subdirectories for organization

**Screen Files to Move:**
| Source Pattern | Target |
|----------------|--------|
| `features/*/presentation/*_screen.dart` | `lib/screens/{feature}/*_screen.dart` |
| `features/*/presentation/*_page.dart` | `lib/screens/{feature}/*_page.dart` |

**Complete Feature List (including missing Gap 6 - webview):**
- `ai`, `ai_tutor`, `auth`, `exam`, `flashcard`, `games`, `home`, `interview`, `journey`, `listening`, `profile`, `settings`, `social`, `speaking`, `stats`, `affiliate`, `decks`, `grammar`, `legal`, `leaderboard`, `pronunciation`, `quiz`, `reminders`, `webview` ⚠️ ADDED

**Implementation Steps:**

1. **Write Test First:**
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
        'lib/features/webview/presentation',  # ADDED - Gap 6
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

2. Create screen subdirectories:
```bash
mkdir -p lib/screens/{ai,ai_tutor,auth,exam,flashcard,games,home,interview,journey,listening,profile,settings,social,speaking,stats,affiliate,decks,grammar,legal,leaderboard,pronunciation,quiz,reminders,webview}
```

3. Move screens:
```bash
# Move all presentation files
for feature in ai ai_tutor auth exam flashcard games home interview journey listening profile settings social speaking stats affiliate decks grammar legal leaderboard pronunciation quiz reminders webview; do
  if [ -d "lib/features/$feature/presentation" ]; then
    git mv lib/features/$feature/presentation/* lib/screens/$feature/ 2>/dev/null || true
  fi
done
```

4. Create barrel exports:
```dart
// lib/screens/screens.dart
export 'ai/ai_chat_page.dart';
export 'exam/exam_screen.dart';
export 'webview/webview_lesson_screen.dart';
// ... etc
```

**Success Criteria:**
- [ ] All screens moved to lib/screens/
- [ ] Presentation directories empty
- [ ] Tests pass

**Rollback:**
```bash
git checkout HEAD -- lib/features/ lib/screens/
```

---

### Phase 5b: Feature Widgets

**Requirements:**
- Functional: Move widgets from features/*/presentation/widgets/ and features/*/widgets/
- Non-functional: Keep feature-specific widgets in subdirectories

**Widget Directories to Move:**
| Source | Target |
|--------|--------|
| `features/*/widgets/*.dart` | `lib/widgets/{feature}/*.dart` |
| `features/*/presentation/widgets/*.dart` | `lib/widgets/{feature}/*.dart` |

**Complete Widget Directory List (Gap 2 fix):**
- `lib/features/ai/widgets/` → `lib/widgets/ai/`
- `lib/features/speaking/widgets/` → `lib/widgets/speaking/`
- `lib/features/flashcard/presentation/widgets/` → `lib/widgets/flashcard/` ⚠️ ADDED
- `lib/features/ai_tutor/presentation/widgets/` → `lib/widgets/ai_tutor/` ⚠️ ADDED

**Implementation Steps:**

1. **Write Test First:**
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

2. Move widgets:
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

**Success Criteria:**
- [ ] All feature widgets consolidated in lib/widgets/
- [ ] Original widget directories empty or removed
- [ ] Tests pass

**Rollback:**
```bash
git checkout HEAD -- lib/features/ lib/widgets/
```

---

### Phase 5c: Shared Widgets

**Requirements:**
- Functional: Move widgets from lib/shared/widgets/ to lib/widgets/common/
- Non-functional: Verify no other lib/shared/ subdirectories exist

**Implementation Steps:**

1. **Write Test First:**
```dart
// test/structure/shared_widgets_test.dart
test('lib/widgets/common/ exists', () {
  expect(Directory('lib/widgets/common').existsSync(), true);
});

test('shared/widgets/ moved', () {
  expect(Directory('lib/shared/widgets').existsSync(), false);
});
```

2. Move shared widgets:
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

3. Create barrel exports:
```dart
// lib/widgets/widgets.dart
export 'common/app_shell.dart';
export 'common/auth_card.dart';
export 'common/tiger_logo.dart';
// ... etc
```

**Success Criteria:**
- [ ] All shared widgets in lib/widgets/common/
- [ ] lib/shared/ deleted
- [ ] Tests pass

**Rollback:**
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

---

## Phase 6: ViewModels Layer

### Phase 6a: Consolidate Providers to ViewModels

**Requirements:**
- Functional: Move *provider.dart files to lib/view_models/
- Non-functional: Maintain Riverpod provider pattern

**Provider Files to Move:**
| Source | Target |
|--------|--------|
| `features/*/presentation/*_provider.dart` | `lib/view_models/{feature}/*_provider.dart` |
| `core/theme/theme_provider.dart` | `lib/view_models/theme_provider.dart` |
| `core/preferences/preferences_provider.dart` | `lib/view_models/preferences_provider.dart` |
| `core/providers.dart` | `lib/view_models/providers.dart` |

**Existing Provider Files:**
- `features/flashcard/presentation/review_provider.dart`
- `features/decks/presentation/deck_provider.dart`
- `features/ai_tutor/presentation/ai_tutor_provider.dart`
- `features/exam/presentation/exam_provider.dart`
- `core/theme/theme_provider.dart`
- `core/providers.dart`
- `features/interview/presentation/video_note_provider.dart`
- `features/speaking/presentation/speaking_provider.dart`
- `features/affiliate/presentation/affiliate_provider.dart`
- `features/interview/presentation/transcript_provider.dart`
- `features/vocabulary_search/presentation/vocab_search_provider.dart`
- `features/ai/presentation/ai_provider.dart`
- `features/home/presentation/home_provider.dart`
- `features/listening/presentation/podcast_provider.dart`
- `core/preferences/preferences_provider.dart`
- `features/journey/presentation/journey_provider.dart`
- `features/social/presentation/social_provider.dart`
- `features/stats/presentation/stats_provider.dart`
- `features/interview/presentation/interview_provider.dart`

**Implementation Steps:**

1. **Write Test First:**
```dart
// test/structure/view_models_layer_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ViewModels Layer Migration', () {
    test('lib/view_models/providers.dart exists', () {
      expect(File('lib/view_models/providers.dart').existsSync(), true);
    });
    
    test('lib/view_models/theme_provider.dart exists', () {
      expect(File('lib/view_models/theme_provider.dart').existsSync(), true);
    });
    
    test('Feature providers in subdirectories', () {
      expect(Directory('lib/view_models/ai').existsSync(), true);
      expect(Directory('lib/view_models/exam').existsSync(), true);
    });
  });
}
```

2. Create view_models subdirectories:
```bash
mkdir -p lib/view_models/{ai,ai_tutor,auth,decks,exam,flashcard,home,interview,journey,listening,profile,quiz,settings,social,speaking,stats,affiliate}
```

3. Move providers:
```bash
# Move core providers
git mv lib/core/providers.dart lib/view_models/
git mv lib/core/theme/theme_provider.dart lib/view_models/
git mv lib/core/preferences/preferences_provider.dart lib/view_models/

# Move feature providers
git mv lib/features/ai/presentation/ai_provider.dart lib/view_models/ai/
git mv lib/features/ai_tutor/presentation/ai_tutor_provider.dart lib/view_models/ai_tutor/
git mv lib/features/decks/presentation/deck_provider.dart lib/view_models/decks/
git mv lib/features/exam/presentation/exam_provider.dart lib/view_models/exam/
git mv lib/features/flashcard/presentation/review_provider.dart lib/view_models/flashcard/
git mv lib/features/home/presentation/home_provider.dart lib/view_models/home/
git mv lib/features/interview/presentation/video_note_provider.dart lib/view_models/interview/
git mv lib/features/interview/presentation/transcript_provider.dart lib/view_models/interview/
git mv lib/features/interview/presentation/interview_provider.dart lib/view_models/interview/
git mv lib/features/journey/presentation/journey_provider.dart lib/view_models/journey/
git mv lib/features/listening/presentation/podcast_provider.dart lib/view_models/listening/
git mv lib/features/speaking/presentation/speaking_provider.dart lib/view_models/speaking/
git mv lib/features/social/presentation/social_provider.dart lib/view_models/social/
git mv lib/features/stats/presentation/stats_provider.dart lib/view_models/stats/
git mv lib/features/affiliate/presentation/affiliate_provider.dart lib/view_models/affiliate/
```

4. Create barrel exports:
```dart
// lib/view_models/view_models.dart
export 'providers.dart';
export 'theme_provider.dart';
export 'preferences_provider.dart';
export 'ai/ai_provider.dart';
export 'exam/exam_provider.dart';
// ... etc
```

**Success Criteria:**
- [ ] All providers moved to lib/view_models/
- [ ] Original provider locations updated
- [ ] Tests pass

**Rollback:**
```bash
git checkout HEAD -- lib/features/ lib/view_models/ lib/core/
# NOTE: If directories were deleted, restore from previous commit
git checkout HEAD~1 -- lib/features/ lib/core/
```

**Risk Assessment:**
- **Medium Risk** - 16+ provider files + providers.dart
- **Mitigation:** Verify imports in Phase 9

---

## Phase 7: L10n Layer

### Phase 7a: Migrate i18n to l10n

**Requirements:**
- Functional: Move lib/core/i18n/ to lib/l10n/
- Non-functional: Use flutter_localizations pattern

**Implementation Steps:**

1. **Write Test First:**
```dart
// test/structure/l10n_layer_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('L10n Layer Migration', () {
    test('lib/l10n/ directory exists', () {
      expect(Directory('lib/l10n').existsSync(), true);
    });
    
    test('i18n_service moved to l10n/', () {
      expect(File('lib/l10n/i18n_service.dart').existsSync(), true);
    });
    
    test('lib/core/i18n/ removed', () {
      expect(Directory('lib/core/i18n').existsSync(), false);
    });
  });
}
```

2. Move i18n:
```bash
git mv lib/core/i18n lib/l10n/
```

**Success Criteria:**
- [ ] i18n moved to l10n
- [ ] Tests pass

**Rollback:**
```bash
git checkout HEAD -- lib/l10n/ lib/core/
# NOTE: If directories were deleted, restore from previous commit
git checkout HEAD~1 -- lib/core/
```

---

## Phase 8: Navigation Layer

### Phase 8a: Create Navigation Controller

**Requirements:**
- Functional: Move lib/core/router/app_router.dart to lib/navigation/
- Non-functional: Keep router pattern

**Implementation Steps:**

1. **Write Test First:**
```dart
// test/structure/navigation_layer_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Navigation Layer Migration', () {
    test('lib/navigation/ directory exists', () {
      expect(Directory('lib/navigation').existsSync(), true);
    });
    
    test('app_router.dart moved to navigation/', () {
      expect(File('lib/navigation/app_router.dart').existsSync(), true);
    });
    
    test('lib/core/router/ removed', () {
      expect(Directory('lib/core/router').existsSync(), false);
    });
  });
}
```

2. Move router:
```bash
git mv lib/core/router/app_router.dart lib/navigation/
rmdir lib/core/router 2>/dev/null || true
```

**Success Criteria:**
- [ ] Router moved to lib/navigation/
- [ ] Tests pass

**Rollback:**
```bash
git checkout HEAD -- lib/navigation/ lib/core/router/
# NOTE: If directories were deleted, restore from previous commit
git checkout HEAD~1 -- lib/core/
```

---

## Phase 9: Fix All Imports

**⚠️ HIGH RISK PHASE - Use Regex Patterns (Risk Mitigation from Validation Report)**

### Phase 9a: Automated Import Updates

**Requirements:**
- Functional: Update all import statements to new paths
- Non-functional: Use package imports for cross-module, regex patterns for robustness

**⚠️ CRITICAL: Use `dart fix --apply` + Manual Verification**

Do NOT use raw string replacement. Use these methods in order:

1. `dart fix --apply` for common patterns
2. Regex-based migration script (see below)
3. Manual fixes for edge cases

**Implementation Steps:**

### 9.1: Use dart fix First
```bash
# Let dart fix handle simple import rewrites
dart fix --apply lib/
```

### 9.2: Create Regex-Based Migration Script

```dart
// scripts/update_imports.dart
import 'dart:io';

void main() async {
  // Regex patterns for migration (more robust than exact strings)
  final mappings = [
    // Services (Phase 2)
    (RegExp(r"import\s+'package:deutschtiger/core/auth/auth_service\.dart'"),
     "import 'package:deutschtiger/services/auth_service.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/auth/disabled_auth_service\.dart'"),
     "import 'package:deutschtiger/services/disabled_auth_service.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/auth/token_provider\.dart'"),
     "import 'package:deutschtiger/services/auth_provider.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/notifications/([^']+)\.dart'"),
     "import 'package:deutschtiger/services/notifications/\$1.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/audio/audio_service\.dart'"),
     "import 'package:deutschtiger/services/audio_service.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/network/api_client\.dart'"),
     "import 'package:deutschtiger/services/api_client.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/offline/([^']+)\.dart'"),
     "import 'package:deutschtiger/services/offline/\$1.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/config/([^']+)\.dart'"),
     "import 'package:deutschtiger/services/config/\$1.dart'"),

    // Data (Phase 3)
    (RegExp(r"import\s+'package:deutschtiger/features/(\w+)/domain/([^']+)\.dart'"),
     "import 'package:deutschtiger/data/\$1/\$2.dart'"),

    // Repositories (Phase 4)
    (RegExp(r"import\s+'package:deutschtiger/features/(\w+)/data/([^']+)\.dart'"),
     "import 'package:deutschtiger/repositories/\$1/\$2.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/identity/profile_repository\.dart'"),
     "import 'package:deutschtiger/repositories/profile_repository.dart'"),

    // Screens (Phase 5)
    (RegExp(r"import\s+'package:deutschtiger/features/(\w+)/presentation/([^']+)\.dart'"),
     "import 'package:deutschtiger/screens/\$1/\$2.dart'"),

    // Widgets (Phase 5)
    (RegExp(r"import\s+'package:deutschtiger/shared/widgets/([^']+)\.dart'"),
     "import 'package:deutschtiger/widgets/common/\$1.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/features/(\w+)/widgets/([^']+)\.dart'"),
     "import 'package:deutschtiger/widgets/\$1/\$2.dart'"),

    // ViewModels (Phase 6)
    (RegExp(r"import\s+'package:deutschtiger/core/providers\.dart'"),
     "import 'package:deutschtiger/view_models/providers.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/theme/theme_provider\.dart'"),
     "import 'package:deutschtiger/view_models/theme_provider.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/preferences/preferences_provider\.dart'"),
     "import 'package:deutschtiger/view_models/preferences_provider.dart'"),

    // L10n (Phase 7)
    (RegExp(r"import\s+'package:deutschtiger/core/i18n/([^']+)\.dart'"),
     "import 'package:deutschtiger/l10n/\$1.dart'"),

    // Navigation (Phase 8)
    (RegExp(r"import\s+'package:deutschtiger/core/router/app_router\.dart'"),
     "import 'package:deutschtiger/navigation/app_router.dart'"),
  ];

  final dir = Directory('lib');
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      var content = entity.readAsStringSync();
      for (final (pattern, replacement) in mappings) {
        content = content.replaceAllMapped(pattern, (m) => replacement);
      }
      entity.writeAsStringSync(content);
    }
  }
}
```

### 9.3: Run Migration Script
```bash
dart run scripts/update_imports.dart
```

### 9.4: Manual Fixes with flutter analyze
```bash
flutter analyze 2>&1 | grep "not found" | head -50
# Fix each error manually
```

### 9.5: Verify with pub get
```bash
flutter pub get
```

### 9.6: Add Import Chain Tests
```dart
// test/structure/import_chain_test.dart
test('All package imports resolve', () {
  final dir = Directory('lib');
  final errors = <String>[];
  
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = entity.readAsStringSync();
      final importRegex = RegExp(r"import\s+'package:deutschtiger/([^']+)\.dart'");
      final matches = importRegex.allMatches(content);
      
      for (final match in matches) {
        final importPath = match.group(1)!;
        final fullPath = '${entity.parent.path}/$importPath.dart';
        final importFile = File(fullPath);
        
        if (!importFile.existsSync()) {
          errors.add('${entity.path}: ${match.group(0)} -> $fullPath not found');
        }
      }
    }
  }
  
  expect(errors.isEmpty, true, reason: 'Import errors: ${errors.join("\n")}');
});
```

**Success Criteria:**
- [ ] `flutter analyze` shows 0 errors
- [ ] All imports resolve correctly
- [ ] `flutter pub get` succeeds
- [ ] Import chain tests pass

**Rollback:**
```bash
git checkout HEAD -- lib/
# NOTE: If Phase 9 breaks everything, restore from Phase 8 commit
git checkout HEAD~9 -- lib/
```

---

## Phase 10: Verification

### Phase 10a: Full Verification

**Requirements:**
- Functional: All tests pass, analyze clean
- Non-functional: Manual smoke test completes

**Implementation Steps:**

1. Run full test suite:
```bash
flutter test --reporter expanded > test_results.txt 2>&1
```

2. Run analyze:
```bash
flutter analyze > analyze_results.txt 2>&1
```

3. Manual smoke test:
   - [ ] App builds without errors
   - [ ] Auth flow works
   - [ ] Navigation works
   - [ ] Settings accessible

4. Regenerate Freezed files (Q1 Resolution):
```bash
dart run build_runner build --delete-conflicting-outputs
```

5. Cleanup empty lib/features/ (Q2 Resolution):
```bash
# Only after all verifications pass
find lib/features -type d -empty -delete 2>/dev/null || true
rmdir lib/features 2>/dev/null || true
```

**Success Criteria:**
- [ ] `flutter test` all pass
- [ ] `flutter analyze` 0 errors
- [ ] Manual smoke test complete
- [ ] Freezed files regenerated
- [ ] `lib/features/` cleaned up

**Rollback:**
```bash
git checkout HEAD -- lib/
# If Phase 10 cleanup broke things, restore from Phase 9 commit
git checkout HEAD~1 -- lib/
# If features directory was deleted, restore entirely
git checkout HEAD~10 -- lib/features/
```

---

## Summary

| Phase | Name | Effort | Risk |
|-------|------|--------|------|
| 1 | Baseline & Preparation | 1h | Low |
| 2 | Core Layer (Services) | 2h | Medium |
| 3 | Data Layer (DTOs) | 3h | Medium |
| 4 | Repositories Layer | 2h | Medium |
| 5a | Screens Flattening | 1.5h | High |
| 5b | Feature Widgets | 1h | High |
| 5c | Shared Widgets | 0.5h | Medium |
| 6 | ViewModels | 2h | Medium |
| 7 | L10n | 1h | Low |
| 8 | Navigation | 1h | Low |
| 9 | Fix Imports | 4h | High |
| 10 | Verification | 2h | Low |
| **Total** | | **20h** | |

**Critical Path:** Phase 1 → 2 → 3 → 4 → 5a → 5b → 5c → 6 → 7 → 8 → 9 → 10

**Parallel Phases:** None recommended due to import dependencies

---

## Resolved Questions (from Validation Report)

All open questions from the validation report have been resolved:

| ID | Question | Resolution |
|----|----------|------------|
| Q1 | Generated files (.freezed.dart, .g.dart) | Keep in original location, regenerate post-Phase 9 |
| Q2 | lib/features/ directory | Keep empty for rollback, delete after Phase 10 |
| Q3 | Barrel exports | Maintain for backward compatibility |
| Q4 | Feature subdirs in lib/screens/ | Keep subdirs (matches reference) |
| Q5 | lib/core/ cleanup | Keep as lib/core/ (matches reference) |
| Q6 | Widget categorization | Feature subdirs (lib/widgets/ai/) |
| Q7 | lib/shared/ directory | Move widgets to lib/widgets/common/, delete empty parent |
| Q8 | providers.dart imports | Update in Phase 2 before services move |

---

## References

- Reference repo structure: `/home/qwm/Desktop/flutter-accelerator-ai`
- Current baseline analysis: `baseline_analysis.txt`
- Current test results: `baseline_test_results.txt`
- Validation report: `plans/bigbang-restructure/validation-report.md`
