/// In-memory chat/grading state for the `SprechenExamMode` partner chat +
/// bewertung (grading) panel. Not persisted directly — built from AI repo
/// responses (`POST /ai/sprechen-partner|sprechen-feedback|grade-sprechen`).
library;

enum SprechenChatRole { user, assistant }

/// One rendered chat bubble.
class SprechenChatMessage {
  const SprechenChatMessage({
    required this.role,
    required this.text,
    this.translationVi,
    this.feedbackScore,
    this.feedbackComment,
    this.pending = false,
  });

  final SprechenChatRole role;
  final String text;
  final String? translationVi;

  /// User-turn score out of 5, from `POST /ai/sprechen-feedback`.
  final int? feedbackScore;
  final String? feedbackComment;

  /// True while awaiting the AI reply (renders the bouncing-dots state).
  final bool pending;

  SprechenChatMessage copyWith({
    String? text,
    String? translationVi,
    int? feedbackScore,
    String? feedbackComment,
    bool? pending,
  }) {
    return SprechenChatMessage(
      role: role,
      text: text ?? this.text,
      translationVi: translationVi ?? this.translationVi,
      feedbackScore: feedbackScore ?? this.feedbackScore,
      feedbackComment: feedbackComment ?? this.feedbackComment,
      pending: pending ?? this.pending,
    );
  }
}

/// Per-category score breakdown from `POST /ai/grade-sprechen`. Response
/// shape is Review status (P10 matrix) — parsed defensively with 0-fallback
/// so a missing field never crashes the panel.
class SprechenGrading {
  const SprechenGrading({
    required this.total,
    required this.max,
    required this.inhalt,
    required this.grammatik,
    required this.wortschatz,
    this.mainErrors = const [],
  });

  final num total;
  final num max;
  final num inhalt;
  final num grammatik;
  final num wortschatz;
  final List<String> mainErrors;

  factory SprechenGrading.fromJson(Map<String, dynamic> json) {
    return SprechenGrading(
      total: (json['total'] as num?) ?? (json['score'] as num?) ?? 0,
      max: (json['max_score'] as num?) ?? (json['max'] as num?) ?? 25,
      inhalt: (json['inhalt'] as num?) ?? 0,
      grammatik:
          (json['grammatik'] as num?) ?? (json['grammar'] as num?) ?? 0,
      wortschatz: (json['wortschatz'] as num?) ?? 0,
      mainErrors:
          (json['main_errors'] as List<dynamic>?)?.cast<String>() ??
          const [],
    );
  }
}
