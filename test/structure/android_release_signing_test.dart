import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android release build never falls back to debug signing', () {
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();

    expect(gradle, isNot(contains('signingConfigs.getByName("debug")')));
    expect(gradle, contains('Release signing is not configured.'));
    expect(gradle, contains('name.equals("assembleRelease"'));
    expect(gradle, contains('name.equals("bundleRelease"'));
  });
}
