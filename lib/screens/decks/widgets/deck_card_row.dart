import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/decks/deck_models.dart';
import '../../../shared/widgets/speak_button.dart';
import '../../../widgets/common/app_card.dart';

/// One card row in the deck-detail list — word/translation, star toggle,
/// TTS. Web parity: `flashcard-deck-detail.tsx` card list row.
class DeckCardRow extends StatelessWidget {
  const DeckCardRow({
    super.key,
    required this.card,
    required this.onTap,
    required this.onToggleStar,
  });

  final DeckWord card;
  final VoidCallback onTap;
  final VoidCallback onToggleStar;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    const amber = Color(0xFFF59E0B);

    return AppCard.small(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.word,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tokens.foreground),
                ),
                const SizedBox(height: 2),
                Text(
                  card.translation,
                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SpeakButton(text: card.word, audioUrl: card.audioUrl, iconSize: 18),
          IconButton(
            onPressed: onToggleStar,
            tooltip: card.isStarred ? 'Bỏ gắn sao' : 'Gắn sao',
            icon: Icon(
              card.isStarred ? PhosphorIconsFill.star : PhosphorIconsRegular.star,
              color: card.isStarred ? amber : tokens.mutedForeground.withValues(alpha: 0.3),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
