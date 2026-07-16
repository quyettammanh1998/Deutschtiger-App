import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/app_button.dart';
import '../../../../widgets/common/app_card.dart';

/// Rung climb entry shown in the "leo bậc hôm nay" list — kept source-agnostic
/// (label + kind + from/to rung) so the overlay doesn't depend on the
/// `WeeklyRecap` data model directly.
class MissionClimbedEntry {
  const MissionClimbedEntry({
    required this.label,
    required this.isStructure,
    required this.fromRung,
    required this.toRung,
  });

  final String label;
  final bool isStructure;
  final int fromRung;
  final int toRung;
}

const _rungIcon = ['👂', '👁️', '✍️', '🗣️'];

/// Overlay shown on mission completion — mirrors web
/// `mission-complete-overlay.tsx`: trophy circle, XP gradient badge, optional
/// "leveled up today" list (never blocks when absent/empty), streak line,
/// full-width gradient CTA.
class MissionCompleteOverlay extends StatelessWidget {
  const MissionCompleteOverlay({
    super.key,
    required this.xpEarned,
    required this.streakUpdated,
    required this.onDone,
    this.climbed = const <MissionClimbedEntry>[],
    this.isSubmitting = false,
  });

  final int xpEarned;
  final bool streakUpdated;
  final List<MissionClimbedEntry> climbed;
  final VoidCallback onDone;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.6),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: AppCard.card(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          tokens.primary,
                          Color.lerp(tokens.primary, Colors.black, 0.25)!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      AppPhosphorIcons.trophy,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.missionCompleteTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: tokens.foreground,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.missionCompleteSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          tokens.primary,
                          Color.lerp(tokens.primary, Colors.black, 0.25)!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          AppPhosphorIcons.lightning,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.missionXpBadge(xpEarned),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (climbed.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: tokens.muted.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.missionClimbedTitle,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: tokens.foreground,
                            ),
                          ),
                          const SizedBox(height: 6),
                          for (final c in climbed.take(5))
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Text(
                                    c.isStructure ? '🧩' : '🃏',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      c.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: tokens.foreground,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${_rungIcon[c.fromRung.clamp(0, 3)]} → '
                                    '${_rungIcon[c.toRung.clamp(0, 3)]}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: tokens.mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                  if (streakUpdated) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.missionStreakUpdated,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: tokens.primary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: AppGradientButton(
                      label: isSubmitting ? l10n.saving : l10n.missionNextStepCta,
                      onPressed: isSubmitting ? null : onDone,
                      loading: isSubmitting,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
