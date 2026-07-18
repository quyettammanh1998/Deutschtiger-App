import 'package:deutschtiger/core/identity/app_user.dart';
import 'package:deutschtiger/data/social/message_models.dart';
import 'package:deutschtiger/data/social/public_profile_model.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/social/message_repository.dart';
import 'package:deutschtiger/repositories/social/public_profile_repository.dart';
import 'package:deutschtiger/screens/social/chat_page.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:deutschtiger/view_models/social/social_repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(
    MessageRepository messageRepo,
    PublicProfileRepository profileRepo,
  ) => ProviderScope(
    overrides: [
      messageRepositoryProvider.overrideWithValue(messageRepo),
      publicProfileRepositoryProvider.overrideWithValue(profileRepo),
      myProfileProvider.overrideWith(
        (ref) async => const AppUser(id: 'me', displayName: 'Me'),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('vi'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const ChatPage(friendId: 'u2'),
    ),
  );

  testWidgets('shows fetched messages with sender-aware bubbles', (
    tester,
  ) async {
    final messageRepo = _FakeMessageRepository(
      initial: [
        ChatMessage(
          id: 'm1',
          senderId: 'u2',
          receiverId: 'me',
          content: 'Hallo!',
          createdAt: DateTime.now(),
        ),
      ],
    );

    await tester.pumpWidget(wrap(messageRepo, _FakeProfileRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Hallo!'), findsOneWidget);
  });

  testWidgets('sending a message posts it then refetches the thread (poll)', (
    tester,
  ) async {
    final messageRepo = _FakeMessageRepository(initial: const []);

    await tester.pumpWidget(wrap(messageRepo, _FakeProfileRepository()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Wie geht es dir?');
    await tester.tap(find.byIcon(PhosphorIcons.paperPlaneTilt));
    await tester.pumpAndSettle();

    expect(messageRepo.sentContents, ['Wie geht es dir?']);
    // The thread is re-fetched (poll) after send, so the new message shows.
    expect(find.text('Wie geht es dir?'), findsOneWidget);
  });
}

/// In-memory fake standing in for the poll-based thread: `getMessages`
/// returns whatever has been sent so far (mirrors the backend's append
/// behavior), matching `notification_center_screen_test.dart`'s pattern of
/// faking at the repository seam instead of scripting HTTP.
class _FakeMessageRepository extends MessageRepository {
  _FakeMessageRepository({required List<ChatMessage> initial})
    : _messages = List.of(initial),
      super(
        ApiClient(
          baseUrl: 'https://example.test/api/v1',
          tokenProvider: _NoTokenProvider(),
        ),
      );

  final List<ChatMessage> _messages;
  final List<String> sentContents = [];

  @override
  Future<List<ChatMessage>> getMessages(
    String friendId, {
    int limit = 40,
  }) async => List.of(_messages);

  @override
  Future<ChatMessage> sendMessage(String receiverId, String content) async {
    sentContents.add(content);
    final message = ChatMessage(
      id: 'm${_messages.length + 1}',
      senderId: 'me',
      receiverId: receiverId,
      content: content,
      createdAt: DateTime.now(),
    );
    _messages.add(message);
    return message;
  }

  @override
  Future<void> markAsRead(String senderId) async {}
}

class _FakeProfileRepository extends PublicProfileRepository {
  _FakeProfileRepository()
    : super(
        ApiClient(
          baseUrl: 'https://example.test/api/v1',
          tokenProvider: _NoTokenProvider(),
        ),
      );

  @override
  Future<SocialPublicProfile> getProfile(String userId) async =>
      SocialPublicProfile(
        id: userId,
        displayName: 'Maria',
        createdAt: '2026-01-01T00:00:00Z',
        isPremium: false,
        isOnline: true,
        level: 5,
        totalXp: 100,
        weeklyXp: 20,
        currentStreak: 3,
        longestStreak: 10,
        friendsCount: 2,
        totalFlashcards: 5,
        wordsLearned: 40,
        totalReviews: 60,
        weeklyRank: null,
        recentActivities: const [],
      );
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
