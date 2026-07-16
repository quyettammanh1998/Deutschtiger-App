import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';

/// One collapsible clip within [WordSelectionPanel] — Teil badge header +
/// flowing tappable transcript body.
class WordSelectionClipCard extends StatelessWidget {
  const WordSelectionClipCard({
    super.key,
    required this.audio,
    required this.label,
    required this.contentWords,
    required this.expanded,
    required this.onToggle,
    required this.selected,
    required this.onToggleWord,
  });

  final ExamDictationAudio audio;
  final String label;
  final Set<String> contentWords;
  final bool expanded;
  final VoidCallback onToggle;
  final Set<String> selected;
  final ValueChanged<String> onToggleWord;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final selectableCount = audio.sentences.fold<int>(
      0,
      (n, s) => n + s.words.where((w) => contentWords.contains(w.clean)).length,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: tokens.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: tokens.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$selectableCount từ',
                    style: TextStyle(
                      fontSize: 11,
                      color: tokens.mutedForeground,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    expanded ? Icons.expand_less : Icons.chevron_right,
                    color: tokens.mutedForeground,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Wrap(
                spacing: 4,
                runSpacing: 6,
                children: [
                  for (final sentence in audio.sentences)
                    for (final w in sentence.words)
                      contentWords.contains(w.clean)
                          ? _TapWord(
                              word: w.word,
                              selected: selected.contains(w.clean),
                              onTap: () => onToggleWord(w.clean),
                            )
                          : Text(
                              '${w.word} ',
                              style: TextStyle(color: tokens.foreground),
                            ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TapWord extends StatelessWidget {
  const _TapWord({
    required this.word,
    required this.selected,
    required this.onTap,
  });

  final String word;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected
              ? tokens.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: Text(
            word,
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dotted,
              color: selected
                  ? tokens.primary
                  : tokens.primary.withValues(alpha: 0.75),
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
