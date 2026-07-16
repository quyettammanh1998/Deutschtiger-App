import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// Small rounded-full label chip — web parity: the many `rounded-full` pill
/// badges used across level chips, tag pills, and status badges (e.g.
/// `bg-primary/10 text-primary`, `bg-muted text-muted-foreground`).
///
/// Caller supplies [background]/[foreground]; defaults fall back to the
/// muted pill (`bg-muted`) which is the most common bare usage on web.
class AppPill extends StatelessWidget {
  const AppPill({
    super.key,
    required this.label,
    this.background,
    this.foreground,
    this.icon,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  /// `bg-primary/10 text-primary` tinted pill — common "active level" /
  /// "selected tag" style on web.
  factory AppPill.tinted(
    BuildContext context, {
    Key? key,
    required String label,
    Widget? icon,
    double fontSize = 12,
  }) {
    final tokens = context.tokens;
    return AppPill(
      key: key,
      label: label,
      background: tokens.primary.withValues(alpha: 0.1),
      foreground: tokens.primary,
      icon: icon,
      fontSize: fontSize,
    );
  }

  final String label;
  final Color? background;
  final Color? foreground;
  final Widget? icon;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bg = background ?? tokens.muted;
    final fg = foreground ?? tokens.mutedForeground;
    return DecoratedBox(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              IconTheme(data: IconThemeData(color: fg, size: fontSize + 2), child: icon!),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(color: fg, fontSize: fontSize, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
