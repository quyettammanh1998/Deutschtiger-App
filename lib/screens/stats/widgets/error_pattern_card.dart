import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_button.dart';
import 'package:deutschtiger/data/stats/stats_models.dart';
import 'error_pattern_labels.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// One error-pattern card — bullet + label + count, strikethrough/corrected
/// example, per-type drill CTA, source pills. Mirror web `PatternCard`.
class ErrorPatternCard extends StatelessWidget {
  const ErrorPatternCard({super.key, required this.pattern});

  final ErrorPatternSummary pattern;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final config = errorTypeLabel(context, pattern.errorType);
    final hasExample =
        pattern.exampleOriginal != null || pattern.exampleCorrected != null;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '•',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: config.color,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  config.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: tokens.foreground,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.errorPatternsTimesCount(pattern.totalCount),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: tokens.mutedForeground,
                ),
              ),
            ],
          ),
          if (hasExample) ...[
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  if (pattern.exampleOriginal != null)
                    TextSpan(
                      text: pattern.exampleOriginal,
                      style: TextStyle(
                        color: tokens.mutedForeground,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  if (pattern.exampleOriginal != null &&
                      pattern.exampleCorrected != null)
                    const TextSpan(text: '  →  '),
                  if (pattern.exampleCorrected != null)
                    TextSpan(
                      text: pattern.exampleCorrected,
                      style: TextStyle(
                        color: tokens.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (config.drillRoute != null && config.drillLabel != null)
                InkWell(
                  onTap: () => context.push(config.drillRoute!),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        config.drillLabel!(l10n),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: tokens.primary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        PhosphorIcons.arrowRight,
                        size: 14,
                        color: tokens.primary,
                      ),
                    ],
                  ),
                )
              else
                const Spacer(),
              const Spacer(),
              if (pattern.sources.isNotEmpty)
                Flexible(
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 6,
                    runSpacing: 6,
                    children: pattern.sources
                        .map(
                          (s) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: tokens.muted,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              errorSourceLabel(context, s),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: tokens.mutedForeground,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 📝 + title/body + 2 CTA buttons. Mirror web `ErrorPatternsPage` empty
/// branch.
class ErrorPatternsEmptyState extends StatelessWidget {
  const ErrorPatternsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📝', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              l10n.errorPatternsEmptyTitle,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: tokens.foreground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.errorPatternsEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  label: l10n.errorPatternsDrillWordOrder,
                  variant: AppButtonVariant.outline,
                  onPressed: () => context.push('/games/wortstellung'),
                ),
                const SizedBox(width: 12),
                AppButton(
                  label: l10n.errorPatternsDrillExam,
                  onPressed: () => context.push('/exam'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
