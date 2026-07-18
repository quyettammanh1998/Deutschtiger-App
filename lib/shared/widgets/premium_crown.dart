import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// "Premium" badge with a gold icon and a label. Renders inline next to a
/// username, in a card header, or as a small chip.
class PremiumCrown extends StatelessWidget {
  const PremiumCrown({
    super.key,
    this.label = 'Premium',
    this.compact = false,
    this.background,
  });

  final String label;
  final bool compact;

  /// Override the gradient's base colour; defaults to the brand gold.
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final color = background ?? DesignTokens.warning;
    final hPad = compact ? DesignTokens.spacingSm : 10.0;
    final vPad = compact ? 2.0 : DesignTokens.spacingXs;
    final iconSize = compact ? 14.0 : DesignTokens.spacingMd;
    final fontSize = compact ? 11.0 : 12.0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            PhosphorIcons.crown,
            color: DesignTokens.card,
            size: iconSize,
          ),
          SizedBox(width: compact ? DesignTokens.spacingXs : 6),
          Text(
            label,
            style: TextStyle(
              color: DesignTokens.card,
              fontWeight: FontWeight.w700,
              fontSize: fontSize,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
