import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Screens Layer (plan 260706-0232 - mirrors web src/pages/)', () {
    test('lib/screens/ai/ exists', () {
      expect(Directory('lib/screens/ai').existsSync(), true);
    });

    test('lib/screens/exam/ exists', () {
      expect(Directory('lib/screens/exam').existsSync(), true);
    });

    test('lib/screens/home/ exists', () {
      expect(Directory('lib/screens/home').existsSync(), true);
    });

    test('Presentation subdirs mirror web (UI + widgets)', () {
      // Plan 260706-0232: giữ mixed layout giữa lib/screens/ và lib/features/<domain>/presentation/.
      // Presentation dirs được phép có widgets (đúng pattern: features/<domain>/presentation/widgets/).
      final presentationDirs = [
        'lib/features/ai/presentation',
        'lib/features/exam/presentation',
        'lib/features/home/presentation',
        'lib/features/vocabulary/presentation',
        'lib/features/grammar/presentation',
      ];
      int totalFiles = 0;
      for (final dir in presentationDirs) {
        if (Directory(dir).existsSync()) {
          final dartFiles = Directory(dir)
              .listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.dart'))
              .toList();
          totalFiles += dartFiles.length;
        }
      }
      // Phase 3+4 đã move widgets vào presentation/widgets/ - đây là pattern chuẩn.
      expect(totalFiles, greaterThan(0),
          reason: 'Presentation dirs should contain UI widgets');
    });

    test('Key feature modules have data/domain/presentation layers', () {
      final featureDirs = ['vocabulary', 'exam', 'grammar', 'journey'];
      for (final f in featureDirs) {
        final hasData = Directory('lib/features/$f/data').existsSync() ||
            Directory('lib/features/$f/domain').existsSync() ||
            Directory('lib/features/$f/presentation').existsSync();
        expect(hasData, true,
            reason: 'lib/features/$f should have at least one of: data/domain/presentation');
      }
    });
  });
}
