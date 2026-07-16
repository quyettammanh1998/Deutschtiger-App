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

  group('AuthValidators.passwordMin8', () {
    test('dưới 8 ký tự → báo lỗi', () {
      expect(AuthValidators.passwordMin8('1234567', vietnamese), isNotNull);
    });
    test('rỗng → báo lỗi required', () {
      expect(
        AuthValidators.passwordMin8('', vietnamese),
        vietnamese.passwordRequired,
      );
    });
    test('đủ 8 ký tự → null', () {
      expect(AuthValidators.passwordMin8('12345678', vietnamese), isNull);
    });
  });

  group('AuthValidators.confirmPassword', () {
    test('không khớp → báo lỗi', () {
      expect(
        AuthValidators.confirmPassword('abc12345', 'abc12346', vietnamese),
        vietnamese.passwordConfirmationMismatch,
      );
    });
    test('khớp → null', () {
      expect(
        AuthValidators.confirmPassword('abc12345', 'abc12345', vietnamese),
        isNull,
      );
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
