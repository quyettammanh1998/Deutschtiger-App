import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Thẻ hiển thị một video YouTube (thumbnail + tiêu đề + trạng thái).
/// Dùng chung cho tracker cá nhân, popular videos và video library.
class YouTubeVideoCard extends StatelessWidget {
  const YouTubeVideoCard({
    super.key,
    required this.videoId,
    required this.title,
    this.thumbnailUrl,
    this.completed = false,
    this.subtitle,
    this.onTap,
    this.onDelete,
  });

  final String videoId;
  final String title;
  final String? thumbnailUrl;
  final bool completed;
  final String? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final thumb = thumbnailUrl?.isNotEmpty == true
        ? thumbnailUrl!
        : 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      thumb,
                      width: 96,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 96,
                        height: 60,
                        color: AppColors.muted,
                        child: const Icon(
                          Icons.ondemand_video,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ),
                    Icon(
                      completed
                          ? Icons.check_circle
                          : Icons.play_circle_fill_rounded,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 28,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isEmpty ? 'Video chưa có tiêu đề' : title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.mutedForeground,
                    size: 20,
                  ),
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
