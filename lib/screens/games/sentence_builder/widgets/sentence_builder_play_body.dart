import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/games/sentence_builder_models.dart';
import '../../../../data/learn/learn_models.dart';

/// In-progress play view — word card + text field + AI feedback. Extracted
/// from `sentence_builder_play_screen.dart` to stay under the module LOC
/// guideline.
class SentenceBuilderPlayBody extends StatelessWidget {
  const SentenceBuilderPlayBody({
    super.key,
    required this.session,
    required this.index,
    required this.controller,
    required this.feedback,
    required this.submitting,
    required this.submitError,
    required this.onSubmit,
    required this.onNext,
  });

  final SentenceBuilderSession session;
  final int index;
  final TextEditingController controller;
  final GradeSentenceResult? feedback;
  final bool submitting;
  final bool submitError;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final word = session.words[index];
    final total = session.words.length;
    final showNext = feedback != null || submitError;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${index + 1}/$total lượt · ${session.topic.labelVi}',
            style: TextStyle(color: tokens.mutedForeground),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: index / total,
            color: tokens.primary,
            backgroundColor: tokens.muted,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: tokens.card,
              borderRadius: BorderRadius.circular(tokens.radius),
              border: Border.all(color: tokens.border),
            ),
            child: Column(
              children: [
                Text(
                  word.contentDe,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: tokens.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  word.contentVi,
                  style: TextStyle(color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Viết câu có từ "${word.contentDe}":',
            style: TextStyle(color: tokens.foreground),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('sentence-builder-input'),
            controller: controller,
            maxLines: 3,
            enabled: feedback == null && !submitting,
            decoration: const InputDecoration(
              hintText: 'Nhập câu tiếng Đức...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          if (submitting)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 10),
                  Text('Đang chấm...'),
                ],
              ),
            ),
          if (feedback != null) _FeedbackCard(feedback: feedback!),
          if (submitError)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Không thể chấm bài. Vui lòng thử lại.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 16),
          if (!showNext)
            FilledButton(
              onPressed: submitting ? null : onSubmit,
              child: const Text('Kiểm tra'),
            )
          else
            FilledButton(
              key: const Key('sentence-builder-next'),
              onPressed: onNext,
              child: Text(index + 1 >= total ? 'Xem kết quả' : 'Tiếp tục'),
            ),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.feedback});

  final GradeSentenceResult feedback;

  @override
  Widget build(BuildContext context) {
    final good = feedback.score >= 70;
    return Card(
      color: good
          ? Colors.green.withValues(alpha: 0.08)
          : Colors.amber.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${feedback.score}/100',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (feedback.summaryVi.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(feedback.summaryVi),
            ],
            if (feedback.correctedSentence.isNotEmpty && !good) ...[
              const SizedBox(height: 6),
              Text(
                '"${feedback.correctedSentence}"',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
