import 'package:flutter/material.dart';

import '../../../core/release/release_feature_flags.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_card.dart';
import '../../../widgets/common/app_pill.dart';
import '../../../widgets/common/app_button.dart';
import 'daily_review_round_cards.dart';
import 'daily_review_rounds.dart';

/// Web parity: `daily-review-done.tsx` — session summary shown once the
/// playlist finishes (or immediately when there was nothing due). Mobile
/// scope only (web's desktop sidebar column is `hidden md:block`).
class DailyReviewDoneScreen extends StatelessWidget {
  const DailyReviewDoneScreen({
    super.key,
    required this.result,
    required this.onGoHome,
    required this.onContinueLearning,
    this.onRetryWeakWords,
    this.onContinue,
    this.onListenPractice,
    this.onAskAi,
  });

  final DailyReviewResult result;
  final VoidCallback onGoHome;

  /// "Tiếp tục học" secondary CTA — web always routes to `/vocabulary`.
  final VoidCallback onContinueLearning;
  final VoidCallback? onRetryWeakWords;
  final VoidCallback? onContinue;
  final VoidCallback? onListenPractice;
  final VoidCallback? onAskAi;

  Color _statusColor(AppTokens tokens) {
    if (result.accuracy >= 80) return tokens.success;
    if (result.accuracy >= 50) return tokens.primary;
    return tokens.destructive;
  }

  String _statusLabel(AppLocalizations l10n) {
    if (result.accuracy >= 80) return l10n.dailyReviewStatusExcellent;
    if (result.accuracy >= 50) return l10n.dailyReviewStatusGood;
    return l10n.dailyReviewStatusNeedsWork;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final statusColor = _statusColor(tokens);
    final hasWeakWords = result.weakWords.isNotEmpty;
    final showRetryCta = hasWeakWords && onRetryWeakWords != null;
    final showSecondaryCtas = result.totalCount >= 5;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AppCard.card(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (result.totalCount == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        const Text('🎉', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 8),
                        Text(
                          l10n.dailyReviewEmptyTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: tokens.foreground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.dailyReviewEmptySubtitle,
                          style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                        ),
                      ],
                    ),
                  )
                else ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.dailyReviewSessionLabel,
                          style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppPill(
                        label: _statusLabel(l10n),
                        background: statusColor.withValues(alpha: 0.15),
                        foreground: statusColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      const Text('📖', style: TextStyle(fontSize: 44)),
                      const SizedBox(height: 4),
                      Text(
                        l10n.dailyReviewCompletedTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: tokens.foreground,
                        ),
                      ),
                      Text(
                        '${result.accuracy}%',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                        ),
                      ),
                      Text(
                        l10n.practiceAccuracySummary(result.correctCount, result.totalCount),
                        style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                      ),
                      if (result.xpEarned > 0) ...[
                        const SizedBox(height: 6),
                        DailyReviewXpPill(xp: result.xpEarned),
                      ],
                    ],
                  ),
                ],
                if (hasWeakWords) ...[
                  const SizedBox(height: 16),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: tokens.destructive.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.dailyReviewWeakWordsTitle,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: tokens.destructive,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final w in result.weakWords)
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: tokens.card,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      w.contentDe,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: tokens.foreground,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Column(
                  children: [
                    if (result.hasMore && onContinue != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: AppGradientButton(
                            label: l10n.dailyReviewCtaMore,
                            onPressed: onContinue,
                          ),
                        ),
                      ),
                    if (showRetryCta)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: AppGradientButton(
                            label: l10n.dailyReviewCtaRetryWeak(result.weakWords.length),
                            onPressed: onRetryWeakWords,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: AppGradientButton(
                        label: l10n.backToHome,
                        variant: showRetryCta
                            ? AppGradientButtonVariant.secondary
                            : AppGradientButtonVariant.primary,
                        onPressed: onGoHome,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: AppGradientButton(
                        label: l10n.dailyReviewCtaContinueLearning,
                        variant: AppGradientButtonVariant.secondary,
                        onPressed: onContinueLearning,
                      ),
                    ),
                  ],
                ),
                if (showSecondaryCtas) ...[
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: tokens.border)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      // Web mobile default is `flex-col` (row only from `sm:`
                      // up) — stack vertically so long German CTA labels
                      // never overflow at 200% text scale.
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (onListenPractice != null)
                            AppButton(
                              label: l10n.dailyReviewCtaListening,
                              variant: AppButtonVariant.outline,
                              size: AppButtonSize.small,
                              onPressed: onListenPractice,
                            ),
                          if (onListenPractice != null && ReleaseFeatureFlags.aiTutor && onAskAi != null)
                            const SizedBox(height: 8),
                          if (ReleaseFeatureFlags.aiTutor && onAskAi != null)
                            AppButton(
                              label: l10n.dailyReviewCtaAskAi,
                              variant: AppButtonVariant.outline,
                              size: AppButtonSize.small,
                              onPressed: onAskAi,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
