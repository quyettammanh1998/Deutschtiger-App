enum MyWordsFilter { saved, seen, reviewing }

extension MyWordsFilterApiValue on MyWordsFilter {
  String get apiValue => name;
}

class MyWord {
  const MyWord({
    required this.learningItemId,
    required this.contentDe,
    required this.contentVi,
    required this.status,
    this.level,
    this.source,
    this.lastContext,
    this.seenCount,
    this.state,
    this.due,
  });

  final String learningItemId;
  final String contentDe;
  final String contentVi;
  final String status;
  final String? level;
  final String? source;
  final String? lastContext;
  final int? seenCount;
  final int? state;
  final DateTime? due;

  factory MyWord.fromJson(Map<String, dynamic> json) => MyWord(
    learningItemId: json['learning_item_id'] as String? ?? '',
    contentDe: json['content_de'] as String? ?? '',
    contentVi: json['content_vi'] as String? ?? '',
    status: json['status'] as String? ?? '',
    level: json['level'] as String?,
    source: json['source'] as String?,
    lastContext: json['last_context'] as String?,
    seenCount: (json['seen_count'] as num?)?.toInt(),
    state: (json['state'] as num?)?.toInt(),
    due: DateTime.tryParse(json['due'] as String? ?? ''),
  );
}

class MyWordsPage {
  const MyWordsPage({
    required this.words,
    required this.total,
    required this.limit,
    required this.offset,
  });

  final List<MyWord> words;
  final int total;
  final int limit;
  final int offset;
}
