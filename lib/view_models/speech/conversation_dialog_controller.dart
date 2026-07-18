import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/speech/conversation_models.dart';
import '../../repositories/speech/conversation_repository.dart';
import '../../repositories/speech/conversation_session_repository.dart';
import '../../services/api_client.dart';

/// Identity + payload for one live dialog run — passed as the family key to
/// [conversationDialogControllerProvider]. `cacheKey` must be stable across
/// rebuilds of the same conversation (scenario id, `custom`, or
/// `interview:<uuid>`) so Riverpod doesn't recreate the controller on every
/// frame.
@immutable
class ConversationDialogArgs {
  const ConversationDialogArgs({
    required this.cacheKey,
    required this.scenario,
  });

  final String cacheKey;
  final Scenario scenario;

  @override
  bool operator ==(Object other) =>
      other is ConversationDialogArgs &&
      other.cacheKey == cacheKey &&
      identical(other.scenario, scenario);

  @override
  int get hashCode => Object.hash(cacheKey, identityHashCode(scenario));
}

/// Immutable snapshot of one live conversation run.
@immutable
class ConversationDialogState {
  const ConversationDialogState({
    this.messages = const [],
    this.initializing = true,
    this.sending = false,
    this.sessionDone = false,
    this.coverage = const [],
    this.error,
  });

  final List<DialogMessage> messages;
  final bool initializing;
  final bool sending;
  final bool sessionDone;
  final List<CoveragePoint> coverage;
  final String? error;

  int get userTurns => messages.where((m) => m.isUser).length;

  ConversationDialogState copyWith({
    List<DialogMessage>? messages,
    bool? initializing,
    bool? sending,
    bool? sessionDone,
    List<CoveragePoint>? coverage,
    String? error,
    bool clearError = false,
  }) => ConversationDialogState(
    messages: messages ?? this.messages,
    initializing: initializing ?? this.initializing,
    sending: sending ?? this.sending,
    sessionDone: sessionDone ?? this.sessionDone,
    coverage: coverage ?? this.coverage,
    error: clearError ? null : (error ?? this.error),
  );
}

/// Drives the live text-chat loop for one conversation scenario: opening
/// line → user sends → `/turn` → AI reply (+coverage/session-done). Mic/
/// voice turn input is MASTER P8 scope — this controller only exposes the
/// text-composer path.
class ConversationDialogController
    extends StateNotifier<ConversationDialogState> {
  ConversationDialogController({
    required this._repository,
    required this._sessionRepository,
    required this.args,
  }) : super(const ConversationDialogState()) {
    _loadOpening();
  }

  final ConversationRepository _repository;
  final ConversationSessionRepository _sessionRepository;
  final ConversationDialogArgs args;

  Scenario get scenario => args.scenario;

  Future<void> _loadOpening() async {
    state = state.copyWith(initializing: true, clearError: true);
    try {
      final aiMessage = await _repository.fetchOpening(
        scenarioId: scenario.id,
        customScenario: CustomScenarioPayload.fromScenario(scenario),
      );
      final text = aiMessage.trim().isNotEmpty
          ? aiMessage
          : scenario.starterPromptDe;
      state = state.copyWith(
        messages: [DialogMessage(role: 'ai', text: text)],
        initializing: false,
      );
    } on ApiException {
      // Fall back to the scenario's static starter line so the chat is
      // always usable even when the opening AI call fails.
      state = state.copyWith(
        messages: [DialogMessage(role: 'ai', text: scenario.starterPromptDe)],
        initializing: false,
      );
    }
  }

  /// Sends the learner's typed message and appends the AI reply. No-op
  /// while a previous send is in flight, the session already ended, or the
  /// message is blank.
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.sending || state.sessionDone) return;

    final historyBeforeTurn = state.messages;
    final userMessage = DialogMessage(role: 'user', text: trimmed);
    state = state.copyWith(
      messages: [...historyBeforeTurn, userMessage],
      sending: true,
      clearError: true,
    );

    try {
      final response = await _repository.postTurn(
        scenarioId: scenario.id,
        history: historyBeforeTurn,
        userMessage: trimmed,
        customScenario: CustomScenarioPayload.fromScenario(scenario),
      );
      state = state.copyWith(
        messages: [
          ...state.messages,
          DialogMessage(role: 'ai', text: response.aiMessage),
        ],
        sending: false,
        sessionDone: response.sessionDone,
        coverage: response.coverage.isNotEmpty
            ? response.coverage
            : state.coverage,
      );
    } on ApiException catch (e) {
      state = state.copyWith(sending: false, error: e.message);
    }
  }

  /// Persists the finished/abandoned session (no audio). Idempotent per
  /// controller instance via [_saved].
  bool _saved = false;

  Future<void> persistSession() async {
    if (_saved || state.userTurns < 1) return;
    _saved = true;
    final title = scenario.isCustom
        ? (scenario.customTopic?.isNotEmpty == true
              ? scenario.customTopic!
              : scenario.titleVi)
        : (scenario.titleDe.isNotEmpty ? scenario.titleDe : scenario.titleVi);
    try {
      await _sessionRepository.saveSession(
        scenarioId: args.cacheKey,
        title: title.isNotEmpty ? title : 'Hội thoại',
        level: scenario.level,
        userTurns: state.userTurns,
        messages: state.messages,
      );
    } on ApiException {
      _saved = false; // allow a later retry (e.g. on exit)
    }
  }

  /// Resets the run in place ("Thực hành lại").
  void restart() {
    _saved = false;
    state = const ConversationDialogState();
    _loadOpening();
  }
}
