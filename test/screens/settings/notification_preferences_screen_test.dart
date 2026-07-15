import 'package:deutschtiger/data/notifications/notification_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/notifications/notifications_repository.dart';
import 'package:deutschtiger/screens/settings/notification_preferences_screen.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(NotificationsRepository repo) => ProviderScope(
    overrides: [notificationsRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      locale: const Locale('vi'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const NotificationPreferencesScreen(),
    ),
  );

  testWidgets('loads preferences and saves the enabled toggle', (tester) async {
    final repo = _FakePreferencesRepository(
      const NotificationPreferences(
        enabled: false,
        preferredTime: '07:00',
        contentMode: 'mix',
      ),
    );

    await tester.pumpWidget(wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Nhắc nhở học tập'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(repo.saved?.enabled, isTrue);
  });

  testWidgets('shows an error view when preferences fail to load', (tester) async {
    final repo = _FakePreferencesRepository(null, shouldFail: true);

    await tester.pumpWidget(wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Không tải được thông báo. Vui lòng thử lại.'), findsOneWidget);
  });
}

class _FakePreferencesRepository extends NotificationsRepository {
  _FakePreferencesRepository(this._preferences, {this.shouldFail = false})
    : super(ApiClient(baseUrl: 'https://example.test/api/v1', tokenProvider: _NoTokenProvider()));

  NotificationPreferences? _preferences;
  final bool shouldFail;
  NotificationPreferences? saved;

  @override
  Future<NotificationPreferences> getPreferences() async {
    if (shouldFail || _preferences == null) throw Exception('load failed');
    return _preferences!;
  }

  @override
  Future<NotificationPreferences> savePreferences(NotificationPreferences preferences) async {
    saved = preferences;
    _preferences = preferences;
    return preferences;
  }
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
