import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../data/vocab_lesson_utils.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const Map<VocabCardMode, String> _modeLabels = {
  VocabCardMode.flip: '🃏 Lật thẻ (DE → VI)',
  VocabCardMode.reverse: '🔄 Lật ngược (VI → DE)',
  VocabCardMode.listen: '🔊 Nghe đoán',
  VocabCardMode.choice: '🎯 Trắc nghiệm',
  VocabCardMode.cloze: '🧩 Điền vào chỗ trống',
  VocabCardMode.compose: '🖊️ Viết câu (AI chấm)',
};

/// Studying-phase header — collection name + orange progress bar + `n/total`
/// counter, plus the mode-label pill + "✓ Đã biết" toolbar row underneath.
/// Web parity: header block of `vocabulary-lesson-page.tsx` (studying phase).
class LessonSessionHeader extends StatelessWidget {
  const LessonSessionHeader({
    super.key,
    required this.collectionName,
    required this.cardIndex,
    required this.total,
    required this.mode,
    required this.canMarkKnown,
    required this.onBack,
    required this.onMarkKnown,
  });

  final String collectionName;
  final int cardIndex;
  final int total;
  final VocabCardMode mode;
  final bool canMarkKnown;
  final VoidCallback onBack;
  final VoidCallback onMarkKnown;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final progress = total == 0 ? 0.0 : cardIndex / total;
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 12, 8),
            child: Row(
              children: [
                IconButton(onPressed: onBack, icon: const Icon(PhosphorIcons.arrowLeft)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        collectionName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: tokens.foreground),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0, 1),
                          minHeight: 4,
                          backgroundColor: const Color(0xFFF97316).withValues(alpha: 0.15),
                          valueColor: const AlwaysStoppedAnimation(Color(0xFFF97316)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$cardIndex/$total',
                  style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 12, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(999)),
                  child: Text(
                    _modeLabels[mode] ?? '',
                    style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                  ),
                ),
                TextButton(
                  onPressed: canMarkKnown ? onMarkKnown : null,
                  child: const Text('✓ Đã biết', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
