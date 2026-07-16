import 'package:deutschtiger/data/learn/learn_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/learn/learner_model_screen.dart';
import 'package:deutschtiger/view_models/learn/learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('learner model screen renders mastery + weak words + can-dos', (
    tester,
  ) async {
    // Viewport lớn để ListView build hết children (không chỉ phần visible ở
    // kích thước mặc định) — cần thấy weak word cuối danh sách.
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          learnerModelProvider.overrideWith((ref) async => _model),
          capabilityMapProvider.overrideWith((ref) async => _map),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: LearnerModelScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hồ sơ năng lực'), findsOneWidget);
    expect(find.text('30%'), findsOneWidget);
    expect(find.text('laufen'), findsOneWidget);
    expect(find.text('Chào hỏi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('learner model screen shows empty weak-words state', (
    tester,
  ) async {
    // More sections render above weak-words now (readiness/PageIntro/mastery
    // card) — a taller surface keeps the weak-words empty state in the
    // ListView's built range without needing an explicit scroll.
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          learnerModelProvider.overrideWith(
            (ref) async => const LearnerModel(
              totalCards: 0,
              matureCards: 0,
              maturePct: 0,
              dueNow: 0,
              weakTotal: 0,
              coverageByLevel: [],
              weakWords: [],
              grammarWeaknesses: [],
              readiness: LearnerReadiness(
                pct: 0,
                low: 0,
                high: 0,
                hasData: false,
              ),
            ),
          ),
          capabilityMapProvider.overrideWith(
            (ref) async => const CapabilityMap(
              goal: 'comm_a1_a2',
              progressPct: 0,
              mastered: 0,
              total: 0,
              canDos: [],
              nextRoute: '/learn',
            ),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: LearnerModelScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa có từ nào cần luyện thêm. Tuyệt vời!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('learner model screen shows error view + retry', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          learnerModelProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: LearnerModelScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Không tải được dữ liệu. Vui lòng thử lại.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

const _model = LearnerModel(
  totalCards: 100,
  matureCards: 30,
  maturePct: 30,
  dueNow: 4,
  weakTotal: 1,
  coverageByLevel: [LevelCoverage(level: 'A1', total: 50, mature: 20)],
  weakWords: [
    LearnerWeakWord(
      learningItemId: 'w1',
      contentDe: 'laufen',
      contentVi: 'chạy',
      level: 'A1',
      lapses: 3,
    ),
  ],
  grammarWeaknesses: [],
  readiness: LearnerReadiness(pct: 55, low: 40, high: 70, hasData: true),
);

const _map = CapabilityMap(
  goal: 'comm_a1_a2',
  progressPct: 40,
  mastered: 2,
  total: 5,
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
        CanDoMember(kind: 'vocab', key: 'Hallo', ref: 'item-1', label: 'Hallo', rung: 1),
      ],
      laggards: ['Hallo'],
    ),
  ],
  nextRoute: '/learn',
);
