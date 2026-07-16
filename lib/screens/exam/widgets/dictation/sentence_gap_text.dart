import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import 'dictation_cue.dart';

/// Renders [cue.sentenceText] with the cued word blanked out (or revealed) —
/// mirrors web `SentenceWithGap`. Shows a first-letter hint after >=1 wrong
/// attempt.
class SentenceGapText extends StatelessWidget {
  const SentenceGapText({
    super.key,
    required this.cue,
    required this.revealed,
    required this.wrongAttempts,
  });

  final DictationCue cue;
  final bool revealed;
  final int wrongAttempts;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final sentenceTokens = cue.sentenceText.split(RegExp(r'\s+'));
    var matchCount = 0;
    final showFirstLetter = wrongAttempts >= 1;
    final firstLetter = cue.word.isNotEmpty ? cue.word[0] : '';
    final letters = letterCount(cue.word);

    final spans = <InlineSpan>[];
    for (final token in sentenceTokens) {
      final tokenClean = normaliseWord(token);
      final isMatch = tokenClean == cue.clean;
      final isGap = isMatch && matchCount++ == cue.occurrenceRank;
      if (isGap) {
        if (revealed) {
          spans.add(
            WidgetSpan(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: tokens.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border(
                    bottom: BorderSide(color: tokens.primary, width: 2),
                  ),
                ),
                child: Text(
                  cue.word,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: tokens.primary,
                  ),
                ),
              ),
            ),
          );
        } else {
          spans.add(
            WidgetSpan(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                constraints: const BoxConstraints(minWidth: 70),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: tokens.primary.withValues(alpha: 0.05),
                  border: Border(
                    bottom: BorderSide(color: tokens.primary, width: 2),
                  ),
                ),
                child: Text(
                  showFirstLetter
                      ? '$firstLetter${'_' * (letters - 1).clamp(0, 30)}'
                      : '${'_' * letters.clamp(1, 30)} ($letters chữ cái)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: tokens.mutedForeground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }
      } else {
        spans.add(TextSpan(text: '$token '));
      }
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 15, color: tokens.foreground, height: 1.6),
        children: spans,
      ),
    );
  }
}
