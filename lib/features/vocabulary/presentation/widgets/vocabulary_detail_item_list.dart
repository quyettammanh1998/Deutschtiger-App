import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/app_pill.dart';
import '../../domain/graduation_stats.dart';
import '../../domain/vocabulary_models.dart';
import '../vocabulary_provider.dart';
import 'vocabulary_detail_scope_resolver.dart';

enum VocabularyDetailTab { list, mine }

/// The "Danh sách" / "Từ của tôi" content — web parity: `VocabularyItemList`
/// (paginated rows + mastery dot) and `VocabMyWordsTab` (same item pool
/// grouped by mastery bucket instead of paginated). Both read the same
/// item/mastery data so this stays one widget with a [tab] switch.
class VocabularyDetailItemList extends ConsumerWidget {
  const VocabularyDetailItemList({
    super.key,
    required this.scope,
    required this.tab,
    required this.page,
    required this.search,
    required this.weakOnly,
    required this.onPageChanged,
    required this.onTotalPages,
  });

  static const _pageSize = 20;
  static const _wideSampleSize = 150;

  final ResolvedVocabularyScope scope;
  final VocabularyDetailTab tab;
  final int page;
  final String search;
  final bool weakOnly;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onTotalPages;

  bool get _wide => tab == VocabularyDetailTab.mine || weakOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final itemsAsync = _watchItems(ref);

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(child: Text(l10n.couldNotLoadVocabulary)),
      data: (result) {
        if (!_wide) {
          final totalPages = (result.total / _pageSize).ceil().clamp(
            1,
            1 << 30,
          );
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => onTotalPages(totalPages),
          );
        }
        if (result.items.isEmpty) {
          return Center(child: Text(l10n.noVocabulary));
        }
        final ids = result.items.map((i) => i.id).toList(growable: false);
        final masteryAsync = ref.watch(
          itemMasteryStatesProvider(ItemMasteryQuery(ids)),
        );
        final masteryMap = masteryAsync.value ?? const {};

        if (tab == VocabularyDetailTab.mine) {
          return _MineGroupedList(items: result.items, mastery: masteryMap);
        }

        final visible = weakOnly
            ? result.items.where((item) {
                final m = masteryMap[item.id];
                if (m == null) return false;
                if (!m.isWeak) return false;
                if (search.trim().isEmpty) return true;
                final q = search.trim().toLowerCase();
                return item.contentDe.toLowerCase().contains(q) ||
                    (item.contentVi ?? '').toLowerCase().contains(q);
              }).toList()
            : result.items;

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          itemCount: visible.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) => _ItemRow(
            item: visible[index],
            mastery: masteryMap[visible[index].id],
            scope: scope,
          ),
        );
      },
    );
  }

  AsyncValue<CollectionItemsResult> _watchItems(WidgetRef ref) {
    final pageSize = _wide ? _wideSampleSize : _pageSize;
    final effectivePage = _wide ? 1 : page;
    final trimmedSearch = search.trim();
    final effectiveSearch = tab == VocabularyDetailTab.mine || trimmedSearch.isEmpty
        ? null
        : trimmedSearch;
    if (scope.topicKey != null) {
      return ref.watch(
        topicLevelItemsProvider(
          TopicLevelItemsParams(
            topic: scope.topicKey!,
            level: scope.level,
            page: effectivePage,
            pageSize: pageSize,
            search: effectiveSearch,
          ),
        ),
      );
    }
    if (scope.level != null) {
      return ref.watch(
        itemsByLevelProvider(
          ItemsByLevelParams(
            level: scope.level!,
            page: effectivePage,
            pageSize: pageSize,
            search: effectiveSearch,
          ),
        ),
      );
    }
    return ref.watch(
      collectionItemsProvider(
        CollectionItemsParams(
          collectionId: scope.collectionId ?? '',
          page: effectivePage,
          pageSize: pageSize,
          search: effectiveSearch,
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.mastery, required this.scope});
  final LearningItem item;
  final ItemMasteryState? mastery;
  final ResolvedVocabularyScope scope;

  static const _bucketColor = {
    ItemMasteryBucket.newWord: Color(0xFF9CA3AF),
    ItemMasteryBucket.learning: Color(0xFFF59E0B),
    ItemMasteryBucket.known: Color(0xFF3B82F6),
    ItemMasteryBucket.mastered: Color(0xFF10B981),
  };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: mastery != null
              ? _bucketColor[mastery!.bucket]
              : Colors.transparent,
        ),
      ),
      title: Text(item.contentDe, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(item.contentVi ?? item.meanings?.firstOrNull ?? ''),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () => context.push(
        '/vocabulary/word/${item.id}'
        '?topicKey=${scope.topicKey ?? ''}'
        '${scope.level != null ? '&level=${scope.level}' : ''}',
      ),
    );
  }
}

class _MineGroupedList extends StatelessWidget {
  const _MineGroupedList({required this.items, required this.mastery});
  final List<LearningItem> items;
  final Map<String, ItemMasteryState> mastery;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final groups = <ItemMasteryBucket, List<LearningItem>>{};
    for (final item in items) {
      final bucket = mastery[item.id]?.bucket ?? ItemMasteryBucket.newWord;
      (groups[bucket] ??= []).add(item);
    }
    final order = [
      ItemMasteryBucket.mastered,
      ItemMasteryBucket.known,
      ItemMasteryBucket.learning,
      ItemMasteryBucket.newWord,
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      children: [
        for (final bucket in order)
          if ((groups[bucket] ?? const []).isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _bucketLabel(l10n, bucket),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: _ItemRow._bucketColor[bucket],
                        ),
                      ),
                      const SizedBox(width: 6),
                      AppPill(label: '${groups[bucket]!.length}'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  for (final item in groups[bucket]!)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text('${item.contentDe} — ${item.contentVi ?? ''}'),
                    ),
                ],
              ),
            ),
      ],
    );
  }

  String _bucketLabel(AppLocalizations l10n, ItemMasteryBucket bucket) =>
      switch (bucket) {
        ItemMasteryBucket.mastered => l10n.vocabularyMasteryMastered,
        ItemMasteryBucket.known => l10n.vocabularyMasteryKnown,
        ItemMasteryBucket.learning => l10n.vocabularyMasteryLearning,
        ItemMasteryBucket.newWord => l10n.vocabularyMasteryNew,
      };
}
