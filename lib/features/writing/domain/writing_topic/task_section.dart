import 'audio_sentence.dart';

/// `sec-aufgabe` payload — web parity `GoetheB1WritingTopic.task`.
class WritingTask {
  const WritingTask({required this.de, required this.vi, this.audioUrl});

  final String de;
  final String vi;
  final String? audioUrl;

  factory WritingTask.fromJson(Map<String, dynamic> json) => WritingTask(
        de: json['de']?.toString() ?? '',
        vi: json['vi']?.toString() ?? '',
        audioUrl: json['audioUrl']?.toString(),
      );
}

/// One `taskAnalysis.points[]` entry, with optional subpoints (Teil 2
/// Vorteile/Nachteile aspects) and approaches (Teil 2 development strategies).
class TaskAnalysisPoint {
  const TaskAnalysisPoint({
    required this.de,
    required this.vi,
    this.audioUrl,
    this.subpoints = const [],
    this.approaches = const [],
  });

  final String de;
  final String vi;
  final String? audioUrl;
  final List<AudioSentence> subpoints;
  final List<AudioSentence> approaches;

  factory TaskAnalysisPoint.fromJson(Map<String, dynamic> json) =>
      TaskAnalysisPoint(
        de: json['de']?.toString() ?? '',
        vi: json['vi']?.toString() ?? '',
        audioUrl: json['audioUrl']?.toString(),
        subpoints: AudioSentence.listFromJson(json['subpoints']),
        approaches: AudioSentence.listFromJson(json['approaches']),
      );
}

/// `sec-task-analysis` payload — web parity `GoetheB1WritingTopic.taskAnalysis`.
class TaskAnalysis {
  const TaskAnalysis({this.summaryVi = '', this.points = const []});

  final String summaryVi;
  final List<TaskAnalysisPoint> points;

  factory TaskAnalysis.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['points'];
    return TaskAnalysis(
      summaryVi: json['summaryVi']?.toString() ?? '',
      points: rawPoints is List
          ? rawPoints
              .whereType<Map>()
              .map((p) =>
                  TaskAnalysisPoint.fromJson(Map<String, dynamic>.from(p)))
              .toList()
          : const [],
    );
  }
}

/// One row in the (no-TOC-entry) `TextStructureCard` table.
class TextStructureRow {
  const TextStructureRow({
    required this.part,
    required this.de,
    required this.vi,
    this.tip,
    this.audioUrl,
  });

  final String part;
  final String de;
  final String vi;
  final String? tip;
  final String? audioUrl;

  factory TextStructureRow.fromJson(Map<String, dynamic> json) =>
      TextStructureRow(
        part: json['part']?.toString() ?? '',
        de: json['de']?.toString() ?? '',
        vi: json['vi']?.toString() ?? '',
        tip: json['tip']?.toString(),
        audioUrl: json['audioUrl']?.toString(),
      );

  static List<TextStructureRow> listFromJson(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => TextStructureRow.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
