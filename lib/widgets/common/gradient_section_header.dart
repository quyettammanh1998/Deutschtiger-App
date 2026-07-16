import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// Gradient hero header used at the top of a themed section — web parity:
/// grammar level-detail hero (`from-emerald-500 to-emerald-600` etc.) and
/// grammar-home level cards. Caller passes the gradient colors (per-level /
/// per-section tint on web) so this stays a generic shell.
class GradientSectionHeader extends StatelessWidget {
  const GradientSectionHeader({
    super.key,
    required this.title,
    required this.gradientColors,
    this.subtitle,
    this.leading,
    this.trailing,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
  });

  final String title;
  final String? subtitle;
  final List<Color> gradientColors;
  final Widget? leading;
  final Widget? trailing;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: tokens.primaryForeground,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Grandstander',
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: tokens.primaryForeground.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 12), trailing!],
          ],
        ),
      ),
    );
  }
}
