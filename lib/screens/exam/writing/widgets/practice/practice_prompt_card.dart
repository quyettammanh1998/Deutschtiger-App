import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/goethe_b1_writing_topic.dart';
import '../../../../../l10n/app_localizations.dart';

/// Left-column task prompt shown next to [WritingPracticePanel] — web parity
/// `practice-prompt-card.tsx`: "Aufgabe" title + word-count + toggle-VI +
/// task text, then numbered "Yêu cầu viết" points.
///
/// DEVIATION: `ReportContentButton` (report-content moderation) omitted —
/// no Flutter equivalent exists for exam-content reporting yet.
class PracticePromptCard extends StatefulWidget {
  const PracticePromptCard({super.key, required this.topic});

  final GoetheB1WritingTopic topic;

  @override
  State<PracticePromptCard> createState() => _PracticePromptCardState();
}

class _PracticePromptCardState extends State<PracticePromptCard> {
  bool _showVi = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final task = widget.topic.task;
    final points = widget.topic.taskAnalysis?.points ?? const [];
    final hasVi = (task?.vi ?? '').isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Aufgabe',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: tokens.primary)),
              const Spacer(),
              if (widget.topic.taskWordCount != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    l10n.writingWordCountHint(
                      widget.topic.taskWordCount!.min,
                      widget.topic.taskWordCount!.max,
                    ),
                    style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                  ),
                ),
              if (hasVi)
                InkWell(
                  onTap: () => setState(() => _showVi = !_showVi),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _showVi ? const Color(0xFF3B82F6) : tokens.muted,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _showVi ? l10n.writingHideTranslation : l10n.writingShowTranslation,
                      style: TextStyle(
                        fontSize: 11,
                        color: _showVi ? Colors.white : tokens.mutedForeground,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(task?.de ?? '', style: TextStyle(fontSize: 14, color: tokens.foreground, height: 1.5)),
          if (_showVi && hasVi) ...[
            const SizedBox(height: 6),
            Text(task!.vi, style: TextStyle(fontSize: 12, color: tokens.mutedForeground, fontStyle: FontStyle.italic)),
          ],
          if (points.isNotEmpty) ...[
            Divider(height: 24, color: tokens.border),
            Text(l10n.writingRequirementsTitle,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: tokens.primary)),
            const SizedBox(height: 8),
            for (var i = 0; i < points.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 2, right: 8),
                      decoration: BoxDecoration(
                        color: tokens.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text('${i + 1}',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: tokens.primary)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(points[i].de, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: tokens.foreground)),
                          if (_showVi && points[i].vi.isNotEmpty)
                            Text(points[i].vi, style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
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
