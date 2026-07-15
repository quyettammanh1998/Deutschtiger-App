import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:deutschtiger/widgets/interview/transcript_panel.dart';
import 'package:deutschtiger/data/youtube/video_library.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';

enum _PanelMode { none, transcript }

/// Màn xem video trong một "video library" (bộ sưu tập biên tập sẵn): player
/// + transcript đồng bộ (tra từ qua transcript) + hoàn thành/xem lại + chuyển
/// video kế tiếp trong nhóm. Tương đương web `VideoLibraryWatchPage` (rút gọn
/// — không mang cinema mode/floating subtitle của bản web, xem ghi chú gap).
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
  ConsumerState<VideoLibraryWatchScreen> createState() =>
      _VideoLibraryWatchScreenState();
}

class _VideoLibraryWatchScreenState
    extends ConsumerState<VideoLibraryWatchScreen> {
  YoutubePlayerController? _controller;
  String? _mountedVideoId;
  bool _completing = false;
  bool _autoMarked = false;
  _PanelMode _panelMode = _PanelMode.none;
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
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    )..stream.listen((event) {
        if (event.playerState == PlayerState.ended && !_autoMarked) {
          _autoMarked = true;
          _markComplete();
        }
      });
  }

  ({String slug, String groupId}) get _key =>
      (slug: widget.slug, groupId: widget.groupId);

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
            content: Text(
              video.isCompleted ? 'Đã ghi nhận xem lại' : 'Đã đánh dấu hoàn thành',
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không lưu được tiến độ, thử lại sau.')),
        );
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _panelMode == _PanelMode.transcript ? Icons.subtitles : Icons.subtitles_outlined,
              color: _panelMode == _PanelMode.transcript ? Colors.white : AppColors.tigerOrange,
            ),
            onPressed: () => setState(() {
              _panelMode = _panelMode == _PanelMode.transcript
                  ? _PanelMode.none
                  : _PanelMode.transcript;
            }),
            style: _panelMode == _PanelMode.transcript
                ? IconButton.styleFrom(backgroundColor: AppColors.tigerOrange)
                : null,
          ),
        ],
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

            return Column(
              children: [
                YoutubePlayer(controller: _controller!, aspectRatio: 16 / 9),
                if (_panelMode == _PanelMode.transcript)
                  Expanded(
                    child: TranscriptPanel(videoId: active.videoId, onSegmentTap: _seekTo),
                  )
                else
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
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.tigerOrange,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: _completing ? null : _markComplete,
                            icon: Icon(
                              active.isCompleted ? Icons.replay : Icons.check_circle,
                            ),
                            label: Text(active.isCompleted ? 'Xem lại' : 'Đã hoàn thành'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Video khác trong nhóm',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        for (final v in videos)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Material(
                              color: v.videoId == active.videoId
                                  ? AppColors.tigerOrange.withValues(alpha: 0.1)
                                  : AppColors.card,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => setState(() => _activeVideoId = v.videoId),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          v.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      if (v.isCompleted)
                                        const Icon(
                                          Icons.check_circle,
                                          color: AppColors.success,
                                          size: 18,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
