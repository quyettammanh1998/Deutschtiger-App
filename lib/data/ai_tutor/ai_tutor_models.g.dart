// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_tutor_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AITutorSession _$AITutorSessionFromJson(Map<String, dynamic> json) =>
    _AITutorSession(
      id: json['id'] as String,
      odlId: json['odlId'] as String,
      title: json['title'] as String,
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => AITutorMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AITutorMessage>[],
      messageCount: (json['messageCount'] as num?)?.toInt() ?? 0,
      tokensUsed: (json['tokensUsed'] as num?)?.toInt() ?? 0,
      avgResponseTime: (json['avgResponseTime'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
    );

Map<String, dynamic> _$AITutorSessionToJson(_AITutorSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'odlId': instance.odlId,
      'title': instance.title,
      'messages': instance.messages,
      'messageCount': instance.messageCount,
      'tokensUsed': instance.tokensUsed,
      'avgResponseTime': instance.avgResponseTime,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
    };

_AITutorMessage _$AITutorMessageFromJson(Map<String, dynamic> json) =>
    _AITutorMessage(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      translation: json['translation'] as String? ?? '',
      vocabularyHighlight:
          (json['vocabularyHighlight'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      isGrammarHint: json['isGrammarHint'] as bool? ?? false,
      isCorrection: json['isCorrection'] as bool? ?? false,
    );

Map<String, dynamic> _$AITutorMessageToJson(_AITutorMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'role': instance.role,
      'content': instance.content,
      'translation': instance.translation,
      'vocabularyHighlight': instance.vocabularyHighlight,
      'isGrammarHint': instance.isGrammarHint,
      'isCorrection': instance.isCorrection,
    };

_AIWritingPractice _$AIWritingPracticeFromJson(Map<String, dynamic> json) =>
    _AIWritingPractice(
      id: json['id'] as String,
      odlId: json['odlId'] as String,
      topic: json['topic'] as String,
      topicVi: json['topicVi'] as String,
      prompt: json['prompt'] as String? ?? '',
      promptVi: json['promptVi'] as String? ?? '',
      wordLimit: (json['wordLimit'] as num?)?.toInt() ?? 0,
      userText: json['userText'] as String? ?? '',
      feedback:
          (json['feedback'] as List<dynamic>?)
              ?.map(
                (e) => AIWritingFeedback.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <AIWritingFeedback>[],
      overallScore: (json['overallScore'] as num?)?.toDouble() ?? 0.0,
      grammarScore: (json['grammarScore'] as num?)?.toDouble() ?? 0.0,
      vocabularyScore: (json['vocabularyScore'] as num?)?.toDouble() ?? 0.0,
      coherenceScore: (json['coherenceScore'] as num?)?.toDouble() ?? 0.0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
    );

Map<String, dynamic> _$AIWritingPracticeToJson(_AIWritingPractice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'odlId': instance.odlId,
      'topic': instance.topic,
      'topicVi': instance.topicVi,
      'prompt': instance.prompt,
      'promptVi': instance.promptVi,
      'wordLimit': instance.wordLimit,
      'userText': instance.userText,
      'feedback': instance.feedback,
      'overallScore': instance.overallScore,
      'grammarScore': instance.grammarScore,
      'vocabularyScore': instance.vocabularyScore,
      'coherenceScore': instance.coherenceScore,
      'isCompleted': instance.isCompleted,
      'submittedAt': instance.submittedAt?.toIso8601String(),
    };

_AIWritingFeedback _$AIWritingFeedbackFromJson(Map<String, dynamic> json) =>
    _AIWritingFeedback(
      id: json['id'] as String,
      practiceId: json['practiceId'] as String,
      type: json['type'] as String,
      original: json['original'] as String,
      suggestion: json['suggestion'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      startIndex: (json['startIndex'] as num?)?.toInt() ?? 0,
      endIndex: (json['endIndex'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AIWritingFeedbackToJson(_AIWritingFeedback instance) =>
    <String, dynamic>{
      'id': instance.id,
      'practiceId': instance.practiceId,
      'type': instance.type,
      'original': instance.original,
      'suggestion': instance.suggestion,
      'explanation': instance.explanation,
      'startIndex': instance.startIndex,
      'endIndex': instance.endIndex,
    };

_AITutorMode _$AITutorModeFromJson(Map<String, dynamic> json) => _AITutorMode(
  id: json['id'] as String,
  name: json['name'] as String,
  nameVi: json['nameVi'] as String,
  description: json['description'] as String,
  descriptionVi: json['descriptionVi'] as String? ?? '',
  avatar: json['avatar'] as String? ?? '',
  tone: json['tone'] as String? ?? 'formal',
  focus: json['focus'] as String? ?? 'grammar',
);

Map<String, dynamic> _$AITutorModeToJson(_AITutorMode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameVi': instance.nameVi,
      'description': instance.description,
      'descriptionVi': instance.descriptionVi,
      'avatar': instance.avatar,
      'tone': instance.tone,
      'focus': instance.focus,
    };
