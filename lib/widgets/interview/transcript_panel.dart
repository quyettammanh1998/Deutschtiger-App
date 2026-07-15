import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/interview/transcript_models.dart';
import 'package:deutschtiger/view_models/interview/transcript_provider.dart';
import 'package:deutschtiger/shared/widgets/word_lookup_sheet.dart';

/// Panel hien thi transcript cua video YouTube.
/// Hien transcript voi tap-to-seek functionality.
class TranscriptPanel extends ConsumerStatefulWidget {
  const TranscriptPanel({
    super.key,
    required this.videoId,
    this.onSegmentTap,
    this.autoScroll = true,
  });

  final String videoId;
  final void Function(int startMs)? onSegmentTap;
  final bool autoScroll;

  @override
  ConsumerState<TranscriptPanel> createState() => _TranscriptPanelState();
}

class _TranscriptPanelState extends ConsumerState<TranscriptPanel> {
  final ScrollController _scrollController = ScrollController();
  int _currentSegmentIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTime(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final transcriptAsync = ref.watch(transcriptProvider(widget.videoId));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.muted.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.subtitles, size: 18, color: AppColors.tigerOrange),
                const SizedBox(width: 8),
                const Text(
                  'Transcript',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                transcriptAsync.whenOrNull(
                  data: (transcript) => transcript != null
                      ? Text(
                          '${transcript.segments.length} lines',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        )
                      : null,
                ) ?? const SizedBox.shrink(),
              ],
            ),
          ),
          Expanded(
            child: transcriptAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.tigerOrange),
              ),
              error: (e, _) => _ErrorView(
                error: e.toString(),
                onRetry: () => ref.invalidate(transcriptProvider(widget.videoId)),
              ),
              data: (transcript) {
                if (transcript == null || transcript.segments.isEmpty) {
                  return const _EmptyTranscriptView();
                }
                return _TranscriptList(
                  segments: transcript.segments,
                  scrollController: _scrollController,
                  currentIndex: _currentSegmentIndex,
                  onTap: (index, segment) {
                    setState(() => _currentSegmentIndex = index);
                    widget.onSegmentTap?.call(segment.startMs);
                  },
                  formatTime: _formatTime,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TranscriptList extends StatelessWidget {
  const _TranscriptList({
    required this.segments,
    required this.scrollController,
    required this.currentIndex,
    required this.onTap,
    required this.formatTime,
  });

  final List<TranscriptSegment> segments;
  final ScrollController scrollController;
  final int currentIndex;
  final void Function(int index, TranscriptSegment segment) onTap;
  final String Function(int) formatTime;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: segments.length,
      itemBuilder: (context, index) {
        final segment = segments[index];
        final isActive = index == currentIndex;

        return InkWell(
          onTap: () => onTap(index, segment),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.tigerOrange.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.muted.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    formatTime(segment.startMs),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isActive ? AppColors.tigerOrange : AppColors.mutedForeground,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TappableSentence(
                        text: segment.textDe,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                          color: isActive ? AppColors.foreground : AppColors.mutedForeground,
                        ),
                      ),
                      if (segment.textVi != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          segment.textVi!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Câu transcript với từng từ có thể bấm để tra nghĩa (word lookup), tái dùng
/// [WordLookupSheet] hiện có (không viết dictionary lookup mới). Bấm vào
/// khoảng trắng/dấu câu vẫn rơi qua `InkWell` cha (seek video).
class _TappableSentence extends StatelessWidget {
  const _TappableSentence({required this.text, required this.style});

  final String text;
  final TextStyle style;

  static final _wordSplit = RegExp(r'(\s+)');
  static final _stripPunctuation = RegExp(r'^[^\p{L}]+|[^\p{L}]+$', unicode: true);

  @override
  Widget build(BuildContext context) {
    final tokens = text.split(_wordSplit);
    return Wrap(
      children: [
        for (final token in tokens)
          if (token.trim().isEmpty)
            Text(token, style: style)
          else
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                final word = token.replaceAll(_stripPunctuation, '');
                if (word.isEmpty) return;
                showWordLookupSheet(context, word: word);
              },
              child: Text(token, style: style),
            ),
      ],
    );
  }
}

class _EmptyTranscriptView extends StatelessWidget {
  const _EmptyTranscriptView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.subtitles_off,
            size: 40,
            color: AppColors.muted,
          ),
          const SizedBox(height: 8),
          Text(
            'Không có transcript',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 40,
            color: AppColors.destructive,
          ),
          const SizedBox(height: 8),
          Text(
            'Lỗi: $error',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.destructive,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
