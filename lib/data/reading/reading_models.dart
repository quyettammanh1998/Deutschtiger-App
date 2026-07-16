import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// DTOs cho Reading surface (live API — `GET /api/v1/reading/*`).
///
/// Nguồn: `thamkhao/deutschtiger-backend/internal/feature/content/video/reading_handler.go`
/// (list/detail/levels) và `readingfeed/handler.go` (feed cá nhân hoá).

/// Tóm tắt một bài đọc — trả về bởi `GET /reading/articles?level=`.
class ReadingArticleSummary {
  const ReadingArticleSummary({
    required this.id,
    required this.slug,
    required this.sourceUrl,
    required this.sourceSite,
    required this.topic,
    required this.level,
    required this.title,
    required this.summary,
    this.audioUrl,
  });

  final String id;
  final String slug;
  final String sourceUrl;
  final String sourceSite;
  final String topic;
  final String level;
  final String title;
  final String summary;
  final String? audioUrl;

  factory ReadingArticleSummary.fromJson(Map<String, dynamic> json) {
    return ReadingArticleSummary(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      sourceUrl: json['source_url'] as String? ?? '',
      sourceSite: json['source_site'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      level: (json['level'] as String? ?? '').toUpperCase(),
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      audioUrl: json['audio_url'] as String?,
    );
  }
}

/// Một dòng glossary đã match được với learning item (để lưu từ vựng).
class ReadingGlossaryItem {
  const ReadingGlossaryItem({required this.wordDe, required this.learningItemId});

  final String wordDe;
  final String learningItemId;

  factory ReadingGlossaryItem.fromJson(Map<String, dynamic> json) {
    return ReadingGlossaryItem(
      wordDe: json['word_de'] as String? ?? '',
      learningItemId: json['learning_item_id'] as String? ?? '',
    );
  }
}

/// Bài đọc đầy đủ — trả về bởi `GET /reading/articles/{level}/{slug}`.
class ReadingArticle {
  const ReadingArticle({
    required this.id,
    required this.slug,
    required this.level,
    required this.title,
    required this.summary,
    required this.body,
    this.audioUrl,
    this.bodyVi,
    this.glossary = const [],
    this.glossaryItems = const [],
  });

  final String id;
  final String slug;
  final String level;
  final String title;
  final String summary;
  final String body;
  final String? audioUrl;
  final String? bodyVi;
  final List<String> glossary;
  final List<ReadingGlossaryItem> glossaryItems;

  factory ReadingArticle.fromJson(Map<String, dynamic> json) {
    return ReadingArticle(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      level: (json['level'] as String? ?? '').toUpperCase(),
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      body: json['body'] as String? ?? '',
      audioUrl: json['audio_url'] as String?,
      bodyVi: json['body_vi'] as String?,
      glossary: (json['glossary'] as List<dynamic>?)?.cast<String>() ?? const [],
      glossaryItems: (json['glossary_items'] as List<dynamic>?)
              ?.map((e) => ReadingGlossaryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  /// Tách `body` thành từng đoạn (double newline), map 1:1 với `bodyVi` khi số
  /// đoạn khớp nhau (giống logic `reading-detail-page.tsx`); nếu không khớp,
  /// bản dịch coi như không có (không đoán ghép sai).
  List<ReadingParagraph> get paragraphs {
    final de = body.split('\n\n').map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
    final viRaw = bodyVi;
    final vi = viRaw == null
        ? const <String>[]
        : viRaw.split('\n\n').map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
    final aligned = vi.length == de.length;
    return [
      for (var i = 0; i < de.length; i++)
        ReadingParagraph(de: de[i], vi: aligned ? vi[i] : ''),
    ];
  }
}

/// Một đoạn văn DE + bản dịch VI (rỗng nếu không có bản dịch khớp).
class ReadingParagraph {
  const ReadingParagraph({required this.de, required this.vi});
  final String de;
  final String vi;
}

/// Tham số điều hướng tới màn hình chi tiết bài đọc — chỉ cần level+slug để
/// gọi API; title dùng để hiển thị tạm trong lúc đang tải.
class ReadingDetailArgs {
  const ReadingDetailArgs({required this.level, required this.slug, this.title});
  final String level;
  final String slug;
  final String? title;
}

/// Mức độ phù hợp trình độ trong reading feed (xem `readingfeed/handler.go`).
enum ReadingFeedFit { ideal, accessible, challenging }

ReadingFeedFit _fitFromJson(String? raw) => switch (raw) {
      'ideal' => ReadingFeedFit.ideal,
      'accessible' => ReadingFeedFit.accessible,
      _ => ReadingFeedFit.challenging,
    };

/// Một bài đọc trong feed cá nhân hoá — trả về bởi `GET /reading-feed`.
class ReadingFeedArticle {
  const ReadingFeedArticle({
    required this.id,
    required this.slug,
    required this.title,
    required this.level,
    required this.topic,
    required this.summary,
    required this.vocabTotal,
    required this.vocabKnown,
    required this.vocabNew,
    required this.coverage,
    required this.fit,
    this.titleVi,
    this.imageUrl,
  });

  final String id;
  final String slug;
  final String title;
  final String? titleVi;
  final String level;
  final String topic;
  final String summary;
  final String? imageUrl;
  final int vocabTotal;
  final int vocabKnown;
  final int vocabNew;
  final double coverage;
  final ReadingFeedFit fit;

  factory ReadingFeedArticle.fromJson(Map<String, dynamic> json) {
    return ReadingFeedArticle(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      titleVi: json['title_vi'] as String?,
      level: (json['level'] as String? ?? '').toUpperCase(),
      topic: json['topic'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      vocabTotal: json['vocab_total'] as int? ?? 0,
      vocabKnown: json['vocab_known'] as int? ?? 0,
      vocabNew: json['vocab_new'] as int? ?? 0,
      coverage: (json['coverage'] as num?)?.toDouble() ?? 0,
      fit: _fitFromJson(json['fit'] as String?),
    );
  }
}

/// Kết quả `GET /reading-feed` — bọc kèm cờ `coverageReady` để phân biệt
/// "hệ thống chưa tính coverage" (rỗng vô hại) với "không có bài phù hợp".
class ReadingFeedResult {
  const ReadingFeedResult({required this.articles, required this.coverageReady});
  final List<ReadingFeedArticle> articles;
  final bool coverageReady;

  factory ReadingFeedResult.fromJson(dynamic json) {
    // BE có thể trả bare array (legacy) hoặc { articles, coverage_ready }.
    if (json is List) {
      return ReadingFeedResult(
        articles: json
            .map((e) => ReadingFeedArticle.fromJson(e as Map<String, dynamic>))
            .toList(),
        coverageReady: true,
      );
    }
    final map = json as Map<String, dynamic>;
    final articles = (map['articles'] as List<dynamic>?)
            ?.map((e) => ReadingFeedArticle.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];
    return ReadingFeedResult(
      articles: articles,
      coverageReady: map['coverage_ready'] as bool? ?? true,
    );
  }
}

/// Một dòng bảng xếp hạng — trả về bởi `GET /reading-leaderboard` và
/// `GET /user/reading-rank` (field khớp `ReadingLeaderboardEntry` của web).
class ReadingLeaderboardEntry {
  const ReadingLeaderboardEntry({
    required this.userId,
    required this.displayName,
    required this.avatarUrl,
    required this.completedCount,
    required this.rank,
  });

  final String userId;
  final String displayName;
  final String avatarUrl;
  final int completedCount;
  final int rank;

  factory ReadingLeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return ReadingLeaderboardEntry(
      userId: json['user_id'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      completedCount: json['completed_count'] as int? ?? 0,
      rank: json['rank'] as int? ?? 0,
    );
  }
}

/// Color mapping cho level badge — match màu web admin dashboard.
Color readingLevelColor(String level) {
  if (level.startsWith('A1')) return const Color(0xFF16A34A);
  if (level.startsWith('A2')) return const Color(0xFF0D9488);
  if (level.startsWith('B1')) return const Color(0xFF2563EB);
  if (level.startsWith('B2')) return const Color(0xFF9333EA);
  if (level.startsWith('C1')) return const Color(0xFFEA580C);
  return DesignTokens.mutedForeground;
}
