import 'package:deutschtiger/data/learn/learn_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/learn/learn_repository.dart';
import 'package:deutschtiger/screens/learn/can_do_practice_screen.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/learn/learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('can-do practice screen submits a sentence and grades it', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          capabilityMapProvider.overrideWith((ref) async => _map),
          learnRepositoryProvider.overrideWith(
            (ref) => _FakeLearnRepository(),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: CanDoPracticeScreen(canDoId: 'c1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chào hỏi'), findsOneWidget);
    expect(find.text('Câu 1/1'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Hallo, wie geht es dir?');
    await tester.tap(find.text('Nộp câu'));
    await tester.pumpAndSettle();

    expect(find.textContaining('85/100'), findsOneWidget);
    expect(find.text('Hoàn thành'), findsOneWidget);
  });

  testWidgets('can-do practice screen shows all-clear when no laggards', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          capabilityMapProvider.overrideWith(
            (ref) async => const CapabilityMap(
              goal: 'comm_a1_a2',
              progressPct: 100,
              mastered: 1,
              total: 1,
              canDos: [
                CanDo(
                  id: 'c1',
                  labelVi: 'Chào hỏi',
                  labelDe: 'Begrüßen',
                  cefr: 'A1',
                  status: 'mastered',
                  spoken: true,
                  almostUnlocked: false,
                  members: [
                    CanDoMember(
                      kind: 'vocab',
                      key: 'Hallo',
                      ref: 'item-1',
                      label: 'Hallo',
                      rung: 3,
                    ),
                  ],
                  laggards: [],
                ),
              ],
              nextRoute: '/learn',
            ),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: CanDoPracticeScreen(canDoId: 'c1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Đã viết được hết các khối của mục tiêu này 🎉'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('can-do practice screen shows error view + retry', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          capabilityMapProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: CanDoPracticeScreen(canDoId: 'c1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không tải được dữ liệu. Vui lòng thử lại.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

const _map = CapabilityMap(
  goal: 'comm_a1_a2',
  progressPct: 40,
  mastered: 0,
  total: 1,
  canDos: [
    CanDo(
      id: 'c1',
      labelVi: 'Chào hỏi',
      labelDe: 'Begrüßen',
      cefr: 'A1',
      status: 'in_progress',
      spoken: false,
      almostUnlocked: true,
      members: [
        CanDoMember(
          kind: 'vocab',
          key: 'Hallo',
          ref: 'item-1',
          label: 'Hallo',
          rung: 0,
        ),
      ],
      laggards: ['Hallo'],
    ),
  ],
  nextRoute: '/learn',
);

class _FakeLearnRepository extends LearnRepository {
  _FakeLearnRepository()
    : super(
        ApiClient(
          baseUrl: 'https://example.test/api/v1',
          tokenProvider: _NoTokenProvider(),
        ),
      );

  @override
  Future<GradeSentenceResult> gradeSentence({
    required String promptWord,
    required String promptMeaning,
    required String userSentence,
    required String userLevel,
    required List<TargetBlockInput> targetBlocks,
  }) async {
    return const GradeSentenceResult(
      score: 85,
      correctedSentence: 'Hallo, wie geht es dir?',
      summaryVi: 'Câu đúng ngữ pháp.',
    );
  }
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
