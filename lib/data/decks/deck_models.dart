/// Model cho một deck (bộ từ tự tạo). Web parity: `FlashcardDeck`
/// (`thamkhao/deutschtiger-frontend/src/types/flashcard/index.ts`) — the
/// live contract has NO `word_count`/`cover_color`/`learned_count`; those
/// derive client-side from [DeckSummaryRow] (mastery) and the cards list.
class Deck {
  final String id;
  final String name;
  final String? description;
  final String? folderId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Deck({
    required this.id,
    required this.name,
    this.description,
    this.folderId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: (json['description'] as String?)?.trim().isEmpty ?? true
          ? null
          : json['description'] as String?,
      folderId: json['folder_id'] as String?,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }
}

/// Web parity: `FlashcardFolder`.
class DeckFolder {
  final String id;
  final String name;
  final String? color;
  final String? parentId;
  final int sortOrder;
  final int deckCount;
  final int subfolderCount;

  const DeckFolder({
    required this.id,
    required this.name,
    this.color,
    this.parentId,
    this.sortOrder = 0,
    this.deckCount = 0,
    this.subfolderCount = 0,
  });

  factory DeckFolder.fromJson(Map<String, dynamic> json) {
    return DeckFolder(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      color: json['color'] as String?,
      parentId: json['parent_id'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      deckCount: (json['deck_count'] as num?)?.toInt() ?? 0,
      subfolderCount: (json['subfolder_count'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Word/card trong deck. Web parity: `Flashcard` type — field names below
/// map 1:1 to the live `/user/flashcard-decks/{id}/cards` response
/// (`word_de`/`word_vi`/`example_sentence*`/`is_starred`/`audio_url`).
class DeckWord {
  final String id;
  final String deckId;
  final String wordId;
  final String word;
  final String translation;
  final String? pronunciation;
  final String? example;
  final String? exampleTranslation;
  final String? audioUrl;
  final String? imageUrl;
  final bool isStarred;
  final bool isLearned;
  final int sortOrder;
  final String? deckName;
  final DateTime addedAt;

  const DeckWord({
    required this.id,
    this.deckId = '',
    required this.wordId,
    required this.word,
    required this.translation,
    this.pronunciation,
    this.example,
    this.exampleTranslation,
    this.audioUrl,
    this.imageUrl,
    this.isStarred = false,
    this.isLearned = false,
    this.sortOrder = 0,
    this.deckName,
    required this.addedAt,
  });

  factory DeckWord.fromJson(Map<String, dynamic> json) {
    return DeckWord(
      id: json['id'] as String? ?? '',
      deckId: json['deck_id'] as String? ?? '',
      wordId: json['learning_item_id'] as String? ?? json['id'] as String? ?? '',
      word: json['word_de'] as String? ?? json['word'] as String? ?? '',
      translation:
          json['word_vi'] as String? ?? json['translation'] as String? ?? '',
      pronunciation: json['ipa'] as String? ?? json['pronunciation'] as String?,
      example:
          json['example_sentence'] as String? ?? json['example'] as String?,
      exampleTranslation: json['example_sentence_vi'] as String?,
      audioUrl: json['audio_url'] as String?,
      imageUrl: json['image_url'] as String?,
      isStarred: json['is_starred'] as bool? ?? false,
      isLearned: json['is_learned'] as bool? ?? false,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      deckName: json['deck_name'] as String?,
      addedAt:
          DateTime.tryParse(
            json['created_at'] as String? ?? json['added_at'] as String? ?? '',
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }
}

/// Per-deck SM-2 mastery counts. Web parity: `DeckSummaryRow`
/// (`/user/flashcard-reviews/deck-summary`).
class DeckSummaryRow {
  final String deckId;
  final int total;
  final int due;
  final int newCount;
  final int learning;
  final int known;
  final int mastered;

  const DeckSummaryRow({
    required this.deckId,
    this.total = 0,
    this.due = 0,
    this.newCount = 0,
    this.learning = 0,
    this.known = 0,
    this.mastered = 0,
  });

  factory DeckSummaryRow.fromJson(Map<String, dynamic> json) {
    return DeckSummaryRow(
      deckId: json['deck_id'] as String? ?? '',
      total: (json['total'] as num?)?.toInt() ?? 0,
      due: (json['due'] as num?)?.toInt() ?? 0,
      newCount: (json['new'] as num?)?.toInt() ?? 0,
      learning: (json['learning'] as num?)?.toInt() ?? 0,
      known: (json['known'] as num?)?.toInt() ?? 0,
      mastered: (json['mastered'] as num?)?.toInt() ?? 0,
    );
  }

  /// Web parity: `learning*0.3 + known*0.7 + mastered) / total`.
  int get percentMastered {
    if (total == 0) return 0;
    return ((learning * 0.3 + known * 0.7 + mastered) / total * 100).round();
  }
}
