import 'package:flutter/material.dart';

import '../../../data/home/dashboard_data.dart';
import '../../../l10n/app_localizations.dart';
import 'dashboard_sections.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

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
  'pencil' => PhosphorIcons.pencilSimple,
  'headphones' => PhosphorIcons.headphones,
  'cards' => PhosphorIcons.cards,
  'book' => PhosphorIcons.bookOpen,
  'zap' => PhosphorIcons.lightning,
  'target' => PhosphorIcons.crosshair,
  'play' => PhosphorIcons.playCircle,
  'clipboard' => PhosphorIcons.clipboardText,
  'gamepad' => PhosphorIcons.gameController,
  _ => PhosphorIcons.star,
};
