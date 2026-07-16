import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_client.dart';
import '../../../view_models/providers.dart';
import '../../../data/practice/practice_result.dart';
import '../../../data/practice/practice_round_item.dart';
import '../data/mission_service.dart';
import '../domain/mission_game_type.dart';
import '../domain/mission_models.dart';

/// Mission runner state machine — port of web `mission-session-runner.tsx`.
///
/// States: `resumePreStep → inRound → completed`. The engine drives whole
/// **rounds** (not individual words) through the shared practice-view round
/// types (P4): each playable round is dispatched to
/// [PracticeListeningView]/[PracticeWritingView] based on
/// [canonicalMissionGame], mirroring web's unified `<PracticeSession>`.
/// `resumePreStep` is skipped entirely when the mission has no
/// `resume_items` (mirrors web `showResume = resumeItems.length > 0 &&
/// !resumeDone`).
///
/// Persistence is mission-native (`completeRound` per round, `completeMission`
/// once) — NEVER FSRS (`/user/srs/review`).
enum MissionRunnerStatus { resumePreStep, inRound, completed }

enum MissionSessionError { roundNotSaved, missionNotCompleted }

class MissionSessionState {
  const MissionSessionState({
    required this.status,
    required this.mission,
    required this.playableRounds,
    this.roundIndex = 0,
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
  final int totalCorrect;
  final int totalAnswered;
  final CompleteMissionResult? result;
  final bool submitting;
  final MissionSessionError? error;

  bool get hasRounds => playableRounds.isNotEmpty;

  MissionRound? get currentRound =>
      roundIndex < playableRounds.length ? playableRounds[roundIndex] : null;

  /// Round items for the current round, in the shared source-agnostic shape
  /// consumed by the P4 practice views.
  List<PracticeRoundItem> get currentRoundItems {
    final round = currentRound;
    if (round == null) return const [];
    return round.wordIds
        .map(mission.wordById)
        .whereType<DailyMissionWord>()
        .map(PracticeRoundItem.fromMissionWord)
        .toList(growable: false);
  }

  MissionCanonicalGame? get currentGame {
    final round = currentRound;
    return round == null ? null : canonicalMissionGame(round.gameType);
  }

  MissionSessionState copyWith({
    MissionRunnerStatus? status,
    int? roundIndex,
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
    final showResume = mission.resumeItems.isNotEmpty;
    final initialStatus = !showResume && playableRounds.isEmpty
        ? MissionRunnerStatus.completed
        : showResume
            ? MissionRunnerStatus.resumePreStep
            : MissionRunnerStatus.inRound;

    if (initialStatus != MissionRunnerStatus.completed) {
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

  /// ResumePreStep → first playable round (mirrors web `setResumeDone(true)`).
  void completeResumeStep() {
    final s = state.value;
    if (s == null || s.status != MissionRunnerStatus.resumePreStep) return;
    state = AsyncData(
      s.copyWith(
        status: s.hasRounds
            ? MissionRunnerStatus.inRound
            : MissionRunnerStatus.completed,
      ),
    );
  }

  /// The active round's practice view reports its results → persist the
  /// round, then advance to the next round or finish the mission (mirrors
  /// web `handleRoundResults` + `handleComplete`).
  Future<void> submitRoundResults(List<PracticeResultEntry> results) async {
    final s = state.value;
    if (s == null || s.status != MissionRunnerStatus.inRound || s.submitting) {
      return;
    }
    final round = s.currentRound;
    if (round == null) return;

    final correct = results.where((r) => r.correct).length;
    state = AsyncData(
      s.copyWith(
        submitting: true,
        clearError: true,
        totalCorrect: s.totalCorrect + correct,
        totalAnswered: s.totalAnswered + results.length,
      ),
    );

    final saved = await _completeRound(s, round, results);
    if (!saved) {
      state = AsyncData(
        state.value!.copyWith(
          submitting: false,
          error: MissionSessionError.roundNotSaved,
        ),
      );
      return;
    }

    final current = state.value!;
    final nextRoundIndex = current.roundIndex + 1;
    if (nextRoundIndex < current.playableRounds.length) {
      state = AsyncData(
        current.copyWith(
          roundIndex: nextRoundIndex,
          submitting: false,
          clearError: true,
        ),
      );
      return;
    }

    final result = await _completeMission(current);
    if (result == null) {
      state = AsyncData(
        state.value!.copyWith(
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
          metadata: {'answered_count': current.totalAnswered},
        );
    state = AsyncData(
      state.value!.copyWith(
        status: MissionRunnerStatus.completed,
        result: result,
        submitting: false,
        clearError: true,
      ),
    );
  }

  Future<bool> _completeRound(
    MissionSessionState s,
    MissionRound round,
    List<PracticeResultEntry> results,
  ) async {
    final total = results.length.clamp(1, 1 << 30);
    final correct = results.where((r) => r.correct).length;
    final payload = CompleteRoundPayload(
      score: ((correct / total) * 100).round(),
      answers: results
          .map((r) => MissionRoundAnswer(itemId: r.cardId, correct: r.correct))
          .toList(),
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
