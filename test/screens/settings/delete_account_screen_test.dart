import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/settings/delete_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'deletion screen remains honest and scrollable at German 200% on a short phone',
    (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 640),
              textScaler: TextScaler.linear(2),
            ),
            child: const DeleteAccountScreen(),
          ),
        ),
      );

      expect(
        find.text('Kontolöschung in der App ist noch nicht verfügbar'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('Support kontaktieren'), findsOneWidget);
      expect(find.text('Delete permanently'), findsNothing);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    },
  );
}
