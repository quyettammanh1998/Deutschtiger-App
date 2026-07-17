import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../core/icons/app_icons.dart';
import '../../l10n/app_localizations.dart';
import '../../services/offline/offline_service.dart';
import '../../shared/widgets/more_features_sheet.dart';
import '../../shared/widgets/offline_banner.dart';
import '../heartbeat_bootstrap.dart';
import 'nav/app_bottom_nav.dart';
import 'nav/nav_hamburger_icon.dart';
import 'nav/nav_tab_accents.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Khung bottom-nav, bao các route con qua go_router ShellRoute.
///
/// Mapping tab (theo web `bottom-nav.tsx`, đã đối chiếu 1:1):
///   0 — Trang chủ   → /home
///   1 — Thi         → /exam
///   2 — Học         → /learn
///   3 — Hội thoại   → /conversation (web) — hoặc AI → /ai khi
///       `ReleaseFeatureFlags.speaking` (P10 conversation hub) còn tắt, xem
///       [appShellTabs] và switch tương ứng trong `app_router.dart`.
///   cuối — Thêm     → KHÔNG navigate: mở [MoreFeaturesSheet]
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int get _selectedIndex {
    final selectedTab = appShellTabs(AppLocalizations.of(context))
        .indexWhere((tab) => tab.branchIndex == widget.navigationShell.currentIndex);
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
      bottomNavigationBar: AppBottomNav(
        tabs: tabs,
        selectedIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}

/// Visible shell tabs for the compiled release configuration. Branch indices
/// stay stable even when tab 4's content swaps between Hội thoại and AI.
List<AppBottomNavTab> appShellTabs(AppLocalizations l10n) => [
  AppBottomNavTab(
    branchIndex: 0,
    iconBuilder: AppIcons.home,
    label: l10n.home,
    accent: NavTabAccents.home,
  ),
  AppBottomNavTab(
    branchIndex: 1,
    iconBuilder: AppIcons.exams,
    label: l10n.exam,
    accent: NavTabAccents.exam,
  ),
  AppBottomNavTab(
    branchIndex: 2,
    iconBuilder: AppIcons.learn,
    label: l10n.learn,
    accent: NavTabAccents.learn,
  ),
  // Tab 4 is the AI chat (product decision — kept in the nav bar rather than
  // web's "Hội thoại" slot). The conversation hub still ships when
  // `ReleaseFeatureFlags.speaking` is on, reached from the More-features sheet
  // instead of this tab.
  AppBottomNavTab(
    branchIndex: 3,
    iconBuilder: ({double size = 24, Color? color}) =>
        Icon(PhosphorIcons.robot, size: size, color: color),
    label: l10n.ai,
    accent: NavTabAccents.ai,
  ),
  AppBottomNavTab(
    opensMoreSheet: true,
    iconBuilder: ({double size = 24, Color? color}) => NavHamburgerIcon(
      size: size,
      color: color ?? NavTabAccents.inactiveLight,
    ),
    label: l10n.more,
    // "Thêm" never gets an active pill/color — it opens a dialog, it never
    // becomes the "current" branch.
  ),
];
