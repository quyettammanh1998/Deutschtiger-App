import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:deutschtiger/data/youtube/youtube_video.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'widgets/youtube_video_card.dart';
import 'youtube_url_utils.dart';

enum _StatusFilter { all, pending, completed }

/// Tracker YouTube cá nhân: người dùng dán URL video Đức bất kỳ để lưu lại,
/// đánh dấu hoàn thành và xem lại. Tương đương web `YouTubeTrackerPage`.
class YouTubeTrackerScreen extends ConsumerStatefulWidget {
  const YouTubeTrackerScreen({super.key});

  @override
  ConsumerState<YouTubeTrackerScreen> createState() =>
      _YouTubeTrackerScreenState();
}

class _YouTubeTrackerScreenState extends ConsumerState<YouTubeTrackerScreen> {
  final _urlController = TextEditingController();
  _StatusFilter _filter = _StatusFilter.all;
  bool _adding = false;
  String? _addError;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _addVideo() async {
    final input = _urlController.text.trim();
    final videoId = extractYouTubeVideoId(input);
    if (videoId == null) {
      setState(() => _addError = 'URL YouTube không hợp lệ');
      return;
    }
    setState(() {
      _adding = true;
      _addError = null;
    });
    try {
      await ref
          .read(youtubeRepositoryProvider)
          .addVideo(
            youtubeUrl: 'https://www.youtube.com/watch?v=$videoId',
            videoId: videoId,
          );
      _urlController.clear();
      ref.invalidate(pendingVideosProvider);
      ref.invalidate(completedVideosProvider);
    } catch (e) {
      setState(() => _addError = 'Không thêm được video, thử lại sau.');
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  Future<void> _deleteVideo(YouTubeVideo video) async {
    if (!video.isPersisted) return;
    try {
      await ref.read(youtubeRepositoryProvider).deleteVideo(video.id);
      ref.invalidate(pendingVideosProvider);
      ref.invalidate(completedVideosProvider);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Không xoá được video.')));
      }
    }
  }

  void _openVideo(YouTubeVideo video) {
    context.push(
      '/listening/youtube/watch',
      extra: (videoId: video.videoId, title: video.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingAsync = ref.watch(pendingVideosProvider);
    final completedAsync = ref.watch(completedVideosProvider);
    final popularAsync = ref.watch(popularVideosProvider);
    final statsAsync = ref.watch(youtubeStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        foregroundColor: AppColors.tigerOrange,
        title: const Text(
          'YouTube',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 17,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(pendingVideosProvider);
            ref.invalidate(completedVideosProvider);
            ref.invalidate(popularVideosProvider);
            ref.invalidate(youtubeStatsProvider);
          },
          child: pendingAsync.when(
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(
              message: 'Không tải được danh sách video.',
              onRetry: () => ref.invalidate(pendingVideosProvider),
            ),
            data: (pending) {
              final completed = completedAsync.value ?? const [];
              final all = [...pending, ...completed];
              final filtered = switch (_filter) {
                _StatusFilter.all => all,
                _StatusFilter.pending => pending,
                _StatusFilter.completed => completed,
              };
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  statsAsync.whenOrNull(
                        data: (stats) => _StatsRow(stats: stats),
                      ) ??
                      const SizedBox.shrink(),
                  const SizedBox(height: 16),
                  _AddVideoForm(
                    controller: _urlController,
                    adding: _adding,
                    error: _addError,
                    onSubmit: _addVideo,
                  ),
                  const SizedBox(height: 20),
                  popularAsync.whenOrNull(
                        data: (popular) => popular.isEmpty
                            ? const SizedBox.shrink()
                            : _PopularVideosSection(
                                videos: popular,
                                onTap: (v) => context.push(
                                  '/listening/youtube/watch',
                                  extra: (videoId: v.videoId, title: v.title),
                                ),
                              ),
                      ) ??
                      const SizedBox.shrink(),
                  const SizedBox(height: 12),
                  _StatusFilterBar(
                    value: _filter,
                    onChanged: (v) => setState(() => _filter = v),
                  ),
                  const SizedBox(height: 8),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          'Chưa có video nào. Dán URL YouTube ở trên để bắt đầu.',
                          style: TextStyle(color: AppColors.mutedForeground),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    for (final v in filtered)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: YouTubeVideoCard(
                          videoId: v.videoId,
                          title: v.title ?? '',
                          thumbnailUrl: v.thumbnailUrl,
                          completed: v.isCompleted,
                          subtitle: v.isCompleted && v.watchCount > 0
                              ? 'Đã xem ×${v.watchCount}'
                              : null,
                          onTap: () => _openVideo(v),
                          onDelete: () => _deleteVideo(v),
                        ),
                      ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});
  final YouTubeStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatChip(label: 'Hôm nay', value: stats.today)),
        const SizedBox(width: 8),
        Expanded(child: _StatChip(label: 'Tuần này', value: stats.thisWeek)),
        const SizedBox(width: 8),
        Expanded(child: _StatChip(label: 'Tổng', value: stats.totalCompleted)),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.tigerOrange,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddVideoForm extends StatelessWidget {
  const _AddVideoForm({
    required this.controller,
    required this.adding,
    required this.error,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool adding;
  final String? error;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Dán URL YouTube...',
                  filled: true,
                  fillColor: AppColors.card,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => onSubmit(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.tigerOrange,
              ),
              onPressed: adding ? null : onSubmit,
              child: adding
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Thêm'),
            ),
          ],
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              error!,
              style: const TextStyle(color: AppColors.destructive, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class _PopularVideosSection extends StatelessWidget {
  const _PopularVideosSection({required this.videos, required this.onTap});

  final List<YouTubePopularVideo> videos;
  final void Function(YouTubePopularVideo) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Video phổ biến',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: videos.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final v = videos[i];
              return GestureDetector(
                onTap: () => onTap(v),
                child: SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          v.thumbnailUrl,
                          width: 160,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 160,
                            height: 90,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        v.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StatusFilterBar extends StatelessWidget {
  const _StatusFilterBar({required this.value, required this.onChanged});

  final _StatusFilter value;
  final ValueChanged<_StatusFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final f in _StatusFilter.values)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(switch (f) {
                _StatusFilter.all => 'Tất cả',
                _StatusFilter.pending => 'Chưa xem',
                _StatusFilter.completed => 'Đã xem',
              }),
              selected: value == f,
              onSelected: (_) => onChanged(f),
              selectedColor: AppColors.tigerOrange.withValues(alpha: 0.15),
            ),
          ),
      ],
    );
  }
}
