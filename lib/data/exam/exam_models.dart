import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_models.freezed.dart';
part 'exam_models.g.dart';

/// Exam hub (Goethe B1, Telc, etc.)
@freezed
abstract class ExamHub with _$ExamHub {
  const factory ExamHub({
    required String id,
    required String name,
    required String nameVi,
    required String type,
    @Default('') String description,
    @Default('') String descriptionVi,
    @Default('') String level,
    @Default('') String imageUrl,
    @Default(0.0) double readinessScore,
    @Default(0) int completedExams,
    @Default(0) int totalExams,
    @Default(<ExamSection>[]) List<ExamSection> sections,
  }) = _ExamHub;

  factory ExamHub.fromJson(Map<String, dynamic> json) => _$ExamHubFromJson(json);
}

/// Exam section (Writing, Speaking, Reading, Listening)
@freezed
abstract class ExamSection with _$ExamSection {
  const factory ExamSection({
    required String id,
    required String hubId,
    required String title,
    required String titleVi,
    required String type,
    @Default(0.0) double score,
    @Default(0) int totalQuestions,
    @Default(0) int correctAnswers,
    @Default(false) bool isCompleted,
  }) = _ExamSection;

  factory ExamSection.fromJson(Map<String, dynamic> json) =>
      _$ExamSectionFromJson(json);
}

/// Writing topic for exam practice
@freezed
abstract class WritingTopic with _$WritingTopic {
  const factory WritingTopic({
    required String id,
    required String hubId,
    required String title,
    required String titleVi,
    required String prompt,
    required String promptVi,
    @Default(0) int wordLimit,
    @Default(0) int estimatedMinutes,
    @Default(0) int attempts,
    @Default(0.0) double bestScore,
    @Default('') String lastSubmission,
    @Default('') String lastFeedback,
    @Default(<String>[]) List<String> sampleAnswers,
  }) = _WritingTopic;

  factory WritingTopic.fromJson(Map<String, dynamic> json) =>
      _$WritingTopicFromJson(json);
}

/// Speaking topic for exam practice
@freezed
abstract class SpeakingTopic with _$SpeakingTopic {
  const factory SpeakingTopic({
    required String id,
    required String hubId,
    required String title,
    required String titleVi,
    required String prompt,
    required String promptVi,
    @Default(0) int estimatedMinutes,
    @Default(0) int attempts,
    @Default(0.0) double bestScore,
    @Default('') String audioUrl,
    @Default('') String transcription,
  }) = _SpeakingTopic;

  factory SpeakingTopic.fromJson(Map<String, dynamic> json) =>
      _$SpeakingTopicFromJson(json);
}

/// Exam readiness assessment
@freezed
abstract class ExamReadiness with _$ExamReadiness {
  const factory ExamReadiness({
    required String hubId,
    @Default(0.0) double overallScore,
    @Default(0.0) double readingScore,
    @Default(0.0) double writingScore,
    @Default(0.0) double listeningScore,
    @Default(0.0) double speakingScore,
    @Default(<String>[]) List<String> strengths,
    @Default(<String>[]) List<String> weaknesses,
    @Default(<String>[]) List<String> recommendations,
    DateTime? lastAssessedAt,
  }) = _ExamReadiness;

  factory ExamReadiness.fromJson(Map<String, dynamic> json) =>
      _$ExamReadinessFromJson(json);
}
