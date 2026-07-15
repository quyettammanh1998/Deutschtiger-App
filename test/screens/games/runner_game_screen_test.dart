import 'package:deutschtiger/data/vocab/vocab_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/games/runner_game_screen.dart';
import 'package:deutschtiger/view_models/games/runner_game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _app = MaterialApp(
  locale: Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: RunnerGameScreen(),
);

const _words = [
  VocabWord(id: '1', word: 'Haus', translation: 'Nhà'),
  VocabWord(id: '2', word: 'Buch', translation: 'Sách'),
  VocabWord(id: '3', word: 'Wasser', translation: 'Nước'),
  VocabWord(id: '4', word: 'Auto', translation: 'Ô tô'),
];

void main() {
  testWidgets('runner game renders a live learned word as the quiz prompt', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          runnerGameWordsProvider.overrideWith((ref) async => _words),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      _words.any((w) => find.text(w.word).evaluate().isNotEmpty),
      isTrue,
    );
    expect(find.text('Chọn nghĩa đúng'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('runner game shows error view + retry on fetch failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          runnerGameWordsProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('runner game shows a guidance message when too few words are learned', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          runnerGameWordsProvider.overrideWith(
            (ref) async => _words.take(2).toList(),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Cần học ít nhất 4 từ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
