import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/app_card.dart';
import '../../domain/schreiben_grading_result.dart';
import 'grading_result_bars.dart';
import 'grading_result_layout.dart';
import 'grading_result_lists.dart';

/// Inline AI grading result — web parity
/// `components/exam/schreiben/grading-result-card.tsx`. Shown right after a
/// successful `WritingRepository.gradeSchreiben` call inside
/// `PracticeEditorCard`. Sub-sections split into `grading_result_bars.dart`
/// (score bars) and `grading_result_lists.dart` (chips/collapsibles) to
/// stay under the 200-LOC-per-file guideline.
class GradingResultCard extends StatefulWidget {
  const GradingResultCard({super.key, required this.result});

  final SchreibenGradingResult result;

  @override
  State<GradingResultCard> createState() => _GradingResultCardState();
}

class _GradingResultCardState extends State<GradingResultCard> {
  late bool _correctionsOpen = widget.result.corrections.length <= 3;
  late bool _suggestionsOpen = widget.result.suggestions.length <= 3;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final result = widget.result;
    final badge = _gradeBadge(tokens, result.grade, result.score);

    final commonErrors = <String, int>{};
    for (final c in result.corrections) {
      final key = c.errorType ?? 'other';
      commonErrors[key] = (commonErrors[key] ?? 0) + 1;
    }
    final topErrors = (commonErrors.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(4)
        .toList();

    final categories = [
      (l10n.writingGradeCategoryTask, result.taskCompletion),
      (l10n.writingGradeCategoryGrammar, result.grammar),
      (l10n.writingGradeCategoryVocab, result.vocabulary),
      (l10n.writingGradeCategoryCoherence, result.coherence),
    ];

    return AppCard.card(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: badge.$2,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge.$1,
                    style: TextStyle(fontWeight: FontWeight.bold, color: badge.$3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.writingScorePoints(result.score),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: tokens.foreground,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        result.summary,
                        style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (result.hasGoetheRaw) GoetheRawSection(goetheRaw: result.goetheRaw!, l10n: l10n),
          if (topErrors.isNotEmpty)
            sectionBorder(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionLabel(context, l10n.writingCommonErrorsTitle),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final entry in topErrors)
                        ErrorTypeChip(typeKey: entry.key, count: entry.value),
                    ],
                  ),
                ],
              ),
            ),
          sectionBorder(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionLabel(context, l10n.writingDetailedAssessment),
                const SizedBox(height: 12),
                for (var i = 0; i < categories.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  CategoryBar(label: categories[i].$1, category: categories[i].$2),
                ],
              ],
            ),
          ),
          if (result.suggestions.isNotEmpty)
            sectionBorder(
              context,
              child: GradingCollapsibleSection(
                title: l10n.writingSuggestionsTitle(result.suggestions.length),
                open: _suggestionsOpen,
                onToggle: () => setState(() => _suggestionsOpen = !_suggestionsOpen),
                child: Column(
                  children: [for (final s in result.suggestions) SuggestionRow(suggestion: s)],
                ),
              ),
            ),
          if (result.corrections.isNotEmpty)
            sectionBorder(
              context,
              child: GradingCollapsibleSection(
                title: l10n.writingCorrectionsTitle(result.corrections.length),
                open: _correctionsOpen,
                onToggle: () => setState(() => _correctionsOpen = !_correctionsOpen),
                child: Column(
                  children: [for (final c in result.corrections) CorrectionRow(correction: c)],
                ),
              ),
            ),
          if (result.corrections.isNotEmpty)
            sectionBorder(
              context,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => context.push('/practice/focus'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: tokens.primary.withValues(alpha: 0.08),
                    border: Border.all(color: tokens.primary.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      l10n.writingFocusLink(result.corrections.length),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600, color: tokens.primary),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// (label, background, foreground) — web parity `getGradeBadge`: exact
  /// grade string wins; falls back to a score-derived Goethe band when the
  /// AI omitted/mis-cased `grade`.
  (String, Color, Color) _gradeBadge(AppTokens tokens, String grade, int score) {
    final resolvedGrade = grade.isNotEmpty ? grade : _scoreBand(score);
    switch (resolvedGrade) {
      case 'sehr_gut':
      case 'A':
        return (resolvedGrade, tokens.success.withValues(alpha: 0.15), tokens.success);
      case 'gut':
      case 'B':
        return (resolvedGrade, tokens.primary.withValues(alpha: 0.12), tokens.primary);
      case 'befriedigend':
      case 'C':
        return (resolvedGrade, tokens.warning.withValues(alpha: 0.18), tokens.warning);
      case 'ausreichend':
      case 'D':
        return (
          resolvedGrade,
          const Color(0xFFF97316).withValues(alpha: 0.15),
          const Color(0xFFEA580C),
        );
      default:
        return (resolvedGrade, tokens.destructive.withValues(alpha: 0.12), tokens.destructive);
    }
  }

  String _scoreBand(int score) {
    if (score >= 90) return 'sehr_gut';
    if (score >= 80) return 'gut';
    if (score >= 70) return 'befriedigend';
    if (score >= 60) return 'ausreichend';
    return 'nicht_bestanden';
  }
}
