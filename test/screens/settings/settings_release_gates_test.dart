import 'package:deutschtiger/core/release/release_feature_flags.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/settings/settings_screen.dart';
import 'package:deutschtiger/screens/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Settings hides entries without a release-ready route', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Einstellungen'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.widgetWithText(SettingsTile, 'Daten exportieren'),
      300,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Passwort ändern'), findsNothing);
    expect(find.text('E-Mail-Adresse ändern'), findsNothing);
    // Assertions follow tile order top-to-bottom because scrollUntilVisible
    // only scrolls forward: AI memory tile sits above the feedback tile.
    if (ReleaseFeatureFlags.aiTutor) {
      await tester.scrollUntilVisible(
        find.widgetWithText(SettingsTile, 'KI-Speicher & Einstellungen'),
        300,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('KI-Speicher & Einstellungen'), findsOneWidget);
    } else {
      expect(find.text('KI-Speicher & Einstellungen'), findsNothing);
    }
    await tester.scrollUntilVisible(
      find.widgetWithText(SettingsTile, 'Feedback senden'),
      300,
      scrollable: find.byType(Scrollable),
    );
  });
}
