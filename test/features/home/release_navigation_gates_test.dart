import 'package:deutschtiger/core/release/release_feature_flags.dart';
import 'package:deutschtiger/features/daily_path/domain/daily_path.dart';
import 'package:deutschtiger/features/daily_path/presentation/daily_path_route_resolver.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/home/widgets/dashboard_sections.dart';
import 'package:deutschtiger/widgets/common/app_shell.dart';
import 'package:deutschtiger/widgets/dashboard/mobile_dashboard_header.dart';
import 'package:deutschtiger/widgets/dashboard/mobile_stats_card.dart';
import 'package:deutschtiger/widgets/dashboard/quick_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  locale: const Locale('en'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  test('unsupported daily-path skills return to the live Learn hub', () {
    // Grammar now has a verified live data contract (see
    // `docs/flutter-live-data-inventory.md`), so its release flag defaults to
    // `true` and the daily path resolves straight to `/grammar`.
    const grammar = DailyPathStep(
      key: 'grammar',
      skill: 'grammar',
      title: 'Grammar',
      description: 'Grammar practice',
      route: '/grammar',
      estimatedMinutes: 5,
      done: false,
      premium: false,
    );
    const reading = DailyPathStep(
      key: 'reading',
      skill: 'reading',
      title: 'Reading',
      description: 'Reading practice',
      route: '/reading',
      estimatedMinutes: 5,
      done: false,
      premium: false,
    );

    // Reading now has a verified live data contract too (see
    // `docs/flutter-live-data-inventory.md`), so its release flag defaults to
    // `true` and the daily path resolves straight to `/reading`.
    expect(resolveDailyPathRoute(grammar), '/grammar');
    expect(resolveDailyPathRoute(reading), '/reading');
    expect(resolveDailyPathRoute(null), '/learn');
  });

  test('bottom navigation hides the gated AI branch by default', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final tabs = appShellTabs(l10n);

    expect(
      tabs.any((tab) => tab.branchIndex == 3),
      ReleaseFeatureFlags.aiTutor,
      reason: 'The AI tutor branch must follow its compile-time release flag.',
    );
    expect(tabs.last.opensMoreSheet, isTrue);
  });

  testWidgets('Home components hide gated navigation affordances', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const Column(
          children: [
            MobileDashboardHeader(
              displayName: 'Mai',
              streak: 0,
              showMessages: false,
            ),
            MobileStatsCard(
              totalWordsLearned: 1,
              totalLookups: 1,
              streak: 0,
              showDetails: false,
            ),
            QuickActions(
              onLearnTap: _noop,
              onReviewTap: _noop,
              onExamTap: _noop,
              showAi: false,
            ),
            DashboardMissionsSection(missions: [], onSeeAllTap: null),
          ],
        ),
      ),
    );

    expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsNothing);
    expect(find.text('Xem chi tiết'), findsNothing);
    expect(find.text('AI'), findsNothing);
    expect(find.text('Xem tất cả'), findsNothing);
  });

  testWidgets('quick actions reflow German labels at 200% text scale', (
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
              child: QuickActions(
                onLearnTap: _noop,
                onReviewTap: _noop,
                onExamTap: _noop,
                showAi: false,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Wrap), findsOneWidget);
    expect(find.text('Lernen'), findsOneWidget);
    expect(find.text('Heutige Lerneinheit'), findsOneWidget);
    expect(find.text('Tägliche Wiederholung'), findsOneWidget);
    expect(find.text('Prüfungsvorbereitung'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Tägliche Wiederholung: Fällige Wörter'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home stats expose localized summaries and actions at 200%', (
    tester,
  ) async {
    var streakTapped = false;
    var detailsTapped = false;
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: MobileStatsCard(
                totalWordsLearned: 14,
                totalLookups: 6,
                streak: 4,
                onlineSeconds: 3900,
                onStreakTap: () => streakTapped = true,
                onDetailsTap: () => detailsTapped = true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Gelernte Wörter: 14'), findsOneWidget);
    expect(find.bySemanticsLabel('Nachschlagen: 6'), findsOneWidget);
    expect(find.bySemanticsLabel('Serie: 4 Tage'), findsOneWidget);
    expect(find.bySemanticsLabel('Heute: 1 Std. 5 Min.'), findsOneWidget);
    expect(find.bySemanticsLabel('Details anzeigen'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Serie: 4 Tage'));
    await tester.tap(find.bySemanticsLabel('Details anzeigen'));

    expect(streakTapped, isTrue);
    expect(detailsTapped, isTrue);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('Home header gives Profile and Settings 48px semantic actions', (
    tester,
  ) async {
    var profileTapped = false;
    var settingsTapped = false;
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: MobileDashboardHeader(
              displayName: 'Mai',
              streak: 0,
              onProfileTap: () => profileTapped = true,
              onSettingsTap: () => settingsTapped = true,
              showMessages: false,
            ),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Profil'), findsOneWidget);
    expect(find.bySemanticsLabel('Einstellungen'), findsOneWidget);
    expect(
      tester.getSize(
        find.ancestor(
          of: find.byIcon(Icons.settings_outlined),
          matching: find.byType(SizedBox),
        ),
      ),
      const Size(48, 48),
    );

    await tester.tap(find.bySemanticsLabel('Profil'));
    await tester.tap(find.bySemanticsLabel('Einstellungen'));

    expect(profileTapped, isTrue);
    expect(settingsTapped, isTrue);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}

void _noop() {}
