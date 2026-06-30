import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ai_repository.dart';
import '../data/mock_data.dart';
import '../domain/ai_models.dart';

final aiRepositoryProvider = Provider<AIRepository>((ref) => AIRepository());

final aiChatHistoryProvider = FutureProvider<List<ChatHistoryItem>>((ref) async {
  final repo = ref.watch(aiRepositoryProvider);
  return repo.getChatHistory();
});

final aiSessionsProvider = FutureProvider<List<AISession>>((ref) async {
  final repo = ref.watch(aiRepositoryProvider);
  return repo.getSessions();
});

final aiModesProvider = FutureProvider<List<AIMode>>((ref) async {
  final repo = ref.watch(aiRepositoryProvider);
  return repo.getModes();
});

final aiSettingsProvider = FutureProvider<AISettings>((ref) async {
  final repo = ref.watch(aiRepositoryProvider);
  return repo.getSettings();
});

final aiWritingPracticesProvider = FutureProvider<List<WritingPractice>>((ref) async {
  final repo = ref.watch(aiRepositoryProvider);
  return repo.getWritingPractices();
});

// Simple mutable state classes for use with Provider

class AIChatState {
  final AISession? currentSession;
  final List<AIChatMessage> messages;
  final String currentMode;
  final bool isLoading;
  final String? error;
  
  AIChatState({
    this.currentSession,
    this.messages = const [],
    this.currentMode = 'grammar',
    this.isLoading = false,
    this.error,
  });
  
  AIChatState copyWith({
    AISession? currentSession,
    List<AIChatMessage>? messages,
    String? currentMode,
    bool? isLoading,
    String? error,
  }) {
    return AIChatState(
      currentSession: currentSession ?? this.currentSession,
      messages: messages ?? this.messages,
      currentMode: currentMode ?? this.currentMode,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Provider-based state management (without StateNotifier)
class AIChatNotifier {
  final AIRepository _repo;
  AIChatState _state = AIChatState();
  
  AIChatNotifier(this._repo);
  
  AIChatState get state => _state;
  
  Future<void> startNewSession(String mode) async {
    _state = _state.copyWith(isLoading: true, error: null);
    
    try {
      final session = await _repo.createSession(mode);
      _state = _state.copyWith(
        currentSession: session,
        messages: session.messages,
        isLoading: false,
        currentMode: mode,
      );
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  Future<void> loadSession(String sessionId) async {
    _state = _state.copyWith(isLoading: true, error: null);
    
    try {
      final session = await _repo.getSession(sessionId);
      if (session != null) {
        _state = _state.copyWith(
          currentSession: session,
          messages: session.messages,
          isLoading: false,
          currentMode: session.mode,
        );
      } else {
        _state = _state.copyWith(isLoading: false, error: 'Session not found');
      }
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    
    final userMsg = AIChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: _state.currentSession?.id ?? 'new',
      role: 'user',
      content: content,
      createdAt: DateTime.now(),
    );
    
    _state = _state.copyWith(
      messages: [..._state.messages, userMsg],
      isLoading: true,
      error: null,
    );
    
    try {
      final response = await _repo.sendMessage(
        sessionId: _state.currentSession?.id ?? 'new',
        content: content,
        mode: _state.currentMode,
      );
      
      _state = _state.copyWith(
        messages: [..._state.messages, response],
        isLoading: false,
      );
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  void clearSession() {
    _state = AIChatState();
  }
}

final aiChatNotifierProvider = Provider<AIChatNotifier>((ref) {
  return AIChatNotifier(ref.watch(aiRepositoryProvider));
});

final aiChatStateProvider = Provider<AIChatState>((ref) {
  return ref.watch(aiChatNotifierProvider).state;
});

// Writing State
class AIWritingState {
  final List<WritingPractice> practices;
  final WritingPractice? lastSubmitted;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  
  AIWritingState({
    this.practices = const [],
    this.lastSubmitted,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
  });
  
  AIWritingState copyWith({
    List<WritingPractice>? practices,
    WritingPractice? lastSubmitted,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
  }) {
    return AIWritingState(
      practices: practices ?? this.practices,
      lastSubmitted: lastSubmitted,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

class AIWritingNotifier {
  final AIRepository _repo;
  AIWritingState _state = AIWritingState();
  
  AIWritingNotifier(this._repo);
  
  AIWritingState get state => _state;
  
  Future<void> loadPractices() async {
    _state = _state.copyWith(isLoading: true);
    
    try {
      final practices = await _repo.getWritingPractices();
      _state = _state.copyWith(practices: practices, isLoading: false);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  Future<void> submitPractice(String practiceId, String content) async {
    _state = _state.copyWith(isSubmitting: true, error: null);
    
    try {
      final updated = await _repo.submitWriting(
        practiceId: practiceId,
        content: content,
      );
      
      final updatedPractices = _state.practices.map((p) {
        return p.id == practiceId ? updated : p;
      }).toList();
      
      _state = _state.copyWith(
        practices: updatedPractices,
        isSubmitting: false,
        lastSubmitted: updated,
      );
    } catch (e) {
      _state = _state.copyWith(isSubmitting: false, error: e.toString());
    }
  }
  
  void clearSubmission() {
    _state = _state.copyWith(lastSubmitted: null);
  }
}

final aiWritingNotifierProvider = Provider<AIWritingNotifier>((ref) {
  return AIWritingNotifier(ref.watch(aiRepositoryProvider));
});

final aiWritingStateProvider = Provider<AIWritingState>((ref) {
  return ref.watch(aiWritingNotifierProvider).state;
});

// Settings State
class AISettingsNotifier {
  final AIRepository _repo;
  AISettings _state = AIMockData.mockSettings;
  
  AISettingsNotifier(this._repo);
  
  AISettings get state => _state;
  
  Future<void> loadSettings() async {
    try {
      final settings = await _repo.getSettings();
      _state = settings;
    } catch (_) {
      // Keep default settings
    }
  }
  
  Future<void> updateSettings(AISettings settings) async {
    try {
      final updated = await _repo.updateSettings(settings);
      _state = updated;
    } catch (_) {
      // Keep current state
    }
  }
  
  void updateLevel(String level) {
    _state = _state.copyWith(userLevel: level);
  }
  
  void toggleTranslations() {
    _state = _state.copyWith(includeTranslations: !_state.includeTranslations);
  }
  
  void toggleGrammarHints() {
    _state = _state.copyWith(showGrammarHints: !_state.showGrammarHints);
  }
  
  void toggleVocabularyHighlights() {
    _state = _state.copyWith(showVocabularyHighlights: !_state.showVocabularyHighlights);
  }
  
  void setFocusExam(String exam) {
    _state = _state.copyWith(focusExam: exam);
  }
}

final aiSettingsNotifierProvider = Provider<AISettingsNotifier>((ref) {
  return AISettingsNotifier(ref.watch(aiRepositoryProvider));
});

final aiSettingsStateProvider = Provider<AISettings>((ref) {
  return ref.watch(aiSettingsNotifierProvider).state;
});
