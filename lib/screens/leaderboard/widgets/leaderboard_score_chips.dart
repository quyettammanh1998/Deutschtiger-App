import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../leaderboard_screen.dart';

/// One weighted contribution to the composite `weekly_score` — mirror web
/// `weekly-score-breakdown-chips.tsx` `buildChips`. Per-source weights + caps
/// mirror the backend composite score.
class _ScoreChip {
  const _ScoreChip(this.emoji, this.raw, this.weighted);
  final String emoji;
  final int raw;
  final int weighted;
}

int _cap(int n, int max) => n < max ? n : max;

List<_ScoreChip> _buildChips(LeaderboardEntry e) => [
  _ScoreChip('⚡', e.weeklyXp, e.weeklyXp),
  _ScoreChip('📝', e.examPoints, _cap(e.examPoints, 200) * 3),
  _ScoreChip('🎯', e.missionCount, e.missionCount * 30),
  _ScoreChip('📚', e.vocabReviewed, _cap(e.vocabReviewed, 700)),
  _ScoreChip('📖', e.readingCount, _cap(e.readingCount, 35) * 15),
  _ScoreChip('🗣️', e.speakWriteCount, _cap(e.speakWriteCount, 35) * 20),
  _ScoreChip('➕', e.wordsAdded, _cap(e.wordsAdded, 210) * 2),
  _ScoreChip('🔥', e.streak, _cap(e.streak, 30) * 10),
];

/// Breadth multiplier: +8% per distinct active source beyond 2, capped 1.5×.
/// Mirror web `diversityMultiplier`.
double leaderboardDiversityMultiplier(LeaderboardEntry entry) {
  final active = _buildChips(entry).where((c) => c.raw > 0).length;
  final extra = active - 2 > 0 ? active - 2 : 0;
  final pct = 100 + 8 * extra;
  return (pct > 150 ? 150 : pct) / 100;
}

/// Breakdown chips for a weekly leaderboard entry — shows which metrics
/// contribute to the composite score. `compact` = top-2 by weighted
/// contribution (podium/rows); `full` = all non-zero chips (detail sheet).
class LeaderboardScoreChips extends StatelessWidget {
  const LeaderboardScoreChips({
    super.key,
    required this.entry,
    this.compact = true,
    this.alignment = WrapAlignment.center,
  });

  final LeaderboardEntry entry;
  final bool compact;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final chips = _buildChips(entry).where((c) => c.raw > 0).toList()
      ..sort((a, b) => b.weighted.compareTo(a.weighted));
    if (chips.isEmpty) return const SizedBox.shrink();
    final visible = compact ? chips.take(2).toList() : chips;
    final mult = leaderboardDiversityMultiplier(entry);

    return Wrap(
      alignment: alignment,
      spacing: 4,
      runSpacing: 4,
      children: [
        for (var i = 0; i < visible.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: i == 0
                  ? tokens.primary.withValues(alpha: 0.1)
                  : tokens.muted.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(999),
              border: i == 0
                  ? Border.all(color: tokens.primary.withValues(alpha: 0.2))
                  : null,
            ),
            child: Text(
              '${visible[i].emoji} ${visible[i].raw}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: i == 0 ? tokens.primary : tokens.mutedForeground,
              ),
            ),
          ),
        if (!compact && mult > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
            ),
            child: Text(
              '🌈 ×${mult.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.orange,
              ),
            ),
          ),
      ],
    );
  }
}
