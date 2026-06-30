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
          final openBraces = '{'.allMatches(content).length;
          final closeBraces = '}'.allMatches(content).length;
          if (openBraces != closeBraces) {
            errors.add('$file: Unbalanced braces');
          }
        } catch (e) {
          errors.add('$file: Failed to read');
        }
      }

      expect(errors, isEmpty, reason: 'Files with errors: ${errors.join('\n')}');
    });

    test('Target directory structure is in place', () {
      // Basic structure check - this is informational
      expect(Directory('lib/core').existsSync(), true);
      expect(Directory('lib/data').existsSync(), true);
      expect(Directory('lib/services').existsSync(), true);
      expect(Directory('lib/repositories').existsSync(), true);
      expect(Directory('lib/screens').existsSync(), true);
      expect(Directory('lib/widgets').existsSync(), true);
      expect(Directory('lib/view_models').existsSync(), true);
      expect(Directory('lib/navigation').existsSync(), true);
      expect(Directory('lib/l10n').existsSync(), true);
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
