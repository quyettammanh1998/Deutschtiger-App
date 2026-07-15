import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_client.dart';
import '../../../view_models/providers.dart';
import '../data/mission_service.dart';
import '../domain/mission_models.dart';

/// Mission runner state machine — port of web `mission-session-runner.tsx`.
///
/// States: `idle → starting → in_word_intro → in_practice → between_words →
/// completed` (per phase-05 §B3). `idle`/`starting` collapse into the
/// provider's `AsyncLoading` (fetch mission + `POST .../start`); the notifier
/// then drives `inWordIntro → inPractice → betweenWords` per word and
/// `completed` once every playable round + the mission itself are persisted.
///
/// Persistence is mission-native (`completeRound` per round, `completeMission`
/// once) — NEVER FSRS (`/user/srs/review`). Mirrors the web runner's comment:
/// "the engine owns the round flow; this runner owns persistence".
enum MissionRunnerStatus {
  idle,
  starting,
  inWordIntro,
  inPractice,
  betweenWords,
  completed,
}

enum MissionSessionError { roundNotSaved, missionNotCompleted }

class MissionSessionState {
  const MissionSessionState({
    required this.status,
    required this.mission,
    required this.playableRounds,
    this.roundIndex = 0,
    this.wordIndexInRound = 0,
    this.roundAnswers = const <MissionRoundAnswer>[],
    this.lastAnswerCorrect,
    this.totalCorrect = 0,
    this.totalAnswered = 0,
    this.result,
    this.submitting = false,
    this.error,
  });

  final MissionRunnerStatus status;
  final DailyMission mission;

  /// Rounds with `game_type != 'resume'` — the resume pre-step is not part of
  /// the playable flow (mirrors web `mission.rounds.filter(r => r.game_type
  /// !== 'resume')`).
  final List<MissionRound> playableRounds;

  final int roundIndex;
  final int wordIndexInRound;

  /// Answers collected so far for the round in progress — flushed to
  /// `completeRound` when the round finishes.
  final List<MissionRoundAnswer> roundAnswers;

  final bool? lastAnswerCorrect;
  final int totalCorrect;
  final int totalAnswered;
  final CompleteMissionResult? result;
  final bool submitting;
  final MissionSessionError? error;

  /// Total playable words across all rounds (for progress + final score).
  int get totalWords =>
      playableRounds.fold(0, (sum, r) => sum + r.wordIds.length);

  /// 1-based overall word position (for progress display).
  int get overallPosition {
    var count = 0;
    for (var i = 0; i < roundIndex; i++) {
      count += playableRounds[i].wordIds.length;
    }
    return count + wordIndexInRound + 1;
  }

  MissionRound? get currentRound =>
      roundIndex < playableRounds.length ? playableRounds[roundIndex] : null;

  DailyMissionWord? get currentWord {
    final round = currentRound;
    if (round == null || wordIndexInRound >= round.wordIds.length) {
      return null;
    }
    return mission.wordById(round.wordIds[wordIndexInRound]);
  }

  bool get hasWords => totalWords > 0;

  MissionSessionState copyWith({
    MissionRunnerStatus? status,
    int? roundIndex,
    int? wordIndexInRound,
    List<MissionRoundAnswer>? roundAnswers,
    bool? lastAnswerCorrect,
    bool clearLastAnswer = false,
    int? totalCorrect,
    int? totalAnswered,
    CompleteMissionResult? result,
    bool? submitting,
    MissionSessionError? error,
    bool clearError = false,
  }) {
    return MissionSessionState(
      status: status ?? this.status,
      mission: mission,
      playableRounds: playableRounds,
      roundIndex: roundIndex ?? this.roundIndex,
      wordIndexInRound: wordIndexInRound ?? this.wordIndexInRound,
      roundAnswers: roundAnswers ?? this.roundAnswers,
      lastAnswerCorrect: clearLastAnswer
          ? null
          : (lastAnswerCorrect ?? this.lastAnswerCorrect),
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      result: result ?? this.result,
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

final missionServiceProvider = Provider<MissionService>((ref) {
  return MissionService(ref.watch(apiClientProvider));
});

final todayMissionProvider = FutureProvider<DailyMission>((ref) {
  return ref.watch(missionServiceProvider).fetchTodayMission();
});

class MissionSessionNotifier
    extends AutoDisposeAsyncNotifier<MissionSessionState> {
  @override
  Future<MissionSessionState> build() async {
    final service = ref.watch(missionServiceProvider);
    final mission = await service.fetchTodayMission();

    // startMission is a one-time DB flag flip (`started_at`); best-effort —
    // a failure here shouldn't block the session from running.
    try {
      await service.startMission(mission.id);
    } on ApiException {
      // ignore — non-critical timestamp, session still proceeds.
    }

    final playableRounds = mission.playableRounds;
    final initialStatus = playableRounds.isEmpty
        ? MissionRunnerStatus.completed
        : MissionRunnerStatus.inWordIntro;

    if (initialStatus == MissionRunnerStatus.inWordIntro) {
      ref
          .read(eventTrackingProvider)
          .track(
            'mission_started',
            source: 'mission_action_queue',
            metadata: {'rounds': playableRounds.length},
          );
    }

    return MissionSessionState(
      status: initialStatus,
      mission: mission,
      playableRounds: playableRounds,
    );
  }

  /// WordIntroView → PracticeView.
  void beginPractice() {
    final s = state.value;
    if (s == null || s.status != MissionRunnerStatus.inWordIntro) return;
    state = AsyncData(s.copyWith(status: MissionRunnerStatus.inPractice));
  }

  /// PracticeView reports self-graded recall (correct/incorrect) →
  /// ResultView (`between_words`). Grading here is mission-native pass/fail
  /// bookkeeping for `completeRound`, NOT FSRS — the FSRS queue/rating flow
  /// (Again/Hard/Good/Easy) lives entirely in `reviewSessionProvider`.
  void submitAnswer(bool correct) {
    final s = state.value;
    if (s == null || s.status != MissionRunnerStatus.inPractice) return;
    final word = s.currentWord;
    if (word == null) return;

    state = AsyncData(
      s.copyWith(
        status: MissionRunnerStatus.betweenWords,
        roundAnswers: [
          ...s.roundAnswers,
          MissionRoundAnswer(itemId: word.wordId, correct: correct),
        ],
        lastAnswerCorrect: correct,
        totalCorrect: s.totalCorrect + (correct ? 1 : 0),
        totalAnswered: s.totalAnswered + 1,
      ),
    );
  }

  /// ResultView → next word / next round / completed. Flushes the round's
  /// answers via `completeRound` when a round finishes, then `completeMission`
  /// once after the last round (mirrors web `handleRoundResults` +
  /// `handleComplete`).
  Future<void> advance() async {
    final s = state.value;
    if (s == null ||
        s.status != MissionRunnerStatus.betweenWords ||
        s.submitting) {
      return;
    }

    final round = s.currentRound;
    if (round == null) return;

    final nextWordIndex = s.wordIndexInRound + 1;
    if (nextWordIndex < round.wordIds.length) {
      state = AsyncData(
        s.copyWith(
          status: MissionRunnerStatus.inWordIntro,
          wordIndexInRound: nextWordIndex,
          clearLastAnswer: true,
        ),
      );
      return;
    }

    // Round finished — persist it, then move to the next round or finish.
    state = AsyncData(s.copyWith(submitting: true, clearError: true));
    final roundSaved = await _completeRound(s, round);
    if (!roundSaved) {
      state = AsyncData(
        s.copyWith(submitting: false, error: MissionSessionError.roundNotSaved),
      );
      return;
    }

    final nextRoundIndex = s.roundIndex + 1;
    if (nextRoundIndex < s.playableRounds.length) {
      state = AsyncData(
        s.copyWith(
          status: MissionRunnerStatus.inWordIntro,
          roundIndex: nextRoundIndex,
          wordIndexInRound: 0,
          roundAnswers: const [],
          clearLastAnswer: true,
          submitting: false,
          clearError: true,
        ),
      );
      return;
    }

    final result = await _completeMission(s);
    if (result == null) {
      state = AsyncData(
        s.copyWith(
          submitting: false,
          error: MissionSessionError.missionNotCompleted,
        ),
      );
      return;
    }

    ref
        .read(eventTrackingProvider)
        .track(
          'mission_completed',
          source: 'mission_action_queue',
          metadata: {'answered_count': s.totalAnswered},
        );
    state = AsyncData(
      s.copyWith(
        status: MissionRunnerStatus.completed,
        result: result,
        submitting: false,
        clearError: true,
      ),
    );
  }

  Future<bool> _completeRound(MissionSessionState s, MissionRound round) async {
    final total = s.roundAnswers.length.clamp(1, 1 << 30);
    final correct = s.roundAnswers.where((a) => a.correct).length;
    final payload = CompleteRoundPayload(
      score: ((correct / total) * 100).round(),
      answers: s.roundAnswers,
    );
    try {
      await ref
          .read(missionServiceProvider)
          .completeRound(s.mission.id, round.index, payload);
      return true;
    } on ApiException {
      return false;
    }
  }

  Future<CompleteMissionResult?> _completeMission(MissionSessionState s) async {
    try {
      return await ref
          .read(missionServiceProvider)
          .completeMission(s.mission.id);
    } on ApiException {
      return null;
    }
  }
}

final missionSessionProvider =
    AutoDisposeAsyncNotifierProvider<
      MissionSessionNotifier,
      MissionSessionState
    >(MissionSessionNotifier.new);
