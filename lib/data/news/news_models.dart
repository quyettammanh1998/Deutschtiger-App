/// DTOs cho News surface (live API — `GET/POST /api/v1/news*`,
/// `/api/v1/user/news-progress`, `/api/v1/user/news-week-stats`).
///
/// Nguồn: `thamkhao/deutschtiger-backend/internal/feature/content/video/news_handler.go`
/// (list/story/topics) và `newsprogress/news_progress_handler.go` (progress + week
/// stats). Field names khớp 1:1 với `deutschtiger-frontend/src/lib/news/news-service.ts`
/// để tránh đoán schema. Không dùng freezed/json_serializable (build_runner race
/// với các agent khác đang chạy song song) — parse tay bằng `fromJson`.
library;

/// Một mục từ vựng trong bài (`vocab[]`).
class NewsVocab {
  const NewsVocab({
    required this.wordDe,
    required this.meaningVi,
    required this.exampleDe,
    this.learningItemId,
  });

  final String wordDe;
  final String meaningVi;
  final String exampleDe;

  /// Có mặt khi `word_de` khớp được với 1 từ trong catalog vocabulary — cho
  /// phép app hiển thị nút "lưu từ". Vắng mặt nghĩa là không khớp.
  final String? learningItemId;

  factory NewsVocab.fromJson(Map<String, dynamic> json) {
    return NewsVocab(
      wordDe: json['word_de'] as String? ?? '',
      meaningVi: json['meaning_vi'] as String? ?? '',
      exampleDe: json['example_de'] as String? ?? '',
      learningItemId: json['learning_item_id'] as String?,
    );
  }
}

/// Một câu hỏi trắc nghiệm cuối bài (`quiz[]`).
class NewsQuiz {
  const NewsQuiz({
    required this.question,
    required this.options,
    required this.correct,
    required this.explanationVi,
  });

  final String question;
  final List<String> options;
  final int correct;
  final String explanationVi;

  factory NewsQuiz.fromJson(Map<String, dynamic> json) {
    return NewsQuiz(
      question: json['question'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)?.cast<String>() ?? const [],
      correct: json['correct'] as int? ?? -1,
      explanationVi: json['explanation_vi'] as String? ?? '',
    );
  }
}

/// Một cặp câu DE→VI dóng hàng (tap-to-reveal), trong `sentences[]`.
class NewsSentence {
  const NewsSentence({required this.de, required this.vi});
  final String de;
  final String vi;

  factory NewsSentence.fromJson(Map<String, dynamic> json) {
    return NewsSentence(
      de: json['de'] as String? ?? '',
      vi: json['vi'] as String? ?? '',
    );
  }
}

/// Thẻ tóm tắt 1 bài — trả về bởi `GET /news/today` và `GET /news/list`.
class NewsStorySummary {
  const NewsStorySummary({
    required this.storyGroupId,
    required this.slug,
    required this.topic,
    required this.title,
    required this.summary,
    required this.level,
    required this.levelsAvailable,
    this.titleVi,
    this.imageUrl,
    this.audioUrl,
    this.publishedAt,
  });

  final String storyGroupId;
  final String slug;
  final String topic;
  final String title;
  final String? titleVi;
  final String summary;
  final String level;
  final List<String> levelsAvailable;
  final String? imageUrl;
  final String? audioUrl;
  final String? publishedAt;

  factory NewsStorySummary.fromJson(Map<String, dynamic> json) {
    return NewsStorySummary(
      storyGroupId: json['story_group_id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      title: json['title'] as String? ?? '',
      titleVi: json['title_vi'] as String?,
      summary: json['summary'] as String? ?? '',
      level: (json['level'] as String? ?? '').toUpperCase(),
      levelsAvailable:
          (json['levels_available'] as List<dynamic>?)?.cast<String>() ??
              const [],
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      publishedAt: json['published_at'] as String?,
    );
  }
}

/// Bài đầy đủ cho 1 CEFR level — 1 phần tử của `levels[]`
/// (`GET /news/story-by-slug/{slug}`, `GET /news/story/{groupId}`).
class NewsLevelArticle {
  const NewsLevelArticle({
    required this.id,
    required this.storyGroupId,
    required this.slug,
    required this.topic,
    required this.level,
    required this.title,
    required this.summary,
    required this.body,
    this.sourceUrl,
    this.titleVi,
    this.imageUrl,
    this.sentences = const [],
    this.vocab = const [],
    this.quiz = const [],
    this.audioUrl,
    this.audioUrlSlow,
    this.attribution,
    this.publishedAt,
    this.examSpeakingPrompt,
    this.examWritingPrompt,
  });

  final String id;
  final String storyGroupId;
  final String slug;
  final String? sourceUrl;
  final String topic;
  final String level;
  final String title;
  final String? titleVi;
  final String summary;
  final String body;
  final String? imageUrl;
  final List<NewsSentence> sentences;
  final List<NewsVocab> vocab;
  final List<NewsQuiz> quiz;
  final String? audioUrl;
  final String? audioUrlSlow;
  final String? attribution;
  final String? publishedAt;
  final String? examSpeakingPrompt;
  final String? examWritingPrompt;

  factory NewsLevelArticle.fromJson(Map<String, dynamic> json) {
    return NewsLevelArticle(
      id: json['id'] as String? ?? '',
      storyGroupId: json['story_group_id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      sourceUrl: json['source_url'] as String?,
      topic: json['topic'] as String? ?? '',
      level: (json['level'] as String? ?? '').toUpperCase(),
      title: json['title'] as String? ?? '',
      titleVi: json['title_vi'] as String?,
      summary: json['summary'] as String? ?? '',
      body: json['body'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      sentences: (json['sentences'] as List<dynamic>?)
              ?.map((e) => NewsSentence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      vocab: (json['vocab'] as List<dynamic>?)
              ?.map((e) => NewsVocab.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      quiz: (json['quiz'] as List<dynamic>?)
              ?.map((e) => NewsQuiz.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      audioUrl: json['audio_url'] as String?,
      audioUrlSlow: json['audio_url_slow'] as String?,
      attribution: json['attribution'] as String?,
      publishedAt: json['published_at'] as String?,
      examSpeakingPrompt: json['exam_speaking_prompt'] as String?,
      examWritingPrompt: json['exam_writing_prompt'] as String?,
    );
  }

  /// Tách `body` thành đoạn văn (double newline) khi bài không có
  /// `sentences[]` (fallback hiển thị — giống `news-detail-page.tsx`).
  List<String> get paragraphs => body
      .split('\n\n')
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();
}

/// Kết quả `GET /news/list` — 1 trang của kho lưu trữ tin tức.
class NewsListResult {
  const NewsListResult({
    required this.stories,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<NewsStorySummary> stories;
  final int total;
  final int page;
  final int pageSize;

  factory NewsListResult.fromJson(Map<String, dynamic> json) {
    final stories = json['stories'] as List<dynamic>? ?? [];
    return NewsListResult(
      stories: stories
          .map((e) => NewsStorySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 10,
    );
  }
}

/// Tiến độ tuần cá nhân (`GET /user/news-week-stats`): số bài xuất bản trong
/// tuần vs. số bài user đã hoàn thành.
class NewsWeekStats {
  const NewsWeekStats({
    required this.publishedThisWeek,
    required this.myCompletedThisWeek,
  });

  final int publishedThisWeek;
  final int myCompletedThisWeek;

  factory NewsWeekStats.fromJson(Map<String, dynamic> json) {
    return NewsWeekStats(
      publishedThisWeek: json['published_this_week'] as int? ?? 0,
      myCompletedThisWeek: json['my_completed_this_week'] as int? ?? 0,
    );
  }
}

/// Một dòng bảng xếp hạng tuần — trả về bởi `GET /news-leaderboard` và
/// `GET /user/news-rank`.
class NewsLeaderboardEntry {
  const NewsLeaderboardEntry({
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

  factory NewsLeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return NewsLeaderboardEntry(
      userId: json['user_id'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      completedCount: json['completed_count'] as int? ?? 0,
      rank: json['rank'] as int? ?? 0,
    );
  }
}

/// Tham số điều hướng tới màn chi tiết — chỉ cần `slug`; `level` là gợi ý mở
/// bài ở trình độ nào (carried từ danh sách qua query `?level=`, giống web).
class NewsDetailArgs {
  const NewsDetailArgs({required this.slug, this.level, this.title});
  final String slug;
  final String? level;
  final String? title;
}
