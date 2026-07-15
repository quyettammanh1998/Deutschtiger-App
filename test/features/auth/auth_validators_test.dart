import 'package:deutschtiger/screens/auth/widgets/auth_text_field.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppLocalizations vietnamese;
  late AppLocalizations german;

  setUpAll(() async {
    vietnamese = await AppLocalizations.delegate.load(const Locale('vi'));
    german = await AppLocalizations.delegate.load(const Locale('de'));
  });

  group('AuthValidators.email', () {
    test('rỗng → báo lỗi', () {
      expect(AuthValidators.email('', vietnamese), isNotNull);
    });
    test('sai định dạng → báo lỗi', () {
      expect(AuthValidators.email('abc', vietnamese), isNotNull);
      expect(AuthValidators.email('a@b', vietnamese), isNotNull);
    });
    test('hợp lệ → null', () {
      expect(
        AuthValidators.email('deutschtiger@gmail.com', vietnamese),
        isNull,
      );
    });
    test('uses the active locale for errors', () {
      expect(AuthValidators.email('', german), 'Gib deine E-Mail-Adresse ein.');
    });
  });

  group('AuthValidators.password', () {
    test('dưới 6 ký tự → báo lỗi', () {
      expect(AuthValidators.password('12345', vietnamese), isNotNull);
    });
    test('đủ 6 ký tự → null', () {
      expect(AuthValidators.password('123456', vietnamese), isNull);
    });
  });

  group('AuthValidators.displayName', () {
    test('rỗng → báo lỗi', () {
      expect(AuthValidators.displayName('', vietnamese), isNotNull);
    });
    test('hợp lệ → null', () {
      expect(AuthValidators.displayName('Cường', vietnamese), isNull);
    });
  });
}
