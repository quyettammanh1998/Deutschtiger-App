import 'package:deutschtiger/data/flashcard/review_item.dart';
import 'package:deutschtiger/repositories/flashcard/review_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/flashcard/review_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('failed FSRS grading keeps the current card for retry', () async {
    final repository = _FailingReviewRepository();
    final container = ProviderContainer(
      overrides: [reviewRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    final provider = reviewSessionProvider(
      const ReviewSessionScope(mode: 'daily_review'),
    );
    final subscription = container.listen(provider, (_, _) {});
    addTearDown(subscription.close);
    await container.read(provider.future);

    final saved = await container
        .read(provider.notifier)
        .rateCurrent(ReviewRating.medium);
    final state = container.read(provider).requireValue;

    expect(saved, isFalse);
    expect(state.index, 0);
    expect(state.ratedCount, 0);
    expect(state.current?.learningItemId, 'item-1');
    expect(state.error, ReviewSessionError.ratingNotSaved);
  });

  test(
    'deck review scope reaches the repository without client filtering',
    () async {
      final repository = _DeckScopedReviewRepository();
      final container = ProviderContainer(
        overrides: [reviewRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      const scope = ReviewSessionScope(mode: 'flashcard', deckId: 'deck-1');
      final provider = reviewSessionProvider(scope);
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);

      final state = await container.read(provider.future);

      expect(repository.requestedDeckId, 'deck-1');
      expect(state.items.single.sourceFlashcardId, 'card-1');
    },
  );
}

class _DeckScopedReviewRepository extends _FailingReviewRepository {
  String? requestedDeckId;

  @override
  Future<List<ReviewItem>> fetchDue({int limit = 50, String? deckId}) async {
    requestedDeckId = deckId;
    return const [
      ReviewItem(sourceFlashcardId: 'card-1', wordDe: 'Haus', wordVi: 'nhà'),
    ];
  }
}

class _FailingReviewRepository extends ReviewRepository {
  _FailingReviewRepository()
    : super(
        ApiClient(
          baseUrl: 'https://example.test/api/v1',
          tokenProvider: _NoTokenProvider(),
        ),
      );

  @override
  Future<List<ReviewItem>> fetchDue({int limit = 50, String? deckId}) async =>
      const [
        ReviewItem(
          learningItemId: 'item-1',
          sourceFlashcardId: 'card-1',
          contentDe: 'Haus',
          contentVi: 'nhà',
        ),
      ];

  @override
  Future<SrsReviewResult> rate(
    ReviewItem item,
    ReviewRating rating, {
    required Duration responseTime,
    required String mode,
  }) async {
    throw ApiException('network failed');
  }
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
