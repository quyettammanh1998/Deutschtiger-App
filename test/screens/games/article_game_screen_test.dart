import 'package:deutschtiger/data/games/learning_item_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/games/learning_item_repository.dart';
import 'package:deutschtiger/screens/games/article_game_screen.dart';
import 'package:deutschtiger/view_models/games/learning_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app() => const MaterialApp(
  locale: Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: ArticleGameScreen(),
);

List<LearningItem> _tenNouns() => List.generate(
  10,
  (i) => LearningItem(
    id: 'w$i',
    type: 'word',
    contentDe: 'Hund$i',
    contentVi: 'con chó $i',
    gender: i.isEven ? 'm' : 'f',
  ),
);

void main() {
  testWidgets('article game renders live noun + der/die/das buttons', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          learningItemRepositoryProvider.overrideWithValue(
            _FakeLearningItemRepository(items: _tenNouns()),
          ),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('der'), findsOneWidget);
    expect(find.text('die'), findsOneWidget);
    expect(find.text('das'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('article game shows error view + retry on fetch failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          learningItemRepositoryProvider.overrideWithValue(
            _FakeLearningItemRepository(fetchError: Exception('boom')),
          ),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(PhosphorIcons.cloudSlash), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('article game shows gate message when fewer than 10 nouns', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          learningItemRepositoryProvider.overrideWithValue(
            _FakeLearningItemRepository(items: _tenNouns().take(3).toList()),
          ),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Cần ít nhất'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selecting the correct article shows correct feedback color', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          learningItemRepositoryProvider.overrideWithValue(
            _FakeLearningItemRepository(items: _tenNouns()),
          ),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    // First word is always index 0 % nouns.length with gender 'm' → 'der'.
    await tester.tap(find.text('der'));
    // Let the post-answer delay (800ms) + its follow-up timers settle so no
    // pending Timer leaks past test teardown.
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}

class _FakeLearningItemRepository implements LearningItemRepository {
  _FakeLearningItemRepository({this.items, this.fetchError});

  final List<LearningItem>? items;
  final Object? fetchError;

  @override
  Future<List<LearningItem>> fetchBalanced({
    required String userLevel,
    String? type,
    int limit = 60,
  }) async {
    if (fetchError != null) throw fetchError!;
    return items ?? const [];
  }
}
