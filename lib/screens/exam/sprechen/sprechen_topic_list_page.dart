import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/speech/sprechen_session_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/speech/sprechen_provider.dart';
import '../../../view_models/speech/sprechen_session_provider.dart';
import '../../../widgets/common/app_card.dart';
import 'widgets/sprechen_topic_group_list.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Web parity: `sprechen-topic-list-page.tsx` (TELC) — same tag-group list
/// as the Goethe topic list plus a diacritic-insensitive search box, see
/// scout §B.10. `CommunityTopicsSection` (community-submitted topics) is
/// out of scope for this phase — leaderboard only.
class SprechenTopicListPage extends ConsumerStatefulWidget {
  const SprechenTopicListPage({super.key, required this.teil});

  final String teil;

  @override
  ConsumerState<SprechenTopicListPage> createState() =>
      _SprechenTopicListPageState();
}

class _SprechenTopicListPageState extends ConsumerState<SprechenTopicListPage> {
  final _searchController = TextEditingController();
  String _query = '';

  static String _normalize(String s) => s
      .toLowerCase()
      .replaceAll(RegExp('[äàáâã]'), 'a')
      .replaceAll(RegExp('[ö]'), 'o')
      .replaceAll(RegExp('[üùúû]'), 'u')
      .replaceAll('ß', 'ss')
      .replaceAll(RegExp(r'[^a-z0-9\s-]'), '');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final topicsAsync = ref.watch(sprechenTopicsProvider(widget.teil));
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
          final filtered = _query.isEmpty
              ? topics
              : topics
                  .where((t) => _normalize(t.slug).contains(_normalize(_query)))
                  .toList();
          final results = resultsAsync.valueOrNull ?? const <SprechenResult>[];
          final doneSlugs = results
              .where((r) => r.teil == widget.teil)
              .map((r) => r.topicSlug)
              .toSet();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard.small(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      AppPhosphorIcons.magnifyingGlass,
                      size: 18,
                    ),
                    hintText: l10n.sprechenTopicSearchHint,
                    border: InputBorder.none,
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(PhosphorIcons.x, size: 16),
                            onPressed: () => setState(() {
                              _searchController.clear();
                              _query = '';
                            }),
                          ),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.sprechenTopicListFilteredCount(filtered.length, topics.length),
                style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
              ),
              const SizedBox(height: 8),
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      l10n.sprechenTopicListEmptyFiltered,
                      style: TextStyle(color: tokens.mutedForeground),
                    ),
                  ),
                )
              else
                AppCard.card(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (var i = 0; i < filtered.length; i++) ...[
                        SprechenTopicRow(
                          index: i + 1,
                          topic: filtered[i],
                          done: doneSlugs.contains(filtered[i].slug),
                          onTap: () => context.push(
                            '/exams/telc/b1/noi/${widget.teil}/${filtered[i].slug}',
                          ),
                        ),
                        if (i != filtered.length - 1)
                          Divider(height: 1, color: tokens.border),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                l10n.leaderboardTitle,
                style: TextStyle(fontWeight: FontWeight.bold),
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
