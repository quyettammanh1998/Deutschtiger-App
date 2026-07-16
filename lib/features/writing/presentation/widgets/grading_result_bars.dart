import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/schreiben_grading_result.dart';
import 'grading_result_layout.dart';

/// Goethe raw rubric breakdown (Inhalt/Kommunikative/Formale, each /4) —
/// only rendered when [SchreibenGradingResult.goetheRaw] is present.
class GoetheRawSection extends StatelessWidget {
  const GoetheRawSection({super.key, required this.goetheRaw, required this.l10n});
  final GoetheRawScores goetheRaw;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final rows = [
      (l10n.writingGoetheInhalt, goetheRaw.inhalt),
      (l10n.writingGoetheKommunikative, goetheRaw.kommunikative),
      (l10n.writingGoetheFormale, goetheRaw.formale),
    ];
    return sectionBorder(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.writingGoetheBreakdownTitle(goetheRaw.teilLabel),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: tokens.mutedForeground,
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            MiniScoreBar(label: rows[i].$1, value: rows[i].$2.toDouble(), max: 4),
          ],
        ],
      ),
    );
  }
}

/// One `label ... x/max` progress bar — shared by the Goethe raw breakdown
/// and the per-category (`/25`) assessment rows.
class MiniScoreBar extends StatelessWidget {
  const MiniScoreBar({super.key, required this.label, required this.value, required this.max});
  final String label;
  final double value;
  final double max;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final pct = max > 0 ? (value / max).clamp(0, 1).toDouble() : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 13, color: tokens.foreground)),
            Text(
              '${value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1)}/${max.toStringAsFixed(0)}',
              style: TextStyle(fontWeight: FontWeight.bold, color: tokens.primary, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 6,
            backgroundColor: tokens.muted,
            valueColor: AlwaysStoppedAnimation(tokens.primary),
          ),
        ),
      ],
    );
  }
}

/// One `/25` category row (label + bar + AI comment) inside "Chi tiết đánh giá".
class CategoryBar extends StatelessWidget {
  const CategoryBar({super.key, required this.label, required this.category});
  final String label;
  final GradingFeedbackCategory category;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MiniScoreBar(label: label, value: category.score.toDouble(), max: 25),
        if (category.comment.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(category.comment, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
        ],
      ],
    );
  }
}
