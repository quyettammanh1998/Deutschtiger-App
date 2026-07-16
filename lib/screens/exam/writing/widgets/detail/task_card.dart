import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/goethe_b1_writing_topic.dart';
import '../../../../../features/writing/presentation/widgets/writing_audio_play_button.dart';
import '../../../../../l10n/app_localizations.dart';
import 'vi_translation_toggle.dart';

/// `sec-aufgabe` — plain (non-collapsible) card. Web parity `task-card.tsx`.
class WritingTaskCard extends StatefulWidget {
  const WritingTaskCard({super.key, required this.topic, this.sectionKey});

  final GoetheB1WritingTopic topic;
  final Key? sectionKey;

  @override
  State<WritingTaskCard> createState() => _WritingTaskCardState();
}

class _WritingTaskCardState extends State<WritingTaskCard> {
  bool _showVi = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final task = widget.topic.task;
    if (task == null) return const SizedBox.shrink();
    final points = widget.topic.taskAnalysis?.points ?? const [];

    return Container(
      key: widget.sectionKey,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('📋 ${l10n.writingSectionTask}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: tokens.primary)),
              const Spacer(),
              if (task.vi.isNotEmpty) ViTranslationToggle(show: _showVi, onToggle: () => setState(() => _showVi = !_showVi)),
              WritingAudioPlayButton(text: task.de, audioUrl: task.audioUrl),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED).withValues(alpha: 0.5),
              border: const Border(left: BorderSide(color: Color(0xFFFB923C), width: 4)),
              borderRadius: const BorderRadius.only(topRight: Radius.circular(6), bottomRight: Radius.circular(6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.de, style: TextStyle(fontSize: 13, color: tokens.foreground, height: 1.5)),
                if (_showVi && task.vi.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(task.vi,
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: const Color(0xFF2563EB))),
                  ),
              ],
            ),
          ),
          if (points.isNotEmpty) ...[
            Divider(height: 20, color: tokens.border),
            Text(l10n.writingRequirementsTitle,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.mutedForeground)),
            const SizedBox(height: 6),
            for (var i = 0; i < points.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${i + 1}. ',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFF97316))),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(points[i].de, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: tokens.foreground)),
                          if (_showVi && points[i].vi.isNotEmpty)
                            Text(points[i].vi, style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: const Color(0xFF2563EB))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
