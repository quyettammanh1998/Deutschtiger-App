import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/goethe_b1_writing_topic.dart';
import '../../../../../l10n/app_localizations.dart';

/// Amber "Đề thật" provenance box — web parity `provenance-card.tsx`.
/// Hidden by the caller when there's nothing to show.
class WritingProvenanceCard extends StatefulWidget {
  const WritingProvenanceCard({super.key, required this.topic});

  final GoetheB1WritingTopic topic;

  static bool hasContent(GoetheB1WritingTopic topic) =>
      topic.examDates.isNotEmpty ||
      topic.sources.isNotEmpty ||
      topic.topicKeywords.isNotEmpty ||
      (topic.lastReviewed?.isNotEmpty ?? false);

  @override
  State<WritingProvenanceCard> createState() => _WritingProvenanceCardState();
}

class _WritingProvenanceCardState extends State<WritingProvenanceCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final topic = widget.topic;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0x33F59E0B) : const Color(0xFFFFFBEB).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.writingProvenanceTitle(topic.examDates.length),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFFCD34D) : const Color(0xFF78350F)),
              ),
              if (topic.frequencyStars >= 5) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(color: isDark ? const Color(0x33F59E0B) : const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(999)),
                  child: Text('⭐ 5/5', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309))),
                ),
              ],
            ],
          ),
          if (topic.sources.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: [
                Text('${l10n.writingSourcesLabel}:', style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
                for (final s in topic.sources)
                  Text(
                    '${s.type == 'gdocs' ? '📂' : s.type == 'link' ? '🔗' : '📄'} ${s.label}',
                    style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFFFCD34D) : const Color(0xFF92400E)),
                  ),
              ],
            ),
          ],
          if (topic.examDates.isNotEmpty) ...[
            const SizedBox(height: 6),
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Text(
                '${_expanded ? '▼' : '▶'} ${l10n.writingExamDatesToggle}',
                style: TextStyle(fontSize: 11, color: tokens.primary),
              ),
            ),
            if (_expanded)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  topic.examDates.join(' · '),
                  style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                ),
              ),
          ],
          if (topic.topicKeywords.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final k in topic.topicKeywords)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(999)),
                    child: Text(k, style: TextStyle(fontSize: 10, color: tokens.mutedForeground)),
                  ),
              ],
            ),
          ],
          if (topic.lastReviewed?.isNotEmpty ?? false) ...[
            const SizedBox(height: 6),
            Text('Reviewed: ${topic.lastReviewed}',
                style: TextStyle(fontSize: 10, color: tokens.mutedForeground.withValues(alpha: 0.7))),
          ],
        ],
      ),
    );
  }
}
