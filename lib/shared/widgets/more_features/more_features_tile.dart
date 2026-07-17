import 'package:flutter/material.dart';

import 'more_features_catalog.dart';

/// One 44px pastel tile in the "Tất cả tính năng" 4-column grid.
/// Disabled items ([MoreFeatureItem.enabled] false) render dimmed and
/// non-interactive instead of navigating to a screen that doesn't exist yet.
class MoreFeaturesTile extends StatelessWidget {
  const MoreFeaturesTile({
    super.key,
    required this.item,
    required this.isDark,
    required this.foreground,
    required this.onTap,
  });

  final MoreFeatureItem item;
  final bool isDark;

  /// Theme foreground color for the label (web: `text-foreground`).
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: item.color.bg(isDark),
            borderRadius: BorderRadius.circular(16),
          ),
          child: item.iconBuilder(size: 24, color: item.color.fg),
        ),
        const SizedBox(height: 6),
        // Label clamps to 2 lines (web `line-clamp-2`); the tile height is
        // content-driven (row of Expanded cells), matching web's natural-height
        // grid rows, so no fixed cell can clip the second line.
        Text(
          item.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 1.15,
            color: foreground,
          ),
        ),
      ],
    );

    if (!item.enabled) {
      return Opacity(
        opacity: 0.4,
        child: Semantics(
          label: item.label,
          enabled: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
            child: content,
          ),
        ),
      );
    }

    return Semantics(
      button: true,
      label: item.label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          child: content,
        ),
      ),
    );
  }
}
