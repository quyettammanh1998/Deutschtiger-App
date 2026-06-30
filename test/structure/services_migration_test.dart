import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Services Migration', () {
    test('AuthService moved to services/', () {
      expect(File('lib/services/auth_service.dart').existsSync(), true);
    });

    test('DisabledAuthService moved to services/', () {
      expect(File('lib/services/disabled_auth_service.dart').existsSync(), true);
    });

    test('TokenProvider renamed to AuthProvider in services/', () {
      expect(File('lib/services/auth_provider.dart').existsSync(), true);
    });

    test('NotificationService moved to services/', () {
      expect(Directory('lib/services/notifications').existsSync(), true);
    });

    test('AudioService moved to services/', () {
      expect(File('lib/services/audio_service.dart').existsSync(), true);
    });

    test('ApiClient moved to services/', () {
      expect(File('lib/services/api_client.dart').existsSync(), true);
    });

    test('OfflineService moved to services/', () {
      expect(Directory('lib/services/offline').existsSync(), true);
    });

    test('AppConfig moved to services/config/', () {
      expect(File('lib/services/config/app_config.dart').existsSync(), true);
    });

    test('design_tokens.dart remains in core/', () {
      expect(File('lib/core/design_tokens.dart').existsSync(), true);
    });

    test('app_colors.dart remains in core/', () {
      expect(File('lib/core/theme/app_colors.dart').existsSync(), true);
    });

    test('app_theme.dart remains in core/', () {
      expect(File('lib/core/theme/app_theme.dart').existsSync(), true);
    });

    test('providers.dart uses package imports', () {
      final content = File('lib/view_models/providers.dart').readAsStringSync();
      expect(content.contains("package:deutschtiger/services/auth_service.dart"), true);
      expect(content.contains("package:deutschtiger/services/audio_service.dart"), true);
      expect(content.contains("package:deutschtiger/services/api_client.dart"), true);
    });
  });
}
