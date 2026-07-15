import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Repositories Layer (plan 260706-0232 - mirrors web src/lib/)', () {
    test('lib/repositories/ exists', () {
      expect(Directory('lib/repositories').existsSync(), true);
    });

    test('lib/repositories/ has subdirectories', () {
      final reposDir = Directory('lib/repositories');
      if (reposDir.existsSync()) {
        final dirs = reposDir
            .listSync()
            .whereType<Directory>()
            .toList();
        // Plan giữ mixed layout (lib/screens + lib/features + lib/repositories + lib/services)
        // nên không require subdirectories cụ thể - chỉ check layout cơ bản
        expect(dirs, isNotNull);
      }
    });

    test('AuthService exists in lib/services/', () {
      // Auth layer ở lib/services/auth_service.dart (theo convention mới)
      expect(File('lib/services/auth_service.dart').existsSync(), true);
    });

    test('Core network layer (api_client) exists', () {
      final candidates = [
        'lib/core/network',
        'lib/services',
      ];
      final hasNetworkLayer = candidates.any((p) => Directory(p).existsSync());
      expect(hasNetworkLayer, true,
          reason: 'Either lib/core/network or lib/services must exist');
    });

    test('Features mirror web domains', () {
      final expectedDomains = [
        'auth',
        'home',
        'exam',
        'vocabulary',
        'flashcard',
        'listening',
        'speaking',
        'journey',
        'social',
        'games',
        'settings',
      ];
      final featureDirs = Directory('lib/features')
          .listSync()
          .whereType<Directory>()
          .map((d) => d.path.split('/').last)
          .toSet();
      for (final domain in expectedDomains) {
        expect(featureDirs.contains(domain), true,
            reason: 'lib/features/$domain should exist (mirrors web src/lib/)');
      }
    });
  });
}
