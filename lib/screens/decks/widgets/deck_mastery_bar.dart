import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/decks/deck_models.dart';

/// Segmented horizontal mastery bar (mastered/known/learning/new). Web
/// parity: `deck-mastery-progress-bar.tsx`. Shared by deck list rows and
/// deck detail header.
class DeckMasteryBar extends StatelessWidget {
  const DeckMasteryBar({super.key, required this.summary, this.compact = false});

  final DeckSummaryRow summary;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (summary.total == 0) return const SizedBox.shrink();
    final tokens = context.tokens;
    final segments = <(int, Color)>[
      (summary.mastered, const Color(0xFF10B981)),
      (summary.known, const Color(0xFF3B82F6)),
      (summary.learning, const Color(0xFFF59E0B)),
      (summary.newCount, tokens.mutedForeground.withValues(alpha: 0.3)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: compact ? 4 : 6,
            child: Row(
              children: [
                for (final (count, color) in segments)
                  if (count > 0)
                    Expanded(
                      flex: count,
                      child: ColoredBox(color: color),
                    ),
              ],
            ),
          ),
        ),
        if (!compact) ...[
          const SizedBox(height: 4),
          Text(
            '${summary.percentMastered}% thuần thục',
            style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
          ),
        ],
      ],
    );
  }
}
