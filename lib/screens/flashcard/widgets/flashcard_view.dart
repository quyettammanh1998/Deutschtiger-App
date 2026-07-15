import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/flashcard/review_item.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

/// Thẻ từ vựng: mặt trước chỉ tiếng Đức + nút loa; sau khi lật hiện nghĩa
/// tiếng Việt và các câu ví dụ. Bấm vào thẻ để lật.
class FlashcardView extends StatelessWidget {
  const FlashcardView({
    super.key,
    required this.item,
    required this.revealed,
    required this.onReveal,
    required this.onPlayAudio,
  });

  final ReviewItem item;
  final bool revealed;
  final VoidCallback onReveal;

  /// Phát audio cho (text, audioUrl?). audioUrl có thể null → tts-cache.
  final void Function(String text, String? audioUrl) onPlayAudio;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: revealed ? null : onReveal,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.orange100),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.level != null && item.level!.isNotEmpty)
              _LevelChip(level: item.level!),
            const SizedBox(height: 12),
            _WordRow(
              text: item.displayDe,
              onPlay: () => onPlayAudio(item.displayDe, item.displayAudioUrl),
            ),
            if (!revealed) ...[
              const SizedBox(height: 20),
              Text(
                l10n.tapToShowMeaning,
                style: const TextStyle(
                  color: AppColors.mutedForeground,
                  fontSize: 13,
                ),
              ),
            ] else
              _RevealedContent(item: item, onPlayAudio: onPlayAudio),
          ],
        ),
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.level});
  final String level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.foreground,
        ),
      ),
    );
  }
}

class _WordRow extends StatelessWidget {
  const _WordRow({required this.text, required this.onPlay});
  final String text;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onPlay,
          icon: const Icon(Icons.volume_up_rounded),
          color: AppColors.tigerOrange,
          tooltip: l10n.listenPronunciation,
        ),
      ],
    );
  }
}

class _RevealedContent extends StatelessWidget {
  const _RevealedContent({required this.item, required this.onPlayAudio});
  final ReviewItem item;
  final void Function(String text, String? audioUrl) onPlayAudio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Divider(color: AppColors.border),
        const SizedBox(height: 12),
        Text(
          item.displayVi,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: AppColors.foreground,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (item.examples.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...item.examples.map(
            (ex) => _ExampleTile(ex: ex, onPlay: onPlayAudio),
          ),
        ],
      ],
    );
  }
}

class _ExampleTile extends StatelessWidget {
  const _ExampleTile({required this.ex, required this.onPlay});
  final ReviewExample ex;
  final void Function(String text, String? audioUrl) onPlay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.orange50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ex.de,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.foreground,
                    ),
                  ),
                  if (ex.vi.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      ex.vi,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            InkWell(
              onTap: () => onPlay(ex.de, ex.audioUrl),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.volume_up_rounded,
                  size: 20,
                  color: AppColors.tigerOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
