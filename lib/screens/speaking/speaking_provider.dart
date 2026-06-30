import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/speaking_repository.dart';
import '../domain/speaking_models.dart';

final speakingRepositoryProvider = Provider<SpeakingRepository>((ref) => SpeakingRepository());

final shadowingSessionsProvider = FutureProvider<List<SpeakingSession>>((ref) async {
  final repo = ref.watch(speakingRepositoryProvider);
  return repo.getShadowingSessions();
});

final pronunciationTrainersProvider = FutureProvider<List<PronunciationTrainer>>((ref) async {
  final repo = ref.watch(speakingRepositoryProvider);
  return repo.getPronunciationTrainers();
});

final aiConversationsProvider = FutureProvider<List<AIConversation>>((ref) async {
  final repo = ref.watch(speakingRepositoryProvider);
  return repo.getAIConversations();
});

class SpeakingState {
  final List<SpeakingSession> sessions;
  final SpeakingAttempt? lastAttempt;
  final bool isRecording;
  final bool isLoading;
  final String? error;
  
  SpeakingState({
    this.sessions = const [],
    this.lastAttempt,
    this.isRecording = false,
    this.isLoading = false,
    this.error,
  });
  
  SpeakingState copyWith({
    List<SpeakingSession>? sessions,
    SpeakingAttempt? lastAttempt,
    bool? isRecording,
    bool? isLoading,
    String? error,
  }) {
    return SpeakingState(
      sessions: sessions ?? this.sessions,
      lastAttempt: lastAttempt ?? this.lastAttempt,
      isRecording: isRecording ?? this.isRecording,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
