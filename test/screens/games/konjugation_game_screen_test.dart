import 'package:deutschtiger/data/games/conjugation_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/games/conjugation_repository.dart';
import 'package:deutschtiger/repositories/games/grammar_drill_repository.dart';
import 'package:deutschtiger/screens/games/konjugation_game_screen.dart';
import 'package:deutschtiger/view_models/games/cases_provider.dart';
import 'package:deutschtiger/view_models/games/conjugation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _app = MaterialApp(
  locale: Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: KonjugationGameScreen(),
);

List<ConjugationExercise> _fiveExercises() => List.generate(
      5,
      (i) => ConjugationExercise(
        id: 'c$i',
        verb: 'haben',
        infinitive: 'haben',
        type: 'irregular',
        level: 'A1',
        tense: 'Präsens',
        person: 'ich',
        expected: 'habe',
        alternatives: const [],
        viVerb: 'có',
        prompt: 'ich (haben, Präsens)',
        key: 'haben:Präsens:ich:$i',
      ),
    );

void main() {
  testWidgets('konjugation trainer renders live exercise', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          conjugationRepositoryProvider.overrideWithValue(
            _FakeConjugationRepository(exercises: _fiveExercises()),
          ),
          grammarDrillRepositoryProvider.overrideWithValue(
            _FakeGrammarDrillRepository(),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('haben'), findsOneWidget);
    expect(find.text('ich'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('konjugation trainer shows error view + retry on fetch failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          conjugationRepositoryProvider.overrideWithValue(
            _FakeConjugationRepository(fetchError: Exception('boom')),
          ),
          grammarDrillRepositoryProvider.overrideWithValue(
            _FakeGrammarDrillRepository(),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('typing the correct form shows success feedback', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          conjugationRepositoryProvider.overrideWithValue(
            _FakeConjugationRepository(exercises: _fiveExercises()),
          ),
          grammarDrillRepositoryProvider.overrideWithValue(
            _FakeGrammarDrillRepository(),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('konjugation-input')), 'habe');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.textContaining('Chính xác'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeConjugationRepository implements ConjugationRepository {
  _FakeConjugationRepository({this.exercises = const [], this.fetchError});

  final List<ConjugationExercise> exercises;
  final Object? fetchError;

  @override
  Future<List<ConjugationExercise>> fetchExercises({
    required String level,
    String type = 'all',
    int limit = 30,
  }) async {
    if (fetchError != null) throw fetchError!;
    return exercises;
  }
}

class _FakeGrammarDrillRepository implements GrammarDrillRepository {
  @override
  Future<void> submitResults(
    String game,
    List<GrammarDrillResultInput> results,
  ) async {}
}
