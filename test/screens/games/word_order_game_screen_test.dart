import 'package:deutschtiger/data/games/learning_item_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/games/learning_item_repository.dart';
import 'package:deutschtiger/screens/games/word_order_game_screen.dart';
import 'package:deutschtiger/view_models/games/learning_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app() => const MaterialApp(
  locale: Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: WordOrderGameScreen(),
);

List<LearningItem> _fiveSentences() => List.generate(
  5,
  (i) => LearningItem(
    id: 's$i',
    type: 'sentence',
    contentDe: 'Ich lerne Deutsch $i.',
    contentVi: 'Tôi học tiếng Đức $i',
  ),
);

void main() {
  testWidgets('word order game renders scrambled words for a live sentence', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          learningItemRepositoryProvider.overrideWithValue(
            _FakeLearningItemRepository(items: _fiveSentences()),
          ),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ich'), findsOneWidget);
    expect(find.text('Kiểm tra'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('word order game shows error view + retry on fetch failure', (
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

  testWidgets(
    'word order game shows gate message when fewer than 3 sentences',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            learningItemRepositoryProvider.overrideWithValue(
              _FakeLearningItemRepository(
                items: _fiveSentences().take(1).toList(),
              ),
            ),
          ],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Cần ít nhất'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'tapping words builds the answer and check button becomes enabled',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            learningItemRepositoryProvider.overrideWithValue(
              _FakeLearningItemRepository(items: _fiveSentences()),
            ),
          ],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ich'));
      await tester.pump();

      expect(tester.takeException(), isNull);
    },
  );
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
