import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/interview/video_notes_panel.dart';
import 'package:deutschtiger/widgets/interview/transcript_panel.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'package:deutschtiger/data/youtube/youtube_video.dart';

enum _PanelMode { none, notes, transcript }

/// Màn xem video YouTube (tracker cá nhân): player + transcript đồng bộ +
/// tra từ (qua transcript) + ghi chú + đánh dấu hoàn thành/xem lại.
///
/// Video có thể chưa từng persist vào DB (đến từ "video phổ biến" hoặc link
/// ngoài) — theo hành vi web, chỉ lazy-add khi người dùng bấm hoàn thành.
/// Không dùng background playback / overlay che player (chính sách YouTube).
class YouTubeWatchScreen extends ConsumerStatefulWidget {
  const YouTubeWatchScreen({super.key, required this.videoId, this.title});

  final String videoId;
  final String? title;

  @override
  ConsumerState<YouTubeWatchScreen> createState() =>
      _YouTubeWatchScreenState();
}

class _YouTubeWatchScreenState extends ConsumerState<YouTubeWatchScreen> {
  late final YoutubePlayerController _controller;
  bool _completing = false;
  bool _autoMarked = false;
  _PanelMode _panelMode = _PanelMode.none;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    _controller.stream.listen((event) {
      if (event.playerState == PlayerState.ended && !_autoMarked) {
        _autoMarked = true;
        _markComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  YouTubeVideo get _video =>
      ref.read(youtubeVideoByIdProvider(widget.videoId)) ??
      YouTubeVideo.unsaved(videoId: widget.videoId, title: widget.title);

  Future<void> _markComplete() async {
    if (_completing) return;
    setState(() => _completing = true);
    final repo = ref.read(youtubeRepositoryProvider);
    try {
      var video = _video;
      if (!video.isPersisted) {
        video = await repo.addVideo(
          youtubeUrl: video.youtubeUrl,
          videoId: video.videoId,
          title: video.title,
          thumbnailUrl: video.thumbnailUrl,
        );
      }
      if (video.isCompleted) {
        await repo.rewatch(video.id);
      } else {
        await repo.complete(video.id);
      }
      ref.invalidate(pendingVideosProvider);
      ref.invalidate(completedVideosProvider);
      ref.invalidate(youtubeStatsProvider);
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
    _controller.seekTo(seconds: milliseconds / 1000);
  }

  void _togglePanel(_PanelMode mode) {
    setState(() {
      _panelMode = _panelMode == mode ? _PanelMode.none : mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final video = _video;
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
              _panelMode == _PanelMode.notes ? Icons.note : Icons.note_alt_outlined,
              color: _panelMode == _PanelMode.notes ? Colors.white : AppColors.tigerOrange,
            ),
            onPressed: () => _togglePanel(_PanelMode.notes),
            tooltip: 'Ghi chú',
            style: _panelMode == _PanelMode.notes
                ? IconButton.styleFrom(backgroundColor: AppColors.tigerOrange)
                : null,
          ),
          IconButton(
            icon: Icon(
              _panelMode == _PanelMode.transcript ? Icons.subtitles : Icons.subtitles_outlined,
              color: _panelMode == _PanelMode.transcript ? Colors.white : AppColors.tigerOrange,
            ),
            onPressed: () => _togglePanel(_PanelMode.transcript),
            tooltip: 'Transcript',
            style: _panelMode == _PanelMode.transcript
                ? IconButton.styleFrom(backgroundColor: AppColors.tigerOrange)
                : null,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
            if (_panelMode == _PanelMode.notes)
              SizedBox(
                height: 200,
                child: VideoNotesPanel(
                  videoId: widget.videoId,
                  videoTitle: video.title ?? '',
                  onSeek: _seekTo,
                ),
              ),
            if (_panelMode == _PanelMode.transcript)
              Expanded(
                child: TranscriptPanel(
                  videoId: widget.videoId,
                  onSegmentTap: _seekTo,
                ),
              ),
            if (_panelMode == _PanelMode.none || _panelMode == _PanelMode.notes)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (video.title?.isNotEmpty ?? false)
                            ? video.title!
                            : 'Video chưa có tiêu đề',
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
                            video.isCompleted ? Icons.replay : Icons.check_circle,
                          ),
                          label: Text(video.isCompleted ? 'Xem lại' : 'Đã hoàn thành'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
