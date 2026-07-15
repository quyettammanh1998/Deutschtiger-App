/// Writing-practice models. This feature has no confirmed backend contract
/// yet (Schreiben grading is a separate, later phase — see
/// `docs/api-changelog.md`), so `AIWritingMockRepository` in `mock_data.dart`
/// still backs it. Live AI chat/sessions/memory/profile models live in
/// `ai_chat_live_models.dart`.
library;

/// Writing practice exercise
class WritingPractice {
  final String id;
  final String title;
  final String titleVi;
  final String prompt;
  final String promptVi;
  final int wordLimit;
  final String userText;
  final List<WritingFeedback> feedback;
  final double overallScore;
  final double grammarScore;
  final double vocabularyScore;
  final double coherenceScore;
  final bool isCompleted;
  final DateTime? submittedAt;
  final DateTime? createdAt;

  const WritingPractice({
    required this.id,
    required this.title,
    required this.titleVi,
    required this.prompt,
    required this.promptVi,
    this.wordLimit = 0,
    this.userText = '',
    this.feedback = const [],
    this.overallScore = 0.0,
    this.grammarScore = 0.0,
    this.vocabularyScore = 0.0,
    this.coherenceScore = 0.0,
    this.isCompleted = false,
    this.submittedAt,
    this.createdAt,
  });

  WritingPractice copyWith({
    String? id,
    String? title,
    String? titleVi,
    String? prompt,
    String? promptVi,
    int? wordLimit,
    String? userText,
    List<WritingFeedback>? feedback,
    double? overallScore,
    double? grammarScore,
    double? vocabularyScore,
    double? coherenceScore,
    bool? isCompleted,
    DateTime? submittedAt,
    DateTime? createdAt,
  }) {
    return WritingPractice(
      id: id ?? this.id,
      title: title ?? this.title,
      titleVi: titleVi ?? this.titleVi,
      prompt: prompt ?? this.prompt,
      promptVi: promptVi ?? this.promptVi,
      wordLimit: wordLimit ?? this.wordLimit,
      userText: userText ?? this.userText,
      feedback: feedback ?? this.feedback,
      overallScore: overallScore ?? this.overallScore,
      grammarScore: grammarScore ?? this.grammarScore,
      vocabularyScore: vocabularyScore ?? this.vocabularyScore,
      coherenceScore: coherenceScore ?? this.coherenceScore,
      isCompleted: isCompleted ?? this.isCompleted,
      submittedAt: submittedAt ?? this.submittedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Writing feedback item
class WritingFeedback {
  final String id;
  final String type;
  final String original;
  final String suggestion;
  final String explanation;
  final int startIndex;
  final int endIndex;
  final String category;

  const WritingFeedback({
    required this.id,
    required this.type,
    required this.original,
    required this.suggestion,
    this.explanation = '',
    this.startIndex = 0,
    this.endIndex = 0,
    this.category = '',
  });
}
