import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../core/release/release_feature_flags.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';
import '../../../widgets/announcements/announcement_banner.dart';
import '../../../widgets/common/async_state_views.dart';
import '../../../widgets/dashboard/mobile_dashboard_header.dart';
import '../../../widgets/dashboard/streak_claim_modal.dart';
import '../../../features/daily_path/domain/daily_path.dart';
import '../../../features/daily_path/presentation/daily_path_route_resolver.dart';
import '../../../features/heartbeat/heartbeat_provider.dart';
import '../../view_models/notifications/notifications_provider.dart';
import 'widgets/community_links.dart';
import 'widgets/dashboard_mission_mapping.dart';
import 'widgets/dashboard_sections.dart';
import 'widgets/exam_corner_card.dart';
import 'widgets/exam_hero_card.dart';
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
    final goalAsync = ref.watch(learnGoalProvider);
    final hasExamGoal = goalAsync.valueOrNull?.targetDate != null;
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
          final missions = mapDashboardMissions(dash.missions, l10n);

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
                          // Web parity: `dashboard-page.tsx` renders
                          // `AnnouncementBanner` above `MobileDashboardHeader`
                          // (before the layout entirely), gated on
                          // `initData?.announcements` being non-empty —
                          // matched here by the banner's own empty-state
                          // (renders `SizedBox.shrink()` when there is
                          // nothing to show).
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              DesignTokens.screenHorizontalPadding,
                              DesignTokens.spacingSm,
                              DesignTokens.screenHorizontalPadding,
                              0,
                            ),
                            child: const AnnouncementBanner(page: 'dashboard'),
                          ),
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
                            wordsLearned: dash.wordsLearned,
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
                          // Exam-goal users get an exam-first hero (real
                          // behavior: exam pages dominate usage for them);
                          // everyone else keeps the daily path as hero with
                          // the compact exam-corner goal-setter strip below
                          // it. Mirrors web `DashboardHeroSection`.
                          if (hasExamGoal) ...[
                            ExamHeroCard(goal: goalAsync.value!),
                            const SizedBox(height: DesignTokens.spacingMd),
                          ],
                          DashboardContinueLearningSection(
                            dailyXp: dailyXp ?? 0,
                            dailyGoal: dailyGoal ?? 0,
                            streak: streak,
                            onStart: _openDailyPathStep,
                          ),
                          const SizedBox(height: DesignTokens.spacingMd),
                          if (!hasExamGoal) ...[
                            // Đích thi — countdown + tiếp tục đề, ngay sau path.
                            const ExamCornerCard(),
                            const SizedBox(height: DesignTokens.spacingMd),
                          ],
                          // 🔗 Lối tắt — 10 pinned shortcuts.
                          const PinnedShortcuts(),
                          const SizedBox(height: DesignTokens.spacingMd),
                          // 🎁 Nhiệm vụ thưởng — discovery missions below the
                          // guided path.
                          DashboardMissionsSection(missions: missions),
                          const SizedBox(height: DesignTokens.spacingMd),
                          // PremiumBanner sits right after missions on web
                          // (block 5) — moved up from the tail of the page.
                          PremiumBanner(
                            isPremiumUser:
                                profileAsync.valueOrNull?.isPremium ?? false,
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

  void _closeStreakModal() {
    if (mounted) setState(() => _showStreakModal = false);
  }

  void _openDailyPathStep(DailyPathStep? step) {
    context.push(resolveDailyPathRoute(step));
  }
}
