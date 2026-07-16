import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:deutschtiger/widgets/interview/transcript_panel.dart';
import 'package:deutschtiger/data/youtube/video_library.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';

/// Màn xem video trong một "video library" (bộ sưu tập biên tập sẵn): player
/// (đầu trang, luôn hiển thị — tương đương `sticky` của web) + transcript
/// inline (collapsible, mặc định mở) + hoàn thành/xem lại + playlist tách
/// "Chưa xem/Đã hoàn thành" kèm thumbnail. Tương đương web
/// `VideoLibraryWatchPage` (rút gọn — không mang cinema mode/floating
/// subtitle/`CommentSection` của bản web, xem ghi chú gap trong report).
class VideoLibraryWatchScreen extends ConsumerStatefulWidget {
  const VideoLibraryWatchScreen({
    super.key,
    required this.slug,
    required this.groupId,
    required this.initialVideoId,
  });

  final String slug;
  final String groupId;
  final String initialVideoId;

  @override
  ConsumerState<VideoLibraryWatchScreen> createState() => _VideoLibraryWatchScreenState();
}

class _VideoLibraryWatchScreenState extends ConsumerState<VideoLibraryWatchScreen> {
  YoutubePlayerController? _controller;
  String? _mountedVideoId;
  bool _completing = false;
  bool _autoMarked = false;
  bool _showTranscript = true;
  String? _activeVideoId;

  @override
  void initState() {
    super.initState();
    _activeVideoId = widget.initialVideoId;
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  void _mountPlayer(String videoId) {
    if (_mountedVideoId == videoId) return;
    _controller?.close();
    _autoMarked = false;
    _mountedVideoId = videoId;
    _controller =
        YoutubePlayerController.fromVideoId(
            videoId: videoId,
            autoPlay: false,
            params: const YoutubePlayerParams(showFullscreenButton: true),
          )
          ..stream.listen((event) {
            if (event.playerState == PlayerState.ended && !_autoMarked) {
              _autoMarked = true;
              _markComplete();
            }
          });
  }

  ({String slug, String groupId}) get _key => (slug: widget.slug, groupId: widget.groupId);

  LibraryVideo? _videoById(String videoId) {
    final videos = ref.read(videoLibraryGroupVideosProvider(_key)).value;
    if (videos == null) return null;
    for (final v in videos) {
      if (v.videoId == videoId) return v;
    }
    return null;
  }

  Future<void> _markComplete() async {
    final videoId = _activeVideoId;
    if (videoId == null || _completing) return;
    setState(() => _completing = true);
    final repo = ref.read(youtubeRepositoryProvider);
    try {
      var video = _videoById(videoId);
      if (video == null || !video.isPersisted) {
        final group = ref.read(videoLibraryGroupProvider(_key));
        if (group != null) {
          await repo.addGroupVideos(widget.slug, widget.groupId, group.videos);
        }
        ref.invalidate(videoLibraryGroupVideosProvider(_key));
        video = _videoById(videoId);
      }
      if (video == null || !video.isPersisted) return;
      if (video.isCompleted) {
        await repo.rewatch(video.id);
      } else {
        await repo.complete(video.id);
      }
      ref.invalidate(videoLibraryGroupVideosProvider(_key));
      ref.invalidate(videoLibraryGroupProgressProvider(widget.slug));
      ref.invalidate(videoLibraryStatsProvider(widget.slug));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(video.isCompleted ? 'Đã ghi nhận xem lại' : 'Đã đánh dấu hoàn thành'),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Không lưu được tiến độ, thử lại sau.')));
      }
    } finally {
      if (mounted) setState(() => _completing = false);
    }
  }

  void _seekTo(int milliseconds) {
    _controller?.seekTo(seconds: milliseconds / 1000);
  }

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(videoLibraryGroupVideosProvider(_key));

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        foregroundColor: AppColors.tigerOrange,
        title: const Text(
          'Xem video',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.tigerOrange, fontSize: 17),
        ),
      ),
      body: SafeArea(
        child: videosAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            message: 'Không tải được video.',
            onRetry: () => ref.invalidate(videoLibraryGroupVideosProvider(_key)),
          ),
          data: (videos) {
            if (videos.isEmpty) {
              return const ErrorView(message: 'Nhóm chưa có video nào.');
            }
            final activeId = _activeVideoId ?? videos.first.videoId;
            final active = videos.firstWhere(
              (v) => v.videoId == activeId,
              orElse: () => videos.first,
            );
            _mountPlayer(active.videoId);
            final pending = videos.where((v) => !v.isCompleted).toList();
            final completed = videos.where((v) => v.isCompleted).toList();

            return Column(
              children: [
                // Player luôn ở đầu trang (tương đương `sticky` của web).
                YoutubePlayer(controller: _controller!, aspectRatio: 16 / 9),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        active.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground,
                        ),
                      ),
                      if (active.watchCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'Đã xem ×${active.watchCount}',
                            style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground),
                          ),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.tigerOrange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _completing ? null : _markComplete,
                          icon: Icon(active.isCompleted ? Icons.replay : Icons.check_circle),
                          label: Text(active.isCompleted ? 'Xem lại' : 'Đã hoàn thành'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => setState(() => _showTranscript = !_showTranscript),
                        child: Row(
                          children: [
                            const Icon(Icons.subtitles, size: 16, color: AppColors.tigerOrange),
                            const SizedBox(width: 8),
                            const Text(
                              'Transcript',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                            const Spacer(),
                            Icon(
                              _showTranscript ? Icons.expand_less : Icons.expand_more,
                              color: AppColors.mutedForeground,
                            ),
                          ],
                        ),
                      ),
                      if (_showTranscript)
                        SizedBox(
                          height: 300,
                          child: TranscriptPanel(videoId: active.videoId, onSegmentTap: _seekTo),
                        ),
                      const SizedBox(height: 16),
                      if (pending.isNotEmpty)
                        _PlaylistSection(
                          title: 'Chưa xem (${pending.length})',
                          videos: pending,
                          activeId: active.videoId,
                          onSelect: (id) => setState(() => _activeVideoId = id),
                        ),
                      if (completed.isNotEmpty)
                        _PlaylistSection(
                          title: 'Đã hoàn thành (${completed.length})',
                          videos: completed,
                          activeId: active.videoId,
                          onSelect: (id) => setState(() => _activeVideoId = id),
                          completedStyle: true,
                        ),
                    ],
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

/// "Chưa xem/Đã hoàn thành" playlist card — web parity: pending rows use the
/// default border, completed rows use a green-tinted border; the active row
/// gets the primary border regardless of section.
class _PlaylistSection extends StatelessWidget {
  const _PlaylistSection({
    required this.title,
    required this.videos,
    required this.activeId,
    required this.onSelect,
    this.completedStyle = false,
  });

  final String title;
  final List<LibraryVideo> videos;
  final String activeId;
  final ValueChanged<String> onSelect;
  final bool completedStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          for (final v in videos)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: InkWell(
                onTap: () => onSelect(v.videoId),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: v.videoId == activeId
                          ? AppColors.tigerOrange
                          : (completedStyle
                                ? AppColors.success.withValues(alpha: 0.4)
                                : AppColors.muted),
                      width: v.videoId == activeId ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          v.thumbnailUrl.isNotEmpty
                              ? v.thumbnailUrl
                              : 'https://img.youtube.com/vi/${v.videoId}/mqdefault.jpg',
                          width: 80,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              Container(width: 80, height: 48, color: AppColors.muted),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          v.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      if (completedStyle)
                        const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
