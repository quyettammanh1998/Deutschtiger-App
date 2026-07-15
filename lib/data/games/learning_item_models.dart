/// Plain Dart models cho Learning Item — subset mirrors backend
/// `internal/infra/database.LearningItem` / web `src/types/learning-item`.
/// Chỉ giữ field cần cho Artikel/Wortstellung/Fill-blank (YAGNI) — không port
/// toàn bộ shape (conjugation, adjective forms, v.v. không dùng ở 3 game này).
/// Không dùng freezed/json_serializable — tránh race build_runner với các
/// domain khác đang chạy song song.
library;

/// Câu ví dụ đính kèm 1 learning item — dùng cho Fill-blank (cloze sentence).
class LearningItemExample {
  const LearningItemExample({required this.de, this.vi, this.cloze});

  final String de;
  final String? vi;
  final String? cloze;

  factory LearningItemExample.fromJson(Map<String, dynamic> json) =>
      LearningItemExample(
        de: json['de'] as String? ?? '',
        vi: json['vi'] as String?,
        cloze: json['cloze'] as String?,
      );
}

/// `GET /user/learning-items/balanced` item — dùng chung cho Artikel
/// (`type=word` + `gender`), Wortstellung (`type=sentence`) và Fill-blank
/// (`type=word` + `examples`).
class LearningItem {
  const LearningItem({
    required this.id,
    required this.type,
    required this.contentDe,
    this.contentVi,
    this.category = '',
    this.level,
    this.gender,
    this.examples = const [],
  });

  final String id;
  final String type;
  final String contentDe;
  final String? contentVi;
  final String category;
  final String? level;

  /// `m` | `f` | `n` — chỉ có ở `type=word` là danh từ.
  final String? gender;
  final List<LearningItemExample> examples;

  factory LearningItem.fromJson(Map<String, dynamic> json) {
    final rawExamples = json['examples'];
    return LearningItem(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'word',
      contentDe: json['content_de'] as String? ?? '',
      contentVi: json['content_vi'] as String?,
      category: json['category'] as String? ?? '',
      level: json['level'] as String?,
      gender: json['gender'] as String?,
      examples: rawExamples is List
          ? rawExamples
              .whereType<Map<String, dynamic>>()
              .map(LearningItemExample.fromJson)
              .toList(growable: false)
          : const [],
    );
  }
}
