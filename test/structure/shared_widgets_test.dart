import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Shared Widgets Migration', () {
    test('lib/widgets/common/ exists', () {
      expect(Directory('lib/widgets/common').existsSync(), true);
    });

    test('lib/widgets/common/ has widgets', () {
      final commonDir = Directory('lib/widgets/common');
      if (commonDir.existsSync()) {
        final files = commonDir.listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .toList();
        expect(files.isNotEmpty, true, reason: 'lib/widgets/common/ should have widgets');
      }
    });

    test('shared/widgets/ moved', () {
      final sharedWidgetsDir = Directory('lib/shared/widgets');
      if (sharedWidgetsDir.existsSync()) {
        final files = sharedWidgetsDir.listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .toList();
        expect(files.isEmpty, true, reason: 'lib/shared/widgets/ should be empty');
      }
    });
  });
}
