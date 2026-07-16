import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_topic/grammar_wortschatz_mistakes.dart';
import '../../../../../features/writing/presentation/widgets/writing_audio_play_button.dart';
import '../../../../../l10n/app_localizations.dart';

/// `sec-fehler` (default closed) — wrong (strikethrough) → correct rows.
class WritingCommonMistakesCard extends StatelessWidget {
  const WritingCommonMistakesCard({super.key, required this.items});

  final List<CommonMistake> items;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: i.isEven ? tokens.muted.withValues(alpha: 0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('❌ ${items[i].wrong}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFFDC2626), decoration: TextDecoration.lineThrough)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text('✅ ${items[i].correct}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF15803D))),
                    ),
                    WritingAudioPlayButton(text: items[i].correct, audioUrl: items[i].audioUrl, size: 14),
                  ],
                ),
                if (items[i].vi.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text('${i + 1}. ${items[i].vi}', style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                  ),
              ],
            ),
          ),
        if (items.isEmpty) Text(l10n.writingNoContent, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
      ],
    );
  }
}
