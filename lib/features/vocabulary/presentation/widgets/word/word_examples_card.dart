import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../shared/widgets/speak_button.dart';
import '../../../../../shared/widgets/tappable_sentence.dart';
import '../../../../../shared/widgets/word_lookup_sheet.dart';
import '../../../domain/vocabulary_models.dart';

/// "Câu ví dụ" card — tappable sentences (tap a word → lookup sheet) + a
/// per-line speaker button. Web parity: examples block of
/// `vocabulary-word-page.tsx` (`TappableSentence` + `SoundIcon`).
class WordExamplesCard extends StatelessWidget {
  const WordExamplesCard({super.key, required this.examples});

  final List<Example> examples;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: tokens.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CÂU VÍ DỤ', style: TextStyle(fontSize: 11, letterSpacing: 1, color: tokens.mutedForeground.withValues(alpha: 0.7))),
          Text(
            '💡 Bấm vào từng từ để nghe phát âm',
            style: TextStyle(fontSize: 11, color: tokens.mutedForeground.withValues(alpha: 0.7)),
          ),
          for (var i = 0; i < examples.length; i++)
            Padding(
              padding: EdgeInsets.only(top: 12, bottom: i == examples.length - 1 ? 0 : 12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: i == examples.length - 1
                      ? null
                      : Border(bottom: BorderSide(color: tokens.border.withValues(alpha: 0.4))),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: i == examples.length - 1 ? 0 : 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TappableSentence(
                              text: examples[i].de,
                              style: TextStyle(fontSize: 15, height: 1.4, color: tokens.foreground),
                              onWordTap: (word) => showWordLookupSheet(context, word: word),
                            ),
                          ),
                          SpeakButton(text: examples[i].de, audioUrl: examples[i].audioUrl, iconSize: 16),
                        ],
                      ),
                      if (examples[i].vi.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(examples[i].vi, style: TextStyle(fontSize: 13, color: tokens.mutedForeground)),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
