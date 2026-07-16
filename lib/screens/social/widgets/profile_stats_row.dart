import 'package:flutter/material.dart';

import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';

/// XP required to go from [level] to [level] + 1.
/// SQL formula: `level = GREATEST(1, FLOOR(SQRT(total_xp / 100)))` (mirrors
/// `gamification-service.ts` `xpForLevel`/`getXpInCurrentLevel`).
int _xpForLevel(int level) {
  final safe = level < 1 ? 1 : level;
  return ((safe + 1) * (safe + 1) - safe * safe) * 100;
}

int _xpBeforeLevel(int level) {
  final safe = level < 1 ? 1 : level;
  return safe * safe * 100;
}

int _xpInCurrentLevel(int level, int totalXp) {
  final safeXp = totalXp < 0 ? 0 : totalXp;
  final v = safeXp - _xpBeforeLevel(level);
  return v < 0 ? 0 : v;
}

/// Web parity: `components/profile/profile-stats-row.tsx` — 5-column stat
/// row (Level w/ XP progress bar, current streak, longest streak, total XP,
/// friends count).
class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({
    super.key,
    required this.level,
    required this.totalXp,
    required this.currentStreak,
    required this.longestStreak,
    required this.friendsCount,
  });

  final int level;
  final int totalXp;
  final int currentStreak;
  final int longestStreak;
  final int friendsCount;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final xpInLevel = _xpInCurrentLevel(level, totalXp);
    final xpForNext = _xpForLevel(level);
    final progress = xpForNext > 0
        ? (xpInLevel / xpForNext).clamp(0.0, 1.0)
        : 0.0;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      runSpacing: 10,
      children: [
        Column(
          children: [
            Text(
              '$level',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: tokens.foreground,
              ),
            ),
            Text(
              l10n.socialLevelShort,
              style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 40,
              height: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: tokens.muted,
                  valueColor: AlwaysStoppedAnimation(tokens.primary),
                ),
              ),
            ),
          ],
        ),
        _StatColumn(
          value: '$currentStreak',
          label: '🔥 ${l10n.socialStreakShort}',
          tokens: tokens,
        ),
        _StatColumn(
          value: '$longestStreak',
          label: '🏆 ${l10n.socialLongestStreakShort}',
          tokens: tokens,
        ),
        _StatColumn(value: '$totalXp', label: 'XP', tokens: tokens),
        _StatColumn(
          value: '$friendsCount',
          label: l10n.socialFriendsShort,
          tokens: tokens,
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.value,
    required this.label,
    required this.tokens,
  });

  final String value;
  final String label;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: tokens.foreground,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: tokens.mutedForeground)),
      ],
    );
  }
}
