import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../features/mission/domain/mission_models.dart';
import '../../features/mission/presentation/mission_session_provider.dart';
import '../../l10n/app_localizations.dart';

/// B2 — Learning Journey (Learn Hub). Top: "Phiên hôm nay" session banner;
/// below: roadmap of CEFR chapters with a mission runner CTA. Mirrors web
/// `learn-page.tsx`.
class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionAsync = ref.watch(todayMissionProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        backgroundColor: DesignTokens.background,
        title: Text(l10n.learningJourney),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _TodaySessionBanner(
              mission: missionAsync,
              onRetry: () => ref.invalidate(todayMissionProvider),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            const _LearnExtensionsSection(),
          ],
        ),
      ),
    );
  }
}

/// Lối vào các màn learn extensions (mirrors web `CapabilityMapSnapshot` +
/// "Khám phá theo chủ đề" trên learn-home-page.tsx).
class _LearnExtensionsSection extends StatelessWidget {
  const _LearnExtensionsSection();

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
          _LearnExtensionTile(
            icon: Icons.school_outlined,
            title: l10n.coursesTileTitle,
            onTap: () => context.push('/journey/courses'),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          _LearnExtensionTile(
            icon: Icons.insights_outlined,
            title: l10n.learnerModelTitle,
            onTap: () => context.push('/learner-model'),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          _LearnExtensionTile(
            icon: Icons.travel_explore_outlined,
            title: l10n.topicExploreTitle,
            onTap: () => context.push('/learn/topics'),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          _LearnExtensionTile(
            icon: Icons.center_focus_strong_outlined,
            title: l10n.focusSessionTitle,
            onTap: () => context.push('/focus-session'),
          ),
        ],
      ),
    );
  }
}

class _LearnExtensionTile extends StatelessWidget {
  const _LearnExtensionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon, color: DesignTokens.tigerOrange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

/// "Phiên hôm nay" banner backed by the mission generated on the server.
class _TodaySessionBanner extends StatelessWidget {
  const _TodaySessionBanner({required this.mission, required this.onRetry});

  final AsyncValue<DailyMission> mission;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return mission.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(DesignTokens.spacingMd),
        child: LinearProgressIndicator(),
      ),
      error: (_, _) => Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text(l10n.retryTodaySession),
        ),
      ),
      data: (data) => _MissionBannerContent(mission: data),
    );
  }
}

class _MissionBannerContent extends StatelessWidget {
  const _MissionBannerContent({required this.mission});
  final DailyMission mission;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentLevel = mission.words.firstOrNull?.level ?? 'A1';
    final roundsLeft = (mission.roundsPlanned - mission.roundsCompleted).clamp(
      0,
      999,
    );
    final completed = mission.completedAt != null || roundsLeft == 0;
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
          gradient: const LinearGradient(
            colors: [DesignTokens.orange500, DesignTokens.rose600],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          boxShadow: DesignTokens.shadowMd,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
              ),
              child: Text(
                currentLevel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.todaySession,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    completed
                        ? l10n.missionCompletedXp(mission.xpEarned)
                        : l10n.missionRoundsWords(
                            roundsLeft,
                            mission.words.length,
                          ),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: completed || mission.words.isEmpty
                  ? null
                  : () => context.push('/journey/session'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: DesignTokens.tigerOrange,
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd,
                  vertical: DesignTokens.spacingSm,
                ),
              ),
              child: Text(completed ? l10n.completed : l10n.start),
            ),
          ],
        ),
      ),
    );
  }
}
