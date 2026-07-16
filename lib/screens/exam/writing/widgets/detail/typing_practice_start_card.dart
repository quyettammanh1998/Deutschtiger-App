import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../typing_practice/typing_practice_sheet.dart';

/// `sec-luyen-go` — "Luyện gõ bài này" entry card, opens
/// [TypingPracticeSheet] with every collected sentence.
class WritingTypingPracticeStartCard extends StatelessWidget {
  const WritingTypingPracticeStartCard({super.key, required this.sentences});

  final List<String> sentences;

  @override
  Widget build(BuildContext context) {
    if (sentences.isEmpty) return const SizedBox.shrink();
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFF7ED), Color(0xFFFFFBEB)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Column(
        children: [
          const Text('✍️', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(l10n.writingTypingStartTitle, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: tokens.foreground)),
          const SizedBox(height: 4),
          Text(
            l10n.writingTypingStartDesc(sentences.length),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF97316)),
              onPressed: () => TypingPracticeSheet.show(context, sentences: sentences),
              child: Text(l10n.writingTypingStartCta),
            ),
          ),
        ],
      ),
    );
  }
}
