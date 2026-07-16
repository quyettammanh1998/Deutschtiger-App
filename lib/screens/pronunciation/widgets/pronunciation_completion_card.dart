import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/confetti_overlay.dart';

/// Trainer/minimal-pairs completion screen — web parity: centered card with
/// confetti, big accuracy `%`, `x / N đúng`, "Luyện lại" (orange gradient) +
/// "Quay lại"/"Đổi cặp âm" (secondary) buttons. No XP chip: the app has no
/// gamification/XP-award wiring for the pronunciation cluster yet (deferred,
/// see phase report) so we don't fabricate an XP value.
class PronunciationCompletionCard extends StatefulWidget {
  const PronunciationCompletionCard({
    super.key,
    required this.titleLabel,
    required this.score,
    required this.total,
    required this.scoreLabel,
    required this.retryLabel,
    required this.onRetry,
    required this.secondaryLabel,
    required this.onSecondary,
    this.lowScoreHint,
  });

  final String titleLabel;
  final int score;
  final int total;

  /// e.g. "x / N đúng".
  final String Function(int score, int total) scoreLabel;

  final String retryLabel;
  final VoidCallback onRetry;
  final String secondaryLabel;
  final VoidCallback onSecondary;

  /// Encouragement line shown when accuracy < 60% (minimal-pairs summary).
  final String? lowScoreHint;

  @override
  State<PronunciationCompletionCard> createState() =>
      _PronunciationCompletionCardState();
}

class _PronunciationCompletionCardState
    extends State<PronunciationCompletionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final accuracy = widget.total > 0
        ? (widget.score / widget.total * 100).round()
        : 100;
    final showHint = widget.lowScoreHint != null && accuracy < 60;

    return Stack(
      children: [
        Positioned.fill(child: ConfettiOverlay(controller: _controller)),
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: tokens.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.titleLabel,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: tokens.foreground,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$accuracy%',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: tokens.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.scoreLabel(widget.score, widget.total),
                  style: TextStyle(color: tokens.mutedForeground),
                ),
                if (showHint) ...[
                  const SizedBox(height: 16),
                  Text(
                    widget.lowScoreHint!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFB45309),
                      fontSize: 13,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: widget.onRetry,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: Text(
                                widget.retryLabel,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onSecondary,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: tokens.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(widget.secondaryLabel),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Emoji matching web's `accuracy >= 80 ? '🎉' : accuracy >= 50 ? '💪' :
/// '🔁'` (minimal-pairs summary only).
String pronunciationSummaryEmoji(int accuracy) {
  if (accuracy >= 80) return '🎉';
  if (accuracy >= 50) return '💪';
  return '🔁';
}
