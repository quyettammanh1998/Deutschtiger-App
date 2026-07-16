import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/speech/sprechen_models.dart';
import '../../../data/speech/sprechen_session_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/speech/sprechen_provider.dart';
import '../../../view_models/speech/sprechen_session_provider.dart';
import 'widgets/sprechen_topic_group_list.dart';

/// Web parity: `goethe-sprechen-topic-list-page.tsx` — collapsible
/// tag-group cards + leaderboard below, see scout §B.2.
class GoetheSprechenTopicListPage extends ConsumerStatefulWidget {
  const GoetheSprechenTopicListPage({
    super.key,
    required this.level,
    required this.teil,
  });

  final String level;
  final String teil;

  @override
  ConsumerState<GoetheSprechenTopicListPage> createState() =>
      _GoetheSprechenTopicListPageState();
}

class _GoetheSprechenTopicListPageState
    extends ConsumerState<GoetheSprechenTopicListPage> {
  final Set<String> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final topicsAsync = ref.watch(sprechenTopicsProvider(widget.teil));
    final tagsAsync = ref.watch(sprechenTagsProvider(widget.teil));
    final resultsAsync = ref.watch(sprechenResultsProvider);
    final leaderboardAsync = ref.watch(sprechenLeaderboardProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sprechenTopicListTitle)),
      body: topicsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(l10n.sprechenTopicListLoadError(e.toString())),
        ),
        data: (topics) {
          if (topics.isEmpty) {
            return Center(
              child: Text(
                l10n.sprechenTopicListEmpty,
                style: TextStyle(color: tokens.mutedForeground),
              ),
            );
          }
          final tags = tagsAsync.valueOrNull ?? const <SprechenTag>[];
          final results =
              resultsAsync.valueOrNull ?? const <SprechenResult>[];
          final doneSlugs = results
              .where((r) => r.teil == widget.teil)
              .map((r) => r.topicSlug)
              .toSet();

          final grouped = <String, List<SprechenTopic>>{};
          for (final topic in topics) {
            grouped.putIfAbsent(topic.tag, () => []).add(topic);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.sprechenTopicListSummary(topics.length, doneSlugs.length),
                style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
              ),
              const SizedBox(height: 12),
              for (final entry in grouped.entries)
                SprechenTopicGroupCard(
                  tagId: entry.key,
                  tag: tags.where((t) => t.id == entry.key).firstOrNull,
                  topics: entry.value,
                  doneSlugs: doneSlugs,
                  expanded: _expanded.contains(entry.key),
                  onToggle: () => setState(() {
                    if (!_expanded.add(entry.key)) _expanded.remove(entry.key);
                  }),
                  onTopicTap: (topic) => context.push(
                    '/exams/goethe/${widget.level}/sprechen/${widget.teil}/${topic.slug}',
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                l10n.leaderboardTitle,
                style: TextStyle(fontWeight: FontWeight.bold, color: tokens.foreground),
              ),
              const SizedBox(height: 8),
              leaderboardAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
                data: (entries) => entries.isEmpty
                    ? Text(
                        l10n.sprechenLeaderboardEmpty,
                        style: TextStyle(color: tokens.mutedForeground),
                      )
                    : Column(
                        children: [
                          for (final e in entries.take(10))
                            ListTile(
                              dense: true,
                              leading: Text('#${e.rank}'),
                              title: Text(e.displayName),
                              trailing: Text('${e.totalScore}'),
                            ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
