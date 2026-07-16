import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/previews/preview_auth_service.dart';
import 'package:deutschtiger/repositories/notifications/notifications_repository.dart';
import 'package:deutschtiger/screens/settings/app_update_screen.dart';
import 'package:deutschtiger/screens/settings/appearance_screen.dart';
import 'package:deutschtiger/screens/settings/learning_preferences_screen.dart';
import 'package:deutschtiger/screens/settings/notification_preferences_screen.dart';
import 'package:deutschtiger/screens/settings/security_screen.dart';
import 'package:deutschtiger/screens/settings/settings_screen.dart';
import 'package:deutschtiger/repositories/settings/learning_preferences_repository.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:deutschtiger/data/notifications/notification_models.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// German is the longest-string locale in this app — a 200% OS text-scale
/// smoke pass on the rebuilt settings tree (P12 wave A) catches overflow
/// regressions without needing per-screen golden files. A thrown
/// [FlutterError] during pump (RenderFlex overflow, etc.) fails the test.
void main() {
  setUpAll(() => SharedPreferences.setMockInitialValues({}));

  Widget wrapAt200(Widget child, {List<Override> overrides = const []}) => ProviderScope(
    overrides: [
      authServiceProvider.overrideWithValue(PreviewAuthService()),
      ...overrides,
    ],
    child: MaterialApp(
      locale: const Locale('de'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: MediaQuery(
        data: const MediaQueryData(
          size: Size(390, 844),
          textScaler: TextScaler.linear(2),
        ),
        child: child,
      ),
    ),
  );

  testWidgets('settings root does not overflow at German 200%', (tester) async {
    await tester.pumpWidget(wrapAt200(const SettingsScreen()));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('security screen does not overflow at German 200%', (tester) async {
    await tester.pumpWidget(wrapAt200(const SecurityScreen()));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('appearance screen does not overflow at German 200%', (tester) async {
    await tester.pumpWidget(wrapAt200(const AppearanceScreen()));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('notification preferences does not overflow at German 200%', (tester) async {
    final repo = _FakeNotificationsRepository();
    await tester.pumpWidget(
      wrapAt200(
        const NotificationPreferencesScreen(),
        overrides: [notificationsRepositoryProvider.overrideWithValue(repo)],
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('learning preferences does not overflow at German 200%', (tester) async {
    await tester.pumpWidget(
      wrapAt200(
        const LearningPreferencesScreen(),
        overrides: [
          learningPreferencesRepositoryProvider.overrideWithValue(
            _FakeLearningPreferencesRepository(),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('app update screen does not overflow at German 200%', (tester) async {
    await tester.pumpWidget(wrapAt200(const AppUpdateScreen()));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}

class _FakeLearningPreferencesRepository extends LearningPreferencesRepository {
  _FakeLearningPreferencesRepository()
    : super(
        ApiClient(baseUrl: 'https://example.test/api/v1', tokenProvider: _NoTokenProvider()),
      );

  @override
  Future<LearningPreferences> get() async => const LearningPreferences(
    cefrLevel: 'B1',
    dailyMinutes: 15,
    dailyXpGoal: 50,
    learningGoals: ['communication', 'goethe'],
  );
}

class _FakeNotificationsRepository extends NotificationsRepository {
  _FakeNotificationsRepository()
    : super(
        ApiClient(baseUrl: 'https://example.test/api/v1', tokenProvider: _NoTokenProvider()),
      );

  @override
  Future<NotificationPreferences> getPreferences() async => const NotificationPreferences(
    enabled: true,
    preferredTime: '07:00',
    timezone: 'Asia/Ho_Chi_Minh',
    contentMode: 'mix',
  );
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
