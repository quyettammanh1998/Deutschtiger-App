import 'package:flutter/material.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/tappable_sentence.dart';
import '../../../data/reading/reading_models.dart' show ReadingParagraph;

/// Audio bar cho bài đọc — phát/tạm dừng + tiến trình (0..1) từ audio player.
class ReadingAudioBar extends StatelessWidget {
  const ReadingAudioBar({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
    this.progress = 0,
  });

  final bool isPlaying;
  final VoidCallback onPlayPause;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: tokens.muted,
        border: Border(
          top: BorderSide(color: tokens.border),
          bottom: BorderSide(color: tokens.border),
        ),
      ),
      child: Row(
        children: [
          IconButton.filled(
            onPressed: onPlayPause,
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            style: IconButton.styleFrom(
              backgroundColor: DesignTokens.tigerOrange,
              foregroundColor: tokens.card,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).readingListenFullStory,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: tokens.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      DesignTokens.tigerOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: DesignTokens.spacingSm),
          IconButton(
            icon: const Icon(Icons.speed),
            tooltip: AppLocalizations.of(context).readingAudioSpeedTooltip,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

/// Một paragraph trong body — DE sentence + VI translation (nếu bật).
class ReadingParagraphView extends StatelessWidget {
  const ReadingParagraphView({
    super.key,
    required this.paragraph,
    required this.showTranslation,
    required this.onWordTap,
  });

  final ReadingParagraph paragraph;
  final bool showTranslation;
  final ValueChanged<String> onWordTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;
    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TappableSentence(
            text: paragraph.de,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: tokens.foreground,
              fontSize: 16,
              height: 1.6,
            ),
            onWordTap: onWordTap,
          ),
          if (showTranslation && paragraph.vi.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacingSm),
            Container(
              padding: const EdgeInsets.all(DesignTokens.spacingSm),
              decoration: BoxDecoration(
                color: tokens.muted,
                borderRadius:
                    BorderRadius.circular(DesignTokens.radiusSm),
              ),
              child: Text(
                paragraph.vi,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: tokens.mutedForeground,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}