import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_topic/uebungen_exercise.dart';
import 'exercise_result_banner.dart';

/// Fill-the-gap exercise — web parity `ClozeExercise`. Local grading only.
class ClozeExerciseView extends StatefulWidget {
  const ClozeExerciseView({super.key, required this.exercise});

  final ClozeExercise exercise;

  @override
  State<ClozeExerciseView> createState() => _ClozeExerciseViewState();
}

class _ClozeExerciseViewState extends State<ClozeExerciseView> {
  final Map<String, String> _answers = {};
  bool _checked = false;

  int get _correctCount => widget.exercise.questions
      .where((q) => _answers[q.id] == q.blank.correct)
      .length;

  void _retry() => setState(() {
        _answers.clear();
        _checked = false;
      });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final allAnswered = widget.exercise.questions.every((q) => _answers.containsKey(q.id));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final q in widget.exercise.questions)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: tokens.muted.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(q.textBefore, style: TextStyle(fontSize: 13, color: tokens.foreground)),
                for (final opt in q.blank.options)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                    child: _ClozeOption(
                      label: opt,
                      selected: _answers[q.id] == opt,
                      checked: _checked,
                      correct: opt == q.blank.correct,
                      onTap: _checked ? null : () => setState(() => _answers[q.id] = opt),
                    ),
                  ),
                Text(q.textAfter, style: TextStyle(fontSize: 13, color: tokens.foreground)),
                if (_checked && _answers[q.id] != q.blank.correct)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('→ ${q.blank.correct}', style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626))),
                  ),
              ],
            ),
          ),
        if (!_checked)
          FilledButton(
            onPressed: allAnswered ? () => setState(() => _checked = true) : null,
            child: const Text('Kiểm tra'),
          )
        else
          ExerciseResultBanner(correct: _correctCount, total: widget.exercise.questions.length, onRetry: _retry),
      ],
    );
  }
}

class _ClozeOption extends StatelessWidget {
  const _ClozeOption({
    required this.label,
    required this.selected,
    required this.checked,
    required this.correct,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool checked;
  final bool correct;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    Color border = tokens.border;
    Color bg = tokens.card;
    if (selected && !checked) {
      border = const Color(0xFFF97316);
      bg = const Color(0xFFFFEDD5);
    } else if (checked && selected && correct) {
      border = const Color(0xFF22C55E);
      bg = const Color(0xFFDCFCE7);
    } else if (checked && selected && !correct) {
      border = const Color(0xFFEF4444);
      bg = const Color(0xFFFEE2E2);
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: bg, border: Border.all(color: border), borderRadius: BorderRadius.circular(8)),
        child: Text(label, style: TextStyle(fontSize: 12, color: tokens.foreground)),
      ),
    );
  }
}
