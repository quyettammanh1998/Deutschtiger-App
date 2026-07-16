import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_topic/grammar_wortschatz_mistakes.dart';
import '../../../../../features/writing/presentation/widgets/writing_audio_play_button.dart';

/// `sec-grammatik` (default closed) — pattern + example + "Khi dùng" note.
class WritingGrammarFocusCard extends StatelessWidget {
  const WritingGrammarFocusCard({super.key, required this.items});

  final List<GrammarFocusItem> items;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: tokens.muted.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.pattern, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: tokens.foreground)),
                if (item.structure != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(color: tokens.card, border: Border.all(color: tokens.border), borderRadius: BorderRadius.circular(4)),
                    child: Text(item.structure!, style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: Text(item.example, style: const TextStyle(fontSize: 12, color: Color(0xFFEA580C)))),
                    WritingAudioPlayButton(text: item.example, audioUrl: item.audioUrl, size: 14),
                  ],
                ),
                if ((item.when ?? item.vi).isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFBEB),
                      border: Border(left: BorderSide(color: Color(0xFFFBBF24), width: 2)),
                    ),
                    child: Text(item.when ?? item.vi, style: const TextStyle(fontSize: 11, color: Color(0xFF92400E))),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
