import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/goethe_b1_writing_topic.dart';
import '../../../../../features/writing/domain/writing_topic/uebungen_exercise.dart';
import '../../../../../widgets/common/app_markdown_view.dart';
import '../uebungen/cloze_exercise_view.dart';
import '../uebungen/error_correction_exercise_view.dart';
import '../uebungen/match_exercise_view.dart';
import '../uebungen/mini_write_exercise_view.dart';
import '../uebungen/word_order_exercise_view.dart';

const _kindEmoji = {
  'cloze': '🧩',
  'word-order': '🔀',
  'match': '🎯',
  'error-correction': '🩹',
  'mini-write': '✏️',
};

/// `sec-uebungen` — tab strip switching between exercise kinds, falling
/// back to raw markdown (`uebungenRaw`) when no structured `uebungen[]`
/// exist. DEVIATION: no `sessionStorage`-equivalent per-exercise-state
/// persistence across app restarts (in-memory per page visit only) —
/// documented, matches this wave's effort budget.
class WritingUebungenSection extends StatefulWidget {
  const WritingUebungenSection({super.key, required this.topic});

  final GoetheB1WritingTopic topic;

  @override
  State<WritingUebungenSection> createState() => _WritingUebungenSectionState();
}

class _WritingUebungenSectionState extends State<WritingUebungenSection> {
  int _active = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final exercises = widget.topic.uebungen;
    if (exercises.isEmpty) {
      final raw = widget.topic.uebungenRaw;
      if (raw == null || raw.isEmpty) return const SizedBox.shrink();
      return AppMarkdownView(raw, dense: true);
    }
    final active = exercises[_active.clamp(0, exercises.length - 1)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var i = 0; i < exercises.length; i++)
              InkWell(
                onTap: () => setState(() => _active = i),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: _active == i
                        ? const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEA580C)])
                        : null,
                    color: _active == i ? null : tokens.muted,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${_kindEmoji[exercises[i].kind] ?? ''} ${exercises[i].title}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _active == i ? Colors.white : tokens.mutedForeground,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        KeyedSubtree(
          key: ValueKey(active.index),
          child: _buildExercise(active),
        ),
      ],
    );
  }

  Widget _buildExercise(Exercise ex) => switch (ex) {
        ClozeExercise() => ClozeExerciseView(exercise: ex),
        WordOrderExercise() => WordOrderExerciseView(exercise: ex),
        MatchExercise() => MatchExerciseView(exercise: ex),
        ErrorCorrectionExercise() => ErrorCorrectionExerciseView(exercise: ex),
        MiniWriteExercise() => MiniWriteExerciseView(exercise: ex),
        _ => const SizedBox.shrink(),
      };
}
