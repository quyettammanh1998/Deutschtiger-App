import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/vocab/vocab_models.dart';

/// Quiz question card + 3 colored answer buttons shown below the sprite
/// stage on the Deutsch Runner playing screen.
class RunnerAnswerPanel extends StatelessWidget {
  const RunnerAnswerPanel({
    super.key,
    required this.question,
    required this.options,
    required this.selected,
    required this.isCorrect,
    required this.onSelect,
  });

  final VocabWord question;
  final List<String> options;
  final String? selected;

  /// Null while unanswered.
  final bool? isCorrect;
  final ValueChanged<String> onSelect;

  static const _colors = [Colors.blue, Colors.pink, Colors.green];

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(tokens.radius),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        children: [
          Text(
            question.word,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Chọn nghĩa đúng',
            style: TextStyle(fontSize: 14, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < options.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                _AnswerButton(
                  answer: options[i],
                  color: _colors[i % _colors.length],
                  isSelected: selected == options[i],
                  isCorrect:
                      isCorrect == true && question.translation == options[i],
                  isWrong: selected == options[i] && isCorrect == false,
                  onTap: () => onSelect(options[i]),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.answer,
    required this.color,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  final String answer;
  final Color color;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color bgColor = color;
    if (isCorrect) bgColor = Colors.green;
    if (isWrong) bgColor = Colors.red;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              answer,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
