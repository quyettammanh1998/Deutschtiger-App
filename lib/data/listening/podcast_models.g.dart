// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PodcastSeries _$PodcastSeriesFromJson(Map<String, dynamic> json) =>
    _PodcastSeries(
      id: json['id'] as String,
      title: json['title'] as String,
      titleVi: json['titleVi'] as String,
      description: json['description'] as String? ?? '',
      descriptionVi: json['descriptionVi'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      level: json['level'] as String? ?? '',
      language: json['language'] as String? ?? '',
      totalEpisodes: (json['totalEpisodes'] as num?)?.toInt() ?? 0,
      completedEpisodes: (json['completedEpisodes'] as num?)?.toInt() ?? 0,
      episodes:
          (json['episodes'] as List<dynamic>?)
              ?.map((e) => PodcastEpisode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PodcastEpisode>[],
    );

Map<String, dynamic> _$PodcastSeriesToJson(_PodcastSeries instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'titleVi': instance.titleVi,
      'description': instance.description,
      'descriptionVi': instance.descriptionVi,
      'imageUrl': instance.imageUrl,
      'level': instance.level,
      'language': instance.language,
      'totalEpisodes': instance.totalEpisodes,
      'completedEpisodes': instance.completedEpisodes,
      'episodes': instance.episodes,
    };

_PodcastEpisode _$PodcastEpisodeFromJson(Map<String, dynamic> json) =>
    _PodcastEpisode(
      id: json['id'] as String,
      seriesId: json['seriesId'] as String,
      episodeNumber: json['episodeNumber'] as String,
      title: json['title'] as String,
      titleVi: json['titleVi'] as String,
      description: json['description'] as String? ?? '',
      descriptionVi: json['descriptionVi'] as String? ?? '',
      audioUrl: json['audioUrl'] as String? ?? '',
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      transcript: json['transcript'] as String? ?? '',
      transcriptUrl: json['transcriptUrl'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      listenCount: (json['listenCount'] as num?)?.toInt() ?? 0,
      progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0.0,
      lastListenedAt: json['lastListenedAt'] == null
          ? null
          : DateTime.parse(json['lastListenedAt'] as String),
    );

Map<String, dynamic> _$PodcastEpisodeToJson(_PodcastEpisode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seriesId': instance.seriesId,
      'episodeNumber': instance.episodeNumber,
      'title': instance.title,
      'titleVi': instance.titleVi,
      'description': instance.description,
      'descriptionVi': instance.descriptionVi,
      'audioUrl': instance.audioUrl,
      'durationSeconds': instance.durationSeconds,
      'transcript': instance.transcript,
      'transcriptUrl': instance.transcriptUrl,
      'isCompleted': instance.isCompleted,
      'listenCount': instance.listenCount,
      'progressPercent': instance.progressPercent,
      'lastListenedAt': instance.lastListenedAt?.toIso8601String(),
    };

_Audiobook _$AudiobookFromJson(Map<String, dynamic> json) => _Audiobook(
  id: json['id'] as String,
  title: json['title'] as String,
  titleVi: json['titleVi'] as String,
  author: json['author'] as String? ?? '',
  description: json['description'] as String? ?? '',
  imageUrl: json['imageUrl'] as String? ?? '',
  level: json['level'] as String? ?? '',
  totalChapters: (json['totalChapters'] as num?)?.toInt() ?? 0,
  completedChapters: (json['completedChapters'] as num?)?.toInt() ?? 0,
  chapters:
      (json['chapters'] as List<dynamic>?)
          ?.map((e) => AudiobookChapter.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AudiobookChapter>[],
);

Map<String, dynamic> _$AudiobookToJson(_Audiobook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'titleVi': instance.titleVi,
      'author': instance.author,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'level': instance.level,
      'totalChapters': instance.totalChapters,
      'completedChapters': instance.completedChapters,
      'chapters': instance.chapters,
    };

_AudiobookChapter _$AudiobookChapterFromJson(Map<String, dynamic> json) =>
    _AudiobookChapter(
      id: json['id'] as String,
      audiobookId: json['audiobookId'] as String,
      chapterNumber: json['chapterNumber'] as String,
      title: json['title'] as String,
      titleVi: json['titleVi'] as String,
      audioUrl: json['audioUrl'] as String? ?? '',
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$AudiobookChapterToJson(_AudiobookChapter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'audiobookId': instance.audiobookId,
      'chapterNumber': instance.chapterNumber,
      'title': instance.title,
      'titleVi': instance.titleVi,
      'audioUrl': instance.audioUrl,
      'durationSeconds': instance.durationSeconds,
      'isCompleted': instance.isCompleted,
    };

_Dictation _$DictationFromJson(Map<String, dynamic> json) => _Dictation(
  id: json['id'] as String,
  title: json['title'] as String,
  titleVi: json['titleVi'] as String,
  level: json['level'] as String? ?? '',
  difficulty: (json['difficulty'] as num?)?.toInt() ?? 0,
  totalSentences: (json['totalSentences'] as num?)?.toInt() ?? 0,
  correctAnswers: (json['correctAnswers'] as num?)?.toInt() ?? 0,
  isCompleted: json['isCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$DictationToJson(_Dictation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'titleVi': instance.titleVi,
      'level': instance.level,
      'difficulty': instance.difficulty,
      'totalSentences': instance.totalSentences,
      'correctAnswers': instance.correctAnswers,
      'isCompleted': instance.isCompleted,
    };

_DictationSentence _$DictationSentenceFromJson(Map<String, dynamic> json) =>
    _DictationSentence(
      id: json['id'] as String,
      dictationId: json['dictationId'] as String,
      sentence: json['sentence'] as String,
      blanks: (json['blanks'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      correctAttempts: (json['correctAttempts'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DictationSentenceToJson(_DictationSentence instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dictationId': instance.dictationId,
      'sentence': instance.sentence,
      'blanks': instance.blanks,
      'attempts': instance.attempts,
      'correctAttempts': instance.correctAttempts,
    };
