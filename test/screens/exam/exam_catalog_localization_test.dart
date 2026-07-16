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
/// network dependency entirely.
class _FixedLearningPreferencesNotifier extends LearningPreferencesNotifier {
  @override
  LearningPreferencesState build() => const LearningPreferencesState(
    preferences: LearningPreferences(cefrLevel: 'B1'),
    isLoading: false,
  );
}

void main() {
  testWidgets('exam landing localizes live-data chrome at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          learningPreferencesProvider.overrideWith(
            _FixedLearningPreferencesNotifier.new,
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

    // Header + subtitle (German ARB strings) render without overflow.
    expect(find.text('Prüfungsvorbereitung'), findsOneWidget);
    expect(find.text('Zertifikat & Niveau wählen'), findsOneWidget);

    // Provider cards (telc/Goethe/ÖSD) render below the fold at 200% scale —
    // scroll into view rather than asserting visibility without scrolling.
    await tester.dragUntilVisible(
      find.text('Goethe-Zertifikat'),
      find.byType(Scrollable).first,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();

    expect(find.text('Goethe-Zertifikat'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
