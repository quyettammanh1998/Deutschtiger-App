import 'package:flutter/material.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'video_collection_models.dart';

/// Chip bar lọc theo trạng thái (Tất cả/Chưa xem/Đang học/Đã xem) kèm số
/// đếm. Web parity: `components/listening/video-status-filter.tsx`.
class VideoStatusFilterBar extends StatelessWidget {
  const VideoStatusFilterBar({
    super.key,
    required this.value,
    required this.counts,
    required this.onChanged,
  });

  final VideoStatusFilterOption value;
  final Map<VideoStatusFilterOption, int> counts;
  final ValueChanged<VideoStatusFilterOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: VideoStatusFilterOption.values.map((option) {
        final active = option == value;
        return GestureDetector(
          onTap: () => onChanged(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: active ? tokens.primary : tokens.muted.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  option.label(l10n),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: active ? Colors.white : tokens.mutedForeground,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: active
                        ? Colors.white.withValues(alpha: 0.2)
                        : tokens.background.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${counts[option] ?? 0}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: active ? Colors.white : tokens.mutedForeground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
