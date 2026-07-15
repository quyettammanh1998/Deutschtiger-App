import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/release/release_feature_flags.dart';
import '../../../data/home/dashboard_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';
import '../../../widgets/common/async_state_views.dart';
import '../../../widgets/dashboard/mobile_dashboard_header.dart';
import '../../../widgets/dashboard/mobile_stats_card.dart';
import '../../../widgets/dashboard/quick_actions.dart';
import '../../../widgets/dashboard/streak_claim_modal.dart';
import '../../../features/daily_path/domain/daily_path.dart';
import '../../../features/daily_path/presentation/daily_path_route_resolver.dart';
import '../../../features/heartbeat/heartbeat_provider.dart';
import '../../view_models/notifications/notifications_provider.dart';
import 'widgets/dashboard_sections.dart';
import 'widgets/resume_section.dart';
import 'widgets/weekly_leaderboard_compact.dart';

/// B1 — Home screen (dashboard) — main entry after login.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showStreakModal = false;
  bool _streakPrompted = false;

  @override
  Widget build(BuildContext context) {
    final dashAsync = ref.watch(dashboardProvider);
    final profileAsync = ref.watch(myProfileProvider);
    final heartbeat = ref.watch(heartbeatProvider);
    final l10n = AppLocalizations.of(context);

    if (heartbeat.claimable && !_streakPrompted && !_showStreakModal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _streakPrompted) return;
        setState(() {
          _streakPrompted = true;
          _showStreakModal = true;
        });
      });
    }

    return Scaffold(
      backgroundColor: DesignTokens.background,
      body: dashAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          message: l10n.couldNotLoadHome,
          onRetry: () => ref.invalidate(dashboardProvider),
        ),
        data: (dash) {
          final gami = dash.gamification;
          final displayName =
              dash.profile?.displayName ??
              profileAsync.valueOrNull?.displayName ??
              l10n.learner;
          final streak = gami?.currentStreak ?? 0;
          final dailyXp = gami?.dailyXpToday;
          final dailyGoal = gami?.dailyGoal;
          final missions = _mapMissions(dash.missions, l10n);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dashboardProvider);
              await Future.wait([
                ref.read(dashboardProvider.future),
                ref.read(unreadNotificationCountProvider.notifier).refresh(),
              ]);
            },
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          MobileDashboardHeader(
                            displayName: displayName,
                            streak: streak,
                            avatarUrl: dash.profile?.avatarUrl,
                            dailyXp: dailyXp,
                            dailyGoal: dailyGoal,
                            onSettingsTap: () => context.push('/settings'),
                            showMessages: ReleaseFeatureFlags.social,
                            onMessagesTap: ReleaseFeatureFlags.social
                                ? () => context.push('/social/messages')
                                : null,
                            onProfileTap: () => context.push('/profile'),
                            onNotificationsTap: () => context.push('/notifications'),
                            unreadNotificationCount: ref.watch(
                              unreadNotificationCountProvider,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              DesignTokens.screenHorizontalPadding,
                              0,
                              DesignTokens.screenHorizontalPadding,
                              DesignTokens.spacingMd,
                            ),
                            child: DashboardSearchBar(
                              onTap: () => context.push('/vocabulary'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.screenHorizontalPadding,
                            ),
                            child: MobileStatsCard(
                              totalWordsLearned: dash.wordsLearned,
                              totalLookups: dash.lookupCount,
                              streak: streak,
                              onlineSeconds: dash.onlineTimeToday,
                              onStreakTap: _openStreakModal,
                              showDetails: ReleaseFeatureFlags.stats,
                              onDetailsTap: ReleaseFeatureFlags.stats
                                  ? () => context.push('/stats')
                                  : null,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacingMd),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.screenHorizontalPadding,
                            ),
                            child: WeeklyLeaderboardCompact(
                              onShowAll: () => context.push('/leaderboard'),
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacingMd),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.screenHorizontalPadding,
                            ),
                            child: QuickActions(
                              onLearnTap: () => context.push('/learn'),
                              onReviewTap: () => context.push('/daily-review'),
                              onExamTap: () => context.push('/exam'),
                              showAi: ReleaseFeatureFlags.aiTutor,
                              onAiTap: ReleaseFeatureFlags.aiTutor
                                  ? () => context.push('/ai-tutor')
                                  : null,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacingMd),
                          DashboardMissionsSection(
                            missions: missions,
                            onSeeAllTap: ReleaseFeatureFlags.journey
                                ? () => context.push('/journey')
                                : null,
                          ),
                          const SizedBox(height: DesignTokens.spacingMd),
                          DashboardContinueLearningSection(
                            dailyXp: dailyXp ?? 0,
                            dailyGoal: dailyGoal ?? 0,
                            streak: streak,
                            onStart: _openDailyPathStep,
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
                StreakClaimModal(
                  open: _showStreakModal,
                  onClose: _closeStreakModal,
                  alreadyClaimed: heartbeat.streakClaimed,
                  heartbeatStreak: heartbeat.streak > 0
                      ? heartbeat.streak
                      : streak,
                  onClaimed: (currentStreak) {
                    markStreakClaimed(ref, currentStreak);
                    ref.invalidate(dashboardProvider);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<DashboardMission> _mapMissions(
    List<Mission> missions,
    AppLocalizations l10n,
  ) {
    return missions.map((m) {
      return DashboardMission(
        title: m.titleVi.isNotEmpty ? m.titleVi : l10n.mission,
        subtitle: '${m.currentProgress}/${m.targetCount} · ${m.xpReward} XP',
        progress: m.progressRatio,
        icon: m.isCompleted ? Icons.check_circle : Icons.star_outline,
        color: m.isCompleted ? DesignTokens.success : DesignTokens.tigerOrange,
      );
    }).toList();
  }

  void _openStreakModal() {
    if (mounted) setState(() => _showStreakModal = true);
  }

  void _closeStreakModal() {
    if (mounted) setState(() => _showStreakModal = false);
  }

  void _openDailyPathStep(DailyPathStep? step) {
    context.push(resolveDailyPathRoute(step));
  }
}
