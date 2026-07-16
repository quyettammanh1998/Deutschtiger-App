import 'package:flutter/material.dart';

/// Colored option grid — web parity: `case-cloze-quiz.tsx`/
/// `verb-case-matcher.tsx` `grid-cols-3` idle blue/indigo/violet buttons,
/// green ring on the correct answer once confirmed, red ring on a wrong
/// pick. Always renders in a fixed 3-column grid, matching web regardless
/// of how many options a question has (2-4 in practice).
class CaseQuizOptionGrid extends StatelessWidget {
  const CaseQuizOptionGrid({
    super.key,
    required this.options,
    required this.correctAnswer,
    required this.selected,
    required this.onSelect,
  });

  final List<String> options;
  final String correctAnswer;

  /// Null while unanswered.
  final String? selected;
  final ValueChanged<String> onSelect;

  static const _idleColors = [
    Color(0xFF3B82F6), // blue-500
    Color(0xFF6366F1), // indigo-500
    Color(0xFF8B5CF6), // violet-500
  ];

  @override
  Widget build(BuildContext context) {
    final confirmed = selected != null;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final option = options[index];
        final isAnswer = option == correctAnswer;
        final isSelected = option == selected;
        final idle = _idleColors[index % _idleColors.length];

        Color bg = idle;
        double opacity = 1;
        Border? ring;
        if (confirmed) {
          if (isAnswer) {
            bg = const Color(0xFF22C55E);
            ring = Border.all(color: const Color(0xFF86EFAC), width: 3);
          } else if (isSelected) {
            bg = const Color(0xFFEF4444);
            ring = Border.all(color: const Color(0xFFFCA5A5), width: 3);
          } else {
            opacity = 0.3;
          }
        }

        return Opacity(
          opacity: opacity,
          child: Material(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: confirmed ? null : () => onSelect(option),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: ring,
                ),
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
