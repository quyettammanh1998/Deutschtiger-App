import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// Bottom sticky CTA bar — web parity: sticky bottom action bars used e.g.
/// in deck detail (`DeckLearnBottomBar`) and sentence-builder topic select
/// (level pills + "Bắt đầu" gradient CTA row).
///
/// Sits above the 64px bottom nav (`AppShell`) + device safe area when used
/// as a page-level overlay; wrap in a `Positioned`/`Stack` at the call site
/// to control that offset — this widget itself only pads for the device
/// safe area, since call sites differ on whether the bottom nav is present.
class StickyCtaBar extends StatelessWidget {
  const StickyCtaBar({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.clearBottomNav = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// When true, adds 64px extra bottom inset to clear `AppShell`'s bottom
  /// nav (used when this bar floats over a page that still shows the nav).
  final bool clearBottomNav;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border(top: BorderSide(color: tokens.border)),
      ),
      child: Padding(
        padding: padding.add(
          EdgeInsets.only(bottom: safeBottom + (clearBottomNav ? 64 : 0)),
        ),
        child: SafeArea(top: false, bottom: false, child: child),
      ),
    );
  }
}
