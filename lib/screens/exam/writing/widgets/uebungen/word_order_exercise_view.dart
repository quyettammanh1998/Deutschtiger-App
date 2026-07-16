import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_topic/uebungen_exercise.dart';
import 'exercise_result_banner.dart';

/// Word-order (build-the-sentence) exercise — web parity `WordOrderExercise`.
class WordOrderExerciseView extends StatefulWidget {
  const WordOrderExerciseView({super.key, required this.exercise});

  final WordOrderExercise exercise;

  @override
  State<WordOrderExerciseView> createState() => _WordOrderExerciseViewState();
}

class _WordOrderExerciseViewState extends State<WordOrderExerciseView> {
  final Map<String, List<String>> _placed = {};
  bool _checked = false;

  static String _normalize(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), '').trim();

  bool _isCorrect(WordOrderQuestion q) =>
      _normalize((_placed[q.id] ?? const []).join(' ')) == _normalize(q.correct);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final allPlaced = widget.exercise.questions
        .every((q) => (_placed[q.id]?.length ?? 0) == q.tokens.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < widget.exercise.questions.length; i++)
          _buildQuestion(context, tokens, widget.exercise.questions[i], i),
        if (!_checked)
          FilledButton(
            onPressed: allPlaced ? () => setState(() => _checked = true) : null,
            child: const Text('Kiểm tra'),
          )
        else
          ExerciseResultBanner(
            correct: widget.exercise.questions.where(_isCorrect).length,
            total: widget.exercise.questions.length,
            onRetry: () => setState(() {
              _placed.clear();
              _checked = false;
            }),
          ),
      ],
    );
  }

  Widget _buildQuestion(BuildContext context, AppTokens tokens, WordOrderQuestion q, int i) {
    final placed = _placed[q.id] ?? const [];
    final remaining = List<String>.from(q.tokens);
    for (final p in placed) {
      remaining.remove(p);
    }
    final ok = _checked && _isCorrect(q);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: tokens.muted.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (q.vi != null) Text('${i + 1}. ${q.vi}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
          const SizedBox(height: 6),
          Container(
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _checked ? (ok ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2)) : tokens.card,
              border: Border.all(color: _checked ? (ok ? const Color(0xFF4ADE80) : const Color(0xFFF87171)) : tokens.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: placed.isEmpty
                  ? [Text('Chọn từ bên dưới…', style: TextStyle(fontSize: 11, color: tokens.mutedForeground))]
                  : [
                      for (final t in placed)
                        _Chip(
                          label: t,
                          onTap: _checked ? null : () => setState(() => (_placed[q.id] ??= []).remove(t)),
                        ),
                    ],
            ),
          ),
          if (_checked && !ok)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('Đúng: ${q.correct}', style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626))),
            ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final t in remaining)
                _Chip(
                  label: t,
                  filled: false,
                  onTap: _checked ? null : () => setState(() => (_placed[q.id] ??= []).add(t)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.onTap, this.filled = true});
  final String label;
  final VoidCallback? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: filled ? tokens.primary.withValues(alpha: 0.1) : tokens.card,
          border: Border.all(color: tokens.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, color: tokens.foreground)),
      ),
    );
  }
}
