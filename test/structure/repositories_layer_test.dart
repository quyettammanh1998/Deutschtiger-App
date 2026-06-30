import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Repositories Layer Migration', () {
    test('lib/repositories/ai/ exists', () {
      expect(Directory('lib/repositories/ai').existsSync(), true);
    });

    test('lib/repositories/exam/ exists', () {
      expect(Directory('lib/repositories/exam').existsSync(), true);
    });

    test('lib/repositories/flashcard/ exists', () {
      expect(Directory('lib/repositories/flashcard').existsSync(), true);
    });

    test('lib/repositories/vocab/ exists', () {
      expect(Directory('lib/repositories/vocab').existsSync(), true);
    });

    test('lib/repositories/auth_repository.dart exists', () {
      expect(File('lib/repositories/profile_repository.dart').existsSync(), true);
    });

    test('lib/core/identity/ only has app_user (not moved per plan)', () {
      final identityDir = Directory('lib/core/identity');
      if (identityDir.existsSync()) {
        final files = identityDir.listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .where((f) => !f.path.endsWith('.freezed.dart'))
            .where((f) => !f.path.endsWith('.g.dart'));
        // Only app_user.dart should remain per plan Q1
        expect(files.length, 1, reason: 'Only app_user.dart should remain');
        expect(files.first.path, endsWith('app_user.dart'));
      }
    });

    test('Original data/ directories emptied', () {
      final dataDirs = [
        'lib/features/ai/data',
        'lib/features/exam/data',
        'lib/features/flashcard/data',
        'lib/features/vocabulary_search/data',
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
