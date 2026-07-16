/// DTOs for the Sprechen (speaking exam) catalog surface — live API.
///
/// Source: `GET /sprechen/{teil}/topics`, `GET /sprechen/{teil}/tags`,
/// `GET /exams/official/sprechen-content?id=`.
/// See `docs/flutter-api-contract-matrix.md` §"Speech ecosystem" (P10).
library;

/// One topic entry from `GET /sprechen/{teil}/topics`.
class SprechenTopic {
  const SprechenTopic({
    required this.slug,
    required this.isPremium,
    required this.order,
    required this.tag,
  });

  final String slug;
  final bool isPremium;
  final int order;
  final String tag;

  factory SprechenTopic.fromJson(Map<String, dynamic> json) {
    return SprechenTopic(
      slug: json['slug'] as String? ?? '',
      isPremium: json['is_premium'] as bool? ?? false,
      order: (json['order'] as num?)?.toInt() ?? 0,
      tag: json['tag'] as String? ?? '',
    );
  }
}

/// One tag/group entry from `GET /sprechen/{teil}/tags`.
class SprechenTag {
  const SprechenTag({
    required this.id,
    required this.label,
    required this.emoji,
    required this.order,
  });

  final String id;
  final String label;
  final String emoji;
  final int order;

  factory SprechenTag.fromJson(Map<String, dynamic> json) {
    return SprechenTag(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Response from `GET /exams/official/sprechen-content?id=`.
/// `locked=true` when the topic is premium and the user isn't entitled —
/// this is a valid render state, not an error.
class SprechenContent {
  const SprechenContent({required this.markdown, required this.locked});

  final String markdown;
  final bool locked;

  factory SprechenContent.fromJson(Map<String, dynamic> json) {
    return SprechenContent(
      markdown: json['markdown'] as String? ?? '',
      locked: json['locked'] as bool? ?? false,
    );
  }
}

/// Well-known teil segment ids used across sprechen routes/UI.
abstract final class SprechenTeil {
  static const goetheTeil1 = 'goethe-teil1';
  static const goetheTeil2 = 'goethe-teil2';
  static const goetheTeil3 = 'goethe-teil3';
  static const telcTeil1 = 'telc-teil1';
  static const telcTeil2 = 'telc-teil2';
  static const telcTeil3 = 'telc-teil3';
}
