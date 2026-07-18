import 'package:deutschtiger/features/daily_path/domain/daily_path.dart';
import 'package:deutschtiger/features/daily_path/presentation/daily_path_route_resolver.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/home/widgets/dashboard_sections.dart';
import 'package:deutschtiger/widgets/common/app_shell.dart';
import 'package:deutschtiger/widgets/dashboard/mobile_dashboard_header.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
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

  test(
    'bottom navigation tab 4 stays the AI chat regardless of the speaking flag',
    () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      final tabs = appShellTabs(l10n);

      // Tab 4 (branch index 3) is a product decision to always be the AI
      // chat, not web's "Hội thoại" slot — the conversation hub still ships
      // when `ReleaseFeatureFlags.speaking` is on, but it's reached from the
      // More-features sheet instead. See the tab-4 comment in `app_shell.dart`.
      final tab4 = tabs.singleWhere((tab) => tab.branchIndex == 3);
      expect(tab4.label, l10n.ai);
      expect(tabs.last.opensMoreSheet, isTrue);
    },
  );

  testWidgets('Home components hide gated navigation affordances', (
    tester,
  ) async {
    // `MobileStatsCard`/`QuickActions` were deleted in the P12 wave-B
    // deletion sweep (Flutter-only orphans — home_screen.dart never rendered
    // them; superseded by `stats_screen.dart` blocks and `PinnedShortcuts`/
    // `DashboardMissionsSection`). This test now only covers the header +
    // missions section that home_screen.dart actually renders.
    await tester.pumpWidget(
      _wrap(
        const Column(
          children: [
            MobileDashboardHeader(displayName: 'Mai', streak: 0),
            DashboardMissionsSection(missions: []),
          ],
        ),
      ),
    );

    // Messages/settings are always visible in the header now (web parity —
    // the messages icon slot is no longer gated by ReleaseFeatureFlags.social,
    // see mobile_dashboard_header.dart).
    expect(find.byIcon(PhosphorIcons.chatCircle), findsOneWidget);
    expect(find.text('Xem chi tiết'), findsNothing);
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
          of: find.byIcon(PhosphorIcons.gearSix),
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
