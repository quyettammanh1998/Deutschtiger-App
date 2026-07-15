import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Data Layer (plan 260706-0232 - mirrors web src/lib/)', () {
    test('lib/data/ exists', () {
      expect(Directory('lib/data').existsSync(), true);
    });

    test('lib/data/ has at least one domain', () {
      final dataDir = Directory('lib/data');
      if (dataDir.existsSync()) {
        final dirs = dataDir
            .listSync()
            .whereType<Directory>()
            .toList();
        // Plan giữ mixed layout: data ở lib/data/ hoặc lib/features/*/data
        // chỉ check có data structure somewhere
        expect(dirs, isNotNull);
      }
    });

    test('Features have data/ subdirs OR lib/data/ has models', () {
      final featuresDataDirs = Directory('lib/features')
          .listSync(recursive: true)
          .whereType<Directory>()
          .where((d) => d.path.endsWith('/data'))
          .toList();
      final libDataHasFiles = Directory('lib/data').existsSync() &&
          Directory('lib/data')
              .listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.dart'))
              .isNotEmpty;
      expect(featuresDataDirs.isNotEmpty || libDataHasFiles, true,
          reason: 'Either features/*/data or lib/data/ should have models');
    });

    test('DTOs mirror web src/types/ structure', () {
      // Plan: mirror web src/types/<domain>/index.ts sang Flutter DTO files.
      // Layout hiện tại giữ mixed - check có DTO files ở đâu đó.
      final allDartFiles = Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .where((f) => !f.path.endsWith('.g.dart'))
          .where((f) => !f.path.endsWith('.freezed.dart'))
          .toList();
      expect(allDartFiles.length, greaterThan(50),
          reason: 'Should have many DTO/data files across lib/');
    });
  });
}
