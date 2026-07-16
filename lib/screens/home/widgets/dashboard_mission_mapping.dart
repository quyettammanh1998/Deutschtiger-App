import 'package:flutter/material.dart';

import '../../../data/home/dashboard_data.dart';
import '../../../l10n/app_localizations.dart';
import 'dashboard_sections.dart';

/// Maps the backend's `Mission` list (real dashboard data) to the
/// presentation-layer [DashboardMission] the missions section renders.
List<DashboardMission> mapDashboardMissions(
  List<Mission> missions,
  AppLocalizations l10n,
) {
  return missions.map((m) {
    return DashboardMission(
      title: m.titleVi.isNotEmpty ? m.titleVi : l10n.mission,
      icon: _missionIcon(m.icon),
      xpReward: m.xpReward,
      currentProgress: m.currentProgress,
      targetCount: m.targetCount,
      isCompleted: m.isCompleted,
    );
  }).toList();
}

/// Maps the backend's semantic `Mission.icon` key (real data, not derived)
/// to a close Material icon — mirrors web `ICON_MAP` in
/// `daily-missions-section.tsx` (pencil/headphones/cards/book/zap/target/
/// play/clipboard/gamepad).
IconData _missionIcon(String icon) => switch (icon) {
  'pencil' => Icons.edit_outlined,
  'headphones' => Icons.headset_outlined,
  'cards' => Icons.style_outlined,
  'book' => Icons.menu_book_outlined,
  'zap' => Icons.bolt_outlined,
  'target' => Icons.track_changes_outlined,
  'play' => Icons.play_circle_outline,
  'clipboard' => Icons.assignment_outlined,
  'gamepad' => Icons.sports_esports_outlined,
  _ => Icons.star_outline,
};
