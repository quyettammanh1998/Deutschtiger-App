import 'package:deutschtiger/screens/auth/widgets/auth_text_field.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthValidators.email', () {
    test('rỗng → báo lỗi', () {
      expect(AuthValidators.email(''), isNotNull);
    });
    test('sai định dạng → báo lỗi', () {
      expect(AuthValidators.email('abc'), isNotNull);
      expect(AuthValidators.email('a@b'), isNotNull);
    });
    test('hợp lệ → null', () {
      expect(AuthValidators.email('deutschtiger@gmail.com'), isNull);
    });
  });

  group('AuthValidators.password', () {
    test('dưới 6 ký tự → báo lỗi', () {
      expect(AuthValidators.password('12345'), isNotNull);
    });
    test('đủ 6 ký tự → null', () {
      expect(AuthValidators.password('123456'), isNull);
    });
  });

  group('AuthValidators.displayName', () {
    test('rỗng → báo lỗi', () {
      expect(AuthValidators.displayName(''), isNotNull);
    });
    test('hợp lệ → null', () {
      expect(AuthValidators.displayName('Cường'), isNull);
    });
  });
}
