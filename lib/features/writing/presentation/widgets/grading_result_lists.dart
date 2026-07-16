import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../domain/schreiben_grading_result.dart';
import 'grading_error_type_labels.dart';

/// Small tinted pill — `{label} · {count}` — for the "common errors in this
/// essay" summary row.
class ErrorTypeChip extends StatelessWidget {
  const ErrorTypeChip({super.key, required this.typeKey, required this.count});
  final String typeKey;
  final int count;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final label = errorTypeLabelVi[typeKey] ?? typeKey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: tokens.warning.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label · $count',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.warning),
      ),
    );
  }
}

/// Toggle header (`title` + caret) followed by [child] when [open] — used
/// for the collapsible "suggestions" / "corrections" sections.
class GradingCollapsibleSection extends StatelessWidget {
  const GradingCollapsibleSection({
    super.key,
    required this.title,
    required this.open,
    required this.onToggle,
    required this.child,
  });

  final String title;
  final bool open;
  final VoidCallback onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onToggle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: tokens.mutedForeground,
                  ),
                ),
              ),
              Icon(
                open ? AppPhosphorIcons.caretUp : AppPhosphorIcons.caretDown,
                size: 14,
                color: tokens.mutedForeground,
              ),
            ],
          ),
        ),
        if (open) ...[const SizedBox(height: 8), child],
      ],
    );
  }
}

/// One stylistic suggestion row: struck-through original → natural phrasing
/// + optional Vietnamese gloss/explanation.
class SuggestionRow extends StatelessWidget {
  const SuggestionRow({super.key, required this.suggestion});
  final WritingSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: tokens.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestion.original,
            style: TextStyle(
              fontSize: 13,
              color: tokens.mutedForeground,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(AppPhosphorIcons.arrowRight, size: 14, color: tokens.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  suggestion.natural,
                  style: TextStyle(fontWeight: FontWeight.w600, color: tokens.primary),
                ),
              ),
            ],
          ),
          if (suggestion.vi.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '🇻🇳 ${suggestion.vi}',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: tokens.mutedForeground,
              ),
            ),
          ],
          if (suggestion.why.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(suggestion.why, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
          ],
        ],
      ),
    );
  }
}

/// One grammar correction row: struck-through original → corrected text +
/// error-type chip + explanation.
class CorrectionRow extends StatelessWidget {
  const CorrectionRow({super.key, required this.correction});
  final WritingCorrection correction;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final typeKey = correction.errorType ?? 'other';
    final typeLabel = errorTypeLabelVi[typeKey] ?? typeKey;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: tokens.muted.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              Text(
                correction.original,
                style: TextStyle(
                  color: tokens.destructive,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 13,
                ),
              ),
              Icon(AppPhosphorIcons.arrowRight, size: 13, color: tokens.mutedForeground),
              Text(
                correction.corrected,
                style: TextStyle(color: tokens.success, fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: tokens.muted,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(typeLabel, style: TextStyle(fontSize: 11, color: tokens.foreground)),
              ),
            ],
          ),
          if (correction.explanation.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              correction.explanation,
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            ),
          ],
        ],
      ),
    );
  }
}
