import 'package:flutter/material.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../data/home/dashboard_data.dart';
import '../../../l10n/app_localizations.dart';

class _OverviewCardSpec {
  const _OverviewCardSpec(
    this.label,
    this.value,
    this.note,
    this.icon,
    this.colors,
  );
  final String label;
  final String value;
  final String note;
  final IconData icon;
  final List<Color> colors;
}

/// 4 gradient stat cards (level/XP/streak/best streak). Mirror web
/// `stats-overview-cards.tsx`.
class StatsOverviewCards extends StatelessWidget {
  const StatsOverviewCards({super.key, required this.data});

  final Gamification data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cards = [
      _OverviewCardSpec(
        l10n.statsCurrentLevel,
        '${data.level}',
        l10n.statsOverviewLevelNote,
        AppPhosphorIcons.star,
        const [Color(0xFF3B82F6), Color(0xFF4F46E5)],
      ),
      _OverviewCardSpec(
        l10n.statsOverviewTotalXp,
        data.totalXp.toString(),
        l10n.statsOverviewXpNote,
        AppPhosphorIcons.lightning,
        const [Color(0xFFF59E0B), Color(0xFFEA580C)],
      ),
      _OverviewCardSpec(
        l10n.statsCurrentStreak,
        l10n.streakDays(data.currentStreak),
        l10n.statsOverviewStreakNote,
        AppPhosphorIcons.fire,
        const [Color(0xFFF97316), Color(0xFFEF4444)],
      ),
      _OverviewCardSpec(
        l10n.statsOverviewBestStreak,
        l10n.streakDays(data.longestStreak),
        l10n.statsOverviewBestStreakNote,
        AppPhosphorIcons.trophy,
        const [Color(0xFF10B981), Color(0xFF0D9488)],
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 520 ? 4 : 2;
        return GridView.count(
          crossAxisCount: cols,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: cards.map((c) => _Card(spec: c)).toList(),
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.spec});
  final _OverviewCardSpec spec;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: spec.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: spec.colors.last.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spec.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      spec.value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(spec.icon, size: 16, color: Colors.white),
              ),
            ],
          ),
          const Spacer(),
          Text(
            spec.note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
