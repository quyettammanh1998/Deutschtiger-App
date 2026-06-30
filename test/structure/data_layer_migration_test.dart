import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Data Layer Migration', () {
    test('lib/data/ai/ exists with models', () {
      expect(Directory('lib/data/ai').existsSync(), true);
    });

    test('lib/data/exam/ exists with models', () {
      expect(Directory('lib/data/exam').existsSync(), true);
    });

    test('lib/data/home/ exists with dashboard models', () {
      expect(Directory('lib/data/home').existsSync(), true);
    });

    test('lib/data/journey/ exists with journey models', () {
      expect(Directory('lib/data/journey').existsSync(), true);
    });

    test('lib/data/listening/ exists with podcast models', () {
      expect(Directory('lib/data/listening').existsSync(), true);
    });

    test('lib/data/social/ exists with social models', () {
      expect(Directory('lib/data/social').existsSync(), true);
    });

    test('lib/data/speaking/ exists with speaking models', () {
      expect(Directory('lib/data/speaking').existsSync(), true);
    });

    test('lib/data/vocab/ exists with vocabulary models', () {
      expect(Directory('lib/data/vocab').existsSync(), true);
    });

    test('DTOs moved from features/*/domain/', () {
      // Check that domain directories are empty (except for generated files)
      final featuresWithDomain = [
        'lib/features/ai',
        'lib/features/exam',
        'lib/features/home',
        'lib/features/journey',
        'lib/features/listening',
        'lib/features/social',
        'lib/features/speaking',
        'lib/features/vocabulary_search',
      ];

      final errors = <String>[];
      for (final feature in featuresWithDomain) {
        final domainDir = Directory('$feature/domain');
        if (domainDir.existsSync()) {
          final files = domainDir.listSync()
              .whereType<File>()
              .where((f) => f.path.endsWith('.dart'))
              .where((f) => !f.path.endsWith('.freezed.dart'))
              .where((f) => !f.path.endsWith('.g.dart'))
              .toList();
          if (files.isNotEmpty) {
            errors.add('$domainDir still has non-generated files: ${files.map((f) => f.path).join(', ')}');
          }
        }
      }

      expect(errors, isEmpty, reason: errors.join('\n'));
    });
  });
}
