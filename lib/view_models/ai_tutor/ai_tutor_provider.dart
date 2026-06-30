import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/ai_tutor/ai_tutor_repository.dart';
import '../../data/ai_tutor/ai_tutor_models.dart';

final aiTutorRepositoryProvider = Provider<AITutorRepository>((ref) => AITutorRepository());

final aiSessionsProvider = FutureProvider<List<AITutorSession>>((ref) async {
  final repo = ref.watch(aiTutorRepositoryProvider);
  return repo.getSessions();
});

final aiTutorModesProvider = FutureProvider<List<AITutorMode>>((ref) async {
  final repo = ref.watch(aiTutorRepositoryProvider);
  return repo.getModes();
});

final aiWritingPracticesProvider = FutureProvider<List<AIWritingPractice>>((ref) async {
  final repo = ref.watch(aiTutorRepositoryProvider);
  return repo.getWritingPractices();
});

final currentAIModeProvider = FutureProvider<AITutorMode>((ref) async {
  final repo = ref.watch(aiTutorRepositoryProvider);
  return repo.getCurrentMode();
});

final currentSessionProvider = StateProvider<AITutorSession?>((ref) => null);

class AITutorNotifier extends StateNotifier<AITutorState> {
  final AITutorRepository _repo;
  
  AITutorNotifier(this._repo) : super(AITutorState());
  
  Future<void> sendMessage(String content, String mode) async {
    final userMsg = AITutorMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: state.currentSession?.id ?? 'new',
      role: 'user',
      content: content,
    );
    
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
    );
    
    try {
      final response = await _repo.sendMessage(
        sessionId: state.currentSession?.id ?? 'new',
        content: content,
        mode: mode,
      );
      
      state = state.copyWith(
        messages: [...state.messages, response],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  void startNewSession(String modeId) {
    state = AITutorState(
      currentMode: modeId,
      messages: [
        const AITutorMessage(
          id: 'welcome',
          sessionId: 'new',
          role: 'assistant',
          content: 'Hallo! Ich bin dein AI-Tutor. Wie kann ich dir heute helfen?',
          translation: 'Hello! I am your AI tutor. How can I help you today?',
        ),
      ],
    );
  }
}

class AITutorState {
  final AITutorSession? currentSession;
  final List<AITutorMessage> messages;
  final String? currentMode;
  final bool isLoading;
  final String? error;
  
  AITutorState({
    this.currentSession,
    this.messages = const [],
    this.currentMode,
    this.isLoading = false,
    this.error,
  });
  
  AITutorState copyWith({
    AITutorSession? currentSession,
    List<AITutorMessage>? messages,
    String? currentMode,
    bool? isLoading,
    String? error,
  }) {
    return AITutorState(
      currentSession: currentSession ?? this.currentSession,
      messages: messages ?? this.messages,
      currentMode: currentMode ?? this.currentMode,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final aiTutorNotifierProvider = StateNotifierProvider<AITutorNotifier, AITutorState>((ref) {
  return AITutorNotifier(ref.watch(aiTutorRepositoryProvider));
});
