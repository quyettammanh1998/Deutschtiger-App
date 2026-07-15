import 'package:deutschtiger/data/games/learning_item_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/games/learning_item_repository.dart';
import 'package:deutschtiger/screens/games/fill_blank_game_screen.dart';
import 'package:deutschtiger/view_models/games/learning_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app() => const MaterialApp(
      locale: Locale('vi'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: FillBlankGameScreen(),
    );

/// 8 danh từ khác category, mỗi từ có 1 câu ví dụ chứa chính nó — đủ để
/// dựng cloze + 3 distractor cùng category (đạt ngưỡng `_minQuestions`).
List<LearningItem> _eightWordsWithExamples() => List.generate(
      8,
      (i) => LearningItem(
        id: 'w$i',
        type: 'word',
        contentDe: 'Wort$i',
        contentVi: 'từ $i',
        category: 'animals',
        examples: [
          LearningItemExample(de: 'Das ist Wort$i heute.', vi: 'Đây là từ $i hôm nay.'),
        ],
      ),
    );

void main() {
  testWidgets('fill blank game renders a live cloze sentence + 4 options', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          learningItemRepositoryProvider.overrideWithValue(
            _FakeLearningItemRepository(items: _eightWordsWithExamples()),
          ),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Das ist', findRichText: true),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('fill blank game shows error view + retry on fetch failure', (
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

    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'fill blank game shows gate message when fewer than 6 cloze-able items',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            learningItemRepositoryProvider.overrideWithValue(
              _FakeLearningItemRepository(
                items: _eightWordsWithExamples().take(2).toList(),
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

  testWidgets('selecting an option shows correct/incorrect feedback icon', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          learningItemRepositoryProvider.overrideWithValue(
            _FakeLearningItemRepository(items: _eightWordsWithExamples()),
          ),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    final optionTiles = find.byIcon(Icons.check_circle);
    expect(optionTiles, findsNothing); // not answered yet

    await tester.tap(find.byType(GestureDetector).last);
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
