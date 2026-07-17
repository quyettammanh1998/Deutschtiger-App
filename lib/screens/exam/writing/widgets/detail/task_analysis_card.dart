import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_topic/task_section.dart';
import '../../../../../features/writing/presentation/widgets/writing_audio_play_button.dart';
import '../../../../../l10n/app_localizations.dart';
import 'vi_translation_toggle.dart';

/// `sec-task-analysis` body — web parity `task-analysis-card.tsx`.
/// Simplified: single accent color (not per-index rotation) and approaches
/// list starts expanded (web starts collapsed behind a "💡 N cách triển
/// khai" toggle) — documented deviation, content is fully present either way.
class WritingTaskAnalysisCard extends StatefulWidget {
  const WritingTaskAnalysisCard({super.key, required this.analysis});

  final TaskAnalysis analysis;

  @override
  State<WritingTaskAnalysisCard> createState() => _WritingTaskAnalysisCardState();
}

class _WritingTaskAnalysisCardState extends State<WritingTaskAnalysisCard> {
  final Set<int> _showVi = {};

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.analysis.summaryVi.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(widget.analysis.summaryVi,
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: tokens.mutedForeground)),
          ),
        for (var i = 0; i < widget.analysis.points.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0x33F59E0B) : const Color(0xFFFFF7ED).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFED7AA)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: Color(0xFFF97316), shape: BoxShape.circle),
                      child: Text('${i + 1}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(widget.analysis.points[i].de,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.foreground)),
                    ),
                    if (widget.analysis.points[i].vi.isNotEmpty)
                      ViTranslationToggle(
                        show: _showVi.contains(i),
                        onToggle: () => setState(
                          () => _showVi.contains(i) ? _showVi.remove(i) : _showVi.add(i),
                        ),
                      ),
                    WritingAudioPlayButton(
                      text: widget.analysis.points[i].de,
                      audioUrl: widget.analysis.points[i].audioUrl,
                    ),
                  ],
                ),
                if (_showVi.contains(i) && widget.analysis.points[i].vi.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 2),
                    child: Text(widget.analysis.points[i].vi,
                        style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF2563EB))),
                  ),
                if (widget.analysis.points[i].subpoints.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final sp in widget.analysis.points[i].subpoints)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text('• ${sp.de}', style: TextStyle(fontSize: 12, color: tokens.foreground)),
                          ),
                      ],
                    ),
                  ),
                if (widget.analysis.points[i].approaches.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('💡 ${l10n.writingApproachesLabel(widget.analysis.points[i].approaches.length)}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFF97316))),
                        for (var j = 0; j < widget.analysis.points[i].approaches.length; j++)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('${j + 1}. ${widget.analysis.points[i].approaches[j].de}',
                                style: TextStyle(fontSize: 12, color: tokens.foreground)),
                          ),
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
