import 'package:deutschtiger/data/games/cases_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/games/cases_repository.dart';
import 'package:deutschtiger/repositories/games/grammar_drill_repository.dart';
import 'package:deutschtiger/screens/games/cases/verb_case_quiz_screen.dart';
import 'package:deutschtiger/view_models/games/cases_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _app = MaterialApp(
  locale: Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: VerbCaseQuizScreen(),
);

List<VerbCaseItem> _fiveItems() => List.generate(
      5,
      (i) => VerbCaseItem(
        id: 'v$i',
        level: 'A2',
        verb: 'helfen',
        caseType: 'Dativ',
        example: 'Ich helfe dem Mann.',
        viExample: 'Tôi giúp người đàn ông.',
        viVerb: 'giúp đỡ',
      ),
    );

void main() {
  testWidgets('verb case quiz renders live items', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          casesRepositoryProvider.overrideWithValue(
            _FakeCasesRepository(verbCaseItems: _fiveItems()),
          ),
          grammarDrillRepositoryProvider.overrideWithValue(
            _FakeGrammarDrillRepository(),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('helfen'), findsOneWidget);
    expect(find.text('Dativ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('verb case quiz shows error view + retry on fetch failure', (
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
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('picking the correct case shows success feedback', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          casesRepositoryProvider.overrideWithValue(
            _FakeCasesRepository(verbCaseItems: _fiveItems()),
          ),
          grammarDrillRepositoryProvider.overrideWithValue(
            _FakeGrammarDrillRepository(),
          ),
        ],
        child: _app,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dativ'));
    await tester.pump();

    expect(find.textContaining('Chính xác'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeCasesRepository implements CasesRepository {
  _FakeCasesRepository({this.verbCaseItems = const [], this.fetchError});

  final List<VerbCaseItem> verbCaseItems;
  final Object? fetchError;

  @override
  Future<CaseExercisesResponse> fetchAkkDat({
    required String level,
    int limit = 30,
  }) async => const CaseExercisesResponse(exercises: []);

  @override
  Future<CaseExercisesResponse> fetchAdjektiv({
    required String level,
    int limit = 30,
  }) async => const CaseExercisesResponse(exercises: []);

  @override
  Future<CaseExercisesResponse> fetchWechselprep({
    required String level,
    int limit = 30,
  }) async => const CaseExercisesResponse(exercises: []);

  @override
  Future<VerbCaseResponse> fetchVerbCase({
    required String level,
    int limit = 15,
  }) async {
    if (fetchError != null) throw fetchError!;
    return VerbCaseResponse(items: verbCaseItems);
  }
}

class _FakeGrammarDrillRepository implements GrammarDrillRepository {
  @override
  Future<void> submitResults(
    String game,
    List<GrammarDrillResultInput> results,
  ) async {}

  @override
  Future<GrammarExplainResult> explainGrammar(
    GrammarExplainRequest request,
  ) async => const GrammarExplainResult(explanation: '', ok: false, cached: false);
}
