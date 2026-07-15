/// Model cho một deck (bộ từ tự tạo).
class Deck {
  final String id;
  final String name;
  final String? description;
  final String? coverColor;
  final int wordCount;
  final int learnedCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Deck({
    required this.id,
    required this.name,
    this.description,
    this.coverColor,
    this.wordCount = 0,
    this.learnedCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      coverColor: json['cover_color'] as String?,
      wordCount: json['word_count'] as int? ?? 0,
      learnedCount: json['learned_count'] as int? ?? 0,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'cover_color': coverColor,
    'word_count': wordCount,
    'learned_count': learnedCount,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

/// Word trong deck.
class DeckWord {
  final String id;
  final String wordId;
  final String word;
  final String translation;
  final String? pronunciation;
  final String? example;
  final bool isLearned;
  final DateTime addedAt;

  const DeckWord({
    required this.id,
    required this.wordId,
    required this.word,
    required this.translation,
    this.pronunciation,
    this.example,
    this.isLearned = false,
    required this.addedAt,
  });

  factory DeckWord.fromJson(Map<String, dynamic> json) {
    return DeckWord(
      id: json['id'] as String? ?? '',
      wordId: json['learning_item_id'] as String? ?? '',
      word: json['word_de'] as String? ?? json['word'] as String? ?? '',
      translation:
          json['word_vi'] as String? ?? json['translation'] as String? ?? '',
      pronunciation: json['ipa'] as String? ?? json['pronunciation'] as String?,
      example:
          json['example_sentence'] as String? ?? json['example'] as String?,
      isLearned: json['is_learned'] as bool? ?? false,
      addedAt:
          DateTime.tryParse(
            json['created_at'] as String? ?? json['added_at'] as String? ?? '',
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'word_id': wordId,
    'word': word,
    'translation': translation,
    'pronunciation': pronunciation,
    'example': example,
    'is_learned': isLearned,
    'added_at': addedAt.toIso8601String(),
  };
}
