import 'package:deutschtiger/core/icons/app_icons.dart';
import 'package:deutschtiger/core/theme/app_theme.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/app_shell.dart';
import 'package:deutschtiger/widgets/common/nav/app_bottom_nav.dart';
import 'package:deutschtiger/widgets/common/nav/nav_tab_accents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {required bool dark}) => MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: dark ? ThemeMode.dark : ThemeMode.light,
  locale: const Locale('vi'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(body: child),
);

// 5-tab fixture mirroring appShellTabs' shape (Trang chủ, Thi, Học, Hội
// thoại, Thêm) without depending on go_router/ReleaseFeatureFlags wiring.
List<AppBottomNavTab> _fixtureTabs() => [
  AppBottomNavTab(
    branchIndex: 0,
    iconBuilder: AppIcons.home,
    label: 'Trang chủ',
    accent: NavTabAccents.home,
  ),
  AppBottomNavTab(
    branchIndex: 1,
    iconBuilder: AppIcons.exams,
    label: 'Thi',
    accent: NavTabAccents.exam,
  ),
  AppBottomNavTab(
    branchIndex: 2,
    iconBuilder: AppIcons.learn,
    label: 'Học',
    accent: NavTabAccents.learn,
  ),
  AppBottomNavTab(
    branchIndex: 3,
    iconBuilder: AppIcons.conversationHub,
    label: 'Hội thoại',
    accent: NavTabAccents.conversation,
  ),
  AppBottomNavTab(
    opensMoreSheet: true,
    iconBuilder: ({double size = 24, Color? color}) =>
        Icon(Icons.menu, size: size, color: color),
    label: 'Thêm',
  ),
];

/// Reads the [BoxDecoration.color] of the 44px icon-pill `Container` that is
/// a sibling of the tab's label `Text` (both live under the same `Column` in
/// `AppBottomNav`'s `_NavSlot`) — scoped to [label] so slots don't collide.
Color? _pillColorFor(WidgetTester tester, String label) {
  final column = find
      .ancestor(of: find.text(label), matching: find.byType(Column))
      .first;
  final container = tester.widget<Container>(
    find
        .descendant(of: column, matching: find.byType(Container))
        .first,
  );
  return (container.decoration as BoxDecoration?)?.color;
}

void main() {
  testWidgets('renders exactly 5 tab slots with their web-parity labels', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AppBottomNav(tabs: _fixtureTabs(), selectedIndex: 0, onTap: (_) {}),
        dark: false,
      ),
    );

    for (final label in ['Trang chủ', 'Thi', 'Học', 'Hội thoại', 'Thêm']) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('each tab shows its own per-tab active pill color', (
    tester,
  ) async {
    final tabs = _fixtureTabs();
    for (var i = 0; i < 4; i++) {
      // Unmount between pumps — MaterialApp/Theme resolution can go stale
      // when reusing the same Element across pumps with different data.
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        _wrap(
          AppBottomNav(tabs: tabs, selectedIndex: i, onTap: (_) {}),
          dark: false,
        ),
      );

      expect(
        _pillColorFor(tester, tabs[i].label),
        tabs[i].accent!.lightBg,
        reason: 'Tab $i (${tabs[i].label}) must show its own accent pill.',
      );
    }
  });

  testWidgets('"Thêm" never gets an active pill color', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppBottomNav(tabs: _fixtureTabs(), selectedIndex: 4, onTap: (_) {}),
        dark: false,
      ),
    );

    // Index 4 ("Thêm") is selected, but it has no [NavTabAccent] — it must
    // never render a pastel pill, even when `selectedIndex` points at it.
    expect(_pillColorFor(tester, 'Thêm'), isNull);
  });

  testWidgets('"Thêm" opens the more-features dialog, not a branch navigation', (
    tester,
  ) async {
    var tappedIndex = -1;
    await tester.pumpWidget(
      _wrap(
        AppBottomNav(
          tabs: _fixtureTabs(),
          selectedIndex: 0,
          onTap: (i) => tappedIndex = i,
        ),
        dark: false,
      ),
    );

    await tester.tap(find.text('Thêm'));
    expect(tappedIndex, 4);
    expect(_fixtureTabs()[4].opensMoreSheet, isTrue);
    expect(_fixtureTabs()[4].branchIndex, isNull);
  });

  testWidgets('inactive tab color is web slate-500 in light theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AppBottomNav(tabs: _fixtureTabs(), selectedIndex: 0, onTap: (_) {}),
        dark: false,
      ),
    );
    final color = tester.widget<Text>(find.text('Thi')).style!.color;
    expect(color, NavTabAccents.inactiveLight);
  });

  testWidgets('inactive tab color is web slate-400 in dark theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AppBottomNav(tabs: _fixtureTabs(), selectedIndex: 0, onTap: (_) {}),
        dark: true,
      ),
    );
    final color = tester.widget<Text>(find.text('Thi')).style!.color;
    expect(color, NavTabAccents.inactiveDark);
    // app_shell.dart previously had a light/dark ternary bug returning the
    // same color for both branches (see phase-01 scout report §1d.6) — pin
    // the two constants apart so a regression fails loudly.
    expect(NavTabAccents.inactiveDark, isNot(NavTabAccents.inactiveLight));
  });

  test('appShellTabs always exposes exactly one tab per branch + "Thêm"', () {
    final l10n = lookupAppLocalizations(const Locale('vi'));
    final tabs = appShellTabs(l10n);

    expect(tabs.length, 5);
    expect(tabs.where((t) => t.opensMoreSheet).length, 1);
    expect(tabs.last.opensMoreSheet, isTrue);
    expect(tabs.last.accent, isNull);
    // Branch indices 0-3 must be present exactly once each, regardless of
    // whether tab 4 is showing "Hội thoại" or "AI" (tab-4 release switch).
    expect(
      tabs.where((t) => t.branchIndex != null).map((t) => t.branchIndex),
      containsAll(<int>[0, 1, 2, 3]),
    );
  });
}
