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
          boxShadow: DesignTokens.shadowMd,
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

/// "🎁 Nhiệm vụ thưởng" section — collapsible list of [DashboardMission]s
/// with an aggregate progress bar. Mirrors web `daily-missions-section.tsx`
/// (mobile collapse toggle + completedCount/totalCount header).
class DashboardMissionsSection extends StatefulWidget {
  const DashboardMissionsSection({super.key, required this.missions});

  final List<DashboardMission> missions;

  @override
  State<DashboardMissionsSection> createState() =>
      _DashboardMissionsSectionState();
}

class _DashboardMissionsSectionState extends State<DashboardMissionsSection> {
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final missions = widget.missions;
    final totalCount = missions.length;
    final completedCount = missions.where((m) => m.isCompleted).length;
    final allDone = totalCount > 0 && completedCount == totalCount;
    final progressRatio = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.screenHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: totalCount == 0
                ? null
                : () => setState(() => _collapsed = !_collapsed),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.dailyMissionsHeading,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.foreground,
                  ),
                ),
                if (totalCount > 0)
                  Row(
                    children: [
                      Text(
                        '$completedCount/$totalCount${allDone ? ' ✓' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: allDone
                              ? DesignTokens.emerald600
                              : DesignTokens.mutedForeground,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingXs),
                      AnimatedRotation(
                        turns: _collapsed ? 0.5 : 0,
                        duration: DesignTokens.durationFast,
                        child: const Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 18,
                          color: DesignTokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (totalCount > 0) ...[
            const SizedBox(height: DesignTokens.spacingSm),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progressRatio,
                minHeight: 6,
                backgroundColor: DesignTokens.muted,
                valueColor: AlwaysStoppedAnimation(
                  allDone ? DesignTokens.emerald600 : const Color(0xFFF59E0B),
                ),
              ),
            ),
          ],
          const SizedBox(height: DesignTokens.spacingSm),
          if (missions.isEmpty)
            Text(
              l10n.noBonusMissions,
              style: const TextStyle(color: DesignTokens.mutedForeground),
            )
          else if (!_collapsed)
            for (var i = 0; i < missions.length; i++) ...[
              if (i > 0) const SizedBox(height: DesignTokens.spacingSm),
              DashboardMissionCard(mission: missions[i], index: i),
            ],
        ],
      ),
    );
  }
}

/// Read-only view model for a single mission card. Carries real backend
/// fields (xpReward/currentProgress/targetCount/isCompleted from
/// `Mission` in dashboard_data.dart) — no derived/fabricated data.
class DashboardMission {
  const DashboardMission({
    required this.title,
    required this.icon,
    this.xpReward = 0,
    this.currentProgress = 0,
    this.targetCount = 0,
    this.isCompleted = false,
  });

  final String title;
  final IconData icon;
  final int xpReward;
  final int currentProgress;
  final int targetCount;
  final bool isCompleted;

  double get progressRatio =>
      targetCount == 0 ? 0 : (currentProgress / targetCount).clamp(0, 1);
}

/// Fixed 4-color palette cycling by card index — matches web `CARD_COLORS`
/// (blue → amber → green → violet) in `daily-missions-section.tsx`.
class _MissionPalette {
  const _MissionPalette({
    required this.bg,
    required this.border,
    required this.text,
    required this.iconBg,
  });

  final Color bg;
  final Color border;
  final Color text;
  final Color iconBg;
}

const List<_MissionPalette> _kMissionPalette = [
  _MissionPalette(
    bg: Color(0xFFEFF6FF),
    border: Color(0xFF2563EB),
    text: Color(0xFF1E40AF),
    iconBg: Color(0xFFDBEAFE),
  ),
  _MissionPalette(
    bg: Color(0xFFFFF7ED),
    border: Color(0xFFD97706),
    text: Color(0xFF92400E),
    iconBg: Color(0xFFFEF3C7),
  ),
  _MissionPalette(
    bg: Color(0xFFF0FDF4),
    border: Color(0xFF16A34A),
    text: Color(0xFF166534),
    iconBg: Color(0xFFDCFCE7),
  ),
  _MissionPalette(
    bg: Color(0xFFF5F3FF),
    border: Color(0xFF7C3AED),
    text: Color(0xFF5B21B6),
    iconBg: Color(0xFFEDE9FE),
  ),
];

class DashboardMissionCard extends StatelessWidget {
  const DashboardMissionCard({
    super.key,
    required this.mission,
    this.index = 0,
  });

  final DashboardMission mission;
  final int index;

  @override
  Widget build(BuildContext context) {
    final palette = _kMissionPalette[index % _kMissionPalette.length];
    final done = mission.isCompleted;

    return Opacity(
      opacity: done ? 0.6 : 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: palette.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: palette.border, width: 3)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: palette.iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                done ? Icons.check_rounded : mission.icon,
                size: 16,
                color: done ? DesignTokens.emerald600 : palette.text,
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mission.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: palette.text,
                      decoration: done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (!done) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: mission.progressRatio,
                              minHeight: 4,
                              backgroundColor: palette.border.withValues(
                                alpha: 0.15,
                              ),
                              valueColor: AlwaysStoppedAnimation(
                                palette.border,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: DesignTokens.spacingSm),
                        Text(
                          '${mission.currentProgress}/${mission.targetCount}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: palette.text,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: done ? DesignTokens.muted : DesignTokens.amber100,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '+${mission.xpReward}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: done
                      ? DesignTokens.mutedForeground
                      : DesignTokens.amber700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
