import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Screens Layer Migration', () {
    test('lib/screens/ai/ exists', () {
      expect(Directory('lib/screens/ai').existsSync(), true);
    });

    test('lib/screens/exam/ exists', () {
      expect(Directory('lib/screens/exam').existsSync(), true);
    });

    test('lib/screens/home/ exists', () {
      expect(Directory('lib/screens/home').existsSync(), true);
    });

    test('lib/screens/webview/ exists', () {
      expect(Directory('lib/screens/webview').existsSync(), true);
    });

    test('Presentation directories emptied', () {
      final presentationDirs = [
        'lib/features/ai/presentation',
        'lib/features/exam/presentation',
        'lib/features/home/presentation',
        'lib/features/webview/presentation',
      ];
      final errors = <String>[];
      for (final dir in presentationDirs) {
        if (Directory(dir).existsSync()) {
          final dartFiles = Directory(dir).listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.dart'))
              .toList();
          if (dartFiles.isNotEmpty) {
            errors.add('$dir still has files: ${dartFiles.length} files');
          }
        }
      }
      expect(errors, isEmpty, reason: errors.join('\n'));
    });
  });
}
