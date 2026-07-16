import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';

/// Breadcrumb + header card — web parity `listening-breadcrumb.tsx` +
/// `VideoCollectionLayout` header row (`rounded-xl border bg-card px-4 py-3`).
/// Shared by youtube/video-library/interview screens (P11 wave 2 ownership).
class MediaBreadcrumb extends StatelessWidget {
  const MediaBreadcrumb({super.key, required this.items});

  /// `(label, path)` — last item has `path == null` (current page, not tappable).
  final List<(String label, String? path)> items;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.chevron_right, size: 14, color: tokens.mutedForeground),
            ),
          if (items[i].$2 != null)
            GestureDetector(
              onTap: () => context.push(items[i].$2!),
              child: Text(
                items[i].$1,
                style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
              ),
            )
          else
            Text(
              items[i].$1,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground),
            ),
        ],
      ],
    );
  }
}

/// Icon-in-rounded-square + title/subtitle header card.
class MediaHeaderCard extends StatelessWidget {
  const MediaHeaderCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.accentColor,
    this.onBack,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color? accentColor;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final accent = accentColor ?? tokens.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: Icon(Icons.arrow_back, size: 18, color: tokens.mutedForeground),
              onPressed: onBack,
            ),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: tokens.foreground,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
