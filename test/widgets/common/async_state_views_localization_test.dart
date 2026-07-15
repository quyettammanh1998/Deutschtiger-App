import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shared error view localizes its default and retry action', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(body: ErrorView(onRetry: _noop)),
        ),
      ),
    );

    expect(
      find.text(
        'Daten konnten nicht geladen werden. Bitte versuche es erneut.',
      ),
      findsOneWidget,
    );
    expect(find.text('Erneut versuchen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void _noop() {}
