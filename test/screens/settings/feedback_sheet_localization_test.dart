import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/settings/widgets/feedback_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('feedback sheet localizes validation at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: const Scaffold(body: FeedbackSheet()),
          ),
        ),
      ),
    );

    expect(find.text('Feedback senden'), findsOneWidget);
    expect(find.text('Fehler melden'), findsOneWidget);
    expect(find.text('Vorschlag'), findsOneWidget);
    expect(find.text('Sonstiges'), findsOneWidget);
    expect(find.text('Senden'), findsOneWidget);

    await tester.tap(find.text('Senden'));
    await tester.pump();

    expect(find.text('Bitte gib dein Feedback ein.'), findsOneWidget);
  });
}
