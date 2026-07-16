import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../core/theme/app_tokens.dart';
import 'package:deutschtiger/widgets/interview/video_notes_panel.dart';
import 'package:deutschtiger/widgets/interview/transcript_panel.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'package:deutschtiger/data/youtube/youtube_video.dart';

/// Màn xem video YouTube (tracker cá nhân) — web parity `youtube-watch-page.tsx`.
///
/// Block order matches web: back → player → complete button (dưới player,
/// theo deviation đã duyệt cho `youtube_player_iframe`) → thông tin video →
/// nút luyện tập (Nghe chép chính tả / Shadowing) → transcript inline
/// (collapsible, mặc định mở) → ghi chú.
///
/// **Deviation đã duyệt (ghi trong report)**: `youtube_player_iframe` không
/// dựng lại được `YouTubeEmbeddedPlayer` custom chrome của web — dùng player
/// control mặc định. Cinema mode ("Toàn màn hình + song ngữ" — stage đen +
/// phụ đề nổi) và `YouTubeVideoNotes` cột phải bị BỎ QUA trong wave này (không
/// có API overlay tương đương an toàn với chính sách YouTube không che/tải
/// video) — ghi chú panel vẫn giữ ở dạng toggle như trước.
class YouTubeWatchScreen extends ConsumerStatefulWidget {
  const YouTubeWatchScreen({super.key, required this.videoId, this.title});

  final String videoId;
  final String? title;

  @override
  ConsumerState<YouTubeWatchScreen> createState() => _YouTubeWatchScreenState();
}

class _YouTubeWatchScreenState extends ConsumerState<YouTubeWatchScreen> {
  late final YoutubePlayerController _controller;
  bool _completing = false;
  bool _autoMarked = false;
  bool _showTranscript = true;
  bool _showNotes = false;

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
    final l10n = AppLocalizations.of(context);
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
              video.isCompleted
                  ? l10n.youtubeRewatchMarked
                  : l10n.youtubeCompleteMarked,
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.youtubeSaveProgressError)));
      }
    } finally {
      if (mounted) setState(() => _completing = false);
    }
  }

  void _seekTo(int milliseconds) =>
      _controller.seekTo(seconds: milliseconds / 1000);

  void _openPractice(String mode) {
    final extra = (videoId: widget.videoId, title: _video.title);
    context.push('/listening/youtube/$mode', extra: extra);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final video = _video;
    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back,
                      size: 16,
                      color: tokens.mutedForeground,
                    ),
                    label: Text(
                      l10n.back,
                      style: TextStyle(color: tokens.mutedForeground),
                    ),
                  ),
                ],
              ),
            ),
            YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: tokens.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _completing ? null : _markComplete,
                        icon: Icon(
                          video.isCompleted ? Icons.replay : Icons.check_circle,
                        ),
                        label: Text(
                          video.isCompleted
                              ? l10n.youtubeRewatchButton
                              : l10n.youtubeCompleteButton,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      (video.title?.isNotEmpty ?? false)
                          ? video.title!
                          : l10n.youtubeUntitledVideo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: tokens.foreground,
                      ),
                    ),
                    if (video.isCompleted && video.watchCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          l10n.youtubeWatchCount(video.watchCount),
                          style: TextStyle(
                            fontSize: 12,
                            color: tokens.mutedForeground,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _openPractice('dictation'),
                            icon: const Icon(Icons.edit_note, size: 18),
                            label: Text(l10n.dictationActivityFullTitle),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _openPractice('shadowing'),
                            icon: const Icon(Icons.record_voice_over, size: 18),
                            label: Text(l10n.youtubePracticeShadowing),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionToggle(
                      label: l10n.youtubeTranscriptLabel,
                      icon: Icons.subtitles,
                      expanded: _showTranscript,
                      onTap: () =>
                          setState(() => _showTranscript = !_showTranscript),
                    ),
                    if (_showTranscript)
                      SizedBox(
                        height: 320,
                        child: TranscriptPanel(
                          videoId: widget.videoId,
                          onSegmentTap: _seekTo,
                        ),
                      ),
                    const SizedBox(height: 8),
                    _SectionToggle(
                      label: l10n.youtubeNotesLabel,
                      icon: Icons.note_alt,
                      expanded: _showNotes,
                      onTap: () => setState(() => _showNotes = !_showNotes),
                    ),
                    if (_showNotes)
                      SizedBox(
                        height: 200,
                        child: VideoNotesPanel(
                          videoId: widget.videoId,
                          videoTitle: video.title ?? '',
                          onSeek: _seekTo,
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

class _SectionToggle extends StatelessWidget {
  const _SectionToggle({
    required this.label,
    required this.icon,
    required this.expanded,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 16, color: tokens.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: tokens.foreground,
              ),
            ),
            const Spacer(),
            Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              size: 18,
              color: tokens.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}
