import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/vocabulary_models.dart';
import '../data/vocabulary_repository.dart';
import '../../../view_models/providers.dart';

/// Vocabulary repository provider
final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  return VocabularyRepository(ref.watch(apiClientProvider));
});

/// Vocabulary topics provider
final vocabularyTopicsProvider = FutureProvider<List<VocabularyTopic>>((
  ref,
) async {
  return ref.watch(vocabularyRepositoryProvider).fetchTopics();
});

/// Word collections provider
final wordCollectionsProvider = FutureProvider<List<WordCollection>>((
  ref,
) async {
  return ref.watch(vocabularyRepositoryProvider).fetchCollections();
});

/// Topic level counts provider
final topicLevelCountsProvider = FutureProvider<List<TopicLevelCount>>((
  ref,
) async {
  return ref.watch(vocabularyRepositoryProvider).fetchTopicLevelCounts();
});

/// Level counts provider
final levelCountsProvider = FutureProvider<List<LevelCount>>((ref) async {
  return (await ref.watch(vocabularyRepositoryProvider).fetchPageData())
      .levelCounts;
});

/// Collection items provider
final collectionItemsProvider =
    FutureProvider.family<CollectionItemsResult, CollectionItemsParams>((
      ref,
      params,
    ) async {
      return ref
          .watch(vocabularyRepositoryProvider)
          .fetchCollectionItems(
            collectionId: params.collectionId,
            page: params.page,
            pageSize: params.pageSize,
            search: params.search,
            shuffle: params.shuffle,
          );
    });

/// Items by level provider
final itemsByLevelProvider =
    FutureProvider.family<CollectionItemsResult, ItemsByLevelParams>((
      ref,
      params,
    ) async {
      return ref
          .watch(vocabularyRepositoryProvider)
          .fetchItemsByLevel(
            level: params.level,
            page: params.page,
            pageSize: params.pageSize,
            search: params.search,
            shuffle: params.shuffle,
          );
    });

final topicLevelItemsProvider =
    FutureProvider.family<CollectionItemsResult, TopicLevelItemsParams>((
      ref,
      params,
    ) {
      return ref
          .watch(vocabularyRepositoryProvider)
          .fetchItemsByTopicLevel(
            topic: params.topic,
            level: params.level,
            page: params.page,
            pageSize: params.pageSize,
            search: params.search,
            shuffle: params.shuffle,
          );
    });

final vocabularyWordRouteProvider =
    FutureProvider.family<
      ({LearningItem item, List<LearningItem> queue}),
      ({String itemId, String topicKey, String? level})
    >((ref, params) async {
      final repository = ref.watch(vocabularyRepositoryProvider);
      final item = await repository.fetchItem(params.itemId);
      if (params.topicKey.isEmpty) return (item: item, queue: [item]);
      final result = await repository.fetchItemsByTopicLevel(
        topic: params.topicKey,
        level: params.level,
        pageSize: 100,
      );
      final hasItem = result.items.any((candidate) => candidate.id == item.id);
      final queue = hasItem
          ? result.items
                .map((candidate) => candidate.id == item.id ? item : candidate)
                .toList(growable: false)
          : [item, ...result.items];
      return (item: item, queue: queue);
    });

/// Vocabulary page data provider
final vocabularyPageDataProvider = FutureProvider<VocabularyPageData>((
  ref,
) async {
  return ref.watch(vocabularyRepositoryProvider).fetchPageData();
});

/// Search items provider
final searchItemsProvider =
    FutureProvider.family<CollectionItemsResult, SearchParams>((
      ref,
      params,
    ) async {
      return ref
          .watch(vocabularyRepositoryProvider)
          .search(
            query: params.query,
            page: params.page,
            pageSize: params.pageSize,
          );
    });

/// View mode for vocabulary page
enum VocabularyViewMode { goal, level, topic }

/// Selected view mode provider
final vocabularyViewModeProvider = StateProvider<VocabularyViewMode>((ref) {
  return VocabularyViewMode.goal;
});

/// Selected goal ID provider
final selectedGoalIdProvider = StateProvider<String>((ref) {
  return 'daily-life';
});

/// Selected main topic ID provider
final selectedMainTopicIdProvider = StateProvider<String>((ref) {
  return '';
});

// Parameter classes
class CollectionItemsParams {
  const CollectionItemsParams({
    required this.collectionId,
    this.page = 1,
    this.pageSize = 20,
    this.search,
    this.shuffle = false,
  });

  final String collectionId;
  final int page;
  final int pageSize;
  final String? search;
  final bool shuffle;

  @override
  bool operator ==(Object other) =>
      other is CollectionItemsParams &&
      other.collectionId == collectionId &&
      other.page == page &&
      other.pageSize == pageSize &&
      other.search == search &&
      other.shuffle == shuffle;

  @override
  int get hashCode =>
      Object.hash(collectionId, page, pageSize, search, shuffle);
}

class ItemsByLevelParams {
  const ItemsByLevelParams({
    required this.level,
    this.page = 1,
    this.pageSize = 20,
    this.search,
    this.shuffle = false,
  });

  final String level;
  final int page;
  final int pageSize;
  final String? search;
  final bool shuffle;

  @override
  bool operator ==(Object other) =>
      other is ItemsByLevelParams &&
      other.level == level &&
      other.page == page &&
      other.pageSize == pageSize &&
      other.search == search &&
      other.shuffle == shuffle;

  @override
  int get hashCode => Object.hash(level, page, pageSize, search, shuffle);
}

class TopicLevelItemsParams {
  const TopicLevelItemsParams({
    required this.topic,
    this.level,
    this.page = 1,
    this.pageSize = 20,
    this.search,
    this.shuffle = false,
  });

  final String topic;
  final String? level;
  final int page;
  final int pageSize;
  final String? search;
  final bool shuffle;

  @override
  bool operator ==(Object other) =>
      other is TopicLevelItemsParams &&
      other.topic == topic &&
      other.level == level &&
      other.page == page &&
      other.pageSize == pageSize &&
      other.search == search &&
      other.shuffle == shuffle;

  @override
  int get hashCode =>
      Object.hash(topic, level, page, pageSize, search, shuffle);
}

class SearchParams {
  const SearchParams({required this.query, this.page = 1, this.pageSize = 20});

  final String query;
  final int page;
  final int pageSize;

  @override
  bool operator ==(Object other) =>
      other is SearchParams &&
      other.query == query &&
      other.page == page &&
      other.pageSize == pageSize;

  @override
  int get hashCode => Object.hash(query, page, pageSize);
}
