import '../domain/vocabulary_models.dart';
import '../../../services/api_client.dart';

/// Vocabulary repository for parsing API responses
class VocabularyRepository {
  const VocabularyRepository(this._api);

  final ApiClient _api;

  Future<VocabularyPageData> fetchPageData() async {
    final json = await _api.get<Map<String, dynamic>>('/vocabulary-page-data');
    return VocabularyPageData(
      topics: parseTopics(json['topics']),
      collections: parseCollections(json['collections']),
      levelCounts: parseLevelCounts(json['level_counts']),
      topicLevelCounts: parseTopicLevelCounts(json['topic_level_counts']),
    );
  }

  Future<List<VocabularyTopic>> fetchTopics() async =>
      parseTopics(await _api.get<List<dynamic>>('/vocabulary/topics'));

  Future<List<WordCollection>> fetchCollections() async => parseCollections(
    await _api.get<List<dynamic>>('/vocabulary/collections'),
  );

  Future<List<TopicLevelCount>> fetchTopicLevelCounts() async =>
      parseTopicLevelCounts(
        await _api.get<List<dynamic>>('/vocabulary/topic-level-counts'),
      );

  Future<LearningItem> fetchItem(String itemId) async => parseLearningItem(
    await _api.get<Map<String, dynamic>>('/learning-items/$itemId'),
  );

  Future<CollectionItemsResult> fetchCollectionItems({
    required String collectionId,
    int page = 1,
    int pageSize = 20,
    String? search,
    bool shuffle = false,
  }) async => _fetchItems(
    '/vocabulary/collections/$collectionId/items',
    page: page,
    pageSize: pageSize,
    search: search,
    shuffle: shuffle,
  );

  Future<CollectionItemsResult> fetchItemsByLevel({
    required String level,
    int page = 1,
    int pageSize = 20,
    String? search,
    bool shuffle = false,
  }) async => _fetchItems(
    '/vocabulary/items-by-level/${level.toUpperCase()}',
    page: page,
    pageSize: pageSize,
    search: search,
    shuffle: shuffle,
  );

  Future<CollectionItemsResult> fetchItemsByTopicLevel({
    required String topic,
    String? level,
    int page = 1,
    int pageSize = 20,
    String? search,
    bool shuffle = false,
  }) async => _fetchItems(
    '/vocabulary/by-topic-level',
    page: page,
    pageSize: pageSize,
    search: search,
    shuffle: shuffle,
    extraQuery: {
      'topic': topic,
      if (level != null && level.isNotEmpty) 'level': level.toUpperCase(),
    },
  );

  Future<CollectionItemsResult> search({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) => _fetchItems(
    '/vocabulary/search',
    page: page,
    pageSize: pageSize,
    extraQuery: {'q': query},
  );

  Future<CollectionItemsResult> _fetchItems(
    String path, {
    required int page,
    required int pageSize,
    String? search,
    bool shuffle = false,
    Map<String, dynamic> extraQuery = const {},
  }) async {
    final json = await _api.get<Map<String, dynamic>>(
      path,
      query: {
        ...extraQuery,
        'page': page,
        'pageSize': pageSize,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (shuffle) 'shuffle': true,
      },
    );
    return parseCollectionItems(json);
  }

  CollectionItemsResult parseCollectionItems(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];
    return CollectionItemsResult(
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(parseLearningItem)
          .toList(growable: false),
      total: _asInt(json['total']),
      page: _asInt(json['page'], fallback: 1),
      pageSize: _asInt(json['pageSize'] ?? json['page_size'], fallback: 20),
    );
  }

  /// Get vocabulary topics
  List<VocabularyTopic> parseTopics(dynamic json) {
    if (json == null) return [];
    if (json is List) {
      return json.map((e) => _parseTopic(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  VocabularyTopic _parseTopic(Map<String, dynamic> json) {
    return VocabularyTopic(
      id: json['id'] as String? ?? '',
      parentId: json['parent_id'] as String?,
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
      labelVi: json['label_vi'] as String? ?? '',
      icon: json['icon'] as String? ?? '📚',
      color: json['color'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  /// Get word collections
  List<WordCollection> parseCollections(dynamic json) {
    if (json == null) return [];
    if (json is List) {
      return json
          .map((e) => _parseCollection(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  WordCollection _parseCollection(Map<String, dynamic> json) {
    return WordCollection(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      collectionType: _parseCollectionType(json['collection_type'] as String?),
      level: _parseLevel(json['level'] as String?),
      sortOrder: json['sort_order'] as int? ?? 0,
      wordCount: json['word_count'] as int? ?? 0,
      icon: json['icon'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  CollectionType _parseCollectionType(String? type) {
    switch (type) {
      case 'goethe':
        return CollectionType.goethe;
      case 'topic':
        return CollectionType.topic;
      case 'medical':
        return CollectionType.medical;
      case 'custom':
        return CollectionType.custom;
      case 'sprechen':
        return CollectionType.sprechen;
      default:
        return CollectionType.custom;
    }
  }

  WordLevel? _parseLevel(String? level) {
    if (level == null) return null;
    switch (level.toUpperCase()) {
      case 'A1':
        return WordLevel.a1;
      case 'A2':
        return WordLevel.a2;
      case 'B1':
        return WordLevel.b1;
      case 'B2':
        return WordLevel.b2;
      case 'C1':
        return WordLevel.c1;
      case 'C2':
        return WordLevel.c2;
      default:
        return null;
    }
  }

  /// Parse learning item
  LearningItem parseLearningItem(Map<String, dynamic> json) {
    return LearningItem.fromJson(json);
  }

  /// Parse level counts
  List<LevelCount> parseLevelCounts(dynamic json) {
    if (json == null) return [];
    if (json is List) {
      return json
          .map(
            (e) => LevelCount(
              level: e['level'] as String? ?? '',
              count: _asInt(e['count']),
            ),
          )
          .toList();
    }
    return [];
  }

  /// Parse topic level counts
  List<TopicLevelCount> parseTopicLevelCounts(dynamic json) {
    if (json == null) return [];
    if (json is List) {
      return json
          .map(
            (e) => TopicLevelCount(
              topicId: e['topic_id'] as String? ?? '',
              topicKey: e['topic_key'] as String? ?? '',
              label: e['label'] as String? ?? '',
              labelVi: e['label_vi'] as String? ?? '',
              parentId: e['parent_id'] as String?,
              level: e['level'] as String? ?? '',
              count: _asInt(e['count']),
              totalCount: e['total_count'] == null
                  ? null
                  : _asInt(e['total_count']),
            ),
          )
          .toList();
    }
    return [];
  }

  int _asInt(dynamic value, {int fallback = 0}) => switch (value) {
    int number => number,
    num number => number.toInt(),
    String text => int.tryParse(text) ?? fallback,
    _ => fallback,
  };

  /// Legacy fallback retained for offline/static previews.
  List<WordCollection> getGoetheCollections() {
    return [
      WordCollection(
        id: 'g-a1',
        slug: 'goethe-a1',
        name: 'GOETHE A1',
        description: 'Từ vựng thi Goethe A1',
        collectionType: CollectionType.goethe,
        level: WordLevel.a1,
        sortOrder: 1,
        wordCount: 0,
        icon: '🌱',
        createdAt: '',
      ),
      WordCollection(
        id: 'g-a2',
        slug: 'goethe-a2',
        name: 'GOETHE A2',
        description: 'Từ vựng thi Goethe A2',
        collectionType: CollectionType.goethe,
        level: WordLevel.a2,
        sortOrder: 2,
        wordCount: 0,
        icon: '🌿',
        createdAt: '',
      ),
      WordCollection(
        id: 'g-b1',
        slug: 'goethe-b1',
        name: 'GOETHE B1',
        description: 'Từ vựng thi Goethe B1',
        collectionType: CollectionType.goethe,
        level: WordLevel.b1,
        sortOrder: 3,
        wordCount: 0,
        icon: '🌳',
        createdAt: '',
      ),
      WordCollection(
        id: 'g-b2',
        slug: 'goethe-b2',
        name: 'GOETHE B2',
        description: 'Từ vựng thi Goethe B2',
        collectionType: CollectionType.goethe,
        level: WordLevel.b2,
        sortOrder: 4,
        wordCount: 0,
        icon: '🎆',
        createdAt: '',
      ),
      WordCollection(
        id: 'g-c1',
        slug: 'goethe-c1',
        name: 'GOETHE C1',
        description: 'Từ vựng thi Goethe C1',
        collectionType: CollectionType.goethe,
        level: WordLevel.c1,
        sortOrder: 5,
        wordCount: 0,
        icon: '🌴',
        createdAt: '',
      ),
      WordCollection(
        id: 'g-c2',
        slug: 'goethe-c2',
        name: 'GOETHE C2',
        description: 'Từ vựng thi Goethe C2',
        collectionType: CollectionType.goethe,
        level: WordLevel.c2,
        sortOrder: 6,
        wordCount: 0,
        icon: '👑',
        createdAt: '',
      ),
    ];
  }
}
