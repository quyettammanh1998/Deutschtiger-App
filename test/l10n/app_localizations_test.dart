import 'package:deutschtiger/core/release/release_feature_flags.dart';
import 'package:deutschtiger/core/identity/app_user.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/profile/widgets/profile_header.dart';
import 'package:deutschtiger/screens/profile/widgets/profile_stats_grid.dart';
import 'package:deutschtiger/screens/settings/widgets/language_picker_sheet.dart';
import 'package:deutschtiger/screens/auth/welcome_screen.dart';
import 'package:deutschtiger/screens/auth/onboarding_screen.dart';
import 'package:deutschtiger/screens/auth/reset_password_screen.dart';
import 'package:deutschtiger/shared/widgets/more_features_sheet.dart';
import 'package:deutschtiger/widgets/dashboard/mobile_dashboard_header.dart';
import 'package:deutschtiger/widgets/dashboard/mobile_stats_card.dart';
import 'package:deutschtiger/widgets/dashboard/quick_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generated catalogs resolve the declared application locales', () async {
    final vietnamese = await AppLocalizations.delegate.load(const Locale('vi'));
    final english = await AppLocalizations.delegate.load(const Locale('en'));
    final german = await AppLocalizations.delegate.load(const Locale('de'));

    expect(vietnamese.settings, 'Cài đặt');
    expect(english.settings, 'Settings');
    expect(german.settings, 'Einstellungen');
    expect(german.profile, 'Profil');
    expect(german.cefrLevelsCount(1), '1 CEFR-Stufe');
    expect(german.cefrLevelsCount(6), '6 CEFR-Stufen');
    expect(german.avatarUrlOptional, 'Profilbild-URL (optional)');
    expect(german.saveChanges, 'Änderungen speichern');
    expect(
      english.couldNotUpdateProfile,
      'Could not update your profile. Please try again.',
    );
    expect(german.searchVocabulary, 'Wortschatz suchen...');
    expect(english.todayMissions, "Today's missions");
    expect(
      MobileDashboardHeader.timeGreeting(german, now: DateTime(2026, 7, 15, 8)),
      'Guten Morgen',
    );
    expect(MobileStatsCard.formatOnlineTime(german, 3900), '1 Std. 5 Min.');
    expect(english.signOutConfirm, 'Are you sure you want to sign out?');
    expect(english.couldNotOpenLink, 'This link could not be opened.');
    expect(german.ratingThanks, 'Danke für deine Bewertung!');
    expect(
      german.couldNotPlayAudio,
      'Audio konnte nicht abgespielt werden. Bitte versuche es erneut.',
    );
    expect(german.offlineMessage, contains('Internetverbindung'));
    expect(
      english.signOutDeviceBody('Pixel'),
      'The device "Pixel" will be signed out of your account.',
    );
  });

  testWidgets('language picker remains labeled at 200% text scale', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: LanguagePickerSheet(currentLanguage: 'de', onSelect: (_) {}),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Sprache auswählen'), findsWidgets);
    expect(find.bySemanticsLabel('Deutsch'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('more features dialog localizes semantic tile labels', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => MoreFeaturesSheet.show(context),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Alle Funktionen'), findsOneWidget);
    expect(find.bySemanticsLabel('Einstellungen'), findsOneWidget);
    if (ReleaseFeatureFlags.grammar) {
      await tester.scrollUntilVisible(
        find.text('Grammatik'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Grammatik'), findsOneWidget);
    }
    semantics.dispose();
  });

  testWidgets('more features dialog reflows German labels on a 200% phone viewport', (
    tester,
  ) async {
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
          child: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => MoreFeaturesSheet.show(context),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Web spec is a fixed 4-column grid (not a responsive reflow) — long
    // German labels line-clamp to 2 lines with an ellipsis instead.
    final grid = tester.widget<GridView>(find.byType(GridView).first);
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 4);

    await tester.scrollUntilVisible(
      find.text('Feedback'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Feedback'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home quick actions use the active localization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const Scaffold(body: QuickActions(totalWords: 100)),
      ),
    );

    // Lead "Luyện thi" tab + its tile render with the active locale.
    expect(find.text('🎓 Prüfungsvorbereitung'), findsOneWidget);
    expect(find.text('Prüfungsvorbereitung'), findsOneWidget);
    expect(find.text('Wortschatz & Wiederholung'), findsOneWidget);
  });

  testWidgets(
    'Welcome route localizes and keeps its login action reachable at 200%',
    (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: const WelcomeScreen(),
          ),
        ),
      );

      expect(
        find.textContaining('Deutsch lernen', findRichText: true),
        findsOneWidget,
      );
      expect(find.text('Lernen starten'), findsOneWidget);
      expect(find.bySemanticsLabel('Anmelden'), findsOneWidget);
      semantics.dispose();
    },
  );

  testWidgets(
    'Onboarding scrolls instead of overflowing at German 200% on a short phone',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('de'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(360, 640),
                textScaler: TextScaler.linear(2),
              ),
              child: const OnboardingScreen(),
            ),
          ),
        ),
      );

      expect(find.text('Überspringen'), findsOneWidget);
      expect(find.text('Wortschatz intelligent lernen'), findsOneWidget);
      expect(find.text('Weiter'), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Reset password route localizes its form and recovery action', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: const ResetPasswordScreen(),
        ),
      ),
    );

    expect(find.text('Passwort zurücksetzen'), findsWidgets);
    expect(find.text('Neues Passwort'), findsOneWidget);
    expect(find.text('Passwort bestätigen'), findsOneWidget);
  });

  testWidgets('Profile chrome localizes and reflows at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileHeader(
                    user: const AppUser(id: 'profile-user', isPremium: true),
                  ),
                  ProfileStatsGrid(
                    user: const AppUser(
                      id: 'profile-user',
                      level: 8,
                      totalXp: 420,
                      currentStreak: 3,
                      wordsLearned: 125,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Lernende:r'), findsOneWidget);
    expect(find.text('★ Premium'), findsOneWidget);
    expect(find.text('Stufe'), findsOneWidget);
    expect(find.text('Gelernte Wörter'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('release flags map every gated More-sheet route family', () {
    expect(
      ReleaseFeatureFlags.allowsMoreFeature('/grammar'),
      ReleaseFeatureFlags.grammar,
    );
    expect(
      ReleaseFeatureFlags.allowsMoreFeature('/listening'),
      ReleaseFeatureFlags.listening,
    );
    expect(
      ReleaseFeatureFlags.allowsMoreFeature('/ai-tutor/chat'),
      ReleaseFeatureFlags.aiTutor,
    );
    expect(
      ReleaseFeatureFlags.allowsMoreFeature('/games'),
      ReleaseFeatureFlags.games,
    );
    expect(
      ReleaseFeatureFlags.allowsMoreFeature('/social'),
      ReleaseFeatureFlags.social,
    );
    expect(
      ReleaseFeatureFlags.allowsMoreFeature('/stats'),
      ReleaseFeatureFlags.stats,
    );
    expect(
      ReleaseFeatureFlags.allowsMoreFeature('/achievements'),
      ReleaseFeatureFlags.achievements,
    );
    expect(ReleaseFeatureFlags.journey, isTrue);
    expect(ReleaseFeatureFlags.reading, isTrue);
    expect(ReleaseFeatureFlags.allowsMoreFeature('/leaderboard'), isTrue);
  });
}
