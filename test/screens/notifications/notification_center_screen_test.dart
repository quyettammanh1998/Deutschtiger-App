import 'package:deutschtiger/data/notifications/notification_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/notifications/notifications_repository.dart';
import 'package:deutschtiger/screens/notifications/notification_center_screen.dart';
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
      home: const NotificationCenterScreen(),
    ),
  );

  testWidgets('shows notifications and marks one as read on tap', (tester) async {
    final repo = _FakeNotificationsRepository(
      items: [
        AppNotification(
          id: 'n1',
          type: 'daily_review',
          data: const {},
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ],
    );

    await tester.pumpWidget(wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Có từ cần ôn hôm nay'), findsOneWidget);

    await tester.tap(find.text('Có từ cần ôn hôm nay'));
    await tester.pumpAndSettle();

    expect(repo.markedAsRead, ['n1']);
  });

  testWidgets('shows the empty state when there are no notifications', (tester) async {
    await tester.pumpWidget(wrap(_FakeNotificationsRepository(items: const [])));
    await tester.pumpAndSettle();

    expect(find.text('Không có thông báo nào'), findsOneWidget);
  });

  testWidgets('shows an error view with retry when the list fails to load', (tester) async {
    final repo = _FakeNotificationsRepository(items: const [], shouldFail: true);

    await tester.pumpWidget(wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Không tải được thông báo. Vui lòng thử lại.'), findsOneWidget);

    repo.shouldFail = false;
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();

    expect(find.text('Không có thông báo nào'), findsOneWidget);
  });

  testWidgets('mark-all-read flips every item to read', (tester) async {
    final repo = _FakeNotificationsRepository(
      items: [
        AppNotification(
          id: 'n1',
          type: 'daily_review',
          data: const {},
          isRead: false,
          createdAt: DateTime.now(),
        ),
        AppNotification(
          id: 'n2',
          type: 'grading_done',
          data: const {},
          isRead: false,
          createdAt: DateTime.now(),
        ),
      ],
    );

    await tester.pumpWidget(wrap(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Đánh dấu tất cả đã đọc'));
    await tester.pumpAndSettle();

    expect(repo.markedAllRead, isTrue);
  });
}

/// In-memory fake used instead of a scripted [ApiClient] adapter — the
/// screen only depends on [NotificationsRepository]'s public methods, so
/// faking at that seam keeps the test focused on UI behavior.
class _FakeNotificationsRepository extends NotificationsRepository {
  _FakeNotificationsRepository({required List<AppNotification> items, this.shouldFail = false})
    : _items = items,
      super(ApiClient(baseUrl: 'https://example.test/api/v1', tokenProvider: _NoTokenProvider()));

  final List<AppNotification> _items;
  bool shouldFail;
  final List<String> markedAsRead = [];
  bool markedAllRead = false;

  @override
  Future<List<AppNotification>> getNotifications({int limit = 20}) async {
    if (shouldFail) throw Exception('network error');
    return _items;
  }

  @override
  Future<void> markAsRead(String id) async {
    markedAsRead.add(id);
  }

  @override
  Future<void> markAllAsRead() async {
    markedAllRead = true;
  }
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
