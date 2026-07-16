import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/home/dashboard_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/settings/learning_preferences_provider.dart';
import '../../../widgets/common/app_card.dart';
import '../../../view_models/stats/error_patterns_provider.dart';
import '../../../view_models/stats/stats_provider.dart';
import 'error_patterns_list.dart';
import 'srs_stats_card.dart';
import 'stats_achievements_data.dart';
import 'stats_achievements_grid.dart';
import 'stats_cefr_level_card.dart';
import 'stats_leaderboard_table.dart';
import 'stats_near_achievements_card.dart';
import 'stats_online_time_card.dart';
import 'stats_review_cards.dart';
import 'stats_spaced_repetition_card.dart';
import 'stats_suggestions_card.dart';
import 'stats_xp_bar_chart.dart';

/// Blocks 3-13 of the web stats page (progress cards handled by the caller;
/// this covers everything from the XP chart down to the leaderboard table +
/// error-patterns preview). Kept as a slivers list so it can sit inside the
/// screen's `CustomScrollView`.
class StatsScreenBody extends StatelessWidget {
  const StatsScreenBody({
    super.key,
    required this.gamification,
    required this.currentUserId,
  });

  final Gamification gamification;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        _Section(
          title: l10n.statsWeeklyXpChartTitle,
          child: Consumer(
            builder: (context, ref, _) => StatsXpBarChart(
              entries: ref.watch(weeklyXpLogProvider).valueOrNull ?? const [],
            ),
          ),
        ),
        Consumer(
          builder: (context, ref, _) => StatsOnlineTimeCard(
            data: ref.watch(weeklyOnlineTimeProvider).valueOrNull ?? const [],
          ),
        ),
        _Section(
          title: l10n.statsReviewCardsTitle,
          child: Consumer(
            builder: (context, ref, _) {
              final stats = ref.watch(flashcardReviewStatsProvider);
              return stats.when(
                loading: () => const SizedBox(
                  height: 60,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, _) => const SizedBox.shrink(),
                data: (s) => StatsReviewCards(stats: s),
              );
            },
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            final review = ref.watch(reviewStatsProvider).valueOrNull;
            final suggestions = <String>[
              if (gamification.currentStreak == 0) l10n.statsSuggestionStreak,
              if ((review?.wordsLearned ?? 0) == 0)
                l10n.statsSuggestionListening,
              if ((review?.totalReviews ?? 0) == 0)
                l10n.statsSuggestionReviewAll,
            ];
            return _Section(
              title: l10n.statsSuggestionsTitle,
              child: StatsSuggestionsCard(suggestions: suggestions),
            );
          },
        ),
        _Section(
          title: l10n.statsSpacedRepetitionTitle,
          child: const StatsSpacedRepetitionCard(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Consumer(
            builder: (context, ref, _) {
              final mastery = ref.watch(masteryProvider);
              final daily = ref.watch(srsDailyStatsProvider);
              return mastery.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: LinearProgressIndicator(),
                ),
                error: (_, _) => const SizedBox.shrink(),
                data: (m) => SRSStatsCard(
                  mastery: m,
                  daily: daily.valueOrNull ?? const [],
                ),
              );
            },
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            final cefr = ref
                .watch(learningPreferencesProvider)
                .preferences
                ?.cefrLevel;
            final words =
                ref.watch(reviewStatsProvider).valueOrNull?.wordsLearned ?? 0;
            return _Section(
              title: l10n.statsCefrTitle,
              child: StatsCefrLevelCard(
                cefrLevel: cefr ?? 'A1',
                wordsLearned: words,
              ),
            );
          },
        ),
        Consumer(
          builder: (context, ref, _) {
            ref.watch(statsAchievementsProvider);
            final near = ref.watch(statsNearAchievementsProvider);
            return near.isEmpty
                ? const SizedBox.shrink()
                : _Section(child: StatsNearAchievementsCard(achievements: near));
          },
        ),
        Consumer(
          builder: (context, ref, _) {
            final all =
                ref.watch(statsAchievementsProvider).valueOrNull ?? const [];
            return all.isEmpty
                ? const SizedBox.shrink()
                : _Section(child: StatsAchievementsGrid(achievements: all));
          },
        ),
        _Section(
          child: StatsLeaderboardTable(currentUserId: currentUserId),
        ),
        _SectionHeader(
          title: l10n.statsErrorPatternsTitle,
          onSeeAll: () => context.push('/stats/error-patterns'),
        ),
        const _ErrorPatternsSection(),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// Uniform `card mb-6 p-4` section wrapper with an optional `h2` title —
/// mirror web's repeated `<div className="card mb-6 p-4 md:p-6">` pattern.
class _Section extends StatelessWidget {
  const _Section({this.title, required this.child});
  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCard.card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: tokens.foreground,
                ),
              ),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

class _ErrorPatternsSection extends ConsumerWidget {
  const _ErrorPatternsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(errorPatternsSummaryProvider);
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: LinearProgressIndicator(),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (patterns) {
        if (patterns.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.statsErrorPatternsEmpty,
              style: TextStyle(color: context.tokens.mutedForeground),
            ),
          );
        }
        final top = [...patterns]
          ..sort((a, b) => b.totalCount.compareTo(a.totalCount));
        return ErrorPatternsList(patterns: top.take(3).toList());
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onSeeAll});
  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: tokens.foreground,
              ),
            ),
          ),
          if (onSeeAll != null)
            TextButton(onPressed: onSeeAll, child: Text(l10n.seeAll)),
        ],
      ),
    );
  }
}
