import 'package:flutter/material.dart';

/// 🔥 streak badge — web parity: `case-cloze-quiz.tsx` header row, shown
/// once the current correct-answer streak reaches 3.
class CaseQuizStreakBadge extends StatelessWidget {
  const CaseQuizStreakBadge({super.key, required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    if (streak < 3) return const SizedBox(width: 48);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🔥', style: TextStyle(fontSize: 14)),
        const SizedBox(width: 2),
        Text(
          '$streak',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}
