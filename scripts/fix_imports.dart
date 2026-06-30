import 'dart:io';

void main() async {
  int filesModified = 0;
  int totalChanges = 0;

  final libDir = Directory('lib');

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      var content = entity.readAsStringSync();
      var originalContent = content;
      int fileChanges = 0;

      // Fix relative imports from features to data
      // features/*/domain/* -> ../../../data/*/
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*features/(\w+)/domain/([^']+)'\.dart"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/data/${m.group(1)}/${m.group(2)}.dart'";
        },
      );

      // Fix relative imports from features to repositories
      // features/*/data/* -> ../../../repositories/*/
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*features/(\w+)/data/([^']+)'\.dart"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/repositories/${m.group(1)}/${m.group(2)}.dart'";
        },
      );

      // Fix relative imports from features to presentation
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*features/(\w+)/presentation/([^']+)'\.dart"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/screens/${m.group(1)}/${m.group(2)}.dart'";
        },
      );

      // Fix relative imports from features to widgets
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*features/(\w+)/widgets/([^']+)'\.dart"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/widgets/${m.group(1)}/${m.group(2)}.dart'";
        },
      );

      // Fix relative imports from screens/*/widgets to widgets
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*screens/(\w+)/widgets/([^']+)'\.dart"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/widgets/${m.group(1)}/${m.group(2)}.dart'";
        },
      );

      // Fix core imports - services
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/auth/auth_service\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/services/auth_service.dart'";
        },
      );
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/auth/disabled_auth_service\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/services/disabled_auth_service.dart'";
        },
      );
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/auth/token_provider\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/services/auth_provider.dart'";
        },
      );
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/audio/audio_service\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/services/audio_service.dart'";
        },
      );
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/network/api_client\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/services/api_client.dart'";
        },
      );
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/config/([^']+)\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/services/config/${m.group(1)}.dart'";
        },
      );
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/notifications/([^']+)\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/services/notifications/${m.group(1)}.dart'";
        },
      );
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/offline/([^']+)\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/services/offline/${m.group(1)}.dart'";
        },
      );

      // Fix core router and providers
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/router/app_router\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/navigation/app_router.dart'";
        },
      );
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/providers\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/view_models/providers.dart'";
        },
      );
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/theme/theme_provider\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/view_models/theme_provider.dart'";
        },
      );
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/preferences/preferences_provider\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/view_models/preferences_provider.dart'";
        },
      );

      // Fix i18n to l10n
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/i18n/([^']+)\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/l10n/${m.group(1)}.dart'";
        },
      );

      // Fix identity imports
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*core/identity/profile_repository\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/repositories/profile_repository.dart'";
        },
      );

      // Fix shared/widgets imports
      content = content.replaceAllMapped(
        RegExp(r"import\s+'[^']*shared/widgets/([^']+)\.dart'"),
        (m) {
          fileChanges++;
          return "import 'package:deutschtiger/widgets/common/${m.group(1)}.dart'";
        },
      );

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
