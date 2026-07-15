/// Vocabulary models - simplified without Freezed
enum LearningItemType { word, sentence, chunk, passage }

enum WordLevel { a1, a2, b1, b2, c1, c2 }

enum CollectionType { goethe, topic, medical, custom, sprechen }

class LearningItem {
  const LearningItem({
    required this.id,
    this.parentId,
    this.userId,
    this.type = LearningItemType.word,
    required this.contentDe,
    this.contentVi,
    this.clozeWords,
    this.category = '',
    this.tags,
    this.level,
    this.audioUrl,
    this.imageUrl,
    this.sourceUrl,
    this.metadata,
    this.path,
    this.depthLevel = 0,
    this.externalId,
    this.importBatchId,
    this.createdBy,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
    this.examples,
    this.meanings,
    this.conjugation,
    this.wordType,
    this.gender,
    this.plural,
    this.ipa,
    this.auxiliary,
    this.isSeparable,
    this.separablePrefix,
    this.komparativ,
    this.superlativ,
    this.parent,
    this.lemma,
  });

  final String id;
  final String? parentId;
  final String? userId;
  final LearningItemType type;
  final String contentDe;
  final String? contentVi;
  final List<String>? clozeWords;
  final String category;
  final List<String>? tags;
  final WordLevel? level;
  final String? audioUrl;
  final String? imageUrl;
  final String? sourceUrl;
  final Map<String, dynamic>? metadata;
  final String? path;
  final int depthLevel;
  final String? externalId;
  final String? importBatchId;
  final String? createdBy;
  final int sortOrder;
  final String createdAt;
  final String updatedAt;
  final List<Example>? examples;
  final List<String>? meanings;
  final ConjugationInfo? conjugation;
  final String? wordType;
  final String? gender;
  final String? plural;
  final String? ipa;
  final String? auxiliary;
  final bool? isSeparable;
  final String? separablePrefix;
  final String? komparativ;
  final String? superlativ;
  final LearningItem? parent;
  final String? lemma;

  factory LearningItem.fromJson(Map<String, dynamic> json) {
    final examplesJson = json['examples'] as List<dynamic>? ?? const [];
    final conjugationJson = json['conjugation'];
    return LearningItem(
      id: json['id'] as String? ?? '',
      parentId: json['parent_id'] as String?,
      userId: json['user_id'] as String?,
      type: LearningItemType.values.firstWhere(
        (e) => e.name == (json['type'] as String? ?? 'word'),
        orElse: () => LearningItemType.word,
      ),
      contentDe: json['content_de'] as String? ?? '',
      contentVi: json['content_vi'] as String?,
      clozeWords: _stringList(json['cloze_words']),
      category: json['category'] as String? ?? '',
      tags: _stringList(json['tags']),
      level: json['level'] != null
          ? WordLevel.values.firstWhere(
              (e) =>
                  e.name.toUpperCase() ==
                  (json['level'] as String).toUpperCase(),
              orElse: () => WordLevel.a1,
            )
          : null,
      audioUrl: json['audio_url'] as String?,
      imageUrl:
          json['image_url'] as String? ??
          (json['metadata'] is Map
              ? json['metadata']['image'] as String?
              : null),
      sourceUrl: json['source_url'] as String?,
      metadata: _stringMap(json['metadata']),
      path: json['path'] as String?,
      depthLevel: _intValue(json['depth_level']),
      externalId: json['external_id'] as String?,
      importBatchId: json['import_batch_id'] as String?,
      createdBy: json['created_by'] as String?,
      sortOrder: _intValue(json['sort_order']),
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      examples: examplesJson
          .whereType<Map<String, dynamic>>()
          .map(Example.fromJson)
          .where((example) => example.de.isNotEmpty)
          .toList(growable: false),
      meanings: _stringList(json['meanings']),
      conjugation: conjugationJson is Map<String, dynamic>
          ? ConjugationInfo.fromJson(conjugationJson)
          : null,
      wordType: json['word_type'] as String?,
      gender: json['gender'] as String?,
      plural: json['plural'] as String?,
      ipa: json['ipa'] as String?,
      auxiliary: json['auxiliary'] as String?,
      isSeparable: json['is_separable'] as bool?,
      separablePrefix: json['separable_prefix'] as String?,
      komparativ: json['komparativ'] as String?,
      superlativ: json['superlativ'] as String?,
      parent: json['parent'] is Map<String, dynamic>
          ? LearningItem.fromJson(json['parent'] as Map<String, dynamic>)
          : null,
      lemma: json['lemma'] as String?,
    );
  }
}

class Example {
  const Example({
    required this.de,
    required this.vi,
    this.cloze,
    this.audioUrl,
  });
  final String de;
  final String vi;
  final String? cloze;
  final String? audioUrl;

  factory Example.fromJson(Map<String, dynamic> json) => Example(
    de: json['de'] as String? ?? '',
    vi: json['vi'] as String? ?? '',
    cloze: json['cloze'] as String?,
    audioUrl: json['audio_url'] as String?,
  );
}

class ConjugationInfo {
  const ConjugationInfo({
    this.praesens,
    this.praeteritum,
    this.konjunktivIi,
    this.perfekt,
    this.raw,
  });
  final List<String>? praesens;
  final List<String>? praeteritum;
  final String? konjunktivIi;
  final String? perfekt;
  final String? raw;

  factory ConjugationInfo.fromJson(Map<String, dynamic> json) =>
      ConjugationInfo(
        praesens: _stringList(json['praesens']),
        praeteritum: _stringList(json['praeteritum']),
        konjunktivIi: json['konjunktiv_ii'] as String?,
        perfekt: json['perfekt'] as String?,
        raw: json['raw'] as String?,
      );
}

List<String>? _stringList(dynamic value) {
  if (value is! List) return null;
  return value.whereType<String>().toList(growable: false);
}

Map<String, dynamic>? _stringMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  return null;
}

int _intValue(dynamic value) => switch (value) {
  int number => number,
  num number => number.toInt(),
  String text => int.tryParse(text) ?? 0,
  _ => 0,
};

class WordCollection {
  const WordCollection({
    required this.id,
    required this.slug,
    required this.name,
    this.description,
    required this.collectionType,
    this.level,
    this.sortOrder = 0,
    this.wordCount = 0,
    this.icon,
    required this.createdAt,
  });

  final String id;
  final String slug;
  final String name;
  final String? description;
  final CollectionType collectionType;
  final WordLevel? level;
  final int sortOrder;
  final int wordCount;
  final String? icon;
  final String createdAt;
}

class VocabularyTopic {
  const VocabularyTopic({
    required this.id,
    this.parentId,
    required this.key,
    required this.label,
    required this.labelVi,
    required this.icon,
    this.color,
    this.sortOrder = 0,
    required this.createdAt,
  });

  final String id;
  final String? parentId;
  final String key;
  final String label;
  final String labelVi;
  final String icon;
  final String? color;
  final int sortOrder;
  final String createdAt;
}

class TopicLevelCount {
  const TopicLevelCount({
    required this.topicId,
    required this.topicKey,
    required this.label,
    required this.labelVi,
    this.parentId,
    required this.level,
    required this.count,
    this.totalCount,
  });

  final String topicId;
  final String topicKey;
  final String label;
  final String labelVi;
  final String? parentId;
  final String level;
  final int count;
  final int? totalCount;
}

class VocabularyPageData {
  VocabularyPageData({
    this.topics = const [],
    this.collections = const [],
    this.levelCounts = const [],
    this.topicLevelCounts = const [],
  });

  final List<VocabularyTopic> topics;
  final List<WordCollection> collections;
  final List<LevelCount> levelCounts;
  final List<TopicLevelCount> topicLevelCounts;
}

class LevelCount {
  const LevelCount({required this.level, required this.count});
  final String level;
  final int count;
}

class CollectionItemsResult {
  CollectionItemsResult({
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.pageSize = 20,
  });

  final List<LearningItem> items;
  final int total;
  final int page;
  final int pageSize;
}

class ReviewResult {
  const ReviewResult({
    required this.itemId,
    required this.correct,
    required this.xpEarned,
    this.nextReviewAt,
  });

  final String itemId;
  final bool correct;
  final int xpEarned;
  final String? nextReviewAt;
}
