import 'package:flutter/material.dart';

/// FSRS rating — value 1..4 matching `POST /user/srs/review`'s `rating`
/// field (go-fsrs Again/Hard/Good/Easy).
class LessonRatingOption {
  const LessonRatingOption(this.value, this.label, this.emoji, this.gradient);
  final int value;
  final String label;
  final String emoji;
  final List<Color> gradient;
}

const lessonRatingOptions = [
  LessonRatingOption(1, 'Quên', '😬', [Color(0xFFEF4444), Color(0xFFDC2626)]),
  LessonRatingOption(2, 'Khó', '🤔', [Color(0xFFF97316), Color(0xFFEA580C)]),
  LessonRatingOption(3, 'Ổn', '🙂', [Color(0xFF22C55E), Color(0xFF16A34A)]),
  LessonRatingOption(4, 'Dễ', '😎', [Color(0xFF3B82F6), Color(0xFF2563EB)]),
];

/// The 4-button emoji rating grid shown once the current card has an answer
/// (flip revealed / writing-choice-cloze-compose result). Web parity:
/// `RATINGS` grid in `vocabulary-lesson-page.tsx`.
class LessonRatingGrid extends StatelessWidget {
  const LessonRatingGrid({
    super.key,
    required this.onRate,
    required this.enabled,
    this.suggested,
  });

  final ValueChanged<int> onRate;
  final bool enabled;

  /// Rating value the app nudges the learner toward (matches web's
  /// `suggested` ring highlight — correct answer suggests 3, wrong suggests
  /// 2). Purely a visual hint; the learner still picks freely.
  final int? suggested;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
          for (final option in lessonRatingOptions)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _RatingButton(
                  option: option,
                  enabled: enabled,
                  highlighted: suggested == option.value,
                  onTap: () => onRate(option.value),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton({
    required this.option,
    required this.enabled,
    required this.highlighted,
    required this.onTap,
  });

  final LessonRatingOption option;
  final bool enabled;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: enabled ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: option.gradient),
              borderRadius: BorderRadius.circular(12),
              border: highlighted ? Border.all(color: Colors.white.withValues(alpha: 0.6), width: 2) : null,
            ),
            child: Column(
              children: [
                Text(option.emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 2),
                Text(
                  option.label,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
