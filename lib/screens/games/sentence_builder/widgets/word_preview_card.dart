import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/games/sentence_builder_models.dart';
import '../../../../shared/widgets/speak_button.dart';
import '../../../../widgets/common/app_card.dart';

/// Web parity: `WordPreviewCard` in `word-preview-page.tsx` — word-type
/// badge, der/die/das gender prefix, essential sparkle, audio button,
/// expandable example list.
class WordPreviewCard extends StatelessWidget {
  const WordPreviewCard({
    super.key,
    required this.word,
    required this.isExpanded,
    required this.onToggle,
  });

  final SentenceBuilderTopicWord word;
  final bool isExpanded;
  final VoidCallback onToggle;

  static const _typeColors = {
    'verb': (bg: Color(0xFFDCEBFF), fg: Color(0xFF1D4ED8)),
    'noun': (bg: Color(0xFFDCF6E3), fg: Color(0xFF15803D)),
    'adjective': (bg: Color(0xFFEEE1FB), fg: Color(0xFF7C3AED)),
  };

  static const _typeLabels = {
    'verb': 'Động từ',
    'noun': 'Danh từ',
    'adjective': 'Tính từ',
  };

  static String _genderPrefix(String? gender) => switch (gender) {
    'masculine' => 'der',
    'feminine' => 'die',
    'neuter' => 'das',
    _ => '',
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final typeColor = _typeColors[word.wordType];
    final genderPrefix = _genderPrefix(word.gender);
    final hasExamples = word.examples.isNotEmpty;

    return AppCard.card(
      padding: EdgeInsets.zero,
      onTap: hasExamples ? onToggle : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor?.bg ?? tokens.muted,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _typeLabels[word.wordType] ?? word.wordType,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: typeColor?.fg ?? tokens.mutedForeground,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: tokens.foreground,
                                ),
                                children: [
                                  if (genderPrefix.isNotEmpty)
                                    TextSpan(
                                      text: '$genderPrefix ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: tokens.mutedForeground,
                                      ),
                                    ),
                                  TextSpan(text: word.contentDe),
                                ],
                              ),
                            ),
                          ),
                          if (word.isEssential) ...[
                            const SizedBox(width: 6),
                            Icon(
                              AppPhosphorIcons.sparkle,
                              size: 16,
                              color: Colors.amber.shade600,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        word.contentVi,
                        style: TextStyle(color: tokens.mutedForeground),
                      ),
                    ],
                  ),
                ),
                SpeakButton(text: word.contentDe, iconSize: 18),
              ],
            ),
            if (isExpanded && hasExamples) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: tokens.border)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ví dụ:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: tokens.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final example in word.examples)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: tokens.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            example,
                            style: TextStyle(
                              fontSize: 13,
                              color: tokens.mutedForeground,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
