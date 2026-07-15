import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('release configuration remains phone-only and portrait-locked', () {
    final androidManifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    final xcodeProject = File(
      'ios/Runner.xcodeproj/project.pbxproj',
    ).readAsStringSync();

    expect(androidManifest, contains('android:screenOrientation="portrait"'));
    expect(xcodeProject, contains('TARGETED_DEVICE_FAMILY = 1;'));
    expect(xcodeProject, isNot(contains('TARGETED_DEVICE_FAMILY = "1,2";')));
  });

  test('Android release configuration excludes app data from backup', () {
    final androidManifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    final backupRules = File(
      'android/app/src/main/res/xml/backup_rules.xml',
    ).readAsStringSync();
    final dataExtractionRules = File(
      'android/app/src/main/res/xml/data_extraction_rules.xml',
    ).readAsStringSync();
    const domains = <String>[
      'root',
      'file',
      'database',
      'sharedpref',
      'external',
      'device_root',
      'device_file',
      'device_database',
      'device_sharedpref',
    ];

    expect(androidManifest, contains('android:allowBackup="false"'));
    expect(
      androidManifest,
      contains('android:fullBackupContent="@xml/backup_rules"'),
    );
    expect(
      androidManifest,
      contains('android:dataExtractionRules="@xml/data_extraction_rules"'),
    );
    expect(backupRules, contains('<full-backup-content>'));
    expect(dataExtractionRules, contains('<cloud-backup>'));
    expect(dataExtractionRules, contains('<device-transfer>'));

    for (final domain in domains) {
      final exclusion = '<exclude domain="$domain" path="." />';
      expect(backupRules, contains(exclusion));
      expect(dataExtractionRules, contains(exclusion));
    }
  });

  test('iOS microphone disclosure matches the local recording implementation', () {
    final infoPlist = File('ios/Runner/Info.plist').readAsStringSync();
    final project = File(
      'ios/Runner.xcodeproj/project.pbxproj',
    ).readAsStringSync();
    final recordingService = File(
      'lib/features/voice/data/recording_service.dart',
    ).readAsStringSync();

    expect(infoPlist, contains('<key>NSMicrophoneUsageDescription</key>'));
    expect(infoPlist, contains('thư mục tạm thời trên thiết bị'));
    expect(
      infoPlist,
      contains('không được gửi âm thanh lên máy chủ trong phiên bản hiện tại'),
    );
    expect(infoPlist, isNot(contains('được gửi lên server')));
    expect(recordingService, contains('getTemporaryDirectory()'));
    expect(recordingService, contains("dt_recording_\${DateTime.now().millisecondsSinceEpoch}.m4a"));
    expect(recordingService, isNot(contains('ApiClient')));
    expect(recordingService, isNot(contains('upload')));
    expect(project, contains('InfoPlist.strings in Resources'));
    expect(project, contains('knownRegions = ('));
    expect(project, contains('\n\t\t\t\tde,'));
    expect(project, contains('\n\t\t\t\tvi,'));

    final localizedDisclosures = <String, String>{
      'ios/Runner/de.lproj/InfoPlist.strings': 'temporären Ordner',
      'ios/Runner/en.lproj/InfoPlist.strings': 'temporary directory',
      'ios/Runner/vi.lproj/InfoPlist.strings': 'thư mục tạm thời',
    };
    for (final entry in localizedDisclosures.entries) {
      final localizedFile = File(entry.key).readAsStringSync();
      expect(localizedFile, contains('NSMicrophoneUsageDescription'));
      expect(localizedFile, contains(entry.value));
      expect(localizedFile, isNot(contains('AI chấm điểm')));
      expect(localizedFile, isNot(contains('sent to a server for AI')));
    }
  });

  test('iOS app target keeps App Transport Security defaults', () {
    final infoPlist = File('ios/Runner/Info.plist').readAsStringSync();

    expect(infoPlist, isNot(contains('NSAppTransportSecurity')));
    expect(infoPlist, isNot(contains('NSAllowsArbitraryLoads')));
    expect(infoPlist, isNot(contains('NSExceptionDomains')));
  });
}
