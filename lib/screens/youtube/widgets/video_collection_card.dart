import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'video_status_filter_bar.dart';

/// 16:9 thumbnail grid card with status ring/badge — web parity
/// `video-collection-card.tsx` (`VideoCollectionCard`/`VideoThumbnailCard`).
class VideoCollectionCard extends StatelessWidget {
  const VideoCollectionCard({
    super.key,
    required this.thumbnailUrl,
    required this.title,
    required this.status,
    this.subtitle,
    this.badge,
    this.onTap,
    this.onDelete,
  });

  final String thumbnailUrl;
  final String title;
  final MediaVideoStatus status;
  final String? subtitle;
  final String? badge;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final completed = status == MediaVideoStatus.completed;
    return Material(
      color: tokens.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: completed ? tokens.success.withValues(alpha: 0.5) : Colors.transparent,
              width: completed ? 2 : 0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        thumbnailUrl,
                        fit: BoxFit.cover,
                        opacity: completed ? const AlwaysStoppedAnimation(0.75) : null,
                        errorBuilder: (_, _, _) => Container(color: tokens.muted),
                      ),
                      if (status != MediaVideoStatus.all)
                        Positioned(
                          top: 6,
                          left: 6,
                          child: _statusBadge(status, AppLocalizations.of(context)),
                        ),
                      if (badge != null)
                        Positioned(
                          bottom: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badge!,
                              style: const TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ),
                      if (onDelete != null)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: onDelete,
                            child: Container(
                              width: 22,
                              height: 22,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Flexible so a fixed-height grid cell (set by the parent
              // GridView's `childAspectRatio`) shrinks the text block instead
              // of hard-overflowing when German 200% text scale inflates the
              // 2-line title + subtitle beyond the cell's natural size.
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: tokens.foreground,
                          ),
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(MediaVideoStatus status, AppLocalizations l10n) {
    final completed = status == MediaVideoStatus.completed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: (completed ? const Color(0xFF16A34A) : const Color(0xFFF59E0B)).withValues(
          alpha: 0.9,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(completed ? Icons.check : Icons.schedule, size: 10, color: Colors.white),
          const SizedBox(width: 2),
          Text(
            completed ? l10n.videoCollectionWatched : l10n.statsMasteryLearning,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
