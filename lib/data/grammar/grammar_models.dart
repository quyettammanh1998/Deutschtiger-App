/// DTOs cho Grammar surface. Backend trả JSON thô (Go `map[string]any`), nên
/// các model ở đây parse phòng thủ (field thiếu/null không được throw).
library;

/// 1 exercise trắc nghiệm trong nội dung bài học.
class GrammarExercise {
  const GrammarExercise({
    required this.question,
    required this.answer,
    this.explanation,
  });

  final String question;
  final String answer;
  final String? explanation;

  factory GrammarExercise.fromJson(Map<String, dynamic> json) {
    return GrammarExercise(
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      explanation: json['explanation'] as String?,
    );
  }
}

/// Union các dạng block nội dung bài học (text / bullet list / bảng /
/// exercises / ảnh). Khớp với `GrammarContentBlock` bên web.
sealed class GrammarContentBlock {
  const GrammarContentBlock();

  factory GrammarContentBlock.fromJson(Map<String, dynamic> json) {
    if (json['image'] is String) {
      return GrammarImageBlock(
        image: json['image'] as String,
        alt: json['alt'] as String?,
      );
    }
    if (json['text'] is String) {
      return GrammarTextBlock(json['text'] as String);
    }
    final arr1 = json['arr_1'];
    if (arr1 is List) {
      return GrammarListBlock(arr1.map((e) => e.toString()).toList());
    }
    final arr2 = json['arr_2'];
    if (arr2 is List) {
      return GrammarTableBlock(
        arr2
            .whereType<List<dynamic>>()
            .map((row) => row.map((cell) => cell.toString()).toList())
            .toList(),
      );
    }
    final exercises = json['exercises'];
    if (exercises is List) {
      return GrammarExercisesBlock(
        exercises
            .whereType<Map<String, dynamic>>()
            .map(GrammarExercise.fromJson)
            .where((e) => e.question.isNotEmpty && e.answer.isNotEmpty)
            .toList(),
      );
    }
    return const GrammarUnknownBlock();
  }
}

class GrammarTextBlock extends GrammarContentBlock {
  const GrammarTextBlock(this.text);
  final String text;
}

class GrammarListBlock extends GrammarContentBlock {
  const GrammarListBlock(this.items);
  final List<String> items;
}

class GrammarTableBlock extends GrammarContentBlock {
  const GrammarTableBlock(this.rows);
  final List<List<String>> rows;
}

class GrammarExercisesBlock extends GrammarContentBlock {
  const GrammarExercisesBlock(this.exercises);
  final List<GrammarExercise> exercises;
}

class GrammarImageBlock extends GrammarContentBlock {
  const GrammarImageBlock({required this.image, this.alt});
  final String image;
  final String? alt;
}

/// Block không nhận dạng được — bỏ qua khi render, không throw.
class GrammarUnknownBlock extends GrammarContentBlock {
  const GrammarUnknownBlock();
}

/// Tóm tắt 1 bài học trong index (`GET /grammar`) — nhẹ, không có `contents`.
class GrammarLessonSummary {
  const GrammarLessonSummary({
    required this.id,
    required this.title,
    required this.level,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String level;
  final List<String> tags;

  factory GrammarLessonSummary.fromJson(Map<String, dynamic> json) {
    return GrammarLessonSummary(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      level: (json['level'] as String? ?? 'A1').toUpperCase(),
      tags: (json['tag'] as List<dynamic>?)?.whereType<String>().toList() ??
          const [],
    );
  }
}

/// Bài học ngữ pháp đầy đủ (`GET /grammar/{level}/{id}`).
class GrammarLesson {
  const GrammarLesson({
    required this.id,
    required this.title,
    required this.level,
    this.sourceId,
    this.tags = const [],
    this.contents = const [],
    this.related = const [],
    this.language,
    this.type,
  });

  final String id;
  final int? sourceId;
  final String title;
  final String level;
  final List<String> tags;
  final List<GrammarContentBlock> contents;
  final List<String> related;
  final String? language;
  final String? type;

  factory GrammarLesson.fromJson(Map<String, dynamic> json) {
    final rawId = json['_id'] ?? json['id'];
    final rawSourceId = json['id'];
    return GrammarLesson(
      id: (rawId ?? '').toString(),
      sourceId:
          rawSourceId is int ? rawSourceId : int.tryParse('$rawSourceId'),
      title: json['title'] as String? ?? '',
      level: (json['level'] as String? ?? 'A1').toUpperCase(),
      tags: (json['tag'] as List<dynamic>?)?.whereType<String>().toList() ??
          const [],
      contents: (json['contents'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(GrammarContentBlock.fromJson)
              .toList() ??
          const [],
      related: _normalizeRelated(json['related']),
      language: json['language'] as String?,
      type: json['type'] as String?,
    );
  }

  static List<String> _normalizeRelated(Object? related) {
    if (related == null) return const [];
    if (related is List) return related.map((e) => e.toString()).toList();
    return [related.toString()];
  }
}

/// Metadata 1 bài đọc (article) — từ `articles/index.json`.
class GrammarArticleMeta {
  const GrammarArticleMeta({
    required this.title,
    required this.level,
    required this.slug,
    this.source,
  });

  final String title;
  final String level;
  final String slug;
  final String? source;

  factory GrammarArticleMeta.fromJson(Map<String, dynamic> json) {
    return GrammarArticleMeta(
      title: json['title'] as String? ?? '',
      level: json['level'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      source: json['source'] as String?,
    );
  }

  /// Progress key dùng chung với lesson (`ARTICLE_ID_PREFIX` bên web).
  String get progressId => 'article:$slug';
}

/// 1 bài đọc đầy đủ (markdown), fetch từ file tĩnh `.md` + frontmatter.
class GrammarArticle extends GrammarArticleMeta {
  const GrammarArticle({
    required super.title,
    required super.level,
    required super.slug,
    super.source,
    required this.markdown,
  });

  final String markdown;
}
