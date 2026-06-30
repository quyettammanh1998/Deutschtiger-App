import 'package:flutter_test/flutter_test.dart';
import 'package:deutschtiger/core/notifications/notification_contract.dart';
import '../../../test/helpers/fake_notification_service.dart';

void main() {
  group('NotificationContract', () {
    group('FakeNotificationService', () {
      test('initializes with zero counts', () {
        final fake = FakeNotificationService();
        expect(fake.initializeCount, 0);
        expect(fake.requestCount, 0);
        expect(fake.scheduleCount, 0);
        expect(fake.cancelCount, 0);
      });

      test('initialize increments count', () async {
        final fake = FakeNotificationService();
        await fake.initialize();
        expect(fake.initializeCount, 1);
      });

      test('initialize can be called multiple times', () async {
        final fake = FakeNotificationService();
        await fake.initialize();
        await fake.initialize();
        await fake.initialize();
        expect(fake.initializeCount, 3);
      });

      test('hasPermission returns initial value', () async {
        final fake = FakeNotificationService(permissionGranted: true);
        expect(await fake.hasPermission(), true);

        final fakeNoPermission = FakeNotificationService(permissionGranted: false);
        expect(await fakeNoPermission.hasPermission(), false);
      });

      test('requestPermission grants permission when requestResult is true', () async {
        final fake = FakeNotificationService(requestResult: true);
        final result = await fake.requestPermission();
        expect(result, true);
        expect(fake.permissionGranted, true);
        expect(fake.requestCount, 1);
      });

      test('requestPermission denies permission when requestResult is false', () async {
        final fake = FakeNotificationService(requestResult: false);
        final result = await fake.requestPermission();
        expect(result, false);
        expect(fake.permissionGranted, false);
        expect(fake.requestCount, 1);
      });

      test('scheduleDailyReminder tracks schedule calls', () async {
        final fake = FakeNotificationService();
        await fake.scheduleDailyReminder(hour: 9, minute: 0);
        expect(fake.scheduleCount, 1);
        expect(fake.lastHour, 9);
        expect(fake.lastMinute, 0);
      });

      test('scheduleDailyReminder captures title and body', () async {
        final fake = FakeNotificationService();
        await fake.scheduleDailyReminder(
          hour: 10,
          minute: 30,
          title: 'Test Title',
          body: 'Test Body',
        );
        expect(fake.lastTitle, 'Test Title');
        expect(fake.lastBody, 'Test Body');
      });

      test('cancelAll increments cancel count', () async {
        final fake = FakeNotificationService();
        await fake.cancelAll();
        expect(fake.cancelCount, 1);
      });

      test('cancelAll can be called multiple times', () async {
        final fake = FakeNotificationService();
        await fake.cancelAll();
        await fake.cancelAll();
        expect(fake.cancelCount, 2);
      });

      test('reset clears all counters and state', () async {
        final fake = FakeNotificationService();
        await fake.initialize();
        await fake.requestPermission();
        await fake.scheduleDailyReminder(hour: 9, minute: 0);
        await fake.cancelAll();

        fake.reset();

        expect(fake.initializeCount, 0);
        expect(fake.requestCount, 0);
        expect(fake.scheduleCount, 0);
        expect(fake.cancelCount, 0);
        expect(fake.lastHour, isNull);
        expect(fake.lastMinute, isNull);
      });

      test('throws on initialize when throwOnInitialize is true', () async {
        final fake = FakeNotificationService()..throwOnInitialize = true;
        expect(() => fake.initialize(), throwsA(isA<StateError>()));
      });

      test('throws on requestPermission when throwOnRequest is true', () async {
        final fake = FakeNotificationService()..throwOnRequest = true;
        expect(() => fake.requestPermission(), throwsA(isA<StateError>()));
      });

      test('throws on scheduleDailyReminder when throwOnSchedule is true', () async {
        final fake = FakeNotificationService()..throwOnSchedule = true;
        expect(
          () => fake.scheduleDailyReminder(hour: 9, minute: 0),
          throwsA(isA<StateError>()),
        );
      });

      test('throws on cancelAll when throwOnCancel is true', () async {
        final fake = FakeNotificationService()..throwOnCancel = true;
        expect(() => fake.cancelAll(), throwsA(isA<StateError>()));
      });
    });
  });
}
