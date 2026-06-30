import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Import Resolution Tests', () {
    test('All dart files can be parsed without errors', () {
      final files = _getAllDartFiles('lib');
      final errors = <String>[];

      for (final file in files) {
        try {
          final content = File(file).readAsStringSync();
          // Basic syntax check - look for unbalanced braces/parens
          final openBraces = '{'.allMatches(content).length;
          final closeBraces = '}'.allMatches(content).length;
          if (openBraces != closeBraces) {
            errors.add('$file: Unbalanced braces ($openBraces open, $closeBraces close)');
          }
        } catch (e) {
          errors.add('$file: Failed to read - $e');
        }
      }

      expect(errors, isEmpty, reason: 'Files with errors: ${errors.join('\n')}');
    });

    test('All package imports reference existing paths', () {
      final files = _getAllDartFiles('lib');
      final errors = <String>[];

      for (final file in files) {
        final content = File(file).readAsStringSync();
        final importRegex = RegExp(r"import\s+['\""]([^'\"]+)['\"']");
        final matches = importRegex.allMatches(content);

        for (final match in matches) {
          final importPath = match.group(1)!;

          // Skip external packages
          if (importPath.startsWith('package:flutter') ||
              importPath.startsWith('package:flutter_riverpod') ||
              importPath.startsWith('package:supabase') ||
              importPath.startsWith('package:go_router') ||
              importPath.startsWith('dart:')) {
            continue;
          }

          // Check package imports
          if (importPath.startsWith('package:deutschtiger/')) {
            final relativePath = importPath.replaceFirst('package:deutschtiger/', '');
            final resolvedPath = 'lib/$relativePath';

            if (!File(resolvedPath).existsSync() && !Directory(resolvedPath).existsSync()) {
              errors.add('$file -> $resolvedPath not found');
            }
          }
        }
      }

      // We expect this test to fail before migration is complete
      // It will pass once all imports are fixed in Phase 9
      expect(
        errors.isEmpty,
        true,
        reason: 'Broken imports found:\n${errors.take(20).join('\n')}${errors.length > 20 ? '\n... and ${errors.length - 20} more' : ''}',
      );
    });
  });
}

List<String> _getAllDartFiles(String directory) {
  final dir = Directory(directory);
  final files = <String>[];

  if (!dir.existsSync()) return files;

  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      files.add(entity.path);
    }
  }

  return files;
}
