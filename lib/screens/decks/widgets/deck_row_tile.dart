import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/decks/deck_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_card.dart';
import 'deck_mastery_bar.dart';

/// One deck row in the "Tất cả decks" list. Web parity:
/// `flashcard-deck-list.tsx` unfoldered-deck row — default-deck star, name +
/// "Mặc định" badge, description, mastery bar, 3-dot context menu, chevron.
class DeckRowTile extends StatelessWidget {
  const DeckRowTile({
    super.key,
    required this.deck,
    required this.isDefault,
    required this.summary,
    required this.onTap,
    required this.onSetDefault,
    required this.onEdit,
    required this.onMoveToFolder,
  });

  final Deck deck;
  final bool isDefault;
  final DeckSummaryRow? summary;
  final VoidCallback onTap;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;
  final VoidCallback onMoveToFolder;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    const amber = Color(0xFFF59E0B);

    return AppCard.small(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onSetDefault,
            tooltip: isDefault ? l10n.deckDefaultTooltip : l10n.deckSetDefaultTooltip,
            icon: Icon(
              isDefault ? PhosphorIconsFill.star : PhosphorIconsRegular.star,
              color: isDefault ? amber : tokens.mutedForeground.withValues(alpha: 0.3),
              size: 20,
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        deck.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: tokens.foreground,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: 6),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: Text(
                            l10n.deckDefaultBadge,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: amber,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (deck.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    deck.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                  ),
                ],
                if (summary != null && summary!.total > 0) ...[
                  const SizedBox(height: 4),
                  DeckMasteryBar(summary: summary!, compact: true),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(PhosphorIconsBold.dotsThreeVertical, size: 16, color: tokens.mutedForeground.withValues(alpha: 0.6)),
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'move') onMoveToFolder();
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
              PopupMenuItem(value: 'move', child: Text(l10n.deckMoveToFolder)),
            ],
          ),
          Icon(PhosphorIconsBold.caretRight, size: 16, color: tokens.mutedForeground.withValues(alpha: 0.4)),
        ],
      ),
    );
  }
}
