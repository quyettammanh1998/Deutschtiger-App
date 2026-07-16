import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/goethe_b1_writing_topic_summary.dart';
import '../../../../../l10n/app_localizations.dart';

/// One topic row inside the topic-list card — web parity
/// `topic-list-item.tsx`: position/lock/check badge, title + HOT/Premium/
/// completed pills, difficulty + frequency stars, chevron or "Mua Premium".
class TopicRow extends StatelessWidget {
  const TopicRow({
    super.key,
    required this.topic,
    required this.position,
    required this.isCompleted,
    required this.isLocked,
    required this.onTap,
    this.onUpgrade,
  });

  final GoetheB1WritingTopicSummary topic;
  final int position;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback onTap;
  final VoidCallback? onUpgrade;

  static const _difficultyColors = {
    'easy': Color(0xFF16A34A),
    'medium': Color(0xFFB45309),
    'hard': Color(0xFFDC2626),
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final stars = topic.frequencyStars;
    final isHot = stars >= 5;
    final diffColor = _difficultyColors[topic.difficulty];

    return InkWell(
      onTap: isLocked ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isLocked
                    ? const Color(0xFFFDE68A).withValues(alpha: 0.5)
                    : isCompleted
                        ? const Color(0xFF22C55E)
                        : tokens.muted,
                shape: BoxShape.circle,
              ),
              child: Text(
                isLocked ? '🔒' : isCompleted ? '✓' : '$position',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isCompleted ? Colors.white : tokens.mutedForeground,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 2,
                    children: [
                      Text(
                        topic.titleDe,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isLocked ? tokens.mutedForeground : tokens.foreground,
                        ),
                      ),
                      if (isHot) _Pill(l10n.writingHotBadge, const Color(0xFFFFF7ED), const Color(0xFFEA580C)),
                      if (isCompleted) _Pill('✓ ${l10n.writingCompletedBadge}', const Color(0xFFF0FDF4), const Color(0xFF15803D)),
                      if (isLocked) _Pill(l10n.writingPremiumBadge, const Color(0xFFFDE68A), const Color(0xFFB45309)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isLocked ? '${topic.titleVi} · ${l10n.writingUnlockToView}' : topic.titleVi,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (stars > 0)
                        Text(
                          '★' * stars.clamp(0, 5) + '☆' * (5 - stars.clamp(0, 5)),
                          style: const TextStyle(fontSize: 11, color: Color(0xFFF59E0B)),
                        ),
                      if (diffColor != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: diffColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _difficultyLabel(l10n, topic.difficulty!),
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: diffColor),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (isLocked)
              GestureDetector(
                onTap: onUpgrade,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEA580C)]),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.writingBuyPremium,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              )
            else
              Icon(Icons.chevron_right, size: 18, color: tokens.mutedForeground.withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }

  String _difficultyLabel(AppLocalizations l10n, String value) => switch (value) {
        'easy' => l10n.writingDifficultyEasy,
        'hard' => l10n.writingDifficultyHard,
        _ => l10n.writingDifficultyMedium,
      };
}

class _Pill extends StatelessWidget {
  const _Pill(this.label, this.bg, this.fg);
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}
