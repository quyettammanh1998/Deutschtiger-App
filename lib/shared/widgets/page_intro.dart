import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Page header with a title, optional subtitle, and an optional action
/// widget aligned to the right (e.g. settings icon, filter button).
class PageIntro extends StatelessWidget {
  const PageIntro({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.padding = const EdgeInsets.fromLTRB(
      DesignTokens.screenHorizontalPadding,
      DesignTokens.spacingMd,
      DesignTokens.screenHorizontalPadding,
      DesignTokens.spacingMd,
    ),
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: DesignTokens.foreground,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: DesignTokens.spacingXs),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: DesignTokens.mutedForeground,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: DesignTokens.spacingSm + 4),
            action!,
          ],
        ],
      ),
    );
  }
}
