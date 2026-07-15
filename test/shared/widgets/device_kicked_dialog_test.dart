import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/shared/widgets/device_kicked_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('device-kicked dialog localizes and acknowledges at 200%', (
    tester,
  ) async {
    var acknowledged = false;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(360, 800),
            textScaler: TextScaler.linear(2),
          ),
          child: Scaffold(
            body: DeviceKickedDialog(onAcknowledge: () => acknowledged = true),
          ),
        ),
      ),
    );

    expect(find.text('Deine Sitzung wurde beendet'), findsOneWidget);
    expect(
      find.text(
        'Dieses Gerät wurde abgemeldet. Bitte melde dich erneut an, um fortzufahren.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Erneut anmelden'));
    await tester.pump();

    expect(acknowledged, isTrue);
    expect(tester.takeException(), isNull);
  });
}
