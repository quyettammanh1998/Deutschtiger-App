/// `sources[]` entry inside [ProvenanceCard] — web parity
/// `GoetheB1WritingSource`.
class WritingSource {
  const WritingSource({required this.label, this.url, this.type});

  final String label;
  final String? url;

  /// `gdocs` | `link` | other — drives the leading icon.
  final String? type;

  factory WritingSource.fromJson(Map<String, dynamic> json) => WritingSource(
        label: json['label']?.toString() ?? '',
        url: json['url']?.toString(),
        type: json['type']?.toString(),
      );

  static List<WritingSource> listFromJson(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => WritingSource.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

class TaskWordCount {
  const TaskWordCount({required this.min, required this.target, required this.max});

  final int min;
  final int target;
  final int max;

  factory TaskWordCount.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TaskWordCount(min: 0, target: 0, max: 0);
    return TaskWordCount(
      min: (json['min'] as num?)?.toInt() ?? 0,
      target: (json['target'] as num?)?.toInt() ?? 0,
      max: (json['max'] as num?)?.toInt() ?? 0,
    );
  }
}
