import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

enum MediaVideoStatus { all, pending, completed }

/// Status pill bar with counts — web parity `video-status-filter.tsx`
/// (`VideoStatusFilterBar`, `Tất cả/Đang học/Đã xem`).
class VideoStatusFilterBar extends StatelessWidget {
  const VideoStatusFilterBar({
    super.key,
    required this.value,
    required this.onChanged,
    required this.counts,
    this.pendingLabel,
  });

  final MediaVideoStatus value;
  final ValueChanged<MediaVideoStatus> onChanged;

  /// Counts keyed by status (`all` = total).
  final Map<MediaVideoStatus, int> counts;

  /// Label for [MediaVideoStatus.pending]; defaults to the ARB
  /// `videoCollectionStatusNew` ("Chưa xem") when null.
  final String? pendingLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final options = [
      (MediaVideoStatus.all, l10n.allFilters),
      (MediaVideoStatus.pending, pendingLabel ?? l10n.videoCollectionStatusNew),
      (MediaVideoStatus.completed, l10n.videoCollectionWatched),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (status, label) in options)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _StatusChip(
                label: '$label (${counts[status] ?? 0})',
                selected: value == status,
                onTap: () => onChanged(status),
                tokens: tokens,
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.tokens,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? tokens.primary : tokens.muted,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? tokens.primaryForeground : tokens.mutedForeground,
          ),
        ),
      ),
    );
  }
}
