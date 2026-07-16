import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/app_card.dart';
import 'daily_review_rounds.dart';

String dailyReviewGameIcon(DailyReviewGameType type) => switch (type) {
  DailyReviewGameType.matching => '🔗',
  DailyReviewGameType.cloze => '✍️',
  DailyReviewGameType.listening => '🎧',
  DailyReviewGameType.writing => '⌨️',
};

String dailyReviewGameName(AppLocalizations l10n, DailyReviewGameType type) =>
    switch (type) {
      DailyReviewGameType.matching => l10n.practiceModeMatching,
      DailyReviewGameType.cloze => l10n.practiceModeCloze,
      DailyReviewGameType.listening => l10n.practiceModeListening,
      DailyReviewGameType.writing => l10n.practiceModeWriting,
    };

/// "⚡ +N XP" gradient pill — web parity: `bg-gradient-to-r from-amber-400
/// to-orange-500` used on both the round summary and [DailyReviewDoneScreen].
class DailyReviewXpPill extends StatelessWidget {
  const DailyReviewXpPill({super.key, required this.xp});

  final int xp;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFBBF24), Color(0xFFF97316)],
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          '⚡ ${l10n.practiceXpEarned(xp)}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/// Web parity: `round-intro-card.tsx` — announces the next mini-game before
/// the round starts ("Vòng {i}/{n}").
class DailyReviewRoundIntroCard extends StatelessWidget {
  const DailyReviewRoundIntroCard({
    super.key,
    required this.gameType,
    required this.roundIndex,
    required this.totalRounds,
    required this.wordCount,
    required this.onStart,
  });

  final DailyReviewGameType gameType;
  final int roundIndex;
  final int totalRounds;
  final int wordCount;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: AppCard.card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.dailyReviewRoundLabel(roundIndex + 1, totalRounds),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: tokens.mutedForeground,
                ),
              ),
              const SizedBox(height: 12),
              Text(dailyReviewGameIcon(gameType), style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 8),
              Text(
                dailyReviewGameName(l10n, gameType),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: tokens.foreground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.dailyReviewRoundWordCount(wordCount),
                style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: AppGradientButton(
                  label: l10n.dailyReviewRoundStart,
                  onPressed: onStart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Web parity: `round-summary-card.tsx` — per-round accuracy + XP before
/// continuing to the next round (or finishing the session).
class DailyReviewRoundSummaryCard extends StatelessWidget {
  const DailyReviewRoundSummaryCard({
    super.key,
    required this.gameType,
    required this.correct,
    required this.total,
    required this.xpEarned,
    required this.isLastRound,
    required this.totalWordsReviewed,
    required this.totalWords,
    required this.onContinue,
  });

  final DailyReviewGameType gameType;
  final int correct;
  final int total;
  final int xpEarned;
  final bool isLastRound;
  final int totalWordsReviewed;
  final int totalWords;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: AppCard.card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(dailyReviewGameIcon(gameType), style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                l10n.dailyReviewRoundDone(dailyReviewGameName(l10n, gameType)),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: tokens.foreground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.practiceAccuracySummary(correct, total),
                style: TextStyle(fontSize: 15, color: tokens.mutedForeground),
              ),
              if (xpEarned > 0) ...[
                const SizedBox(height: 10),
                DailyReviewXpPill(xp: xpEarned),
              ],
              const SizedBox(height: 8),
              Text(
                l10n.dailyReviewRoundProgress(totalWordsReviewed, totalWords),
                style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: AppGradientButton(
                  label: isLastRound
                      ? l10n.dailyReviewRoundFinish
                      : l10n.dailyReviewRoundContinue,
                  onPressed: onContinue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
