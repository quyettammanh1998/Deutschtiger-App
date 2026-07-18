import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/data/listening/podcast_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';
import 'widgets/podcast_index_parts.dart';
import 'widgets/podcast_leaderboard_card.dart';
import 'widgets/podcast_page_chrome.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// `/listening/podcast/easy_german` — index Easy German Podcast (tím, chip
/// theo khoảng thời lượng, stats strip, phân trang, leaderboard). Web parity:
/// `easy-german-podcast-page.tsx`.
class EasyGermanPodcastPage extends ConsumerStatefulWidget {
  const EasyGermanPodcastPage({super.key});

  @override
  ConsumerState<EasyGermanPodcastPage> createState() => _EasyGermanPodcastPageState();
}

class _EasyGermanPodcastPageState extends ConsumerState<EasyGermanPodcastPage> {
  static const _pageSize = 30;

  String _query = '';
  DurationBucket _bucket = DurationBucket.all;
  int _page = 1;

  void _resetPage() => setState(() => _page = 1);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final indexAsync = ref.watch(podcastIndexProvider);
    final completedAsync = ref.watch(podcastCompletedIdsProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: indexAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _buildError(tokens),
          data: (episodes) {
            final completedIds = completedAsync.valueOrNull?.toSet() ?? const <String>{};
            return _buildBody(tokens, episodes, completedIds);
          },
        ),
      ),
    );
  }

  Widget _buildError(AppTokens tokens) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(PhosphorIcons.wifiSlash, size: 56, color: tokens.mutedForeground),
          const SizedBox(height: 12),
          Text(l10n.podcastLoadError, style: TextStyle(color: tokens.mutedForeground)),
          const SizedBox(height: 12),
          TextButton(onPressed: () => ref.invalidate(podcastIndexProvider), child: Text(l10n.retry)),
        ],
      ),
    );
  }

  Widget _buildBody(AppTokens tokens, List<PodcastEpisode> episodes, Set<String> completedIds) {
    final l10n = AppLocalizations.of(context);
    final q = _query.trim().toLowerCase();
    final filtered = episodes
        .where((e) => (q.isEmpty || e.title.toLowerCase().contains(q)) && _bucket.matches(e.duration))
        .toList();
    final totalPages = (filtered.length / _pageSize).ceil().clamp(1, 1 << 30);
    final page = _page.clamp(1, totalPages);
    final paginated = filtered.skip((page - 1) * _pageSize).take(_pageSize).toList();
    final totalMinutes = episodes.fold<int>(0, (sum, e) => sum + e.duration) ~/ 60;

    final counts = {for (final b in DurationBucket.values) b: 0};
    counts[DurationBucket.all] = episodes.length;
    for (final e in episodes) {
      for (final b in DurationBucket.values) {
        if (b != DurationBucket.all && b.matches(e.duration)) {
          counts[b] = (counts[b] ?? 0) + 1;
          break;
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      children: [
        PodcastPageHeader(tokens: tokens, onBack: () => context.pop()),
        const SizedBox(height: 14),
        if (episodes.isNotEmpty) ...[
          Row(
            children: [
              Expanded(child: PodcastStatBox(value: '${episodes.length}', label: l10n.podcastEpisodeCountLabel, tokens: tokens)),
              const SizedBox(width: 10),
              Expanded(child: PodcastStatBox(value: '$totalMinutes', label: l10n.podcastMinutesLabel, tokens: tokens)),
            ],
          ),
          const SizedBox(height: 12),
          PodcastSearchFilterBar(
            tokens: tokens,
            bucket: _bucket,
            counts: counts,
            onQueryChanged: (v) {
              setState(() => _query = v);
              _resetPage();
            },
            onBucketChanged: (b) {
              setState(() => _bucket = b);
              _resetPage();
            },
          ),
          const SizedBox(height: 14),
        ],
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                q.isNotEmpty ? l10n.podcastNoResultsFor(_query) : l10n.podcastNoResultsInBucket,
                style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
              ),
            ),
          )
        else ...[
          for (var i = 0; i < paginated.length; i++) ...[
            PodcastEpisodeRow(
              index: (page - 1) * _pageSize + i,
              episode: paginated[i],
              completed: completedIds.contains(paginated[i].slug),
              tokens: tokens,
              onTap: () => context.push('/listening/podcast/easy_german/${paginated[i].slug}'),
            ),
            const SizedBox(height: 8),
          ],
          if (totalPages > 1)
            PodcastPaginationRow(
              tokens: tokens,
              page: page,
              totalPages: totalPages,
              totalCount: filtered.length,
              onChanged: (p) => setState(() => _page = p),
            ),
        ],
        if (episodes.isNotEmpty) ...[
          const SizedBox(height: 12),
          const PodcastLeaderboardCard(),
        ],
      ],
    );
  }
}
