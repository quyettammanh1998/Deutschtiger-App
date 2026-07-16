import 'package:deutschtiger/features/exam/data/exam_service.dart';
import 'package:deutschtiger/features/exam/presentation/exam_player_provider.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/settings/learning_preferences_repository.dart';
import 'package:deutschtiger/screens/exam/exam_screen.dart';
import 'package:deutschtiger/view_models/settings/learning_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// [ExamProviderCards] (rendered by [ExamScreen]) reads the user's saved
/// CEFR level via [learningPreferencesProvider]. The real notifier fetches
/// it from `GET /user/preferences` (via [apiClientProvider] ->
/// [supabaseClientProvider]), which requires `Supabase.initialize` — not
/// done in widget tests. A fixed, already-loaded state sidesteps that
/// network dependency entirely (this widget test only cares about the
/// catalog's localized text at 200% scale, not the recommended-level pill).
class _FixedLearningPreferencesNotifier extends LearningPreferencesNotifier {
  @override
  LearningPreferencesState build() => const LearningPreferencesState(
    preferences: LearningPreferences(cefrLevel: 'B1'),
    isLoading: false,
  );
}

void main() {
  testWidgets('exam catalog localizes live-data chrome at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          learningPreferencesProvider.overrideWith(
            _FixedLearningPreferencesNotifier.new,
          ),
          examCatalogProvider.overrideWith(
            (ref) async => const [
              ExamCatalogItem(
                slug: 'goethe-b1-1',
                title: 'Goethe B1 Lesen',
                titleVi: 'Goethe B1 Đọc hiểu',
                provider: 'goethe',
                level: 'B1',
                parts: [
                  ExamCatalogPart(
                    skill: 'lesen',
                    durationMinutes: 65,
                    totalQuestions: 30,
                  ),
                ],
              ),
            ],
          ),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: const ExamScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Prüfungsvorbereitung'), findsOneWidget);
    expect(find.text('Alle'), findsOneWidget);

    // At 200% text scale the provider-cards + filters header (rendered
    // above the catalog inside the same scroll view — see ExamScreen's
    // `header:` param on ExamCatalogList) grows well past the test
    // viewport's height, so the catalog card sits below the fold. This
    // mirrors real device/user behavior (scroll to see more of a list) —
    // scroll it into view rather than asserting it's visible without
    // scrolling.
    await tester.dragUntilVisible(
      find.text('30 Fragen'),
      find.byType(Scrollable).first,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();

    expect(find.text('30 Fragen'), findsOneWidget);
    expect(find.text('65 Min.'), findsOneWidget);
    expect(find.text('Üben'), findsOneWidget);
    expect(find.text('Probeprüfung'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
