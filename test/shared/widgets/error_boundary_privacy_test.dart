import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('default fallback does not render exception detail', () {
    final source = File(
      'lib/shared/widgets/error_boundary.dart',
    ).readAsStringSync();

    expect(source, contains('l10n.unexpectedDisplayError'));
    expect(source, isNot(contains('error.toString()')));
  });
}
