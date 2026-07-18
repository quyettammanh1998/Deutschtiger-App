import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../features/mission/domain/mission_models.dart';
import '../../../l10n/app_localizations.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// "Phiên hôm nay" card — mirrors web `today-session-card.tsx` (mobile):
/// white card with a ☀️ heading, a progress bar and a full-width gradient
/// CTA pill with a trailing "→". Backed by the daily word/round mission
/// (`todayMissionProvider`) — the Flutter mission model doesn't carry the
/// web's 4-stage bucket breakdown, so this renders the single guided
/// round-based session the backend already generates instead.
class TodaySessionCard extends StatelessWidget {
  const TodaySessionCard({
    super.key,
    required this.mission,
    required this.onRetry,
  });

  final AsyncValue<DailyMission> mission;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return mission.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(DesignTokens.spacingMd),
        child: LinearProgressIndicator(color: DesignTokens.orange500),
      ),
      error: (_, _) => Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(PhosphorIcons.arrowClockwise),
          label: Text(l10n.retryTodaySession),
        ),
      ),
      data: (data) => _SessionCardBody(mission: data),
    );
  }
}

class _SessionCardBody extends StatelessWidget {
  const _SessionCardBody({required this.mission});

  final DailyMission mission;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final roundsLeft = (mission.roundsPlanned - mission.roundsCompleted).clamp(
      0,
      999,
    );
    final completed = mission.completedAt != null || roundsLeft == 0;
    final canStart = !completed && mission.words.isNotEmpty;
    final progress = mission.roundsPlanned > 0
        ? (mission.roundsCompleted / mission.roundsPlanned).clamp(0.0, 1.0)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.screenHorizontalPadding,
        DesignTokens.spacingSm,
        DesignTokens.screenHorizontalPadding,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.cardPadding),
        decoration: BoxDecoration(
          color: tokens.card,
          border: Border.all(color: tokens.border),
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('☀️ ', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: Text(
                    l10n.todaySession,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: tokens.foreground,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              completed
                  ? l10n.missionCompletedXp(mission.xpEarned)
                  : l10n.missionRoundsWords(roundsLeft, mission.words.length),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: tokens.mutedForeground,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: tokens.muted,
                valueColor: const AlwaysStoppedAnimation(
                  DesignTokens.orange500,
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: canStart
                    ? () => context.push('/learn/session/today')
                    : null,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
                child: Ink(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        DesignTokens.orange500.withValues(alpha: canStart ? 1 : 0.6),
                        DesignTokens.orange600.withValues(alpha: canStart ? 1 : 0.6),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(
                      DesignTokens.radiusSm + 4,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        completed ? l10n.completed : l10n.start,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (!completed) ...[
                        const SizedBox(width: 4),
                        const Text(
                          '→',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
