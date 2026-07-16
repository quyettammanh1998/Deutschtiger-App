import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_bottom_sheet.dart';
import '../../../widgets/common/app_button.dart';
import '../leaderboard_screen.dart';

class _DetailRow {
  const _DetailRow(this.emoji, this.label, this.raw, this.weighted);
  final String emoji;
  final String label;
  final String raw;
  final int weighted;
}

List<_DetailRow> _buildRows(LeaderboardEntry e, AppLocalizations l10n) {
  final rows = [
    _DetailRow('⚡', l10n.leaderboardDetailXp, '${e.weeklyXp}', e.weeklyXp),
    _DetailRow(
      '📝',
      l10n.leaderboardDetailExam,
      '${e.examPoints}',
      e.examPoints * 3,
    ),
    _DetailRow(
      '🎯',
      l10n.leaderboardDetailMission,
      '${e.missionCount}',
      e.missionCount * 30,
    ),
    _DetailRow(
      '📚',
      l10n.leaderboardDetailVocab,
      '${e.vocabReviewed}',
      e.vocabReviewed,
    ),
    _DetailRow(
      '🔥',
      l10n.leaderboardDetailStreak,
      l10n.streakDays(e.streak),
      (e.streak < 30 ? e.streak : 30) * 10,
    ),
  ];
  rows.sort((a, b) => b.weighted.compareTo(a.weighted));
  return rows;
}

/// Detail sheet showing the weighted breakdown behind an entry's composite
/// `weekly_score`. Mirror web `weekly-score-detail-sheet.tsx`.
void showLeaderboardDetailSheet(BuildContext context, LeaderboardEntry entry) {
  showAppBottomSheet<void>(
    context,
    builder: (ctx) => _DetailSheetBody(entry: entry),
  );
}

class _DetailSheetBody extends StatelessWidget {
  const _DetailSheetBody({required this.entry});
  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final name = entry.displayName.trim().isEmpty
        ? l10n.user
        : entry.displayName.trim();
    final rows = _buildRows(entry, l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.leaderboardDetailTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: tokens.foreground,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: tokens.muted.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: tokens.foreground,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.leaderboardDetailComposite,
                        style: TextStyle(
                          fontSize: 11,
                          color: tokens.mutedForeground,
                        ),
                      ),
                      Text(
                        '${entry.xp}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: tokens.primary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.leaderboardDetailRawXp,
                        style: TextStyle(
                          fontSize: 11,
                          color: tokens.mutedForeground,
                        ),
                      ),
                      Text(
                        '${entry.weeklyXp}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: tokens.foreground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < rows.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: i == 0 ? tokens.primary.withValues(alpha: 0.1) : tokens.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: i == 0
                    ? tokens.primary.withValues(alpha: 0.3)
                    : tokens.border,
              ),
            ),
            child: Row(
              children: [
                Text(rows[i].emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rows[i].label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: tokens.foreground,
                        ),
                      ),
                      if (i == 0)
                        Text(
                          l10n.leaderboardDetailTopContributor,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: tokens.primary,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rows[i].raw,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: tokens.foreground,
                      ),
                    ),
                    Text(
                      '+${rows[i].weighted}',
                      style: TextStyle(
                        fontSize: 10,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        if (entry.isNewUserDampened)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.leaderboardDetailDampenedNote,
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
          ),
        AppGradientButton(
          label: l10n.leaderboardDetailViewProfile,
          onPressed: () {
            Navigator.of(context).pop();
            GoRouter.of(context).push('/social/profile/${entry.id}');
          },
        ),
      ],
    );
  }
}
