import 'package:deutschtiger/data/flashcard/review_item.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/flashcard/review_repository.dart';
import 'package:deutschtiger/screens/games/flashcard_game_screen.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/flashcard/review_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _app = MaterialApp(
  locale: Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: FlashcardGameScreen(),
);

void main() {
  testWidgets('flashcard game renders the front of a due card', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reviewRepositoryProvider.overrideWithValue(_FakeReviewRepository()),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Haus'), findsOneWidget);
    expect(find.text('Tap để lật'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('flashcard game shows error view + retry on fetch failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reviewRepositoryProvider.overrideWithValue(
            _FailingReviewRepository(),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('flashcard game shows guidance when no cards are due', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reviewRepositoryProvider.overrideWithValue(_EmptyReviewRepository()),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Không có thẻ nào đến hạn'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeReviewRepository extends ReviewRepository {
  _FakeReviewRepository()
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
  }) async => SrsReviewResult(
    cardReviewId: 'cr-1',
    nextDue: DateTime.now(),
    state: 2,
  );
}

class _EmptyReviewRepository extends _FakeReviewRepository {
  @override
  Future<List<ReviewItem>> fetchDue({int limit = 50, String? deckId}) async =>
      const [];
}

class _FailingReviewRepository extends _FakeReviewRepository {
  @override
  Future<List<ReviewItem>> fetchDue({int limit = 50, String? deckId}) async =>
      throw ApiException('network failed');
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
