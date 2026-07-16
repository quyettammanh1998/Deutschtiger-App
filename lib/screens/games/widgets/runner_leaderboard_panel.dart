import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/games/runner_personal_best.dart';
import '../../leaderboard/leaderboard_screen.dart';

/// Personal best + weekly XP leaderboard snapshot for Deutsch Runner — web
/// parity: `RunnerLeaderboardPanel`. Reuses the existing live
/// `leaderboardProvider(LeaderboardType.weekly)` (already used by
/// `/leaderboard`) rather than adding a runner-specific endpoint — no
/// backend contract for a per-game leaderboard exists, and web itself shows
/// the same account-wide weekly XP board here, not a runner-only ranking.
class RunnerLeaderboardPanel extends ConsumerWidget {
  const RunnerLeaderboardPanel({super.key, required this.personalBest});

  final RunnerPersonalBest? personalBest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final leaderboard = ref.watch(leaderboardProvider(LeaderboardType.weekly));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (personalBest != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KỶ LỤC CỦA BẠN',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.amber.shade800,
                          letterSpacing: 0.4,
                        ),
                      ),
                      Text(
                        '${personalBest!.score} điểm · '
                        '${personalBest!.accuracy}% chính xác',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: tokens.foreground,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text('🏆', style: TextStyle(fontSize: 22)),
              ],
            ),
          ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(tokens.radius),
            border: Border.all(color: tokens.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    'BXH tuần (XP)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: tokens.foreground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              leaderboard.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LinearProgressIndicator(),
                ),
                error: (_, _) => Text(
                  'Chưa có dữ liệu tuần này',
                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                ),
                data: (entries) {
                  final top = entries.take(5).toList();
                  if (top.isEmpty) {
                    return Text(
                      'Chưa có dữ liệu tuần này',
                      style: TextStyle(
                        fontSize: 12,
                        color: tokens.mutedForeground,
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final entry in top)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                child: Text(
                                  entry.rank <= 3
                                      ? ['🥇', '🥈', '🥉'][entry.rank - 1]
                                      : '${entry.rank}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: tokens.mutedForeground,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.displayName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: tokens.foreground,
                                  ),
                                ),
                              ),
                              Text(
                                '${entry.xp} XP',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: tokens.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
