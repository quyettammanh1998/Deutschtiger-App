import 'package:freezed_annotation/freezed_annotation.dart';

part 'podcast_models.freezed.dart';
part 'podcast_models.g.dart';

/// Podcast series (Easy German Podcast, Sprechen B1/B2, etc.)
@freezed
abstract class PodcastSeries with _$PodcastSeries {
  const factory PodcastSeries({
    required String id,
    required String title,
    required String titleVi,
    @Default('') String description,
    @Default('') String descriptionVi,
    @Default('') String imageUrl,
    @Default('') String level,
    @Default('') String language,
    @Default(0) int totalEpisodes,
    @Default(0) int completedEpisodes,
    @Default(<PodcastEpisode>[]) List<PodcastEpisode> episodes,
  }) = _PodcastSeries;

  factory PodcastSeries.fromJson(Map<String, dynamic> json) =>
      _$PodcastSeriesFromJson(json);
}

/// Podcast episode
@freezed
abstract class PodcastEpisode with _$PodcastEpisode {
  const factory PodcastEpisode({
    required String id,
    required String seriesId,
    required String episodeNumber,
    required String title,
    required String titleVi,
    @Default('') String description,
    @Default('') String descriptionVi,
    @Default('') String audioUrl,
    @Default(0) int durationSeconds,
    @Default('') String transcript,
    @Default('') String transcriptUrl,
    @Default(false) bool isCompleted,
    @Default(0) int listenCount,
    @Default(0.0) double progressPercent,
    DateTime? lastListenedAt,
  }) = _PodcastEpisode;

  factory PodcastEpisode.fromJson(Map<String, dynamic> json) =>
      _$PodcastEpisodeFromJson(json);
}

/// Audiobook model
@freezed
abstract class Audiobook with _$Audiobook {
  const factory Audiobook({
    required String id,
    required String title,
    required String titleVi,
    @Default('') String author,
    @Default('') String description,
    @Default('') String imageUrl,
    @Default('') String level,
    @Default(0) int totalChapters,
    @Default(0) int completedChapters,
    @Default(<AudiobookChapter>[]) List<AudiobookChapter> chapters,
  }) = _Audiobook;

  factory Audiobook.fromJson(Map<String, dynamic> json) =>
      _$AudiobookFromJson(json);
}

/// Audiobook chapter
@freezed
abstract class AudiobookChapter with _$AudiobookChapter {
  const factory AudiobookChapter({
    required String id,
    required String audiobookId,
    required String chapterNumber,
    required String title,
    required String titleVi,
    @Default('') String audioUrl,
    @Default(0) int durationSeconds,
    @Default(false) bool isCompleted,
  }) = _AudiobookChapter;

  factory AudiobookChapter.fromJson(Map<String, dynamic> json) =>
      _$AudiobookChapterFromJson(json);
}

/// Dictation exercise
@freezed
abstract class Dictation with _$Dictation {
  const factory Dictation({
    required String id,
    required String title,
    required String titleVi,
    @Default('') String level,
    @Default(0) int difficulty,
    @Default(0) int totalSentences,
    @Default(0) int correctAnswers,
    @Default(false) bool isCompleted,
  }) = _Dictation;

  factory Dictation.fromJson(Map<String, dynamic> json) =>
      _$DictationFromJson(json);
}

/// Dictation sentence for filling in blanks
@freezed
abstract class DictationSentence with _$DictationSentence {
  const factory DictationSentence({
    required String id,
    required String dictationId,
    required String sentence,
    required List<String> blanks,
    @Default(0) int attempts,
    @Default(0) int correctAttempts,
  }) = _DictationSentence;

  factory DictationSentence.fromJson(Map<String, dynamic> json) =>
      _$DictationSentenceFromJson(json);
}
