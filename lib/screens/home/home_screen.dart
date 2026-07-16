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
import 'widgets/community_links.dart';
import 'widgets/dashboard_sections.dart';
import 'widgets/exam_corner_card.dart';
import 'widgets/pinned_shortcuts.dart';
import 'widgets/premium_banner.dart';
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
                            onSettingsTap: () => context.push('/settings'),
                            onMessagesTap: ReleaseFeatureFlags.social
                                ? () => context.push('/social/messages')
                                : null,
                            onProfileTap: () => context.push('/profile'),
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
                          // Lộ trình hôm nay — THE single "what to study now"
                          // answer, first content block after header/search.
                          DashboardContinueLearningSection(
                            dailyXp: dailyXp ?? 0,
                            dailyGoal: dailyGoal ?? 0,
                            streak: streak,
                            onStart: _openDailyPathStep,
                          ),
                          const SizedBox(height: DesignTokens.spacingMd),
                          // Đích thi — countdown + tiếp tục đề, ngay sau path.
                          const ExamCornerCard(),
                          const SizedBox(height: DesignTokens.spacingMd),
                          // 🔗 Lối tắt — 10 pinned shortcuts.
                          const PinnedShortcuts(),
                          const SizedBox(height: DesignTokens.spacingMd),
                          // 🎁 Nhiệm vụ thưởng — discovery missions below the
                          // guided path.
                          DashboardMissionsSection(missions: missions),
                          const SizedBox(height: DesignTokens.spacingMd),
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
                          // Khám phá — free-browse grid, demoted below the
                          // guided path.
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.screenHorizontalPadding,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.exploreSectionTitle,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: DesignTokens.foreground,
                                  ),
                                ),
                                const SizedBox(height: DesignTokens.spacingSm),
                                QuickActions(totalWords: dash.wordsLearned),
                              ],
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacingMd),
                          PremiumBanner(
                            isPremiumUser:
                                profileAsync.valueOrNull?.isPremium ?? false,
                          ),
                          const SizedBox(height: DesignTokens.spacingMd),
                          const CommunityLinks(),
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
