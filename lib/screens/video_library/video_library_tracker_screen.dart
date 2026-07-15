import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:deutschtiger/data/youtube/video_library.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';

/// Tracker của một "video library" (bộ sưu tập video biên tập sẵn theo
/// slug — vd Sprechen B1/B2): danh sách nhóm + tiến độ, bấm nhóm → danh sách
/// video của nhóm đó. Tương đương web `VideoLibraryTrackerPage`.
class VideoLibraryTrackerScreen extends ConsumerStatefulWidget {
  const VideoLibraryTrackerScreen({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<VideoLibraryTrackerScreen> createState() =>
      _VideoLibraryTrackerScreenState();
}

class _VideoLibraryTrackerScreenState
    extends ConsumerState<VideoLibraryTrackerScreen> {
  VideoLibraryGroup? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(videoLibraryConfigProvider(widget.slug));
    final pathAsync = ref.watch(videoLibraryLearningPathProvider(widget.slug));
    final progressAsync = ref.watch(
      videoLibraryGroupProgressProvider(widget.slug),
    );

    final selected = _selectedGroup;

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        foregroundColor: AppColors.tigerOrange,
        leading: selected != null
            ? BackButton(onPressed: () => setState(() => _selectedGroup = null))
            : null,
        title: Text(
          selected != null
              ? selected.nameVi
              : configAsync.value?.title ?? 'Video library',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 17,
          ),
        ),
      ),
      body: SafeArea(
        child: pathAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            message: 'Không tải được lộ trình.',
            onRetry: () =>
                ref.invalidate(videoLibraryLearningPathProvider(widget.slug)),
          ),
          data: (groups) {
            if (selected != null) {
              return _GroupVideoList(slug: widget.slug, group: selected);
            }
            final progress = progressAsync.value ?? const {};
            final totalVideos = groups.fold<int>(
              0,
              (sum, g) => sum + g.videoCount,
            );
            final totalCompleted = progress.values.fold<int>(
              0,
              (sum, p) => sum + p.completed,
            );
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (configAsync.value?.description.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      configAsync.value!.description,
                      style: const TextStyle(color: AppColors.mutedForeground),
                    ),
                  ),
                if (totalVideos > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: totalCompleted / totalVideos,
                              minHeight: 6,
                              backgroundColor: AppColors.muted,
                              color: AppColors.tigerOrange,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$totalCompleted/$totalVideos',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (groups.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'Thư viện này chưa có video nào.',
                        style: TextStyle(color: AppColors.mutedForeground),
                      ),
                    ),
                  )
                else
                  for (final g in groups)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _GroupTile(
                        group: g,
                        progress: progress[g.groupId],
                        onTap: () => setState(() => _selectedGroup = g),
                      ),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  const _GroupTile({required this.group, required this.progress, required this.onTap});

  final VideoLibraryGroup group;
  final LibraryGroupProgress? progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final completed = progress?.completed ?? 0;
    final total = progress?.total ?? group.videoCount;
    final isComplete = total > 0 && completed >= total;
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
              CircleAvatar(
                backgroundColor: isComplete
                    ? AppColors.success.withValues(alpha: 0.15)
                    : AppColors.muted.withValues(alpha: 0.4),
                child: isComplete
                    ? const Icon(Icons.check, color: AppColors.success, size: 18)
                    : Text('${group.order}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.nameDe,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    Text(
                      '${group.nameVi} · ${group.videoCount} video',
                      style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground),
                    ),
                  ],
                ),
              ),
              if (total > 0)
                Text(
                  '$completed/$total',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: AppColors.mutedForeground),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupVideoList extends ConsumerWidget {
  const _GroupVideoList({required this.slug, required this.group});

  final String slug;
  final VideoLibraryGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(
      videoLibraryGroupVideosProvider((slug: slug, groupId: group.groupId)),
    );
    return videosAsync.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorView(
        message: 'Không tải được video của nhóm.',
        onRetry: () => ref.invalidate(
          videoLibraryGroupVideosProvider((slug: slug, groupId: group.groupId)),
        ),
      ),
      data: (videos) {
        if (videos.isEmpty) {
          return const ErrorView(message: 'Nhóm chưa có video nào.');
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: videos.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final v = videos[i];
            return Material(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.push(
                  '/library/$slug/watch?videoId=${v.videoId}&groupId=${group.groupId}',
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          v.thumbnailUrl,
                          width: 96,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 96,
                            height: 60,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${i + 1}. ${v.title}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (v.isCompleted)
                        const Icon(Icons.check_circle, color: AppColors.success, size: 22),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
