import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Full-width gradient CTA button — resumes/starts the exam, or opens the
/// goal setter when the exam date has passed.
class ExamHeroCtaButton extends StatelessWidget {
  const ExamHeroCtaButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.tokens,
  });

  final String label;
  final VoidCallback onTap;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [tokens.primary, tokens.brandDark],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Text(
              '→',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Độ sẵn sàng" / "Đổi mục tiêu" text-link row under the CTA.
class ExamHeroLinkRow extends StatelessWidget {
  const ExamHeroLinkRow({
    super.key,
    required this.onReadinessTap,
    required this.onChangeGoalTap,
    required this.tokens,
  });

  final VoidCallback onReadinessTap;
  final VoidCallback onChangeGoalTap;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: tokens.mutedForeground,
    );
    return Row(
      children: [
        GestureDetector(
          onTap: onReadinessTap,
          child: Text(l10n.examCornerReadiness, style: style),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onChangeGoalTap,
          child: Text(l10n.examCornerChangeGoal, style: style),
        ),
      ],
    );
  }
}

/// Countdown pill in [ExamHeroCard]'s header — amber when <=28 days left,
/// neutral otherwise. Mirrors web's `days <= 28` urgency threshold.
class ExamHeroCountdownBadge extends StatelessWidget {
  const ExamHeroCountdownBadge({
    super.key,
    required this.days,
    required this.tokens,
  });

  final int days;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final urgent = days <= 28;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: urgent ? const Color(0xFFFEF3C7) : tokens.muted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        days == 0 ? l10n.examHeroToday : l10n.examCornerDaysLeft(days),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: urgent ? const Color(0xFFB45309) : tokens.mutedForeground,
        ),
      ),
    );
  }
}

/// Exam-readiness ring (percent, or "?" with an empty ring pre-attempts) —
/// same visual language as the daily-path XP ring. Tapping opens the full
/// readiness page (handled by the caller via [GestureDetector]).
class ExamHeroReadinessRing extends StatelessWidget {
  const ExamHeroReadinessRing({
    super.key,
    required this.percent,
    required this.tokens,
  });

  final int? percent;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              value: percent != null ? percent! / 100 : 0,
              strokeWidth: 3.5,
              backgroundColor: tokens.muted,
              valueColor: AlwaysStoppedAnimation(tokens.primary),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                percent != null ? '$percent%' : '?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: tokens.foreground,
                ),
              ),
              Text(
                l10n.examHeroReadyLabel,
                style: TextStyle(fontSize: 9, color: tokens.mutedForeground),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
