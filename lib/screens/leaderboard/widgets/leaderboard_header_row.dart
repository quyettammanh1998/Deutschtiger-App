import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../leaderboard_screen.dart';
import 'leaderboard_providers.dart';

/// Purple trophy chip + "BXH tuần" label + reset countdown (global tab only).
/// Mirror web `weekly-leaderboard.tsx` header row.
class LeaderboardHeaderRow extends StatelessWidget {
  const LeaderboardHeaderRow({super.key, required this.showCountdown});
  final bool showCountdown;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFF3E8FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.emoji_events,
            size: 14,
            color: Color(0xFF9333EA),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          l10n.leaderboardWeeklyHeader,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: tokens.mutedForeground,
          ),
        ),
        const Spacer(),
        if (showCountdown)
          Text(
            l10n.leaderboardResetCountdown(weeklyResetCountdownLabel()),
            style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
          ),
      ],
    );
  }
}

/// Segmented "Toàn cầu | Bạn bè" tab control. Mirror web `LeaderboardTabs`.
class LeaderboardTabSelector extends StatelessWidget {
  const LeaderboardTabSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });
  final LeaderboardTab selected;
  final ValueChanged<LeaderboardTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: tokens.muted,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: LeaderboardTab.values.map((tab) {
          final isSelected = tab == selected;
          final label = tab == LeaderboardTab.global
              ? l10n.leaderboardTabGlobal
              : l10n.leaderboardTabFriends;
          return Expanded(
            child: Material(
              color: isSelected ? tokens.card : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              elevation: isSelected ? 1 : 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => onChanged(tab),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? tokens.foreground
                          : tokens.mutedForeground,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Generic centered muted-text empty/error state for a leaderboard scope.
class LeaderboardScopeEmpty extends StatelessWidget {
  const LeaderboardScopeEmpty({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(text, style: TextStyle(color: tokens.mutedForeground)),
      ),
    );
  }
}

/// "Chưa có bạn bè trên bảng" empty state with a CTA to `/friends`.
/// Mirror web `WeeklyLeaderboard` `hasNoFriends` branch.
class LeaderboardFriendsEmpty extends StatelessWidget {
  const LeaderboardFriendsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: tokens.border),
        ),
        child: Column(
          children: [
            Text(
              l10n.leaderboardNoFriends,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => GoRouter.of(context).push('/friends'),
              child: Text(
                l10n.leaderboardFindFriends,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: tokens.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
