// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speaking_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpeakingSession _$SpeakingSessionFromJson(Map<String, dynamic> json) =>
    _SpeakingSession(
      id: json['id'] as String,
      odlId: json['odlId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      titleVi: json['titleVi'] as String,
      description: json['description'] as String? ?? '',
      transcript: json['transcript'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      accuracyScore: (json['accuracyScore'] as num?)?.toDouble() ?? 0,
      wordsSpoken: (json['wordsSpoken'] as num?)?.toInt() ?? 0,
      correctWords: (json['correctWords'] as num?)?.toInt() ?? 0,
      attempts:
          (json['attempts'] as List<dynamic>?)
              ?.map((e) => SpeakingAttempt.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SpeakingAttempt>[],
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$SpeakingSessionToJson(_SpeakingSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'odlId': instance.odlId,
      'type': instance.type,
      'title': instance.title,
      'titleVi': instance.titleVi,
      'description': instance.description,
      'transcript': instance.transcript,
      'translation': instance.translation,
      'durationSeconds': instance.durationSeconds,
      'accuracyScore': instance.accuracyScore,
      'wordsSpoken': instance.wordsSpoken,
      'correctWords': instance.correctWords,
      'attempts': instance.attempts,
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

_SpeakingAttempt _$SpeakingAttemptFromJson(Map<String, dynamic> json) =>
    _SpeakingAttempt(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      expectedText: json['expectedText'] as String? ?? '',
      spokenText: json['spokenText'] as String? ?? '',
      audioUrl: json['audioUrl'] as String? ?? '',
      accuracyScore: (json['accuracyScore'] as num?)?.toDouble() ?? 0.0,
      wordResults:
          (json['wordResults'] as List<dynamic>?)
              ?.map((e) => WordResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WordResult>[],
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      recordedAt: json['recordedAt'] == null
          ? null
          : DateTime.parse(json['recordedAt'] as String),
    );

Map<String, dynamic> _$SpeakingAttemptToJson(_SpeakingAttempt instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'expectedText': instance.expectedText,
      'spokenText': instance.spokenText,
      'audioUrl': instance.audioUrl,
      'accuracyScore': instance.accuracyScore,
      'wordResults': instance.wordResults,
      'durationSeconds': instance.durationSeconds,
      'recordedAt': instance.recordedAt?.toIso8601String(),
    };

_WordResult _$WordResultFromJson(Map<String, dynamic> json) => _WordResult(
  word: json['word'] as String,
  isCorrect: json['isCorrect'] as bool,
  expected: json['expected'] as String? ?? '',
  spoken: json['spoken'] as String? ?? '',
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$WordResultToJson(_WordResult instance) =>
    <String, dynamic>{
      'word': instance.word,
      'isCorrect': instance.isCorrect,
      'expected': instance.expected,
      'spoken': instance.spoken,
      'confidence': instance.confidence,
    };

_PronunciationTrainer _$PronunciationTrainerFromJson(
  Map<String, dynamic> json,
) => _PronunciationTrainer(
  id: json['id'] as String,
  type: json['type'] as String,
  name: json['name'] as String,
  nameVi: json['nameVi'] as String,
  targetSound: json['targetSound'] as String,
  description: json['description'] as String? ?? '',
  descriptionVi: json['descriptionVi'] as String? ?? '',
  exercises:
      (json['exercises'] as List<dynamic>?)
          ?.map((e) => TrainerExercise.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TrainerExercise>[],
  totalAttempts: (json['totalAttempts'] as num?)?.toInt() ?? 0,
  correctAttempts: (json['correctAttempts'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PronunciationTrainerToJson(
  _PronunciationTrainer instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'name': instance.name,
  'nameVi': instance.nameVi,
  'targetSound': instance.targetSound,
  'description': instance.description,
  'descriptionVi': instance.descriptionVi,
  'exercises': instance.exercises,
  'totalAttempts': instance.totalAttempts,
  'correctAttempts': instance.correctAttempts,
};

_TrainerExercise _$TrainerExerciseFromJson(Map<String, dynamic> json) =>
    _TrainerExercise(
      id: json['id'] as String,
      trainerId: json['trainerId'] as String,
      word: json['word'] as String,
      translation: json['translation'] as String,
      phonetic: json['phonetic'] as String? ?? '',
      audioUrl: json['audioUrl'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TrainerExerciseToJson(_TrainerExercise instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trainerId': instance.trainerId,
      'word': instance.word,
      'translation': instance.translation,
      'phonetic': instance.phonetic,
      'audioUrl': instance.audioUrl,
      'order': instance.order,
    };

_AIConversation _$AIConversationFromJson(Map<String, dynamic> json) =>
    _AIConversation(
      id: json['id'] as String,
      title: json['title'] as String,
      titleVi: json['titleVi'] as String,
      scenario: json['scenario'] as String,
      scenarioVi: json['scenarioVi'] as String,
      level: json['level'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt() ?? 0,
      conversationCount: (json['conversationCount'] as num?)?.toInt() ?? 0,
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => AIMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AIMessage>[],
      averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$AIConversationToJson(_AIConversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'titleVi': instance.titleVi,
      'scenario': instance.scenario,
      'scenarioVi': instance.scenarioVi,
      'level': instance.level,
      'imageUrl': instance.imageUrl,
      'estimatedMinutes': instance.estimatedMinutes,
      'conversationCount': instance.conversationCount,
      'messages': instance.messages,
      'averageScore': instance.averageScore,
    };

_AIMessage _$AIMessageFromJson(Map<String, dynamic> json) => _AIMessage(
  id: json['id'] as String,
  role: json['role'] as String,
  content: json['content'] as String,
  translation: json['translation'] as String? ?? '',
  score: (json['score'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$AIMessageToJson(_AIMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'translation': instance.translation,
      'score': instance.score,
    };

_AIConversationHistory _$AIConversationHistoryFromJson(
  Map<String, dynamic> json,
) => _AIConversationHistory(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  messages:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => AIMessage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AIMessage>[],
  finalScore: (json['finalScore'] as num?)?.toDouble() ?? 0.0,
  messageCount: (json['messageCount'] as num?)?.toInt() ?? 0,
  durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$AIConversationHistoryToJson(
  _AIConversationHistory instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'messages': instance.messages,
  'finalScore': instance.finalScore,
  'messageCount': instance.messageCount,
  'durationSeconds': instance.durationSeconds,
  'startedAt': instance.startedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
};
