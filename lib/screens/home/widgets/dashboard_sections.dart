import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Pill-style search bar shown at the top of the dashboard — taps through to
/// the vocabulary hub search screen.
class DashboardSearchBar extends StatelessWidget {
  const DashboardSearchBar({super.key, required this.onTap, this.hint});

  final VoidCallback onTap;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMd,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: DesignTokens.card,
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: DesignTokens.mutedForeground,
              size: 20,
            ),
            const SizedBox(width: DesignTokens.spacingSm + 4),
            Text(
              hint ?? l10n.searchVocabulary,
              style: const TextStyle(
                fontSize: 14,
                color: DesignTokens.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Nhiệm vụ hôm nay" section — title + mission cards from
/// [DashboardMission] data.
class DashboardMissionsSection extends StatelessWidget {
  const DashboardMissionsSection({
    super.key,
    this.onSeeAllTap,
    required this.missions,
  });

  final VoidCallback? onSeeAllTap;
  final List<DashboardMission> missions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.screenHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.todayMissions,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: DesignTokens.foreground,
                ),
              ),
              if (onSeeAllTap != null)
                TextButton(onPressed: onSeeAllTap, child: Text(l10n.seeAll)),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          if (missions.isEmpty)
            Text(
              l10n.noBonusMissions,
              style: const TextStyle(color: DesignTokens.mutedForeground),
            ),
          for (var i = 0; i < missions.length; i++) ...[
            if (i > 0) const SizedBox(height: DesignTokens.spacingSm),
            DashboardMissionCard(mission: missions[i]),
          ],
        ],
      ),
    );
  }
}

class DashboardMission {
  const DashboardMission({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.icon,
    required this.color,
  });
  final String title;
  final String subtitle;
  final double progress;
  final IconData icon;
  final Color color;
}

class DashboardMissionCard extends StatelessWidget {
  const DashboardMissionCard({super.key, required this.mission});
  final DashboardMission mission;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: mission.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
            ),
            child: Icon(mission.icon, color: mission.color, size: 24),
          ),
          const SizedBox(width: DesignTokens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: DesignTokens.foreground,
                  ),
                ),
                Text(
                  mission.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: DesignTokens.mutedForeground,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingSm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: mission.progress,
                    minHeight: 6,
                    backgroundColor: DesignTokens.muted,
                    valueColor: AlwaysStoppedAnimation(mission.color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
