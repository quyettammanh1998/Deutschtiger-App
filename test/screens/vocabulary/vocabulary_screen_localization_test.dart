import 'package:deutschtiger/features/vocabulary/domain/vocabulary_models.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_provider.dart';
import 'package:deutschtiger/features/vocabulary/presentation/vocabulary_screen.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('vocabulary library localizes its live-data chrome at 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vocabularyPageDataProvider.overrideWith(
            (ref) async => VocabularyPageData(
              levelCounts: const [LevelCount(level: 'A1', count: 10)],
            ),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: const VocabularyScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Wortschatz'), findsOneWidget);
    expect(find.text('10 Wörter'), findsOneWidget);
    expect(find.text('1 CEFR-Stufe'), findsOneWidget);
    expect(find.text('🎯 Nach Zielen'), findsOneWidget);
    expect(find.text('🧭 Nach Niveau'), findsOneWidget);
    expect(find.text('📚 Nach Thema'), findsOneWidget);
    expect(find.text('Deutsch für den Alltag'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
