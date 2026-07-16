/// Topic-list row + full Teil payload — web parity `GoetheB1WritingTopicSummary`
/// / `GoetheB1WritingTeilData` (`src/lib/goethe-b1-writing/types.ts`). Backend:
/// `GET /goethe-b1-writing/teil/{n}` (public, no auth).
class GoetheB1WritingTopicSummary {
  const GoetheB1WritingTopicSummary({
    required this.slug,
    required this.titleDe,
    required this.titleVi,
    this.isIntro = false,
    this.difficulty,
    this.frequencyStars = 0,
    this.topicCluster,
    this.topicKeywords = const [],
    this.durationMin,
  });

  final String slug;
  final bool isIntro;
  final String titleDe;
  final String titleVi;

  /// `easy` | `medium` | `hard`.
  final String? difficulty;
  final int frequencyStars;
  final String? topicCluster;
  final List<String> topicKeywords;
  final int? durationMin;

  factory GoetheB1WritingTopicSummary.fromJson(Map<String, dynamic> json) {
    return GoetheB1WritingTopicSummary(
      slug: json['slug']?.toString() ?? '',
      titleDe: json['titleDe']?.toString() ?? '',
      titleVi: json['titleVi']?.toString() ?? '',
      isIntro: json['isIntro'] == true,
      difficulty: json['difficulty']?.toString(),
      frequencyStars: (json['frequencyStars'] as num?)?.toInt() ?? 0,
      topicCluster: json['topicCluster']?.toString(),
      topicKeywords: (json['topicKeywords'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      durationMin: (json['durationMin'] as num?)?.toInt(),
    );
  }
}

/// One Teil's full topic list — `GET /goethe-b1-writing/teil/{n}` response.
class GoetheB1WritingTeilData {
  const GoetheB1WritingTeilData({
    required this.teil,
    required this.titleVi,
    required this.topics,
  });

  final int teil;
  final String titleVi;
  final List<GoetheB1WritingTopicSummary> topics;

  factory GoetheB1WritingTeilData.fromJson(Map<String, dynamic> json) {
    final rawTopics = json['topics'];
    return GoetheB1WritingTeilData(
      teil: (json['teil'] as num?)?.toInt() ?? 0,
      titleVi: json['titleVi']?.toString() ?? '',
      topics: rawTopics is List
          ? rawTopics
              .whereType<Map>()
              .map((t) => GoetheB1WritingTopicSummary.fromJson(
                    Map<String, dynamic>.from(t),
                  ))
              .toList()
          : const [],
    );
  }
}
