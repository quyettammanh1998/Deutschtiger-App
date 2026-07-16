import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../leaderboard_screen.dart';
import 'leaderboard_podium.dart';
import 'leaderboard_row.dart';

/// Podium (top-3) + card list (#4-5) + pinned own-rank row when the current
/// user sits outside the top-5. Mirror web `WeeklyLeaderboard` result body.
class LeaderboardListBody extends StatelessWidget {
  const LeaderboardListBody({
    super.key,
    required this.entries,
    required this.showOwnRank,
    required this.myRank,
    required this.onShowDetails,
  });

  final List<LeaderboardEntry> entries;
  final bool showOwnRank;
  final LeaderboardEntry? myRank;
  final ValueChanged<LeaderboardEntry> onShowDetails;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final top5 = entries.take(5).toList();
    final top3 = top5.take(3).toList();
    final rest = top5.skip(3).toList();
    final userInTop5 = top5.any((e) => e.isCurrentUser);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: [
          if (top3.isNotEmpty)
            LeaderboardPodium(entries: top3, onShowDetails: onShowDetails),
          if (rest.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: tokens.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: tokens.border),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < rest.length; i++) ...[
                    if (i > 0)
                      Divider(
                        height: 1,
                        color: tokens.border.withValues(alpha: 0.5),
                      ),
                    LeaderboardRow(
                      entry: rest[i],
                      displayRank: i + 4,
                      onShowDetails: onShowDetails,
                    ),
                  ],
                ],
              ),
            ),
          if (showOwnRank && !userInTop5 && myRank != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: LeaderboardOwnRankRow(
                entry: myRank!,
                onShowDetails: onShowDetails,
              ),
            ),
        ],
      ),
    );
  }
}
