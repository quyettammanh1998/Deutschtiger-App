import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/decks/deck_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_card.dart';

const _folderPalette = <Color>[
  Color(0xFF3B82F6),
  Color(0xFF10B981),
  Color(0xFF8B5CF6),
  Color(0xFFF59E0B),
  Color(0xFFF43F5E),
  Color(0xFF06B6D4),
];

/// Virtual "Starred" row above the folder list. Web parity:
/// `flashcard-deck-list.tsx` starred section.
class DeckStarredRow extends StatelessWidget {
  const DeckStarredRow({super.key, required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    const amber = Color(0xFFF59E0B);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard.card(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(PhosphorIconsFill.star, color: amber, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.deckStarredTitle,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: tokens.foreground),
                  ),
                  Text(
                    l10n.deckStarredSubtitle,
                    style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                  ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(color: amber.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text('$count', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: amber)),
              ),
            ),
            const SizedBox(width: 6),
            Icon(PhosphorIconsBold.caretRight, size: 14, color: tokens.mutedForeground.withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }
}

/// Root-level folders — rotating 6-color icon palette, deck/subfolder
/// counts. Web parity: `flashcard-deck-list.tsx` folder section.
class DeckFolderSection extends StatelessWidget {
  const DeckFolderSection({super.key, required this.folders, required this.onTapFolder});

  final List<DeckFolder> folders;
  final void Function(DeckFolder folder) onTapFolder;

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) return const SizedBox.shrink();
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6, left: 2),
            child: Text(
              l10n.deckFoldersTitle,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: tokens.mutedForeground,
              ),
            ),
          ),
          AppCard.card(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < folders.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: tokens.border),
                  _FolderRow(
                    folder: folders[i],
                    color: _folderPalette[i % _folderPalette.length],
                    onTap: () => onTapFolder(folders[i]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FolderRow extends StatelessWidget {
  const _FolderRow({required this.folder, required this.color, required this.onTap});

  final DeckFolder folder;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
              child: Icon(PhosphorIconsFill.folder, color: color, size: 14),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                folder.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: tokens.foreground),
              ),
            ),
            if (folder.subfolderCount > 0) ...[
              Icon(PhosphorIconsFill.folder, size: 12, color: tokens.mutedForeground),
              const SizedBox(width: 2),
              Text('${folder.subfolderCount}', style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
              const SizedBox(width: 8),
            ],
            Text('${folder.deckCount}', style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
            const SizedBox(width: 6),
            Icon(PhosphorIconsBold.caretRight, size: 14, color: tokens.mutedForeground.withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }
}
