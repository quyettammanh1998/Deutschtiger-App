/// Model cho tu vung trong search.
class VocabWord {
  final String id;
  final String word;
  final String translation;
  final String? pronunciation;
  final String? audioUrl;
  final String? example;
  final String? exampleTranslation;
  final String cefrLevel;
  final List<String> tags;
  final bool isLearned;
  final String? note;

  const VocabWord({
    required this.id,
    required this.word,
    required this.translation,
    this.pronunciation,
    this.audioUrl,
    this.example,
    this.exampleTranslation,
    this.cefrLevel = '',
    this.tags = const [],
    this.isLearned = false,
    this.note,
  });

  VocabWord copyWith({
    String? id,
    String? word,
    String? translation,
    String? pronunciation,
    String? audioUrl,
    String? example,
    String? exampleTranslation,
    String? cefrLevel,
    List<String>? tags,
    bool? isLearned,
    String? note,
  }) {
    return VocabWord(
      id: id ?? this.id,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      pronunciation: pronunciation ?? this.pronunciation,
      audioUrl: audioUrl ?? this.audioUrl,
      example: example ?? this.example,
      exampleTranslation: exampleTranslation ?? this.exampleTranslation,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      tags: tags ?? this.tags,
      isLearned: isLearned ?? this.isLearned,
      note: note ?? this.note,
    );
  }

  factory VocabWord.fromJson(Map<String, dynamic> json) {
    return VocabWord(
      id: json['id'] as String? ?? json['content_de'] as String? ?? '',
      word: json['word'] as String? ?? json['content_de'] as String? ?? '',
      translation: json['translation'] as String? ?? json['content_vi'] as String? ?? '',
      pronunciation: json['pronunciation'] as String? ??
          (json['metadata'] as Map<String, dynamic>?)?['pronounce'] as String?,
      audioUrl: json['audio_url'] as String?,
      example: json['example'] as String?,
      exampleTranslation: json['example_translation'] as String?,
      cefrLevel: json['cefr_level'] as String? ?? json['level'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      isLearned: json['is_learned'] as bool? ?? false,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'translation': translation,
        'pronunciation': pronunciation,
        'audio_url': audioUrl,
        'example': example,
        'example_translation': exampleTranslation,
        'cefr_level': cefrLevel,
        'tags': tags,
        'is_learned': isLearned,
        'note': note,
      };
}

/// Ket qua tim kiem vocabulary.
class VocabSearchResult {
  final List<VocabWord> words;
  final int totalCount;
  final int page;
  final int perPage;

  const VocabSearchResult({
    required this.words,
    required this.totalCount,
    required this.page,
    this.perPage = 20,
  });

  factory VocabSearchResult.fromJson(Map<String, dynamic> json) {
    // API tra ve { items: [], total, page, pageSize } hoac { words: [], total_count, page, per_page }
    final wordsList = json['items'] as List<dynamic>? ??
        json['words'] as List<dynamic>? ?? [];

    return VocabSearchResult(
      words: wordsList
          .map((e) => VocabWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['total'] as int? ?? json['total_count'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      perPage: json['pageSize'] as int? ?? json['per_page'] as int? ?? 20,
    );
  }
}
