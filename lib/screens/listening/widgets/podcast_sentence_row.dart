import 'package:flutter/material.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/data/listening/podcast_models.dart';
import 'package:deutschtiger/shared/widgets/word_lookup_sheet.dart';

final _kPunctuation = RegExp(r'[.,!?;:"“”‘’()\[\]„]');

/// 1 dòng transcript trong podcast player — câu đang phát highlight theo
/// TỪNG TỪ (tím), tap từ → tra cứu (`WordLookupSheet`), tap dòng → seek.
/// Web parity: `SentenceRow` trong `easy-german-podcast-player-page.tsx`.
class PodcastSentenceRow extends StatelessWidget {
  const PodcastSentenceRow({
    super.key,
    required this.sentence,
    required this.isActive,
    required this.activeWordIndex,
    required this.showVi,
    required this.onTap,
  });

  final PodcastSentence sentence;
  final bool isActive;
  final int activeWordIndex;
  final bool showVi;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    const purple50 = Color(0xFFFAF5FF);
    const purple300 = Color(0xFFD8B4FE);
    const purple600 = Color(0xFF9333EA);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? purple50.withValues(alpha: 0.8) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive ? Border.all(color: purple300) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isActive && sentence.words.isNotEmpty)
              Wrap(
                children: [
                  for (var i = 0; i < sentence.words.length; i++)
                    _WordSpan(
                      text: sentence.words[i].text,
                      isActive: i == activeWordIndex,
                      onTap: () => showWordLookupSheet(
                        context,
                        word: sentence.words[i].text.replaceAll(_kPunctuation, '').trim(),
                      ),
                    ),
                ],
              )
            else
              Text(
                sentence.text,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive ? tokens.foreground : tokens.foreground.withValues(alpha: 0.7),
                ),
              ),
            if (showVi && sentence.textVi.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  sentence.textVi,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: isActive ? purple600 : tokens.mutedForeground,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WordSpan extends StatelessWidget {
  const _WordSpan({required this.text, required this.isActive, required this.onTap});

  final String text;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const purple500 = Color(0xFFA855F7);
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 2),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          decoration: BoxDecoration(
            color: isActive ? purple500 : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 17,
              height: 1.5,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? Colors.white : context.tokens.foreground,
            ),
          ),
        ),
      ),
    );
  }
}
