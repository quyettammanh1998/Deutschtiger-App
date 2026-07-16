/// Goethe B1 writing manifest — web parity `GoetheB1WritingManifest`
/// (`src/lib/goethe-b1-writing/types.ts`). Backend:
/// `GET /goethe-b1-writing/manifest` (public, no auth) — a lightweight
/// per-teil topic-title index used by the teil-pick page; the full topic
/// list/detail (W2) reads `GET /goethe-b1-writing/teil/{n}` /
/// `.../topic/{n}/{slug}` instead.
class GoetheB1WritingManifestTeil {
  const GoetheB1WritingManifestTeil({
    required this.teil,
    required this.titleVi,
    required this.topicCount,
  });

  final int teil;
  final String titleVi;

  /// Count of non-intro topics (web: `topics.filter(t => !t.isIntro).length`).
  final int topicCount;

  factory GoetheB1WritingManifestTeil.fromJson(Map<String, dynamic> json) {
    final topics = json['topics'];
    final count = topics is List
        ? topics.whereType<Map>().where((t) => t['isIntro'] != true).length
        : 0;
    return GoetheB1WritingManifestTeil(
      teil: json['teil'] is num ? (json['teil'] as num).toInt() : 0,
      titleVi: json['titleVi']?.toString() ?? '',
      topicCount: count,
    );
  }
}

class GoetheB1WritingManifest {
  const GoetheB1WritingManifest({required this.teils});

  final List<GoetheB1WritingManifestTeil> teils;

  int get totalTopics => teils.fold(0, (sum, t) => sum + t.topicCount);

  factory GoetheB1WritingManifest.fromJson(Map<String, dynamic> json) {
    final teils = json['teils'];
    return GoetheB1WritingManifest(
      teils: teils is List
          ? teils
              .whereType<Map>()
              .map((t) => GoetheB1WritingManifestTeil.fromJson(Map<String, dynamic>.from(t)))
              .toList()
          : const [],
    );
  }
}

/// One saved result row — web parity `goethe-b1-writing-result-service.ts`
/// list item. Backend: `GET /user/goethe-b1-writing-results`. Only the
/// fields the teil-pick "done/total" progress bar needs are kept.
class GoetheB1WritingResult {
  const GoetheB1WritingResult({required this.teil, required this.slug});

  final int teil;
  final String slug;

  factory GoetheB1WritingResult.fromJson(Map<String, dynamic> json) {
    return GoetheB1WritingResult(
      teil: json['teil'] is num ? (json['teil'] as num).toInt() : 0,
      slug: json['slug']?.toString() ?? '',
    );
  }
}
