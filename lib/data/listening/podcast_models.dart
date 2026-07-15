import 'package:freezed_annotation/freezed_annotation.dart';

part 'podcast_models.freezed.dart';
part 'podcast_models.g.dart';

/// 1 tập trong index Easy German Podcast.
/// File tĩnh `{staticBaseUrl}/data/listening/podcast/easy_german/index.json`.
@freezed
abstract class PodcastEpisode with _$PodcastEpisode {
  const factory PodcastEpisode({
    required String slug,
    required String title,
    @Default(0) int duration,
    @Default(0) int segments,
  }) = _PodcastEpisode;

  factory PodcastEpisode.fromJson(Map<String, dynamic> json) =>
      _$PodcastEpisodeFromJson(json);
}

/// 1 từ trong [PodcastSentence], mang timestamp để highlight khi phát.
/// Backend dùng field ngắn `w`/`s`/`e` (word/start/end).
@freezed
abstract class PodcastWord with _$PodcastWord {
  const factory PodcastWord({
    @JsonKey(name: 'w') @Default('') String text,
    @JsonKey(name: 's') @Default(0.0) double start,
    @JsonKey(name: 'e') @Default(0.0) double end,
  }) = _PodcastWord;

  factory PodcastWord.fromJson(Map<String, dynamic> json) =>
      _$PodcastWordFromJson(json);
}

/// 1 câu trong transcript, có bản dịch tiếng Việt + timestamp theo giây.
@freezed
abstract class PodcastSentence with _$PodcastSentence {
  const factory PodcastSentence({
    @Default('') String text,
    @JsonKey(name: 'text_vi') @Default('') String textVi,
    @Default(0.0) double start,
    @Default(0.0) double end,
    @Default(<PodcastWord>[]) List<PodcastWord> words,
  }) = _PodcastSentence;

  factory PodcastSentence.fromJson(Map<String, dynamic> json) =>
      _$PodcastSentenceFromJson(json);
}

/// 1 tập podcast đầy đủ (transcript + mp3), file tĩnh `{slug}.json`.
@freezed
abstract class PodcastEpisodeDetail with _$PodcastEpisodeDetail {
  const factory PodcastEpisodeDetail({
    required String slug,
    required String title,
    @JsonKey(name: 'mp3_url') @Default('') String mp3Url,
    @Default(0) int duration,
    @Default(<PodcastSentence>[]) List<PodcastSentence> sentences,
  }) = _PodcastEpisodeDetail;

  factory PodcastEpisodeDetail.fromJson(Map<String, dynamic> json) =>
      _$PodcastEpisodeDetailFromJson(json);
}

/// 1 dòng trong bảng xếp hạng podcast (`GET /podcast-leaderboard`,
/// `GET /user/podcast-rank`).
@freezed
abstract class PodcastLeaderboardEntry with _$PodcastLeaderboardEntry {
  const factory PodcastLeaderboardEntry({
    @JsonKey(name: 'user_id') @Default('') String userId,
    @JsonKey(name: 'display_name') @Default('') String displayName,
    @JsonKey(name: 'avatar_url') @Default('') String avatarUrl,
    @JsonKey(name: 'completed_count') @Default(0) int completedCount,
    @Default(0) int rank,
  }) = _PodcastLeaderboardEntry;

  factory PodcastLeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$PodcastLeaderboardEntryFromJson(json);
}
