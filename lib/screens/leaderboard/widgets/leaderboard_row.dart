import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../leaderboard_screen.dart';
import 'leaderboard_score_chips.dart';

/// Rank movement vs. last week's reset. Null `lastWeekRank` = no prior
/// ranked week (new entrant). Mirror web `rankDelta`.
({String text, Color Function(BuildContext) color}) leaderboardRankDelta(
  LeaderboardEntry entry,
  AppLocalizations l10n,
) {
  if (entry.lastWeekRank == null) {
    return (text: l10n.leaderboardRankNew, color: (c) => c.tokens.mutedForeground);
  }
  final delta = entry.lastWeekRank! - entry.rank;
  if (delta > 0) return (text: '▲$delta', color: (_) => const Color(0xFF10B981));
  if (delta < 0) {
    return (text: '▼${delta.abs()}', color: (_) => const Color(0xFFEF4444));
  }
  return (text: '—', color: (c) => c.tokens.mutedForeground);
}

Widget _avatar(LeaderboardEntry entry, double size, AppTokens tokens) {
  final name = entry.displayName.trim().isEmpty
      ? '?'
      : entry.displayName.trim();
  if (entry.avatarUrl != null) {
    return ClipOval(
      child: Image.network(
        entry.avatarUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: tokens.primary.withValues(alpha: 0.1),
      border: Border.all(color: tokens.border),
    ),
    child: Center(
      child: Text(
        name.characters.first.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.bold, color: tokens.primary),
      ),
    ),
  );
}

/// A row for ranks #4+ — rank/delta, avatar, name (+ premium/new badges),
/// breakdown chips, composite score. Mirror web `LeaderboardRow`.
class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow({
    super.key,
    required this.entry,
    required this.displayRank,
    required this.onShowDetails,
  });

  final LeaderboardEntry entry;
  final int displayRank;
  final ValueChanged<LeaderboardEntry> onShowDetails;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final name = entry.displayName.trim().isEmpty
        ? l10n.user
        : entry.displayName.trim();
    final delta = entry.isCurrentUser
        ? leaderboardRankDelta(entry, l10n)
        : null;

    return InkWell(
      onTap: () => onShowDetails(entry),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: entry.isCurrentUser
              ? tokens.primary.withValues(alpha: 0.05)
              : null,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Column(
                children: [
                  Text(
                    displayRank.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: tokens.mutedForeground,
                    ),
                  ),
                  if (delta != null)
                    Text(
                      delta.text,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: delta.color(context),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _avatar(entry, 36, tokens),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: entry.isCurrentUser
                          ? tokens.foreground
                          : tokens.foreground.withValues(alpha: 0.9),
                    ),
                  ),
                  LeaderboardScoreChips(
                    entry: entry,
                    alignment: WrapAlignment.start,
                  ),
                ],
              ),
            ),
            Text(
              '${entry.xp}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: entry.isCurrentUser
                    ? tokens.primary
                    : tokens.foreground.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The current user's row, pinned below a "···" divider when outside the
/// visible top-5. Mirror web `WeeklyLeaderboard` bottom block.
class LeaderboardOwnRankRow extends StatelessWidget {
  const LeaderboardOwnRankRow({
    super.key,
    required this.entry,
    required this.onShowDetails,
  });

  final LeaderboardEntry entry;
  final ValueChanged<LeaderboardEntry> onShowDetails;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final delta = leaderboardRankDelta(entry, l10n);
    final name = entry.displayName.trim().isEmpty
        ? l10n.user
        : entry.displayName.trim();

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Container(height: 1, color: tokens.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '···',
                style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
              ),
            ),
            Expanded(child: Container(height: 1, color: tokens.border)),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => onShowDetails(entry),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  tokens.primary.withValues(alpha: 0.1),
                  tokens.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tokens.primary.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Column(
                    children: [
                      Text(
                        entry.rank.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: tokens.primary,
                        ),
                      ),
                      Text(
                        delta.text,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: delta.color(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _avatar(entry, 36, tokens),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: tokens.foreground,
                    ),
                  ),
                ),
                Text(
                  '${entry.xp}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: tokens.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
