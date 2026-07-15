import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/ai/ai_chat_live_models.dart';
import '../../data/ai/ai_models.dart';
import '../../repositories/ai/ai_repository.dart';
import '../../repositories/ai/mock_data.dart';

// ── Chat (live, streaming) ──────────────────────────────────────────────────

/// One chat bubble in the UI. Distinct from [ChatMessageDto] (the persisted
/// server shape) because the assistant bubble mutates in place while tokens
/// stream in.
class AiChatUiMessage {
  const AiChatUiMessage({
    required this.id,
    required this.role,
    required this.content,
    this.isStreaming = false,
    this.attachments = const [],
  });

  final String id;
  final String role; // "user" | "assistant"
  final String content;
  final bool isStreaming;
  final List<ChatAttachment> attachments;

  AiChatUiMessage copyWith({String? content, bool? isStreaming}) =>
      AiChatUiMessage(
        id: id,
        role: role,
        content: content ?? this.content,
        isStreaming: isStreaming ?? this.isStreaming,
        attachments: attachments,
      );
}

/// Which non-fatal banner (if any) the chat screen should show above the
/// input bar. `error` covers both a rejected request and an in-band SSE error
/// chunk — both are retryable via [AiChatNotifier.retry].
enum AiChatBannerKind { none, quotaExceeded, sessionLimitReached, error }

class AiChatState {
  const AiChatState({
    this.sessionId,
    this.messages = const [],
    this.isSending = false,
    this.banner = AiChatBannerKind.none,
    this.bannerMessage,
    this.sessions = const [],
    this.sessionsLoading = false,
  });

  final String? sessionId;
  final List<AiChatUiMessage> messages;
  final bool isSending;
  final AiChatBannerKind banner;
  final String? bannerMessage;
  final List<ChatSessionSummary> sessions;
  final bool sessionsLoading;

  AiChatState copyWith({
    String? sessionId,
    List<AiChatUiMessage>? messages,
    bool? isSending,
    AiChatBannerKind? banner,
    String? bannerMessage,
    bool clearBanner = false,
    List<ChatSessionSummary>? sessions,
    bool? sessionsLoading,
  }) {
    return AiChatState(
      sessionId: sessionId ?? this.sessionId,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      banner: clearBanner ? AiChatBannerKind.none : (banner ?? this.banner),
      bannerMessage: clearBanner ? null : (bannerMessage ?? this.bannerMessage),
      sessions: sessions ?? this.sessions,
      sessionsLoading: sessionsLoading ?? this.sessionsLoading,
    );
  }
}

class AiChatNotifier extends StateNotifier<AiChatState> {
  AiChatNotifier(this._repo) : super(const AiChatState());

  final AIRepository _repo;
  CancelToken? _cancelToken;
  String _lastUserContent = '';

  /// GET /ai/sessions — for the history sidebar.
  Future<void> loadSessions() async {
    state = state.copyWith(sessionsLoading: true);
    try {
      final sessions = await _repo.getSessions();
      state = state.copyWith(sessions: sessions, sessionsLoading: false);
    } catch (_) {
      state = state.copyWith(sessionsLoading: false);
    }
  }

  /// Resumes a previous session by fetching its full history.
  Future<void> resumeSession(String sessionId) async {
    _cancelToken?.cancel();
    state = AiChatState(sessions: state.sessions, sessionId: sessionId);
    try {
      final history = await _repo.getSessionMessages(sessionId);
      state = state.copyWith(
        messages: history
            .map(
              (m) => AiChatUiMessage(
                id: m.id,
                role: m.role,
                content: m.content,
                attachments: m.attachments,
              ),
            )
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(banner: AiChatBannerKind.error, bannerMessage: '$e');
    }
  }

  /// Clears the transcript; the next [sendMessage] creates a fresh session.
  void startNewSession() {
    _cancelToken?.cancel();
    state = AiChatState(sessions: state.sessions);
  }

  /// Sends one chat turn and streams the assistant reply into the transcript
  /// token-by-token.
  Future<void> sendMessage(
    String content, {
    List<ChatAttachment> attachments = const [],
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || state.isSending) return;
    _lastUserContent = trimmed;

    final now = DateTime.now().microsecondsSinceEpoch;
    final userMsg = AiChatUiMessage(
      id: 'local-$now-u',
      role: 'user',
      content: trimmed,
      attachments: attachments,
    );
    final assistantId = 'local-$now-a';
    state = state.copyWith(
      messages: [
        ...state.messages,
        userMsg,
        AiChatUiMessage(id: assistantId, role: 'assistant', content: '', isStreaming: true),
      ],
      isSending: true,
      clearBanner: true,
    );

    _cancelToken = CancelToken();
    var receivedAnyToken = false;
    try {
      await for (final event in _repo.sendMessage(
        content: trimmed,
        sessionId: state.sessionId,
        attachments: attachments,
        cancelToken: _cancelToken,
        onSessionId: (id) => state = state.copyWith(sessionId: id),
      )) {
        switch (event) {
          case AiChatContentEvent(:final text):
            receivedAnyToken = true;
            _appendToken(assistantId, text);
          case AiChatErrorEvent(:final message):
            state = state.copyWith(banner: AiChatBannerKind.error, bannerMessage: message);
          case AiChatDoneEvent():
            break;
        }
      }
      state = state.copyWith(
        messages: _mapMessage(assistantId, (m) => m.copyWith(isStreaming: false)),
        isSending: false,
      );
      if (!receivedAnyToken) {
        // Nothing ever streamed (e.g. immediate in-band error) — drop the
        // empty placeholder bubble instead of showing a blank reply.
        state = state.copyWith(
          messages: state.messages.where((m) => m.id != assistantId).toList(),
        );
      }
    } on AiChatRequestException catch (e) {
      state = state.copyWith(
        messages: state.messages.where((m) => m.id != assistantId).toList(),
        isSending: false,
        banner: e.isQuotaExceeded
            ? AiChatBannerKind.quotaExceeded
            : e.isSessionLimitReached
            ? AiChatBannerKind.sessionLimitReached
            : AiChatBannerKind.error,
        bannerMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        messages: _mapMessage(assistantId, (m) => m.copyWith(isStreaming: false)),
        isSending: false,
        banner: AiChatBannerKind.error,
        bannerMessage: '$e',
      );
    }
  }

  void _appendToken(String assistantId, String text) {
    state = state.copyWith(
      messages: _mapMessage(assistantId, (m) => m.copyWith(content: m.content + text)),
    );
  }

  List<AiChatUiMessage> _mapMessage(
    String id,
    AiChatUiMessage Function(AiChatUiMessage) update,
  ) => [
    for (final m in state.messages) if (m.id == id) update(m) else m,
  ];

  /// Retries the last user turn after an error banner. Drops the failed
  /// attempt's user bubble first so the retry doesn't duplicate it (a new one
  /// is re-added by [sendMessage]).
  Future<void> retry() async {
    if (_lastUserContent.isEmpty) return;
    final messages = [...state.messages];
    if (messages.isNotEmpty && messages.last.role == 'user') {
      messages.removeLast();
    }
    state = state.copyWith(messages: messages, clearBanner: true);
    await sendMessage(_lastUserContent);
  }

  /// Aborts an in-flight stream (e.g. user navigates away mid-response).
  void cancelStreaming() {
    _cancelToken?.cancel();
    state = state.copyWith(
      isSending: false,
      messages: [
        for (final m in state.messages)
          if (m.isStreaming) m.copyWith(isStreaming: false) else m,
      ],
    );
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }
}

final aiChatNotifierProvider =
    StateNotifierProvider.autoDispose<AiChatNotifier, AiChatState>((ref) {
      return AiChatNotifier(ref.watch(aiRepositoryProvider));
    });

/// GET /ai/chat-status — daily/session quota banner data.
final aiChatStatusProvider = FutureProvider.autoDispose<ChatStatus>((ref) {
  return ref.watch(aiRepositoryProvider).getChatStatus();
});

// ── Memory (GET/DELETE /ai/memory) ──────────────────────────────────────────

class AiMemoryState {
  const AiMemoryState({this.facts = const [], this.isLoading = false, this.error});

  final List<AiMemoryFact> facts;
  final bool isLoading;
  final String? error;

  AiMemoryState copyWith({List<AiMemoryFact>? facts, bool? isLoading, String? error}) =>
      AiMemoryState(
        facts: facts ?? this.facts,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class AiMemoryNotifier extends StateNotifier<AiMemoryState> {
  AiMemoryNotifier(this._repo) : super(const AiMemoryState());
  final AIRepository _repo;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final facts = await _repo.getMemory();
      state = state.copyWith(facts: facts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '$e');
    }
  }

  Future<void> deleteFact(String factKey) async {
    final previous = state.facts;
    state = state.copyWith(facts: previous.where((f) => f.factKey != factKey).toList());
    try {
      await _repo.deleteMemoryFact(factKey);
    } catch (e) {
      state = state.copyWith(facts: previous, error: '$e');
    }
  }

  Future<void> deleteAll() async {
    final previous = state.facts;
    state = state.copyWith(facts: const []);
    try {
      await _repo.deleteAllMemory();
    } catch (e) {
      state = state.copyWith(facts: previous, error: '$e');
    }
  }
}

final aiMemoryNotifierProvider =
    StateNotifierProvider.autoDispose<AiMemoryNotifier, AiMemoryState>((ref) {
      return AiMemoryNotifier(ref.watch(aiRepositoryProvider));
    });

// ── Profile (GET/PUT /ai/profile — user-authored "Tiger AI Memory") ────────

class AiProfileFormState {
  const AiProfileFormState({
    this.profile = const AiProfile(),
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final AiProfile profile;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  AiProfileFormState copyWith({
    AiProfile? profile,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) => AiProfileFormState(
    profile: profile ?? this.profile,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    error: error,
  );
}

class AiProfileNotifier extends StateNotifier<AiProfileFormState> {
  AiProfileNotifier(this._repo) : super(const AiProfileFormState());
  final AIRepository _repo;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profile = await _repo.getProfile();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '$e');
    }
  }

  Future<void> save({required Map<String, String> fields, required List<String> notes}) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      final profile = await _repo.updateProfile(fields: fields, notes: notes);
      state = state.copyWith(profile: profile, isSaving: false);
    } catch (e) {
      state = state.copyWith(isSaving: false, error: '$e');
    }
  }
}

final aiProfileNotifierProvider =
    StateNotifierProvider.autoDispose<AiProfileNotifier, AiProfileFormState>((ref) {
      return AiProfileNotifier(ref.watch(aiRepositoryProvider));
    });

// ── Writing practice (mock — see AIWritingMockRepository) ───────────────────

final aiWritingPracticesProvider = FutureProvider<List<WritingPractice>>((ref) async {
  return ref.watch(aiWritingMockRepositoryProvider).getWritingPractices();
});

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
  final AIWritingMockRepository _repo;
  AIWritingState _state = AIWritingState();

  AIWritingNotifier(this._repo);

  AIWritingState get state => _state;

  Future<void> loadPractices() async {
    _state = _state.copyWith(isLoading: true);

    try {
      final practices = await _repo.getWritingPractices();
      _state = _state.copyWith(practices: practices, isLoading: false);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: '$e');
    }
  }

  Future<void> submitPractice(String practiceId, String content) async {
    _state = _state.copyWith(isSubmitting: true, error: null);

    try {
      final updated = await _repo.submitWriting(practiceId: practiceId, content: content);

      final updatedPractices = _state.practices.map((p) {
        return p.id == practiceId ? updated : p;
      }).toList();

      _state = _state.copyWith(
        practices: updatedPractices,
        isSubmitting: false,
        lastSubmitted: updated,
      );
    } catch (e) {
      _state = _state.copyWith(isSubmitting: false, error: '$e');
    }
  }

  void clearSubmission() {
    _state = _state.copyWith(lastSubmitted: null);
  }
}

final aiWritingNotifierProvider = Provider<AIWritingNotifier>((ref) {
  return AIWritingNotifier(ref.watch(aiWritingMockRepositoryProvider));
});

final aiWritingStateProvider = Provider<AIWritingState>((ref) {
  return ref.watch(aiWritingNotifierProvider).state;
});
