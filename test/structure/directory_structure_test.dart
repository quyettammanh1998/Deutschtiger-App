import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final libPath = 'lib';

  group('Target Directory Structure', () {
    test('core/ directory exists', () {
      expect(Directory('$libPath/core').existsSync(), true);
    });

    test('data/ directory exists', () {
      expect(Directory('$libPath/data').existsSync(), true);
    });

    test('repositories/ directory exists', () {
      expect(Directory('$libPath/repositories').existsSync(), true);
    });

    test('screens/ directory exists', () {
      expect(Directory('$libPath/screens').existsSync(), true);
    });

    test('view_models/ directory exists', () {
      expect(Directory('$libPath/view_models').existsSync(), true);
    });

    test('widgets/ directory exists', () {
      expect(Directory('$libPath/widgets').existsSync(), true);
    });

    test('services/ directory exists', () {
      expect(Directory('$libPath/services').existsSync(), true);
    });

    test('navigation/ directory exists', () {
      expect(Directory('$libPath/navigation').existsSync(), true);
    });

    test('l10n/ directory exists', () {
      expect(Directory('$libPath/l10n').existsSync(), true);
    });

    test('previews/ directory exists (preserved)', () {
      expect(Directory('$libPath/previews').existsSync(), true);
    });
  });
}
