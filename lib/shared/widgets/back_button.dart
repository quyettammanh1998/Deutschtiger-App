import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Rounded back button with a soft shadow.
///
/// If [onPressed] is supplied, it is called when the button is tapped.
/// Otherwise the button uses [Navigator.maybePop] and falls back to
/// [GoRouter.go]('/') when the navigator cannot pop.
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.onPressed,
    this.color = DesignTokens.orange500,
    this.background,
    this.padding = const EdgeInsets.all(DesignTokens.spacingSm),
    this.tooltip = 'Quay lại',
  });

  final VoidCallback? onPressed;
  final Color color;
  final Color? background;
  final EdgeInsetsGeometry padding;
  final String tooltip;

  void _defaultAction(BuildContext context) {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else {
      GoRouter.of(context).go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background ?? DesignTokens.card,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: IconButton(
        tooltip: tooltip,
        padding: padding,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        onPressed: onPressed ?? () => _defaultAction(context),
        icon: Icon(PhosphorIcons.arrowLeft, color: color, size: 22),
      ),
    );
  }
}