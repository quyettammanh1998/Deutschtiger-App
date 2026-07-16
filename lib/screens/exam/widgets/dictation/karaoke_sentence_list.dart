import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';

/// Synced sentence list for one clip — highlights the sentence containing
/// [currentSeconds] and lets the learner tap any sentence to seek there.
/// Simplified stand-in for web's word-level `ExamTranscriptPanel` highlight
/// (sentence-granularity, not per-word) — reasonable given no shared
/// transcript-highlight widget exists in the Flutter app yet.
class KaraokeSentenceList extends StatelessWidget {
  const KaraokeSentenceList({
    super.key,
    required this.sentences,
    required this.currentSeconds,
    required this.onSeek,
  });

  final List<ExamDictationSentence> sentences;
  final double currentSeconds;
  final ValueChanged<double> onSeek;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final s in sentences)
          Builder(
            builder: (context) {
              final active =
                  currentSeconds >= s.start && currentSeconds < s.end;
              return InkWell(
                onTap: () => onSeek(s.start),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? tokens.primary.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.text,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: active ? tokens.primary : tokens.foreground,
                        ),
                      ),
                      if (s.textVi.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            s.textVi,
                            style: TextStyle(
                              fontSize: 11,
                              color: tokens.mutedForeground,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
