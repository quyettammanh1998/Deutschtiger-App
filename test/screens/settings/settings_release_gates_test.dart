import 'package:deutschtiger/core/release/release_feature_flags.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/previews/preview_auth_service.dart';
import 'package:deutschtiger/screens/settings/settings_screen.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Settings root shows nav rows, gates AI memory by flag', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        // ProfileEditCard reads authServiceProvider (email) + myProfileProvider
        // (auth-state-gated fetch) — override auth so the test doesn't need a
        // real Supabase.initialize() call.
        overrides: [authServiceProvider.overrideWithValue(PreviewAuthService())],
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
      find.text('Passwort ändern'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Passwort ändern'), findsOneWidget);
    // Assertions follow tile order top-to-bottom because scrollUntilVisible
    // only scrolls forward: AI memory row sits above the feedback row.
    if (ReleaseFeatureFlags.aiTutor) {
      await tester.scrollUntilVisible(
        find.text('KI-Speicher & Einstellungen'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('KI-Speicher & Einstellungen'), findsOneWidget);
    } else {
      expect(find.text('KI-Speicher & Einstellungen'), findsNothing);
    }
    await tester.scrollUntilVisible(
      find.text('Feedback senden'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Abmelden'), findsOneWidget);
  });
}
