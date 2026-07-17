import 'package:flutter/material.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';

/// Header button (icon + tap) cho Word Sprint — Phase 05 I2.
class SprintHeaderButton extends StatelessWidget {
  const SprintHeaderButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          boxShadow: DesignTokens.shadowSm,
        ),
        child: Icon(icon, color: tokens.foreground),
      ),
    );
  }
}

/// Countdown timer pill — chuyển sang `warning` khi còn ≤10s.
class SprintTimerBadge extends StatelessWidget {
  const SprintTimerBadge({
    super.key,
    required this.seconds,
    required this.isWarning,
  });

  final int seconds;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    // `error` isn't a themed AppTokens member (only `destructive` is) — kept
    // as the fixed DesignTokens red used elsewhere for this exact warning
    // pill; `warning` is themed since it IS an AppTokens member.
    final color = isWarning ? DesignTokens.error : tokens.warning;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 18,
            color: tokens.card.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 6),
          Text(
            '${seconds}s',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: tokens.card,
            ),
          ),
        ],
      ),
    );
  }
}

/// Linear progress bar cho biết "Câu X/Y".
class SprintProgressBar extends StatelessWidget {
  const SprintProgressBar({
    super.key,
    required this.current,
    required this.total,
    required this.color,
  });

  final int current;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final pct = total == 0 ? 0 : ((current / total) * 100).round();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingLg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Câu $current/$total',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: tokens.mutedForeground,
                ),
              ),
              Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        ClipRRect(
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : current / total,
            backgroundColor: tokens.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

/// Pill badge cho stat (score / streak / correct).
class SprintStatBadge extends StatelessWidget {
  const SprintStatBadge({
    super.key,
    required this.icon,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingSm + 4,
        vertical: DesignTokens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// 1 ô đáp án 2x2 grid với highlight khi đúng/sai.
class SprintAnswerTile extends StatelessWidget {
  const SprintAnswerTile({
    super.key,
    required this.text,
    required this.state,
    required this.onTap,
  });

  final String text;
  final SprintAnswerState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = _paletteFor(context, state);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: palette.bg,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          border: Border.all(color: palette.border, width: 2),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingSm + 4),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: palette.text,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  _SprintAnswerPalette _paletteFor(BuildContext context, SprintAnswerState state) {
    final tokens = context.tokens;
    switch (state) {
      case SprintAnswerState.idle:
        return _SprintAnswerPalette(
          bg: tokens.card,
          border: tokens.border,
          text: tokens.foreground,
        );
      case SprintAnswerState.correct:
        return _SprintAnswerPalette(
          bg: tokens.success.withValues(alpha: 0.08),
          border: tokens.success,
          text: tokens.success,
        );
      case SprintAnswerState.wrong:
        // `error` isn't a themed AppTokens member (only `destructive` is) —
        // kept as the fixed DesignTokens red used elsewhere for wrong-answer
        // feedback.
        return _SprintAnswerPalette(
          bg: DesignTokens.error.withValues(alpha: 0.08),
          border: DesignTokens.error,
          text: DesignTokens.error,
        );
    }
  }
}

enum SprintAnswerState { idle, correct, wrong }

class _SprintAnswerPalette {
  const _SprintAnswerPalette({
    required this.bg,
    required this.border,
    required this.text,
  });
  final Color bg;
  final Color border;
  final Color text;
}

/// Header cho Word Sprint — close button + title + timer badge.
class SprintGameHeader extends StatelessWidget {
  const SprintGameHeader({
    super.key,
    required this.seconds,
    required this.isWarning,
    required this.onClose,
  });

  final int seconds;
  final bool isWarning;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingSm + 4,
      ),
      child: Row(
        children: [
          SprintHeaderButton(icon: Icons.close, onTap: onClose),
          const SizedBox(width: DesignTokens.spacingSm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Word Sprint',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: tokens.foreground,
                  ),
                ),
                Text(
                  '60 giây chinh phục từ vựng',
                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
          SprintTimerBadge(seconds: seconds, isWarning: isWarning),
        ],
      ),
    );
  }
}

/// Row of 3 stat badges (score / correct / streak).
class SprintStatRow extends StatelessWidget {
  const SprintStatRow({
    super.key,
    required this.score,
    required this.correct,
    required this.streak,
  });

  final int score;
  final int correct;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingLg,
        vertical: DesignTokens.spacingSm + 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SprintStatBadge(
            icon: Icons.star_outline,
            value: '$score',
            color: tokens.warning,
          ),
          SprintStatBadge(
            icon: Icons.check_circle_outline,
            value: '$correct',
            color: tokens.success,
          ),
          if (streak > 0)
            SprintStatBadge(
              icon: Icons.local_fire_department,
              value: 'x$streak',
              color: DesignTokens.tigerOrange,
            ),
        ],
      ),
    );
  }
}

/// Big card hiển thị từ vựng cần dịch.
class SprintWordCard extends StatelessWidget {
  const SprintWordCard({super.key, required this.word});
  final String word;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: DesignTokens.spacingLg),
      padding: const EdgeInsets.all(DesignTokens.spacingLg),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        boxShadow: DesignTokens.shadowMd,
      ),
      child: Column(
        children: [
          Text(
            word,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            'Nghĩa là gì?',
            style: TextStyle(fontSize: 16, color: tokens.mutedForeground),
          ),
        ],
      ),
    );
  }
}