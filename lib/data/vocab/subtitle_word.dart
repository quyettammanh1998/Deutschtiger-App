/// Một từ tiếng Đức người dùng đã gặp trong phụ đề video, chưa nằm trong
/// hàng đợi ôn tập hoặc flashcard — map từ `GET /api/v1/subtitle-words`.
class SubtitleWord {
  const SubtitleWord({
    required this.learningItemId,
    required this.contentDe,
    required this.contentVi,
    this.ipa,
    this.level,
    this.wordType,
    this.audioUrl,
    this.seenCount = 0,
  });

  final String learningItemId;
  final String contentDe;
  final String contentVi;
  final String? ipa;
  final String? level;
  final String? wordType;
  final String? audioUrl;
  final int seenCount;

  factory SubtitleWord.fromJson(Map<String, dynamic> json) {
    return SubtitleWord(
      learningItemId: json['learning_item_id'] as String? ?? '',
      contentDe: json['content_de'] as String? ?? '',
      contentVi: json['content_vi'] as String? ?? '',
      ipa: json['ipa'] as String?,
      level: json['level'] as String?,
      wordType: json['word_type'] as String?,
      audioUrl: json['audio_url'] as String?,
      seenCount: (json['seen_count'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Kết quả `POST /api/v1/subtitle-words/add`.
class AddSubtitleWordsResult {
  const AddSubtitleWordsResult({required this.added});

  final int added;

  factory AddSubtitleWordsResult.fromJson(Map<String, dynamic> json) {
    return AddSubtitleWordsResult(added: (json['added'] as num?)?.toInt() ?? 0);
  }
}
