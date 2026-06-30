import 'dart:io';

void main() async {
  // Comprehensive import mappings for the big bang restructure
  final mappings = <(RegExp, String)>[
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
    (RegExp(r"import\s+'package:Deutschtiger/features/ai/domain/ai_models\.dart'"),
     "import 'package:Deutschtiger/data/ai/ai_models.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/features/ai/domain/ai_models\.dart'"),
     "import 'package:deutschtiger/data/ai/ai_models.dart'"),
    (RegExp(r"import\s+'package:Deutschtiger/features/(\w+)/domain/([^']+)\.dart'"),
     "import 'package:Deutschtiger/data/\$1/\$2.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/features/(\w+)/domain/([^']+)\.dart'"),
     "import 'package:deutschtiger/data/\$1/\$2.dart'"),

    // Repositories (Phase 4)
    (RegExp(r"import\s+'package:Deutschtiger/features/(\w+)/data/([^']+)\.dart'"),
     "import 'package:Deutschtiger/repositories/\$1/\$2.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/features/(\w+)/data/([^']+)\.dart'"),
     "import 'package:deutschtiger/repositories/\$1/\$2.dart'"),
    (RegExp(r"import\s+'package:Deutschtiger/core/identity/profile_repository\.dart'"),
     "import 'package:Deutschtiger/repositories/profile_repository.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/identity/profile_repository\.dart'"),
     "import 'package:deutschtiger/repositories/profile_repository.dart'"),

    // Screens (Phase 5)
    (RegExp(r"import\s+'package:Deutschtiger/features/(\w+)/presentation/([^']+)\.dart'"),
     "import 'package:Deutschtiger/screens/\$1/\$2.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/features/(\w+)/presentation/([^']+)\.dart'"),
     "import 'package:deutschtiger/screens/\$1/\$2.dart'"),

    // Widgets (Phase 5)
    (RegExp(r"import\s+'package:Deutschtiger/shared/widgets/([^']+)\.dart'"),
     "import 'package:Deutschtiger/widgets/common/\$1.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/shared/widgets/([^']+)\.dart'"),
     "import 'package:deutschtiger/widgets/common/\$1.dart'"),
    (RegExp(r"import\s+'package:Deutschtiger/features/(\w+)/widgets/([^']+)\.dart'"),
     "import 'package:Deutschtiger/widgets/\$1/\$2.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/features/(\w+)/widgets/([^']+)\.dart'"),
     "import 'package:deutschtiger/widgets/\$1/\$2.dart'"),

    // ViewModels (Phase 6)
    (RegExp(r"import\s+'package:Deutschtiger/core/providers\.dart'"),
     "import 'package:Deutschtiger/view_models/providers.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/providers\.dart'"),
     "import 'package:deutschtiger/view_models/providers.dart'"),
    (RegExp(r"import\s+'package:Deutschtiger/core/theme/theme_provider\.dart'"),
     "import 'package:Deutschtiger/view_models/theme_provider.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/theme/theme_provider\.dart'"),
     "import 'package:deutschtiger/view_models/theme_provider.dart'"),
    (RegExp(r"import\s+'package:Deutschtiger/core/preferences/preferences_provider\.dart'"),
     "import 'package:Deutschtiger/view_models/preferences_provider.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/preferences/preferences_provider\.dart'"),
     "import 'package:deutschtiger/view_models/preferences_provider.dart'"),

    // L10n (Phase 7)
    (RegExp(r"import\s+'package:Deutschtiger/core/i18n/([^']+)\.dart'"),
     "import 'package:Deutschtiger/l10n/\$1.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/i18n/([^']+)\.dart'"),
     "import 'package:deutschtiger/l10n/\$1.dart'"),

    // Navigation (Phase 8)
    (RegExp(r"import\s+'package:Deutschtiger/core/router/app_router\.dart'"),
     "import 'package:Deutschtiger/navigation/app_router.dart'"),
    (RegExp(r"import\s+'package:deutschtiger/core/router/app_router\.dart'"),
     "import 'package:deutschtiger/navigation/app_router.dart'"),
  ];

  int filesModified = 0;
  int totalChanges = 0;

  final libDir = Directory('lib');
  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      var content = entity.readAsStringSync();
      var originalContent = content;
      int fileChanges = 0;

      for (final (pattern, replacement) in mappings) {
        if (pattern.hasMatch(content)) {
          content = content.replaceAllMapped(pattern, (m) {
            fileChanges++;
            return replacement;
          });
        }
      }

      if (content != originalContent) {
        entity.writeAsStringSync(content);
        filesModified++;
        totalChanges += fileChanges;
        print('Modified: ${entity.path} ($fileChanges changes)');
      }
    }
  }

  print('\n=== Summary ===');
  print('Files modified: $filesModified');
  print('Total changes: $totalChanges');
}
