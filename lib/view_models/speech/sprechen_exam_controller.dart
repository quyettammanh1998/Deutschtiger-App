import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/speech/sprechen_chat_models.dart';
import '../../data/speech/sprechen_session_models.dart';
import '../../repositories/speech/sprechen_ai_repository.dart';
import '../../repositories/speech/sprechen_session_repository.dart';
import 'sprechen_ai_repository_provider.dart';
import 'sprechen_session_provider.dart';

/// Practice-tab state for one `SprechenExamMode` instance: the text-chat
/// transcript with Tiger (AI partner) plus the resulting Bewertung
/// (grading). Text-only per phase scope — no mic/STT wiring here.
class SprechenExamState {
  const SprechenExamState({
    this.teil = '',
    this.topic = '',
    this.started = false,
    this.messages = const [],
    this.grading,
    this.submitting = false,
    this.error,
  });

  final String teil;
  final String topic;
  final bool started;
  final List<SprechenChatMessage> messages;
  final SprechenGrading? grading;
  final bool submitting;
  final String? error;

  SprechenExamState copyWith({
    bool? started,
    List<SprechenChatMessage>? messages,
    SprechenGrading? grading,
    bool? submitting,
    String? error,
  }) {
    return SprechenExamState(
      teil: teil,
      topic: topic,
      started: started ?? this.started,
      messages: messages ?? this.messages,
      grading: grading ?? this.grading,
      submitting: submitting ?? this.submitting,
      error: error,
    );
  }
}

class SprechenExamController extends StateNotifier<SprechenExamState> {
  SprechenExamController(
    this._ai,
    this._sessions, {
    required String teil,
    required String topic,
  }) : super(SprechenExamState(teil: teil, topic: topic));

  final SprechenAiRepository _ai;
  final SprechenSessionRepository _sessions;

  List<Map<String, String>> get _history => state.messages
      .where((m) => !m.pending)
      .map(
        (m) => {
          'role': m.role == SprechenChatRole.user ? 'user' : 'assistant',
          'text': m.text,
        },
      )
      .toList();

  void start() {
    if (state.started) return;
    state = state.copyWith(started: true);
  }

  /// Sends a user turn: appends the bubble, requests per-turn feedback and
  /// the partner's next line in parallel, then folds both results in.
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.submitting) return;

    final userMessage = SprechenChatMessage(
      role: SprechenChatRole.user,
      text: trimmed,
    );
    final pendingReply = const SprechenChatMessage(
      role: SprechenChatRole.assistant,
      text: '',
      pending: true,
    );
    state = state.copyWith(
      messages: [...state.messages, userMessage, pendingReply],
      submitting: true,
      error: null,
    );

    try {
      final historyBeforeReply = _history;
      final results = await Future.wait([
        _ai.partnerReply(
          teil: state.teil,
          topic: state.topic,
          history: historyBeforeReply,
          userMessage: trimmed,
        ),
        _ai.turnFeedback(teil: state.teil, userMessage: trimmed),
      ]);
      final reply = results[0] as String;
      final feedback = results[1] as ({int score, String comment});

      final updated = [...state.messages];
      // userMessage is second-to-last, pendingReply is last.
      final userIndex = updated.length - 2;
      updated[userIndex] = updated[userIndex].copyWith(
        feedbackScore: feedback.score,
        feedbackComment: feedback.comment,
      );
      updated[updated.length - 1] = SprechenChatMessage(
        role: SprechenChatRole.assistant,
        text: reply,
      );
      state = state.copyWith(messages: updated, submitting: false);
    } catch (e) {
      final updated = [...state.messages]..removeLast();
      state = state.copyWith(
        messages: updated,
        submitting: false,
        error: 'Không gửi được tin nhắn. Thử lại.',
      );
    }
  }

  Future<List<String>> fetchSuggestions() async {
    try {
      return await _ai.suggestions(
        teil: state.teil,
        topic: state.topic,
        history: _history,
      );
    } catch (_) {
      return const [];
    }
  }

  /// ABGABE (submit) — requests final grading from the transcript so far.
  Future<void> submitForGrading() async {
    if (state.submitting) return;
    state = state.copyWith(submitting: true, error: null);
    try {
      final grading = await _ai.gradeSprechen(
        teil: state.teil,
        topic: state.topic,
        history: _history,
      );
      state = state.copyWith(grading: grading, submitting: false);
      // Best-effort save — a failed save must not block showing the result
      // screen, the user already sees their score either way.
      unawaited(
        _sessions.submitResult(
          SprechenResult(
            teil: state.teil,
            topicSlug: state.topic,
            score: grading.total,
            grade: grading.total >= grading.max * 0.8 ? 'pass' : 'retry',
          ),
        ),
      );
    } catch (e) {
      state = state.copyWith(
        submitting: false,
        error: 'Không chấm điểm được. Thử lại.',
      );
    }
  }
}

/// One controller instance per (teil, topic) practice session.
final sprechenExamControllerProvider = StateNotifierProvider.family<
  SprechenExamController,
  SprechenExamState,
  ({String teil, String topic})
>((ref, args) {
  return SprechenExamController(
    ref.watch(sprechenAiRepositoryProvider),
    ref.watch(sprechenSessionRepositoryProvider),
    teil: args.teil,
    topic: args.topic,
  );
});
