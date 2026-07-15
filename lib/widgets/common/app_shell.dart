import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../core/release/release_feature_flags.dart';
import '../../l10n/app_localizations.dart';
import '../../services/offline/offline_service.dart';
import '../../shared/widgets/more_features_sheet.dart';
import '../../shared/widgets/offline_banner.dart';
import '../heartbeat_bootstrap.dart';

/// Khung bottom-nav, bao các route con qua go_router ShellRoute.
///
/// Mapping tab (theo web):
///   0 — Trang chủ   → /home
///   1 — Thi         → /exam
///   2 — Học         → /learn
///   3 — AI          → /ai (chỉ khi contract AI tutor được bật)
///   cuối — Thêm     → KHÔNG navigate: mở [MoreFeaturesSheet]
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int get _selectedIndex {
    final selectedTab = appShellTabs(AppLocalizations.of(context)).indexWhere(
      (tab) => tab.branchIndex == widget.navigationShell.currentIndex,
    );
    return selectedTab == -1 ? 0 : selectedTab;
  }

  void _onTap(int index) {
    final tab = appShellTabs(AppLocalizations.of(context))[index];
    if (tab.opensMoreSheet) {
      MoreFeaturesSheet.show(context);
      return;
    }
    widget.navigationShell.goBranch(
      tab.branchIndex!,
      initialLocation: tab.branchIndex == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tabs = appShellTabs(l10n);
    final isOffline = ref.watch(isOfflineProvider).value ?? false;
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final navBg = isDark ? DesignTokens.darkCard : DesignTokens.card;
    final navBorder = isDark ? DesignTokens.darkBorder : DesignTokens.border;
    final activeColor = DesignTokens.tigerOrange;
    final inactiveColor = isDark
        ? DesignTokens.mutedForeground
        : DesignTokens.mutedForeground;

    return Scaffold(
      body: Column(
        children: [
          const HeartbeatBootstrap(),
          AnimatedSwitcher(
            duration: DesignTokens.durationFast,
            child: isOffline
                ? OfflineBanner(
                    key: const ValueKey('offline-banner'),
                    message: l10n.offlineMessage,
                  )
                : const SizedBox.shrink(key: ValueKey('online-spacer')),
          ),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBg,
          border: Border(top: BorderSide(color: navBorder, width: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: navBg,
            selectedItemColor: activeColor,
            unselectedItemColor: inactiveColor,
            showUnselectedLabels: true,
            elevation: 0,
            items: [
              for (final tab in tabs)
                BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  activeIcon: Icon(tab.activeIcon),
                  label: tab.label,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Visible shell tabs for the compiled release configuration. Branch indices
/// stay stable even when a gated tab is absent from the bottom navigation.
List<AppShellTab> appShellTabs(AppLocalizations l10n) => [
  AppShellTab(
    branchIndex: 0,
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    label: l10n.home,
  ),
  AppShellTab(
    branchIndex: 1,
    icon: Icons.assignment_outlined,
    activeIcon: Icons.assignment_rounded,
    label: l10n.exam,
  ),
  AppShellTab(
    branchIndex: 2,
    icon: Icons.menu_book_outlined,
    activeIcon: Icons.menu_book_rounded,
    label: l10n.learn,
  ),
  if (ReleaseFeatureFlags.aiTutor)
    AppShellTab(
      branchIndex: 3,
      icon: Icons.smart_toy_outlined,
      activeIcon: Icons.smart_toy_rounded,
      label: l10n.ai,
    ),
  AppShellTab(
    opensMoreSheet: true,
    icon: Icons.grid_view_rounded,
    activeIcon: Icons.grid_view_rounded,
    label: l10n.more,
  ),
];

class AppShellTab {
  const AppShellTab({
    this.branchIndex,
    this.opensMoreSheet = false,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final int? branchIndex;
  final bool opensMoreSheet;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
