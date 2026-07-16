/// AI grading result models for Schreiben (writing) exam practice — web
/// parity `src/lib/exam/schreiben-ai-grading-service.ts`
/// `SchreibenGradingResult`. Backend: `POST /ai/grade-schreiben`
/// (`internal/shared/aihttp/ai_grading_handler.go`) returns this shape
/// verbatim as JSON (camelCase field names, LLM-authored — treat every
/// field as optionally missing/malformed and fall back gracefully).
library;

/// One category score inside [SchreibenGradingResult.feedback].
class GradingFeedbackCategory {
  const GradingFeedbackCategory({required this.score, required this.comment});

  final int score;
  final String comment;

  factory GradingFeedbackCategory.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const GradingFeedbackCategory(score: 0, comment: '');
    return GradingFeedbackCategory(
      score: _asInt(json['score']),
      comment: json['comment']?.toString() ?? '',
    );
  }
}

/// A grammar/spelling correction — `original -> corrected` with explanation.
class WritingCorrection {
  const WritingCorrection({
    required this.original,
    required this.corrected,
    required this.explanation,
    this.errorType,
  });

  final String original;
  final String corrected;
  final String explanation;
  final String? errorType;

  factory WritingCorrection.fromJson(Map<String, dynamic> json) {
    return WritingCorrection(
      original: json['original']?.toString() ?? '',
      corrected: json['corrected']?.toString() ?? '',
      explanation: json['explanation']?.toString() ?? '',
      errorType: json['error_type']?.toString(),
    );
  }
}

/// A stylistic suggestion — grammatically correct but a more natural phrasing.
class WritingSuggestion {
  const WritingSuggestion({
    required this.original,
    required this.natural,
    required this.vi,
    required this.why,
  });

  final String original;
  final String natural;
  final String vi;
  final String why;

  factory WritingSuggestion.fromJson(Map<String, dynamic> json) {
    return WritingSuggestion(
      original: json['original']?.toString() ?? '',
      natural: json['natural']?.toString() ?? '',
      vi: json['vi']?.toString() ?? '',
      why: json['why']?.toString() ?? '',
    );
  }
}

/// Raw Goethe rubric scores — only present for Goethe B1 exams.
class GoetheRawScores {
  const GoetheRawScores({
    required this.inhalt,
    required this.kommunikative,
    required this.formale,
    required this.teilLabel,
  });

  /// /4
  final num inhalt;

  /// /4
  final num kommunikative;

  /// /4
  final num formale;
  final String teilLabel;

  factory GoetheRawScores.fromJson(Map<String, dynamic> json) {
    return GoetheRawScores(
      inhalt: _asNum(json['inhalt']),
      kommunikative: _asNum(json['kommunikative']),
      formale: _asNum(json['formale']),
      teilLabel: json['teilLabel']?.toString() ?? '',
    );
  }
}

class SchreibenGradingResult {
  const SchreibenGradingResult({
    required this.score,
    required this.grade,
    required this.feedback,
    required this.corrections,
    required this.suggestions,
    required this.summary,
    this.goetheRaw,
    this.correctedText,
  });

  /// Overall score 0-100.
  final int score;

  /// `sehr_gut/gut/befriedigend/ausreichend/nicht_bestanden` (Goethe) or
  /// `A/B/C/D/F`.
  final String grade;
  final Map<String, GradingFeedbackCategory> feedback;
  final List<WritingCorrection> corrections;
  final List<WritingSuggestion> suggestions;
  final String summary;
  final GoetheRawScores? goetheRaw;

  /// Full corrected text — fetched lazily via the rewrite endpoint.
  final String? correctedText;

  bool get hasGoetheRaw => goetheRaw != null;

  GradingFeedbackCategory get taskCompletion =>
      feedback['taskCompletion'] ?? const GradingFeedbackCategory(score: 0, comment: '');
  GradingFeedbackCategory get grammar =>
      feedback['grammar'] ?? const GradingFeedbackCategory(score: 0, comment: '');
  GradingFeedbackCategory get vocabulary =>
      feedback['vocabulary'] ?? const GradingFeedbackCategory(score: 0, comment: '');
  GradingFeedbackCategory get coherence =>
      feedback['coherence'] ?? const GradingFeedbackCategory(score: 0, comment: '');

  factory SchreibenGradingResult.fromJson(Map<String, dynamic> json) {
    final feedbackJson = json['feedback'];
    final feedback = <String, GradingFeedbackCategory>{};
    if (feedbackJson is Map) {
      for (final entry in feedbackJson.entries) {
        if (entry.value is Map) {
          feedback[entry.key.toString()] = GradingFeedbackCategory.fromJson(
            Map<String, dynamic>.from(entry.value as Map),
          );
        }
      }
    }
    final correctionsJson = json['corrections'];
    final corrections = correctionsJson is List
        ? correctionsJson
            .whereType<Map>()
            .map((e) => WritingCorrection.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <WritingCorrection>[];
    final suggestionsJson = json['suggestions'];
    final suggestions = suggestionsJson is List
        ? suggestionsJson
            .whereType<Map>()
            .map((e) => WritingSuggestion.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <WritingSuggestion>[];
    final goetheRawJson = json['goetheRaw'];
    return SchreibenGradingResult(
      score: _asInt(json['score']),
      grade: json['grade']?.toString() ?? '',
      feedback: feedback,
      corrections: corrections,
      suggestions: suggestions,
      summary: json['summary']?.toString() ?? '',
      goetheRaw: goetheRawJson is Map
          ? GoetheRawScores.fromJson(Map<String, dynamic>.from(goetheRawJson))
          : null,
      correctedText: json['correctedText']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'score': score,
    'grade': grade,
    'feedback': {
      'taskCompletion': {'score': taskCompletion.score, 'comment': taskCompletion.comment},
      'grammar': {'score': grammar.score, 'comment': grammar.comment},
      'vocabulary': {'score': vocabulary.score, 'comment': vocabulary.comment},
      'coherence': {'score': coherence.score, 'comment': coherence.comment},
    },
    'corrections': corrections
        .map((c) => {
              'original': c.original,
              'corrected': c.corrected,
              'explanation': c.explanation,
              if (c.errorType != null) 'error_type': c.errorType,
            })
        .toList(),
    'suggestions': suggestions
        .map((s) => {'original': s.original, 'natural': s.natural, 'vi': s.vi, 'why': s.why})
        .toList(),
    'summary': summary,
    if (goetheRaw != null)
      'goetheRaw': {
        'inhalt': goetheRaw!.inhalt,
        'kommunikative': goetheRaw!.kommunikative,
        'formale': goetheRaw!.formale,
        'teilLabel': goetheRaw!.teilLabel,
      },
    if (correctedText != null) 'correctedText': correctedText,
  };

  SchreibenGradingResult copyWith({String? correctedText}) => SchreibenGradingResult(
    score: score,
    grade: grade,
    feedback: feedback,
    corrections: corrections,
    suggestions: suggestions,
    summary: summary,
    goetheRaw: goetheRaw,
    correctedText: correctedText ?? this.correctedText,
  );
}

/// Thrown when the AI grading/rewrite service is unavailable (timeout,
/// 502/503, or `{"error":"ai_unavailable"}`) — enables the retry-with-
/// cooldown UX, mirrors web `AiUnavailableError`.
class AiUnavailableException implements Exception {
  AiUnavailableException(this.message);
  final String message;

  @override
  String toString() => message;
}

int _asInt(Object? value) {
  if (value is num) return value.round();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

num _asNum(Object? value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}
