import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('L10n Layer Migration', () {
    test('lib/l10n/ directory exists', () {
      expect(Directory('lib/l10n').existsSync(), true);
    });

    test('generated localization sources replace the legacy string map', () {
      expect(File('l10n.yaml').existsSync(), true);
      expect(File('lib/l10n/app_vi.arb').existsSync(), true);
      expect(File('lib/l10n/app_en.arb').existsSync(), true);
      expect(File('lib/l10n/app_de.arb').existsSync(), true);
      expect(File('lib/l10n/app_localizations.dart').existsSync(), true);
      expect(File('lib/l10n/i18n_service.dart').existsSync(), false);
    });

    test('lib/core/i18n/ removed', () {
      expect(Directory('lib/core/i18n').existsSync(), false);
    });
  });
}
