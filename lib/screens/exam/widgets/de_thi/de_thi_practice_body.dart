import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../l10n/app_localizations.dart';
import 'de_thi_passage_panel.dart';
import 'de_thi_practice_footer.dart';
import 'de_thi_practice_header.dart';
import 'de_thi_practice_progress_strip.dart';
import 'de_thi_question_card.dart';

/// Web parity: main content column of `de-thi-practice-page.tsx` — header,
/// disclaimer, progress strip, single passage + its questions, footer nav.
/// Pure presentation; all mutable state lives in `DeThiPracticeScreen`.
class DeThiPracticeBody extends StatelessWidget {
  const DeThiPracticeBody({
    super.key,
    required this.entry,
    required this.exam,
    required this.answers,
    required this.submitted,
    required this.passageIndex,
    required this.onSelect,
    required this.onPrev,
    required this.onNext,
    required this.onSubmit,
    required this.onRetry,
    required this.onJumpTo,
  });

  final DeThiRegistryEntry entry;
  final DeThiExam exam;
  final Map<int, String> answers;
  final bool submitted;
  final int passageIndex;
  final void Function(int questionNo, String option) onSelect;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onSubmit;
  final VoidCallback onRetry;
  final ValueChanged<int> onJumpTo;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (exam.passages.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context).deThiListEmpty,
          style: TextStyle(color: tokens.mutedForeground),
        ),
      );
    }

    final allQuestions = exam.passages.expand((p) => p.questions).toList();
    final correctCount = allQuestions
        .where((q) => answers[q.no] == q.answer)
        .length;
    final totalQ = allQuestions.length;
    final score = totalQ > 0
        ? (correctCount / totalQ * 10 * 100).round() / 100
        : 0.0;
    final passage = exam.passages[passageIndex];
    final passageAnswered = passage.questions
        .where((q) => answers[q.no] != null)
        .length;

    return Column(
      children: [
        DeThiPracticeHeader(
          level: exam.level,
          title: entry.title,
          answeredTotal: answers.length,
          totalQuestions: totalQ,
          submitted: submitted,
          onSubmit: onSubmit,
        ),
        if (entry.disclaimer != null)
          DeThiPracticeDisclaimer(text: entry.disclaimer!),
        DeThiPracticeProgressStrip(
          submitted: submitted,
          passageIndex: passageIndex,
          totalPassages: exam.passages.length,
          passageAnswered: passageAnswered,
          passageTotal: passage.questions.length,
          correctCount: correctCount,
          totalQuestions: totalQ,
          score: score,
          onRetry: onRetry,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DeThiPassagePanel(
                passage: passage,
                index: passageIndex,
                answeredCount: passageAnswered,
                totalCount: passage.questions.length,
                submitted: submitted,
              ),
              const SizedBox(height: 8),
              const Divider(height: 32),
              for (final q in passage.questions)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DeThiQuestionCard(
                    question: q,
                    selected: answers[q.no],
                    submitted: submitted,
                    onSelect: (opt) => onSelect(q.no, opt),
                  ),
                ),
            ],
          ),
        ),
        DeThiPracticeFooter(
          passageIndex: passageIndex,
          totalPassages: exam.passages.length,
          submitted: submitted,
          onPrev: onPrev,
          onNext: onNext,
          onSubmit: onSubmit,
          onJumpTo: onJumpTo,
        ),
      ],
    );
  }
}
