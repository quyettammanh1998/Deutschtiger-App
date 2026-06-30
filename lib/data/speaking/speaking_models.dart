import 'package:freezed_annotation/freezed_annotation.dart';

part 'speaking_models.freezed.dart';
part 'speaking_models.g.dart';

/// Speaking practice session
@freezed
abstract class SpeakingSession with _$SpeakingSession {
  const factory SpeakingSession({
    required String id,
    required String odlId,
    required String type,
    required String title,
    required String titleVi,
    @Default('') String description,
    @Default('') String transcript,
    @Default('') String translation,
    @Default(0) int durationSeconds,
    @Default(0) double accuracyScore,
    @Default(0) int wordsSpoken,
    @Default(0) int correctWords,
    @Default(<SpeakingAttempt>[]) List<SpeakingAttempt> attempts,
    DateTime? startedAt,
    DateTime? completedAt,
  }) = _SpeakingSession;

  factory SpeakingSession.fromJson(Map<String, dynamic> json) =>
      _$SpeakingSessionFromJson(json);
}

/// Single speaking attempt
@freezed
abstract class SpeakingAttempt with _$SpeakingAttempt {
  const factory SpeakingAttempt({
    required String id,
    required String sessionId,
    @Default('') String expectedText,
    @Default('') String spokenText,
    @Default('') String audioUrl,
    @Default(0.0) double accuracyScore,
    @Default(<WordResult>[]) List<WordResult> wordResults,
    @Default(0) int durationSeconds,
    DateTime? recordedAt,
  }) = _SpeakingAttempt;

  factory SpeakingAttempt.fromJson(Map<String, dynamic> json) =>
      _$SpeakingAttemptFromJson(json);
}

/// Word-by-word result
@freezed
abstract class WordResult with _$WordResult {
  const factory WordResult({
    required String word,
    required bool isCorrect,
    @Default('') String expected,
    @Default('') String spoken,
    @Default(0.0) double confidence,
  }) = _WordResult;

  factory WordResult.fromJson(Map<String, dynamic> json) =>
      _$WordResultFromJson(json);
}

/// Pronunciation trainer exercise
@freezed
abstract class PronunciationTrainer with _$PronunciationTrainer {
  const factory PronunciationTrainer({
    required String id,
    required String type,
    required String name,
    required String nameVi,
    required String targetSound,
    @Default('') String description,
    @Default('') String descriptionVi,
    @Default(<TrainerExercise>[]) List<TrainerExercise> exercises,
    @Default(0) int totalAttempts,
    @Default(0) int correctAttempts,
  }) = _PronunciationTrainer;

  factory PronunciationTrainer.fromJson(Map<String, dynamic> json) =>
      _$PronunciationTrainerFromJson(json);
}

/// Trainer exercise
@freezed
abstract class TrainerExercise with _$TrainerExercise {
  const factory TrainerExercise({
    required String id,
    required String trainerId,
    required String word,
    required String translation,
    @Default('') String phonetic,
    @Default('') String audioUrl,
    @Default(0) int order,
  }) = _TrainerExercise;

  factory TrainerExercise.fromJson(Map<String, dynamic> json) =>
      _$TrainerExerciseFromJson(json);
}

/// AI conversation scenario
@freezed
abstract class AIConversation with _$AIConversation {
  const factory AIConversation({
    required String id,
    required String title,
    required String titleVi,
    required String scenario,
    required String scenarioVi,
    @Default('') String level,
    @Default('') String imageUrl,
    @Default(0) int estimatedMinutes,
    @Default(0) int conversationCount,
    @Default(<AIMessage>[]) List<AIMessage> messages,
    @Default(0.0) double averageScore,
  }) = _AIConversation;

  factory AIConversation.fromJson(Map<String, dynamic> json) =>
      _$AIConversationFromJson(json);
}

/// AI message in conversation
@freezed
abstract class AIMessage with _$AIMessage {
  const factory AIMessage({
    required String id,
    required String role,
    required String content,
    @Default('') String translation,
    @Default(0.0) double score,
  }) = _AIMessage;

  factory AIMessage.fromJson(Map<String, dynamic> json) =>
      _$AIMessageFromJson(json);
}

/// User's AI conversation history
@freezed
abstract class AIConversationHistory with _$AIConversationHistory {
  const factory AIConversationHistory({
    required String id,
    required String conversationId,
    @Default(<AIMessage>[]) List<AIMessage> messages,
    @Default(0.0) double finalScore,
    @Default(0) int messageCount,
    @Default(0) int durationSeconds,
    DateTime? startedAt,
    DateTime? completedAt,
  }) = _AIConversationHistory;

  factory AIConversationHistory.fromJson(Map<String, dynamic> json) =>
      _$AIConversationHistoryFromJson(json);
}
