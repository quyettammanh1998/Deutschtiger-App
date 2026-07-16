import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_topic/uebungen_exercise.dart';
import '../../../../../l10n/app_localizations.dart';

/// Error-correction exercise — reveal-only mode.
///
/// DEVIATION (see `uebungen_exercise.dart` doc comment): web AI-grades the
/// student's typed correction via `/ai/grade-sentence`(-batch, 1.5s idle
/// prefetch). This wave ships type-then-reveal instead (no AI call) — the
/// student writes their fix, taps "Xem đáp án" to compare against
/// `correct`/`explanation`. Full AI batch grading is a named follow-up.
class ErrorCorrectionExerciseView extends StatefulWidget {
  const ErrorCorrectionExerciseView({super.key, required this.exercise});

  final ErrorCorrectionExercise exercise;

  @override
  State<ErrorCorrectionExerciseView> createState() => _ErrorCorrectionExerciseViewState();
}

class _ErrorCorrectionExerciseViewState extends State<ErrorCorrectionExerciseView> {
  final Map<String, TextEditingController> _controllers = {};
  final Set<String> _revealed = {};

  TextEditingController _controllerFor(String id) => _controllers.putIfAbsent(id, TextEditingController.new);

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < widget.exercise.questions.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFFEF2F2).withValues(alpha: 0.6), borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${i + 1}. ${l10n.writingWrongSentenceLabel}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                Text(widget.exercise.questions[i].wrong, style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: tokens.foreground)),
                const SizedBox(height: 6),
                TextField(
                  controller: _controllerFor(widget.exercise.questions[i].id),
                  minLines: 2,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: tokens.card,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () => setState(() => _revealed.add(widget.exercise.questions[i].id)),
                  child: Text(l10n.writingRevealAnswer, style: const TextStyle(fontSize: 12)),
                ),
                if (_revealed.contains(widget.exercise.questions[i].id))
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: tokens.muted.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('✓ ${widget.exercise.questions[i].correct}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF15803D))),
                        if ((widget.exercise.questions[i].explanation ?? '').isNotEmpty)
                          Text(widget.exercise.questions[i].explanation!, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
