import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/leaderboard/hall_of_fame_entry.dart';
import '../../../l10n/app_localizations.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _medalColors = {
  1: (bg: Color(0xFFFEF3C7), fg: Color(0xFFD97706)),
  2: (bg: Color(0xFFF3F4F6), fg: Color(0xFF6B7280)),
  3: (bg: Color(0xFFFFEDD5), fg: Color(0xFFEA580C)),
};

/// Collapsible "Tuần trước" strip — 3 medal cards from the last weekly
/// reset. Mirror web `hall-of-fame.tsx`.
class LeaderboardHallOfFame extends StatefulWidget {
  const LeaderboardHallOfFame({super.key, required this.entries});

  final List<HallOfFameEntry> entries;

  @override
  State<LeaderboardHallOfFame> createState() => _LeaderboardHallOfFameState();
}

class _LeaderboardHallOfFameState extends State<LeaderboardHallOfFame> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedRotation(
                  turns: _expanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    AppPhosphorIcons.caretRight,
                    size: 12,
                    color: tokens.mutedForeground,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.leaderboardHallOfFameToggle,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: tokens.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: widget.entries
                  .map(
                    (e) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: _MedalCard(entry: e),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _MedalCard extends StatelessWidget {
  const _MedalCard({required this.entry});
  final HallOfFameEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = _medalColors[entry.rank] ?? _medalColors[3]!;
    return InkWell(
      onTap: () => GoRouter.of(context).push('/social/profile/${entry.userId}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            if (entry.avatarUrl != null)
              ClipOval(
                child: Image.network(
                  entry.avatarUrl!,
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
              )
            else
              Icon(PhosphorIcons.star, size: 16, color: colors.fg),
            const SizedBox(height: 4),
            Text(
              entry.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
            Text(
              '${entry.weeklyXp} XP',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colors.fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
