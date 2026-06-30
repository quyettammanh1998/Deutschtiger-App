import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/listening/podcast_repository.dart';
import '../../data/listening/podcast_models.dart';

final podcastRepositoryProvider = Provider<PodcastRepository>((ref) {
  return PodcastRepository();
});

final podcastSeriesProvider = FutureProvider<List<PodcastSeries>>((ref) async {
  final repo = ref.watch(podcastRepositoryProvider);
  return repo.getPodcastSeries();
});

final podcastEpisodesProvider = FutureProvider.family<List<PodcastEpisode>, String>((ref, seriesId) async {
  final repo = ref.watch(podcastRepositoryProvider);
  return repo.getEpisodes(seriesId);
});

final audiobooksProvider = FutureProvider<List<Audiobook>>((ref) async {
  final repo = ref.watch(podcastRepositoryProvider);
  return repo.getAudiobooks();
});

final dictationsProvider = FutureProvider<List<Dictation>>((ref) async {
  final repo = ref.watch(podcastRepositoryProvider);
  return repo.getDictations();
});

final dictationSentencesProvider = FutureProvider.family<List<DictationSentence>, String>((ref, dictationId) async {
  final repo = ref.watch(podcastRepositoryProvider);
  return repo.getDictationSentences(dictationId);
});

final selectedPodcastSeriesProvider = StateProvider<PodcastSeries?>((ref) => null);
final selectedEpisodeProvider = StateProvider<PodcastEpisode?>((ref) => null);
final selectedDictationProvider = StateProvider<Dictation?>((ref) => null);

class PodcastNotifier extends StateNotifier<AudioPlayerState> {
  final PodcastRepository _repo;
  
  PodcastNotifier(this._repo) : super(AudioPlayerState());
  
  Future<void> loadEpisode(String seriesId, String episodeId) async {
    state = state.copyWith(isLoading: true);
    try {
      final episodes = await _repo.getEpisodes(seriesId);
      final episode = episodes.firstWhere((e) => e.id == episodeId);
      state = state.copyWith(
        currentEpisode: episode,
        isLoading: false,
        position: Duration.zero,
        duration: Duration(seconds: episode.durationSeconds),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  void play() => state = state.copyWith(isPlaying: true);
  void pause() => state = state.copyWith(isPlaying: false);
  void seek(Duration position) => state = state.copyWith(position: position);
}

class AudioPlayerState {
  final PodcastEpisode? currentEpisode;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool isLoading;
  final String? error;
  
  AudioPlayerState({
    this.currentEpisode,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isLoading = false,
    this.error,
  });
  
  AudioPlayerState copyWith({
    PodcastEpisode? currentEpisode,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? isLoading,
    String? error,
  }) {
    return AudioPlayerState(
      currentEpisode: currentEpisode ?? this.currentEpisode,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final audioPlayerProvider = StateNotifierProvider<PodcastNotifier, AudioPlayerState>((ref) {
  return PodcastNotifier(ref.watch(podcastRepositoryProvider));
});
