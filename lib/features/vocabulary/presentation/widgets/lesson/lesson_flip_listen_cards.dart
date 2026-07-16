import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../shared/widgets/speak_button.dart';

/// [VocabCardMode.flip] / [VocabCardMode.reverse] renderer — tap to reveal
/// the back face. Web parity: `FlipReverseCard` in
/// `vocabulary-lesson-card-renderers.tsx`.
class LessonFlipCard extends StatelessWidget {
  const LessonFlipCard({
    super.key,
    required this.wordDe,
    required this.wordVi,
    required this.audioUrl,
    required this.showBack,
    required this.onToggleBack,
    required this.isReverse,
  });

  final String wordDe;
  final String wordVi;
  final String audioUrl;
  final bool showBack;
  final VoidCallback onToggleBack;
  final bool isReverse;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final front = isReverse ? (wordVi.isEmpty ? '—' : wordVi) : wordDe;
    final back = isReverse ? wordDe : (wordVi.isEmpty ? '—' : wordVi);
    return GestureDetector(
      onTap: onToggleBack,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: tokens.border),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              front,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: tokens.foreground),
            ),
            if (audioUrl.isNotEmpty && !isReverse) ...[
              const SizedBox(height: 16),
              SpeakButton(text: wordDe, audioUrl: audioUrl),
            ],
            const SizedBox(height: 20),
            if (showBack)
              Text(back, textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: tokens.mutedForeground))
            else
              Text(
                'Bấm vào thẻ để ${isReverse ? "xem tiếng Đức" : "xem nghĩa"}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: tokens.mutedForeground.withValues(alpha: 0.6)),
              ),
          ],
        ),
      ),
    );
  }
}

/// [VocabCardMode.listen] renderer — audio-first, tap to reveal the word.
/// Web parity: `ListenCard`.
class LessonListenCard extends StatelessWidget {
  const LessonListenCard({
    super.key,
    required this.wordDe,
    required this.wordVi,
    required this.audioUrl,
    required this.showBack,
    required this.onToggleBack,
  });

  final String wordDe;
  final String wordVi;
  final String audioUrl;
  final bool showBack;
  final VoidCallback onToggleBack;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return GestureDetector(
      onTap: onToggleBack,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: tokens.border),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'NGHE VÀ ĐOÁN NGHĨA',
              style: TextStyle(fontSize: 11, letterSpacing: 1, color: tokens.mutedForeground),
            ),
            const SizedBox(height: 16),
            if (audioUrl.isNotEmpty)
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFFB923C), Color(0xFFEA580C)]),
                  shape: BoxShape.circle,
                ),
                child: SpeakButton(text: wordDe, audioUrl: audioUrl, iconSize: 32),
              ),
            const SizedBox(height: 20),
            if (showBack)
              Column(
                children: [
                  Text(wordDe, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: tokens.foreground)),
                  const SizedBox(height: 4),
                  Text(wordVi.isEmpty ? '—' : wordVi, style: TextStyle(fontSize: 15, color: tokens.mutedForeground)),
                ],
              )
            else
              Text(
                'Bấm vào thẻ để xem đáp án',
                style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: tokens.mutedForeground.withValues(alpha: 0.6)),
              ),
          ],
        ),
      ),
    );
  }
}
