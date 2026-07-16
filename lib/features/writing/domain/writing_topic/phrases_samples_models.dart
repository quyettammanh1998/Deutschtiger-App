import 'audio_sentence.dart';

/// One `usefulPhrases[].rows[]` row (Tiếng Đức / Tiếng Việt / "Dùng khi").
class UsefulPhraseRow {
  const UsefulPhraseRow({
    required this.de,
    required this.vi,
    this.whenToUse,
    this.audioUrl,
  });

  final String de;
  final String vi;
  final String? whenToUse;
  final String? audioUrl;

  factory UsefulPhraseRow.fromJson(Map<String, dynamic> json) =>
      UsefulPhraseRow(
        de: json['de']?.toString() ?? '',
        vi: json['vi']?.toString() ?? '',
        whenToUse: json['whenToUse']?.toString(),
        audioUrl: json['audioUrl']?.toString(),
      );
}

/// One nested category inside `sec-redemittel`.
class UsefulPhraseCategory {
  const UsefulPhraseCategory({required this.category, required this.rows});

  final String category;
  final List<UsefulPhraseRow> rows;

  factory UsefulPhraseCategory.fromJson(Map<String, dynamic> json) {
    final rawRows = json['rows'];
    return UsefulPhraseCategory(
      category: json['category']?.toString() ?? '',
      rows: rawRows is List
          ? rawRows
              .whereType<Map>()
              .map((r) =>
                  UsefulPhraseRow.fromJson(Map<String, dynamic>.from(r)))
              .toList()
          : const [],
    );
  }

  static List<UsefulPhraseCategory> listFromJson(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) =>
            UsefulPhraseCategory.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

/// One `sampleSentences[]` group ("point" header + its sentences).
class SampleSentenceGroup {
  const SampleSentenceGroup({required this.point, required this.sentences});

  final String point;
  final List<AudioSentence> sentences;

  factory SampleSentenceGroup.fromJson(Map<String, dynamic> json) =>
      SampleSentenceGroup(
        point: json['point']?.toString() ?? '',
        sentences: AudioSentence.listFromJson(json['sentences']),
      );

  static List<SampleSentenceGroup> listFromJson(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) =>
            SampleSentenceGroup.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

/// One `modelAnswers[]` entry — full model essay (+ annotations).
class ModelAnswer {
  const ModelAnswer({
    required this.title,
    required this.de,
    required this.vi,
    this.wordCount,
    this.annotations = const [],
    this.audioUrl,
  });

  final String title;
  final int? wordCount;
  final String de;
  final String vi;
  final List<String> annotations;
  final String? audioUrl;

  factory ModelAnswer.fromJson(Map<String, dynamic> json) => ModelAnswer(
        title: json['title']?.toString() ?? '',
        wordCount: (json['wordCount'] as num?)?.toInt(),
        de: json['de']?.toString() ?? '',
        vi: json['vi']?.toString() ?? '',
        annotations: (json['annotations'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        audioUrl: json['audioUrl']?.toString(),
      );

  static List<ModelAnswer> listFromJson(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => ModelAnswer.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
