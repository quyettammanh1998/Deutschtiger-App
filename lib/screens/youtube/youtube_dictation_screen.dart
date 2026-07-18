import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../core/theme/app_tokens.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/interview/transcript_provider.dart';
import 'package:deutschtiger/view_models/youtube/youtube_provider.dart';
import 'widgets/dictation_panel.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Nghe chép chính tả — web parity `youtube-dictation-page.tsx`. Nguồn câu là
/// transcript đã có sẵn ([transcriptProvider], DE/VI theo segment) thay cho
/// bộ phân tích phụ đề riêng của web (`loadSubtitles`) — Flutter chưa có hạ
/// tầng đó, transcript segment là tương đương hợp lý nhất hiện có, không dựng
/// dữ liệu giả mới. XP: `+1` mỗi câu đúng qua `POST /user/gamification/award-xp` (xem
/// `docs/flutter-api-contract-matrix.md`).
class YouTubeDictationScreen extends ConsumerStatefulWidget {
  const YouTubeDictationScreen({super.key, required this.videoId, this.title});

  final String videoId;
  final String? title;

  @override
  ConsumerState<YouTubeDictationScreen> createState() => _YouTubeDictationScreenState();
}

class _YouTubeDictationScreenState extends ConsumerState<YouTubeDictationScreen> {
  late final YoutubePlayerController _controller;
  bool _hideVideo = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: false),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final transcriptAsync = ref.watch(transcriptProvider(widget.videoId));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  IconButton(icon: const Icon(PhosphorIcons.arrowLeft), onPressed: () => context.pop()),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.dictationActivityFullTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: tokens.foreground,
                          ),
                        ),
                        if ((widget.title ?? '').isNotEmpty)
                          Text(
                            widget.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: _hideVideo
                        ? l10n.youtubeDictationShowVideoTooltip
                        : l10n.youtubeDictationAudioOnlyTooltip,
                    icon: Icon(
                      _hideVideo ? PhosphorIcons.eyeSlash : PhosphorIcons.eye,
                      size: 20,
                      color: tokens.mutedForeground,
                    ),
                    onPressed: () => setState(() => _hideVideo = !_hideVideo),
                  ),
                ],
              ),
            ),
            if (!_hideVideo) YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
            Expanded(
              child: transcriptAsync.when(
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  message: l10n.youtubeTranscriptLoadError,
                  onRetry: () => ref.invalidate(transcriptProvider(widget.videoId)),
                ),
                data: (transcript) {
                  final segments = transcript?.segments ?? const [];
                  if (segments.isEmpty) {
                    return ErrorView(message: l10n.youtubeDictationNoTranscript);
                  }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: DictationPanel(
                      segments: segments,
                      onSeek: (ms) => _controller.seekTo(seconds: ms / 1000),
                      onClose: () => context.pop(),
                      onCorrectSentence: () =>
                          ref.read(dictationXpRepositoryProvider).awardSentenceXp(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
