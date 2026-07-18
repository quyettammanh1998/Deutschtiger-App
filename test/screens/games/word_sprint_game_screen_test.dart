import 'package:deutschtiger/data/vocab/vocab_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/games/word_sprint_game_screen.dart';
import 'package:deutschtiger/view_models/games/word_sprint_provider.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _app = MaterialApp(
  locale: Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: WordSprintGameScreen(),
);

const _words = [
  VocabWord(id: '1', word: 'Haus', translation: 'Nhà'),
  VocabWord(id: '2', word: 'Buch', translation: 'Sách'),
  VocabWord(id: '3', word: 'Wasser', translation: 'Nước'),
  VocabWord(id: '4', word: 'Auto', translation: 'Ô tô'),
];

void main() {
  testWidgets('word sprint renders live learned words as a quiz', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wordSprintWordsProvider.overrideWith((ref) async => _words),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    // Word card shows one of the loaded German words.
    expect(_words.any((w) => find.text(w.word).evaluate().isNotEmpty), isTrue);
    // 2x2 answer grid rendered.
    expect(find.byType(GestureDetector), findsWidgets);
    expect(tester.takeException(), isNull);

    // Dispose cleanly to cancel the round timer before the test ends.
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('word sprint shows error view + retry on fetch failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wordSprintWordsProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(PhosphorIcons.cloudSlash), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'word sprint shows a guidance message when too few words are learned',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            wordSprintWordsProvider.overrideWith(
              (ref) async => _words.take(2).toList(),
            ),
          ],
          child: _app,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Cần học ít nhất 4 từ'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
