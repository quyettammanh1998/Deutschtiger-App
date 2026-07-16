// Regression coverage for the sprechen-exam ARB extraction pass: German is
// the longest of the 3 supported languages, so every widget touched by that
// pass gets a smoke render at 200% text scale to catch RenderFlex overflow.
import 'package:deutschtiger/data/speech/sprechen_chat_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/exam/sprechen/widgets/sprechen_bewertung_panel.dart';
import 'package:deutschtiger/screens/exam/sprechen/widgets/sprechen_exam_header.dart';
import 'package:deutschtiger/screens/exam/sprechen/widgets/sprechen_input_area.dart';
import 'package:deutschtiger/screens/exam/sprechen/widgets/sprechen_instruction_banner.dart';
import 'package:deutschtiger/screens/exam/sprechen/widgets/sprechen_study_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget localized(Widget child, {Size size = const Size(360, 800)}) =>
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: MediaQueryData(size: size, textScaler: const TextScaler.linear(2)),
          child: Scaffold(body: SingleChildScrollView(child: child)),
        ),
      );

  testWidgets('SprechenExamHeader (study tab) does not overflow at German 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized(
        const SprechenExamHeader(
          title: 'Sprechen — familie-und-freunde',
          subtitle: 'goethe-teil2 · 25 Punkte',
          isPracticeTab: false,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('SprechenExamHeader (practice tab, timer) does not overflow at German 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized(
        const SprechenExamHeader(
          title: 'Sprechen — familie-und-freunde',
          subtitle: 'goethe-teil2 · 25 Punkte',
          isPracticeTab: true,
          remaining: Duration(minutes: 5, seconds: 30),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('SprechenBewertungPanel with grading does not overflow at German 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized(
        const SprechenBewertungPanel(
          grading: SprechenGrading(
            total: 20,
            max: 25,
            inhalt: 7,
            grammatik: 6,
            wortschatz: 7,
            mainErrors: ['Falscher Artikel bei "der Tisch"', 'Verb an Position 2 fehlt'],
          ),
          isRunning: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('SprechenInstructionBanner does not overflow at German 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized(
        SprechenInstructionBanner(
          aufgabe:
              'Beschreiben Sie Ihre Familie und erzählen Sie, wie oft Sie sich sehen.',
          hinweis: 'Bấm START để bắt đầu nói.',
          onWordTap: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('SprechenStudyPanel locked state does not overflow at German 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized(const SprechenStudyPanel(markdown: '', locked: true)),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Premium'), findsOneWidget);
  });

  testWidgets('SprechenStudyPanel empty state does not overflow at German 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized(const SprechenStudyPanel(markdown: '', locked: false)),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('SprechenInputArea does not overflow at German 200%', (
    tester,
  ) async {
    await tester.pumpWidget(
      localized(
        SprechenInputArea(
          onSend: (_) {},
          onFetchSuggestions: () async => const [],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
