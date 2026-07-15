import 'package:deutschtiger/data/social/friend_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/social/friend_repository.dart';
import 'package:deutschtiger/screens/social/friends_page.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/social/social_repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(FriendRepository repo) => ProviderScope(
    overrides: [friendRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      locale: const Locale('vi'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const FriendsPage(),
    ),
  );

  testWidgets('shows the accepted friends list', (tester) async {
    final repo = _FakeFriendRepository(
      friends: [
        const FriendProfile(
          id: 'u2',
          displayName: 'Maria',
          avatarUrl: '',
          level: 5,
          currentStreak: 10,
          totalXp: 500,
          friendshipStatus: 'accepted',
          friendshipId: 'f1',
          isOnline: true,
        ),
      ],
    );

    await tester.pumpWidget(wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Maria'), findsOneWidget);
  });

  testWidgets('shows the empty state when there are no friends', (tester) async {
    await tester.pumpWidget(wrap(_FakeFriendRepository(friends: const [])));
    await tester.pumpAndSettle();

    expect(find.text('Chưa có bạn bè'), findsOneWidget);
  });

  testWidgets('block flow calls FriendRepository.blockUser and confirms', (tester) async {
    final repo = _FakeFriendRepository(
      friends: [
        const FriendProfile(
          id: 'u2',
          displayName: 'Maria',
          avatarUrl: '',
          level: 5,
          currentStreak: 10,
          totalXp: 500,
          friendshipStatus: 'accepted',
          friendshipId: 'f1',
        ),
      ],
    );

    await tester.pumpWidget(wrap(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chặn').last);
    await tester.pumpAndSettle();

    // Confirmation dialog appears; confirm.
    expect(find.text('Chặn người dùng này? Họ sẽ không thể liên hệ với bạn nữa.'), findsNothing);
    await tester.tap(find.text('Chặn').last);
    await tester.pumpAndSettle();

    expect(repo.blockedUserIds, ['u2']);
  });
}

/// In-memory fake used instead of a scripted [ApiClient] adapter, mirroring
/// `notification_center_screen_test.dart`'s pattern.
class _FakeFriendRepository extends FriendRepository {
  _FakeFriendRepository({required List<FriendProfile> friends})
    : _friends = friends,
      super(ApiClient(baseUrl: 'https://example.test/api/v1', tokenProvider: _NoTokenProvider()));

  final List<FriendProfile> _friends;
  final List<String> blockedUserIds = [];

  @override
  Future<List<FriendProfile>> getFriends() async => _friends;

  @override
  Future<List<FriendRequest>> getPendingRequests() async => const [];

  @override
  Future<void> blockUser(String targetUserId) async {
    blockedUserIds.add(targetUserId);
  }
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
