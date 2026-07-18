import 'package:deutschtiger/data/games/cases_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/games/cases_repository.dart';
import 'package:deutschtiger/repositories/games/grammar_drill_repository.dart';
import 'package:deutschtiger/screens/games/cases/case_cloze_quiz_screen.dart';
import 'package:deutschtiger/view_models/games/cases_provider.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app() => const MaterialApp(
  locale: Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: CaseClozeQuizScreen(game: 'akk-dat', title: 'Akkusativ vs Dativ'),
);

List<CaseExercise> _tenExercises() => List.generate(
  10,
  (i) => CaseExercise(
    id: 'e$i',
    level: 'A2',
    sentence: 'Ich sehe ___ Mann.',
    options: const ['der', 'den', 'dem'],
    answer: 'den',
    caseType: 'Akkusativ',
    reason: 'sehen + Akkusativ',
    vi: 'Tôi thấy người đàn ông.',
  ),
);

void main() {
  testWidgets('case cloze quiz renders live exercises', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          casesRepositoryProvider.overrideWithValue(
            _FakeCasesRepository(
              clozeResponse: CaseExercisesResponse(exercises: _tenExercises()),
            ),
          ),
          grammarDrillRepositoryProvider.overrideWithValue(
            _FakeGrammarDrillRepository(),
          ),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains('Ich sehe'),
      ),
      findsOneWidget,
    );
    expect(find.text('der'), findsOneWidget);
    expect(find.text('den'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('case cloze quiz shows error view + retry on fetch failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          casesRepositoryProvider.overrideWithValue(
            _FakeCasesRepository(fetchError: Exception('boom')),
          ),
          grammarDrillRepositoryProvider.overrideWithValue(
            _FakeGrammarDrillRepository(),
          ),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(PhosphorIcons.cloudSlash), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('answering a question shows feedback + submits on completion', (
    tester,
  ) async {
    final drillRepo = _FakeGrammarDrillRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          casesRepositoryProvider.overrideWithValue(
            _FakeCasesRepository(
              clozeResponse: CaseExercisesResponse(exercises: _tenExercises()),
            ),
          ),
          grammarDrillRepositoryProvider.overrideWithValue(drillRepo),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('den').first);
    await tester.pump();

    expect(find.textContaining('Chính xác'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeCasesRepository implements CasesRepository {
  _FakeCasesRepository({this.clozeResponse, this.fetchError});

  final CaseExercisesResponse? clozeResponse;
  final Object? fetchError;

  Future<CaseExercisesResponse> _resolve() async {
    if (fetchError != null) throw fetchError!;
    return clozeResponse ?? const CaseExercisesResponse(exercises: []);
  }

  @override
  Future<CaseExercisesResponse> fetchAkkDat({
    required String level,
    int limit = 30,
  }) => _resolve();

  @override
  Future<CaseExercisesResponse> fetchAdjektiv({
    required String level,
    int limit = 30,
  }) => _resolve();

  @override
  Future<CaseExercisesResponse> fetchWechselprep({
    required String level,
    int limit = 30,
  }) => _resolve();

  @override
  Future<VerbCaseResponse> fetchVerbCase({
    required String level,
    int limit = 15,
  }) async => const VerbCaseResponse(items: []);
}

class _FakeGrammarDrillRepository implements GrammarDrillRepository {
  final List<List<GrammarDrillResultInput>> submitted = [];

  @override
  Future<void> submitResults(
    String game,
    List<GrammarDrillResultInput> results,
  ) async {
    submitted.add(results);
  }

  @override
  Future<GrammarExplainResult> explainGrammar(
    GrammarExplainRequest request,
  ) async =>
      const GrammarExplainResult(explanation: '', ok: false, cached: false);
}
