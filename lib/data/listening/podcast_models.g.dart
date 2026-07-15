// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PodcastEpisode _$PodcastEpisodeFromJson(Map<String, dynamic> json) =>
    _PodcastEpisode(
      slug: json['slug'] as String,
      title: json['title'] as String,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      segments: (json['segments'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PodcastEpisodeToJson(_PodcastEpisode instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'title': instance.title,
      'duration': instance.duration,
      'segments': instance.segments,
    };

_PodcastWord _$PodcastWordFromJson(Map<String, dynamic> json) => _PodcastWord(
  text: json['w'] as String? ?? '',
  start: (json['s'] as num?)?.toDouble() ?? 0.0,
  end: (json['e'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$PodcastWordToJson(_PodcastWord instance) =>
    <String, dynamic>{
      'w': instance.text,
      's': instance.start,
      'e': instance.end,
    };

_PodcastSentence _$PodcastSentenceFromJson(Map<String, dynamic> json) =>
    _PodcastSentence(
      text: json['text'] as String? ?? '',
      textVi: json['text_vi'] as String? ?? '',
      start: (json['start'] as num?)?.toDouble() ?? 0.0,
      end: (json['end'] as num?)?.toDouble() ?? 0.0,
      words:
          (json['words'] as List<dynamic>?)
              ?.map((e) => PodcastWord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PodcastWord>[],
    );

Map<String, dynamic> _$PodcastSentenceToJson(_PodcastSentence instance) =>
    <String, dynamic>{
      'text': instance.text,
      'text_vi': instance.textVi,
      'start': instance.start,
      'end': instance.end,
      'words': instance.words,
    };

_PodcastEpisodeDetail _$PodcastEpisodeDetailFromJson(
  Map<String, dynamic> json,
) => _PodcastEpisodeDetail(
  slug: json['slug'] as String,
  title: json['title'] as String,
  mp3Url: json['mp3_url'] as String? ?? '',
  duration: (json['duration'] as num?)?.toInt() ?? 0,
  sentences:
      (json['sentences'] as List<dynamic>?)
          ?.map((e) => PodcastSentence.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PodcastSentence>[],
);

Map<String, dynamic> _$PodcastEpisodeDetailToJson(
  _PodcastEpisodeDetail instance,
) => <String, dynamic>{
  'slug': instance.slug,
  'title': instance.title,
  'mp3_url': instance.mp3Url,
  'duration': instance.duration,
  'sentences': instance.sentences,
};

_PodcastLeaderboardEntry _$PodcastLeaderboardEntryFromJson(
  Map<String, dynamic> json,
) => _PodcastLeaderboardEntry(
  userId: json['user_id'] as String? ?? '',
  displayName: json['display_name'] as String? ?? '',
  avatarUrl: json['avatar_url'] as String? ?? '',
  completedCount: (json['completed_count'] as num?)?.toInt() ?? 0,
  rank: (json['rank'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PodcastLeaderboardEntryToJson(
  _PodcastLeaderboardEntry instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'display_name': instance.displayName,
  'avatar_url': instance.avatarUrl,
  'completed_count': instance.completedCount,
  'rank': instance.rank,
};
