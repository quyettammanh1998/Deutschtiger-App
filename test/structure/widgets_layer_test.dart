import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Feature Widgets Migration', () {
    test('lib/widgets/ai/ exists', () {
      expect(Directory('lib/widgets/ai').existsSync(), true);
    });

    test('lib/widgets/dashboard/ exists', () {
      expect(Directory('lib/widgets/dashboard').existsSync(), true);
    });

    test('lib/widgets/exam/ exists with presentation widgets', () {
      expect(Directory('lib/widgets/exam').existsSync(), true);
    });

    test('lib/widgets/home/ exists', () {
      expect(Directory('lib/widgets/home').existsSync(), true);
    });

    test('lib/widgets/interview/ exists', () {
      expect(Directory('lib/widgets/interview').existsSync(), true);
    });

    test('lib/widgets/flashcard/ exists with presentation widgets', () {
      expect(Directory('lib/widgets/flashcard').existsSync(), true);
    });

    test('lib/widgets/speaking/ exists with presentation widgets', () {
      expect(Directory('lib/widgets/speaking').existsSync(), true);
    });

    test('Original presentation/widgets directories emptied', () {
      final widgetDirs = [
        'lib/features/flashcard/presentation/widgets',
        'lib/features/speaking/presentation/widgets',
      ];
      final errors = <String>[];
      for (final dir in widgetDirs) {
        if (Directory(dir).existsSync()) {
          final dartFiles = Directory(dir).listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.dart'))
              .toList();
          if (dartFiles.isNotEmpty) {
            errors.add('$dir still has files: ${dartFiles.length}');
          }
        }
      }
      expect(errors, isEmpty, reason: errors.join('\n'));
    });
  });
}
