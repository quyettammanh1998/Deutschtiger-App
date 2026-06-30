import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_tutor_models.freezed.dart';
part 'ai_tutor_models.g.dart';

/// AI Tutor chat session
@freezed
abstract class AITutorSession with _$AITutorSession {
  const factory AITutorSession({
    required String id,
    required String odlId,
    required String title,
    @Default(<AITutorMessage>[]) List<AITutorMessage> messages,
    @Default(0) int messageCount,
    @Default(0) int tokensUsed,
    @Default(0.0) double avgResponseTime,
    DateTime? createdAt,
    DateTime? lastMessageAt,
  }) = _AITutorSession;

  factory AITutorSession.fromJson(Map<String, dynamic> json) =>
      _$AITutorSessionFromJson(json);
}

/// AI Tutor message
@freezed
abstract class AITutorMessage with _$AITutorMessage {
  const factory AITutorMessage({
    required String id,
    required String sessionId,
    required String role,
    required String content,
    @Default('') String translation,
    @Default(<String>[]) List<String> vocabularyHighlight,
    @Default(false) bool isGrammarHint,
    @Default(false) bool isCorrection,
  }) = _AITutorMessage;

  factory AITutorMessage.fromJson(Map<String, dynamic> json) =>
      _$AITutorMessageFromJson(json);
}

/// AI Writing practice exercise
@freezed
abstract class AIWritingPractice with _$AIWritingPractice {
  const factory AIWritingPractice({
    required String id,
    required String odlId,
    required String topic,
    required String topicVi,
    @Default('') String prompt,
    @Default('') String promptVi,
    @Default(0) int wordLimit,
    @Default('') String userText,
    @Default(<AIWritingFeedback>[]) List<AIWritingFeedback> feedback,
    @Default(0.0) double overallScore,
    @Default(0.0) double grammarScore,
    @Default(0.0) double vocabularyScore,
    @Default(0.0) double coherenceScore,
    @Default(false) bool isCompleted,
    DateTime? submittedAt,
  }) = _AIWritingPractice;

  factory AIWritingPractice.fromJson(Map<String, dynamic> json) =>
      _$AIWritingPracticeFromJson(json);
}

/// AI Writing feedback
@freezed
abstract class AIWritingFeedback with _$AIWritingFeedback {
  const factory AIWritingFeedback({
    required String id,
    required String practiceId,
    required String type,
    required String original,
    @Default('') String suggestion,
    @Default('') String explanation,
    @Default(0) int startIndex,
    @Default(0) int endIndex,
  }) = _AIWritingFeedback;

  factory AIWritingFeedback.fromJson(Map<String, dynamic> json) =>
      _$AIWritingFeedbackFromJson(json);
}

/// AI Tutor mode/personality
@freezed
abstract class AITutorMode with _$AITutorMode {
  const factory AITutorMode({
    required String id,
    required String name,
    required String nameVi,
    required String description,
    @Default('') String descriptionVi,
    @Default('') String avatar,
    @Default('formal') String tone,
    @Default('grammar') String focus,
  }) = _AITutorMode;

  factory AITutorMode.fromJson(Map<String, dynamic> json) =>
      _$AITutorModeFromJson(json);
}
