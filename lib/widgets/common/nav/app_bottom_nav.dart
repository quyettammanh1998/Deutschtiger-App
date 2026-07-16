import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import 'nav_tab_accents.dart';

/// One bottom-nav slot. Either navigates a shell branch ([branchIndex] set)
/// or opens the more-features dialog ([opensMoreSheet]) — never both.
class AppBottomNavTab {
  const AppBottomNavTab({
    required this.label,
    required this.iconBuilder,
    this.branchIndex,
    this.opensMoreSheet = false,
    this.accent,
  }) : assert(
         (branchIndex != null) != opensMoreSheet,
         'A tab either navigates a branch or opens the more-sheet, not both.',
       );

  final String label;

  /// Renders the tab glyph at the given size/color (matches
  /// `AppIcons.<icon>({size, color})`'s signature so call sites can pass an
  /// `AppIcons` method directly).
  final Widget Function({double size, Color? color}) iconBuilder;

  final int? branchIndex;
  final bool opensMoreSheet;

  /// Per-tab active color/pill. Null → tab is never active-colored (the
  /// "Thêm" slot: it opens a dialog instead of navigating, so it has no
  /// active state).
  final NavTabAccent? accent;
}

/// Web-parity bottom navigation bar (`bottom-nav.tsx`).
///
/// Fixed 64px + safe-area, translucent cream background with a backdrop
/// blur, border-top only (no shadow), 5 `flex-1` slots. Active tab = pastel
/// pill behind a 20px icon, inactive = shared slate color. Deliberately NOT
/// a Material [BottomNavigationBar] — that widget hardcodes a single
/// selected/unselected color pair and label sizing that doesn't match the
/// web spec (10px labels both states, no grow-on-select, per-tab colors).
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<AppBottomNavTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: tokens.border, width: 1)),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: ColoredBox(
            // bg-background/95 — translucent cream (light) / near-black
            // (dark), NOT the card/white surface.
            color: tokens.background.withValues(alpha: 0.95),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 64,
                child: Row(
                  children: [
                    for (var i = 0; i < tabs.length; i++)
                      Expanded(
                        child: _NavSlot(
                          tab: tabs[i],
                          active: i == selectedIndex,
                          isDark: isDark,
                          onTap: () => onTap(i),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavSlot extends StatelessWidget {
  const _NavSlot({
    required this.tab,
    required this.active,
    required this.isDark,
    required this.onTap,
  });

  final AppBottomNavTab tab;
  final bool active;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final inactiveColor = isDark
        ? NavTabAccents.inactiveDark
        : NavTabAccents.inactiveLight;
    final fg = active && tab.accent != null
        ? tab.accent!.fg(isDark)
        : inactiveColor;
    final pillBg = active && tab.accent != null
        ? tab.accent!.bg(isDark)
        : null;

    return Semantics(
      button: true,
      selected: active,
      label: tab.label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: pillBg == null
                  ? null
                  : BoxDecoration(
                      color: pillBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
              child: tab.iconBuilder(size: 20, color: fg),
            ),
            const SizedBox(height: 2),
            Opacity(
              opacity: active ? 1 : 0.7,
              child: Text(
                tab.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
