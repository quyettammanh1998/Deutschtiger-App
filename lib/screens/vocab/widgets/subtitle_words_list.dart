import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/vocab/subtitle_word.dart';
import '../../../l10n/app_localizations.dart';
import 'subtitle_word_row.dart';

/// Select-all toolbar + word rows + empty state — web parity:
/// `subtitle-words-page.tsx` select-all bar and word list/empty-state block.
class SubtitleWordsList extends StatelessWidget {
  const SubtitleWordsList({
    super.key,
    required this.words,
    required this.selectedIds,
    required this.onToggleWord,
    required this.onSelectAll,
    required this.onClearSelection,
  });

  final List<SubtitleWord> words;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleWord;
  final VoidCallback onSelectAll;
  final VoidCallback onClearSelection;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    if (words.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Column(
            children: [
              const Text('📽️', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 12),
              Text(
                l10n.subtitleWordsEmpty,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: tokens.foreground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.subtitleWordsEmptyHint,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                selectedIds.isNotEmpty
                    ? l10n.subtitleWordsSelectedCount(selectedIds.length)
                    : l10n.subtitleWordsCountLabel(words.length),
                style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
              ),
            ),
            TextButton(
              onPressed: onSelectAll,
              child: Text(
                l10n.subtitleWordsSelectAll,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: tokens.primary),
              ),
            ),
            if (selectedIds.isNotEmpty)
              TextButton(
                onPressed: onClearSelection,
                child: Text(
                  l10n.subtitleWordsClearSelection,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: tokens.mutedForeground,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        for (final word in words)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SubtitleWordRow(
              key: Key('subtitle_word_${word.learningItemId}'),
              word: word,
              selected: selectedIds.contains(word.learningItemId),
              onToggle: word.learningItemId.isEmpty
                  ? () {}
                  : () => onToggleWord(word.learningItemId),
            ),
          ),
      ],
    );
  }
}
