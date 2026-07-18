import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../core/release/release_feature_flags.dart';
import '../../core/theme/app_tokens.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/interview/transcript_provider.dart';
import 'package:deutschtiger/data/interview/transcript_models.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Shadowing — web parity `youtube-shadowing-page.tsx`/`YouTubeShadowingMode`.
///
/// Full UI (player + active-sentence card + prev/next/replay + transcript
/// list), but the record/STT/AI-eval action is gated behind
/// `ReleaseFeatureFlags.speaking` (default off) per the GĐ2 P1 condition kept
/// by this plan §Supersede — MASTER P8 wires live mic capture + Soniox STT +
/// AI pronunciation eval into this UI later. Sentence source: transcript
/// segments (see dictation screen note) instead of web's separate subtitle
/// loader.
class YouTubeShadowingScreen extends ConsumerStatefulWidget {
  const YouTubeShadowingScreen({super.key, required this.videoId, this.title});

  final String videoId;
  final String? title;

  @override
  ConsumerState<YouTubeShadowingScreen> createState() =>
      _YouTubeShadowingScreenState();
}

class _YouTubeShadowingScreenState
    extends ConsumerState<YouTubeShadowingScreen> {
  late final YoutubePlayerController _controller;
  int _index = 0;
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

  void _goTo(int index, List<TranscriptSegment> segments) {
    if (index < 0 || index >= segments.length) return;
    setState(() => _index = index);
    _controller.seekTo(seconds: segments[index].startMs / 1000);
    _controller.playVideo();
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
                  IconButton(
                    icon: const Icon(PhosphorIcons.arrowLeft),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.shadowingScreenTitle,
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
                            style: TextStyle(
                              fontSize: 11,
                              color: tokens.mutedForeground,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: _hideVideo
                        ? l10n.youtubeDictationShowVideoTooltip
                        : l10n.shadowingHideVideoTooltip,
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
            if (!_hideVideo)
              YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
            Expanded(
              child: transcriptAsync.when(
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  message: l10n.youtubeTranscriptLoadError,
                  onRetry: () =>
                      ref.invalidate(transcriptProvider(widget.videoId)),
                ),
                data: (transcript) {
                  final segments = transcript?.segments ?? const [];
                  if (segments.isEmpty) {
                    return ErrorView(message: l10n.shadowingNoTranscript);
                  }
                  final index = _index.clamp(0, segments.length - 1);
                  final active = segments[index];
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _ShadowingCard(
                        segment: active,
                        index: index,
                        total: segments.length,
                        onPrev: index > 0
                            ? () => _goTo(index - 1, segments)
                            : null,
                        onNext: index < segments.length - 1
                            ? () => _goTo(index + 1, segments)
                            : null,
                        onListenAgain: () {
                          _controller.seekTo(seconds: active.startMs / 1000);
                          _controller.playVideo();
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.youtubeTranscriptLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: tokens.foreground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (var i = 0; i < segments.length; i++)
                        _TranscriptRow(
                          segment: segments[i],
                          active: i == index,
                          onTap: () => _goTo(i, segments),
                        ),
                    ],
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

class _ShadowingCard extends StatelessWidget {
  const _ShadowingCard({
    required this.segment,
    required this.index,
    required this.total,
    required this.onPrev,
    required this.onNext,
    required this.onListenAgain,
  });

  final TranscriptSegment segment;
  final int index;
  final int total;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback onListenAgain;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final micEnabled = ReleaseFeatureFlags.speaking;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.shadowingSentenceProgress(index + 1, total),
            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 8),
          Text(
            segment.textDe,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: tokens.foreground,
            ),
          ),
          if (segment.textVi != null) ...[
            const SizedBox(height: 4),
            Text(
              segment.textVi!,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: tokens.mutedForeground,
              ),
            ),
          ],
          const SizedBox(height: 14),
          // FittedBox: at German 200% text scale, "Nghe lại" plus 3 icon
          // buttons in one row can hard-overflow a narrow phone width; scale
          // the whole control row down as a unit instead of reflowing it.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: onPrev,
                  icon: const Icon(PhosphorIcons.skipBack),
                ),
                OutlinedButton.icon(
                  onPressed: onListenAgain,
                  icon: const Icon(PhosphorIcons.arrowCounterClockwise, size: 18),
                  label: Text(l10n.shadowingListenAgain),
                ),
                const SizedBox(width: 12),
                Tooltip(
                  message: micEnabled
                      ? l10n.shadowingRecordTooltip
                      : l10n.shadowingRecordComingSoonTooltip,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: micEnabled
                          ? tokens.destructive
                          : tokens.muted,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: micEnabled ? null : null,
                    child: Icon(
                      PhosphorIcons.microphone,
                      color: micEnabled ? Colors.white : tokens.mutedForeground,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onNext,
                  icon: const Icon(PhosphorIcons.skipForward),
                ),
              ],
            ),
          ),
          if (!micEnabled)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                l10n.shadowingRecordComingSoonHint,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
              ),
            ),
        ],
      ),
    );
  }
}

class _TranscriptRow extends StatelessWidget {
  const _TranscriptRow({
    required this.segment,
    required this.active,
    required this.onTap,
  });

  final TranscriptSegment segment;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? tokens.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          segment.textDe,
          style: TextStyle(
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            color: active ? tokens.foreground : tokens.mutedForeground,
          ),
        ),
      ),
    );
  }
}
