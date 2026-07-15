import 'package:deutschtiger/data/games/game_models.dart';
import 'package:deutschtiger/features/games/widgets/game_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const question = GameQuestion(
    id: 'article-1',
    word: 'Katze',
    translation: 'Con mèo',
    options: ['der', 'die', 'das'],
    correctIndex: 1,
  );

  Widget buildGame({
    required List<GameQuestion> questions,
    required ValueChanged<GameResult> onComplete,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: GameBase(
          gameType: GameType.article,
          questions: questions,
          showTimer: false,
          onComplete: onComplete,
        ),
      ),
    );
  }

  testWidgets('grades an answer and returns the game result', (tester) async {
    GameResult? result;
    await tester.pumpWidget(
      buildGame(
        questions: const [question],
        onComplete: (value) => result = value,
      ),
    );

    expect(find.text('Katze'), findsOneWidget);
    expect(find.text('Con mèo'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'die'));
    await tester.pump(const Duration(milliseconds: 800));

    expect(result, isNotNull);
    expect(result!.correct, 1);
    expect(result!.total, 1);
    expect(result!.wrongItemIds, isEmpty);
  });

  testWidgets('shows an empty state when no questions are available', (
    tester,
  ) async {
    await tester.pumpWidget(buildGame(questions: const [], onComplete: (_) {}));

    expect(find.text('Chưa có câu hỏi.'), findsOneWidget);
  });
}
