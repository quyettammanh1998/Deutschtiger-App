// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExamHub _$ExamHubFromJson(Map<String, dynamic> json) => _ExamHub(
  id: json['id'] as String,
  name: json['name'] as String,
  nameVi: json['nameVi'] as String,
  type: json['type'] as String,
  description: json['description'] as String? ?? '',
  descriptionVi: json['descriptionVi'] as String? ?? '',
  level: json['level'] as String? ?? '',
  imageUrl: json['imageUrl'] as String? ?? '',
  readinessScore: (json['readinessScore'] as num?)?.toDouble() ?? 0.0,
  completedExams: (json['completedExams'] as num?)?.toInt() ?? 0,
  totalExams: (json['totalExams'] as num?)?.toInt() ?? 0,
  sections:
      (json['sections'] as List<dynamic>?)
          ?.map((e) => ExamSection.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ExamSection>[],
);

Map<String, dynamic> _$ExamHubToJson(_ExamHub instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'nameVi': instance.nameVi,
  'type': instance.type,
  'description': instance.description,
  'descriptionVi': instance.descriptionVi,
  'level': instance.level,
  'imageUrl': instance.imageUrl,
  'readinessScore': instance.readinessScore,
  'completedExams': instance.completedExams,
  'totalExams': instance.totalExams,
  'sections': instance.sections,
};

_ExamSection _$ExamSectionFromJson(Map<String, dynamic> json) => _ExamSection(
  id: json['id'] as String,
  hubId: json['hubId'] as String,
  title: json['title'] as String,
  titleVi: json['titleVi'] as String,
  type: json['type'] as String,
  score: (json['score'] as num?)?.toDouble() ?? 0.0,
  totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? 0,
  correctAnswers: (json['correctAnswers'] as num?)?.toInt() ?? 0,
  isCompleted: json['isCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$ExamSectionToJson(_ExamSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hubId': instance.hubId,
      'title': instance.title,
      'titleVi': instance.titleVi,
      'type': instance.type,
      'score': instance.score,
      'totalQuestions': instance.totalQuestions,
      'correctAnswers': instance.correctAnswers,
      'isCompleted': instance.isCompleted,
    };

_WritingTopic _$WritingTopicFromJson(Map<String, dynamic> json) =>
    _WritingTopic(
      id: json['id'] as String,
      hubId: json['hubId'] as String,
      title: json['title'] as String,
      titleVi: json['titleVi'] as String,
      prompt: json['prompt'] as String,
      promptVi: json['promptVi'] as String,
      wordLimit: (json['wordLimit'] as num?)?.toInt() ?? 0,
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt() ?? 0,
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      bestScore: (json['bestScore'] as num?)?.toDouble() ?? 0.0,
      lastSubmission: json['lastSubmission'] as String? ?? '',
      lastFeedback: json['lastFeedback'] as String? ?? '',
      sampleAnswers:
          (json['sampleAnswers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$WritingTopicToJson(_WritingTopic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hubId': instance.hubId,
      'title': instance.title,
      'titleVi': instance.titleVi,
      'prompt': instance.prompt,
      'promptVi': instance.promptVi,
      'wordLimit': instance.wordLimit,
      'estimatedMinutes': instance.estimatedMinutes,
      'attempts': instance.attempts,
      'bestScore': instance.bestScore,
      'lastSubmission': instance.lastSubmission,
      'lastFeedback': instance.lastFeedback,
      'sampleAnswers': instance.sampleAnswers,
    };

_SpeakingTopic _$SpeakingTopicFromJson(Map<String, dynamic> json) =>
    _SpeakingTopic(
      id: json['id'] as String,
      hubId: json['hubId'] as String,
      title: json['title'] as String,
      titleVi: json['titleVi'] as String,
      prompt: json['prompt'] as String,
      promptVi: json['promptVi'] as String,
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt() ?? 0,
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      bestScore: (json['bestScore'] as num?)?.toDouble() ?? 0.0,
      audioUrl: json['audioUrl'] as String? ?? '',
      transcription: json['transcription'] as String? ?? '',
    );

Map<String, dynamic> _$SpeakingTopicToJson(_SpeakingTopic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hubId': instance.hubId,
      'title': instance.title,
      'titleVi': instance.titleVi,
      'prompt': instance.prompt,
      'promptVi': instance.promptVi,
      'estimatedMinutes': instance.estimatedMinutes,
      'attempts': instance.attempts,
      'bestScore': instance.bestScore,
      'audioUrl': instance.audioUrl,
      'transcription': instance.transcription,
    };

_ExamReadiness _$ExamReadinessFromJson(Map<String, dynamic> json) =>
    _ExamReadiness(
      hubId: json['hubId'] as String,
      overallScore: (json['overallScore'] as num?)?.toDouble() ?? 0.0,
      readingScore: (json['readingScore'] as num?)?.toDouble() ?? 0.0,
      writingScore: (json['writingScore'] as num?)?.toDouble() ?? 0.0,
      listeningScore: (json['listeningScore'] as num?)?.toDouble() ?? 0.0,
      speakingScore: (json['speakingScore'] as num?)?.toDouble() ?? 0.0,
      strengths:
          (json['strengths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      weaknesses:
          (json['weaknesses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      recommendations:
          (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      lastAssessedAt: json['lastAssessedAt'] == null
          ? null
          : DateTime.parse(json['lastAssessedAt'] as String),
    );

Map<String, dynamic> _$ExamReadinessToJson(_ExamReadiness instance) =>
    <String, dynamic>{
      'hubId': instance.hubId,
      'overallScore': instance.overallScore,
      'readingScore': instance.readingScore,
      'writingScore': instance.writingScore,
      'listeningScore': instance.listeningScore,
      'speakingScore': instance.speakingScore,
      'strengths': instance.strengths,
      'weaknesses': instance.weaknesses,
      'recommendations': instance.recommendations,
      'lastAssessedAt': instance.lastAssessedAt?.toIso8601String(),
    };
