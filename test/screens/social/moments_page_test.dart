import 'package:deutschtiger/data/social/moment_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/social/moment_repository.dart';
import 'package:deutschtiger/screens/social/moments_page.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/social/social_repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(MomentRepository repo) => ProviderScope(
    overrides: [momentRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      locale: const Locale('vi'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const MomentsPage(),
    ),
  );

  Moment buildMoment({required bool isLiked, required int likeCount}) => Moment(
    id: 'm1',
    userId: 'u2',
    content: 'Hallo Welt',
    tags: const [],
    createdAt: DateTime.now(),
    displayName: 'Maria',
    avatarUrl: '',
    likeCount: likeCount,
    commentCount: 2,
    isLiked: isLiked,
  );

  testWidgets('shows the moments feed', (tester) async {
    final repo = _FakeMomentRepository(
      feed: [buildMoment(isLiked: false, likeCount: 3)],
    );

    await tester.pumpWidget(wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Maria'), findsOneWidget);
    expect(find.text('Hallo Welt'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('shows the empty state when the feed is empty', (tester) async {
    await tester.pumpWidget(wrap(_FakeMomentRepository(feed: const [])));
    await tester.pumpAndSettle();

    expect(find.text('Chưa có khoảnh khắc nào'), findsOneWidget);
  });

  testWidgets('tapping the like button calls MomentRepository.like', (tester) async {
    final repo = _FakeMomentRepository(
      feed: [buildMoment(isLiked: false, likeCount: 3)],
    );

    await tester.pumpWidget(wrap(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();

    expect(repo.likedMomentIds, ['m1']);
    expect(find.text('4'), findsOneWidget);
  });
}

/// In-memory fake used instead of a scripted [ApiClient] adapter, mirroring
/// `notification_center_screen_test.dart`'s pattern.
class _FakeMomentRepository extends MomentRepository {
  _FakeMomentRepository({required List<Moment> feed})
    : _feed = feed,
      super(ApiClient(baseUrl: 'https://example.test/api/v1', tokenProvider: _NoTokenProvider()));

  final List<Moment> _feed;
  final List<String> likedMomentIds = [];

  @override
  Future<List<Moment>> getFeed({int limit = 20, int offset = 0}) async => _feed;

  @override
  Future<void> like(String momentId) async {
    likedMomentIds.add(momentId);
  }

  @override
  Future<void> unlike(String momentId) async {}
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
