import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_topic/uebungen_exercise.dart';
import '../../../../../l10n/app_localizations.dart';

/// Mini-write exercise — reveal-only mode (same AI-grading deviation as
/// [ErrorCorrectionExerciseView], see that file's doc comment).
class MiniWriteExerciseView extends StatefulWidget {
  const MiniWriteExerciseView({super.key, required this.exercise});

  final MiniWriteExercise exercise;

  @override
  State<MiniWriteExerciseView> createState() => _MiniWriteExerciseViewState();
}

class _MiniWriteExerciseViewState extends State<MiniWriteExerciseView> {
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
        for (final p in widget.exercise.prompts)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.promptVi, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.foreground)),
                if (p.patternDe.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text('Mẫu: "${p.patternDe}"', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFFEA580C))),
                  ),
                const SizedBox(height: 6),
                TextField(
                  controller: _controllerFor(p.id),
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
                if ((p.sampleAnswer ?? '').isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() => _revealed.add(p.id)),
                    child: Text(l10n.writingShowSampleAnswer, style: const TextStyle(fontSize: 12)),
                  ),
                if (_revealed.contains(p.id) && (p.sampleAnswer ?? '').isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: tokens.muted.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${l10n.writingSampleAnswerLabel}: "${p.sampleAnswer}"',
                            style: TextStyle(fontSize: 12, color: tokens.foreground)),
                        if ((p.sampleAnswerVi ?? '').isNotEmpty)
                          Text(p.sampleAnswerVi!, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
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
