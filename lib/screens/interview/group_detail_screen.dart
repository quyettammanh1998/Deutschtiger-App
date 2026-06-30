import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import '../domain/interview_models.dart';
import 'interview_provider.dart';
import 'widgets/premium_required_view.dart';

/// Chi tiết một nhóm: danh sách video (metadata tĩnh) merge trạng thái xem (DB).
/// Bấm video → màn xem. Premium-gated: 403 → màn Cần Premium.
class GroupDetailScreen extends ConsumerWidget {
  const GroupDetailScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupByIdProvider(groupId));
    final videosState = ref.watch(videosByGroupProvider(groupId));

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        foregroundColor: AppColors.tigerOrange,
        title: Text(
          group?.nameVi ?? 'Nhóm video',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 17,
          ),
        ),
      ),
      body: videosState.when(
        loading: () => const LoadingView(),
        error: (e, _) => isPremiumError(e)
            ? PremiumRequiredView(
                onRetry: () =>
                    ref.invalidate(videosByGroupProvider(groupId)),
              )
            : ErrorView(
                message: 'Không tải được danh sách video.',
                onRetry: () =>
                    ref.invalidate(videosByGroupProvider(groupId)),
              ),
        data: (dbVideos) => _VideoList(
          group: group,
          statusByVideoId: {for (final v in dbVideos) v.videoId: v},
          groupId: groupId,
        ),
      ),
    );
  }
}

class _VideoList extends StatelessWidget {
  const _VideoList({
    required this.group,
    required this.statusByVideoId,
    required this.groupId,
  });

  final InterviewGroup? group;
  final Map<String, InterviewVideo> statusByVideoId;
  final String groupId;

  @override
  Widget build(BuildContext context) {
    final videos = group?.videos ?? const <PathVideo>[];
    if (videos.isEmpty) {
      return const ErrorView(message: 'Nhóm chưa có video nào.');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final v = videos[i];
        final completed = statusByVideoId[v.videoId]?.isCompleted ?? false;
        return _VideoTile(
          index: i + 1,
          video: v,
          completed: completed,
          onTap: () => context.push(
            '/lessons/group/$groupId/watch/${v.videoId}',
            extra: v.title,
          ),
        );
      },
    );
  }
}

class _VideoTile extends StatelessWidget {
  const _VideoTile({
    required this.index,
    required this.video,
    required this.completed,
    required this.onTap,
  });

  final int index;
  final PathVideo video;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
              _Thumb(videoId: video.videoId, completed: completed),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$index. ${video.title}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDuration(video.durationSeconds),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              if (completed)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDuration(int seconds) {
    if (seconds <= 0) return '';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.videoId, required this.completed});
  final String videoId;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            'https://img.youtube.com/vi/$videoId/mqdefault.jpg',
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
    );
  }
}
