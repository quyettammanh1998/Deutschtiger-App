import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../core/theme/app_tokens.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:deutschtiger/widgets/interview/transcript_panel.dart';
import 'package:deutschtiger/data/interview/interview_models.dart';
import 'package:deutschtiger/view_models/interview/interview_provider.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Xem video phỏng vấn trong một nhóm — web parity `interview-watch-page.tsx`:
/// sticky player → title (×lần xem) → transcript inline (collapsible) →
/// playlist "Chưa xem/Đã hoàn thành" trong nhóm.
///
/// `CommentSection` của web bị DEFERRED — Flutter chưa có widget bình luận
/// video dùng chung (không phải comment bài viết `moments`/comment câu hỏi
/// thi) và chưa có contract nào được probe cho nó; ghi trong report thay vì
/// dựng dữ liệu giả mới.
class VideoPlayerScreen extends ConsumerStatefulWidget {
  const VideoPlayerScreen({super.key, required this.videoId, required this.groupId});

  final String videoId;
  final String groupId;

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  YoutubePlayerController? _controller;
  String? _mountedVideoId;
  bool _completing = false;
  bool _autoMarked = false;
  bool _showTranscript = true;
  late String _activeVideoId = widget.videoId;

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

  InterviewVideo? _videoById(String videoId) {
    final videos = ref.read(videosByGroupProvider(widget.groupId)).value;
    if (videos == null) return null;
    for (final v in videos) {
      if (v.videoId == videoId) return v;
    }
    return null;
  }

  Future<void> _markComplete() async {
    final videoId = _activeVideoId;
    if (_completing) return;
    setState(() => _completing = true);
    final repo = ref.read(interviewRepositoryProvider);
    try {
      final video = _videoById(videoId);
      if (video == null) return;
      if (video.isCompleted) {
        await repo.rewatch(video.id);
      } else {
        await repo.complete(video.id);
      }
      ref.invalidate(videosByGroupProvider(widget.groupId));
      ref.invalidate(groupProgressProvider);
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

  void _seekTo(int ms) => _controller?.seekTo(seconds: ms / 1000);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final videosAsync = ref.watch(videosByGroupProvider(widget.groupId));
    final group = ref.watch(groupByIdProvider(widget.groupId));

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(title: Text(group?.nameVi ?? 'Xem video')),
      body: SafeArea(
        child: videosAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            message: 'Không tải được video.',
            onRetry: () => ref.invalidate(videosByGroupProvider(widget.groupId)),
          ),
          data: (videos) {
            if (videos.isEmpty) return const ErrorView(message: 'Nhóm chưa có video nào.');
            final active = videos.firstWhere(
              (v) => v.videoId == _activeVideoId,
              orElse: () => videos.first,
            );
            _mountPlayer(active.videoId);
            final pending = videos.where((v) => !v.isCompleted).toList();
            final completed = videos.where((v) => v.isCompleted).toList();

            return Column(
              children: [
                YoutubePlayer(controller: _controller!, aspectRatio: 16 / 9),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        active.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: tokens.foreground,
                        ),
                      ),
                      if (active.watchCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'Đã xem ×${active.watchCount}',
                            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                          ),
                        ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: tokens.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _completing ? null : _markComplete,
                          icon: Icon(active.isCompleted ? PhosphorIcons.arrowCounterClockwise : PhosphorIcons.checkCircle),
                          label: Text(active.isCompleted ? 'Xem lại' : 'Đã hoàn thành'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => setState(() => _showTranscript = !_showTranscript),
                        child: Row(
                          children: [
                            Icon(PhosphorIcons.closedCaptioning, size: 16, color: tokens.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Transcript',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: tokens.foreground,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              _showTranscript ? PhosphorIcons.caretUp : PhosphorIcons.caretDown,
                              color: tokens.mutedForeground,
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

class _PlaylistSection extends StatelessWidget {
  const _PlaylistSection({
    required this.title,
    required this.videos,
    required this.activeId,
    required this.onSelect,
    this.completedStyle = false,
  });

  final String title;
  final List<InterviewVideo> videos;
  final String activeId;
  final ValueChanged<String> onSelect;
  final bool completedStyle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: tokens.foreground),
          ),
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
                          ? tokens.primary
                          : (completedStyle
                                ? tokens.success.withValues(alpha: 0.4)
                                : tokens.border),
                      width: v.videoId == activeId ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          'https://img.youtube.com/vi/${v.videoId}/mqdefault.jpg',
                          width: 80,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              Container(width: 80, height: 48, color: tokens.muted),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          v.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: tokens.foreground),
                        ),
                      ),
                      if (completedStyle) Icon(PhosphorIcons.checkCircle, size: 16, color: tokens.success),
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
