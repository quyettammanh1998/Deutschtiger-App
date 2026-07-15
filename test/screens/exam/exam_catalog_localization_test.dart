import 'package:deutschtiger/features/exam/data/exam_service.dart';
import 'package:deutschtiger/features/exam/presentation/exam_player_provider.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/exam_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exam catalog localizes live-data chrome at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
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
    expect(find.text('30 Fragen'), findsOneWidget);
    expect(find.text('65 Min.'), findsOneWidget);
    expect(find.text('Üben'), findsOneWidget);
    expect(find.text('Probeprüfung'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
