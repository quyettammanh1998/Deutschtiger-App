import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Navigation Layer Migration', () {
    test('lib/navigation/ directory exists', () {
      expect(Directory('lib/navigation').existsSync(), true);
    });

    test('app_router.dart moved to navigation/', () {
      expect(File('lib/navigation/app_router.dart').existsSync(), true);
    });

    test('lib/core/router/ removed', () {
      expect(Directory('lib/core/router').existsSync(), false);
    });
  });
}
