import 'package:deutschtiger/features/exam/presentation/widgets/exam_dialogs.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget localized(Widget child) => MaterialApp(
    locale: const Locale('de'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(2)),
      child: Scaffold(body: child),
    ),
  );

  testWidgets('exit dialog localizes and returns its selected action', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      localized(
        Builder(
          builder: (context) => FilledButton(
            onPressed: () async => result = await showExitExamDialog(context),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Prüfung verlassen?'), findsOneWidget);
    expect(
      find.text('Dein Fortschritt wurde automatisch gespeichert.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Verlassen'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('submit dialog localizes unanswered count and can cancel', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      localized(
        Builder(
          builder: (context) => FilledButton(
            onPressed: () async =>
                result = await showSubmitExamDialog(context, 2),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Prüfung abgeben?'), findsOneWidget);
    expect(
      find.text('Du hast noch 2 unbeantwortete Fragen. Trotzdem abgeben?'),
      findsOneWidget,
    );
    await tester.tap(find.text('Antworten prüfen'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });
}
