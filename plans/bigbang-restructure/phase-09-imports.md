---
phase: 9
title: "Fix All Imports"
status: pending
priority: P1
effort: 4h
dependencies: [phase-08-navigation]
---

# Phase 9: Fix All Imports

**⚠️ HIGH RISK PHASE - Use Regex Patterns (Risk Mitigation from Validation Report)**

## Overview
Update all import statements to reflect new file locations using package imports.

## Requirements
- Functional: All imports resolve correctly
- Non-functional: Use package imports for cross-module, regex patterns for robustness

## ⚠️ CRITICAL: Migration Method

**Do NOT use raw string replacement.** Use these methods in order:

1. `dart fix --apply` for common patterns
2. Regex-based migration script (see below)
3. Manual fixes for edge cases

## Import Mappings

### Services (Phase 2)
| Old Import | New Import |
|------------|------------|
| `package:deutschtiger/core/auth/auth_service.dart` | `package:deutschtiger/services/auth_service.dart` |
| `package:deutschtiger/core/auth/disabled_auth_service.dart` | `package:deutschtiger/services/disabled_auth_service.dart` |
| `package:deutschtiger/core/auth/token_provider.dart` | `package:deutschtiger/services/auth_provider.dart` |
| `package:deutschtiger/core/notifications/*.dart` | `package:deutschtiger/services/notifications/*.dart` |
| `package:deutschtiger/core/audio/audio_service.dart` | `package:deutschtiger/services/audio_service.dart` |
| `package:deutschtiger/core/network/api_client.dart` | `package:deutschtiger/services/api_client.dart` |
| `package:deutschtiger/core/offline/*.dart` | `package:Deutschtiger/services/offline/*.dart` |
| `package:deutschtiger/core/config/app_config.dart` | `package:deutschtiger/services/config/app_config.dart` |

### Data (Phase 3)
| Old Import | New Import |
|------------|------------|
| `package:deutschtiger/features/ai/domain/*.dart` | `package:deutschtiger/data/ai/*.dart` |
| `package:deutschtiger/features/exam/domain/*.dart` | `package:deutschtiger/data/exam/*.dart` |
| `package:deutschtiger/features/home/domain/*.dart` | `package:deutschtiger/data/home/*.dart` |
| `package:deutschtiger/features/vocabulary_search/domain/*.dart` | `package:deutschtiger/data/vocab/*.dart` |
| ... | ... |

### Repositories (Phase 4)
| Old Import | New Import |
|------------|------------|
| `package:deutschtiger/features/ai/data/*.dart` | `package:deutschtiger/repositories/ai/*.dart` |
| `package:deutschtiger/features/vocabulary_search/data/*.dart` | `package:deutschtiger/repositories/vocab/*.dart` |
| `package:deutschtiger/core/identity/profile_repository.dart` | `package:deutschtiger/repositories/profile_repository.dart` |
| ... | ... |

### Screens (Phase 5)
| Old Import | New Import |
|------------|------------|
| `package:deutschtiger/features/ai/presentation/*.dart` | `package:deutschtiger/screens/ai/*.dart` |
| `package:deutschtiger/features/webview/presentation/*.dart` | `package:deutschtiger/screens/webview/*.dart` |
| ... | ... |

### Widgets (Phase 5)
| Old Import | New Import |
|------------|------------|
| `package:deutschtiger/shared/widgets/*.dart` | `package:deutschtiger/widgets/common/*.dart` |
| `package:deutschtiger/features/ai/widgets/*.dart` | `package:deutschtiger/widgets/ai/*.dart` |
| `package:deutschtiger/features/flashcard/presentation/widgets/*.dart` | `package:deutschtiger/widgets/flashcard/*.dart` |
| ... | ... |

### ViewModels (Phase 6)
| Old Import | New Import |
|------------|------------|
| `package:deutschtiger/core/providers.dart` | `package:deutschtiger/view_models/providers.dart` |
| `package:deutschtiger/features/ai/presentation/*_provider.dart` | `package:deutschtiger/view_models/ai/*_provider.dart` |
| ... | ... |

### L10n (Phase 7)
| Old Import | New Import |
|------------|------------|
| `package:deutschtiger/core/i18n/*.dart` | `package:deutschtiger/l10n/*.dart` |

### Navigation (Phase 8)
| Old Import | New Import |
|------------|------------|
| `package:deutschtiger/core/router/app_router.dart` | `package:deutschtiger/navigation/app_router.dart` |

## Implementation Steps

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
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('All package imports resolve', () {
    final dir = Directory('lib');
    final errors = <String>[];
    
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final content = entity.readAsStringSync();
        final importRegex = RegExp(r"import\s+'package:deutschtiger/([^']+)\.dart'");
        final matches = importRegex.allMatches(content);
        
        for (final match in matches) {
          final importPath = match.group(1)!;
          // Check if the imported file exists
          final possiblePaths = [
            'lib/$importPath.dart',
            'lib/$importPath',
          ];
          
          final exists = possiblePaths.any((p) => File(p).existsSync());
          if (!exists) {
            errors.add('${entity.path}: ${match.group(0)} -> $importPath not found');
          }
        }
      }
    }
    
    expect(errors.isEmpty, true, reason: 'Import errors:\n${errors.join("\n")}');
  });
}
```

## Success Criteria
- [ ] `flutter analyze` shows 0 errors
- [ ] All imports resolve correctly
- [ ] `flutter pub get` succeeds
- [ ] Import chain tests pass

## Rollback
```bash
git checkout HEAD -- lib/
# NOTE: If Phase 9 breaks everything, restore from Phase 8 commit
git checkout HEAD~1 -- lib/
```

## Risk Assessment
- **Risk:** High - Many files need import updates
- **Mitigation:** Use regex patterns + manual verification approach

## Open Questions
- Auto-generate migration script from file moves?
