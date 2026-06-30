import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('L10n Layer Migration', () {
    test('lib/l10n/ directory exists', () {
      expect(Directory('lib/l10n').existsSync(), true);
    });

    test('i18n_service moved to l10n/', () {
      expect(File('lib/l10n/i18n_service.dart').existsSync(), true);
    });

    test('lib/core/i18n/ removed', () {
      expect(Directory('lib/core/i18n').existsSync(), false);
    });
  });
}
