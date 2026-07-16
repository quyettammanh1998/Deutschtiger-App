import 'package:deutschtiger/data/practice/practice_result.dart';
import 'package:deutschtiger/features/mission/data/mission_service.dart';
import 'package:deutschtiger/features/mission/domain/mission_models.dart';
import 'package:deutschtiger/features/mission/presentation/mission_session_provider.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/services/event_tracking.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'one-round mission persists its round and completion end to end',
    () async {
      final service = _FakeMissionService();
      final setup = _container(service);
      addTearDown(setup.dispose);

      final notifier = setup.container.read(missionSessionProvider.notifier);
      var state = await setup.container.read(missionSessionProvider.future);
      expect(state.status, MissionRunnerStatus.inRound);

      await notifier.submitRoundResults(const [
        PracticeResultEntry(cardId: 'word-1', correct: true),
      ]);
      state = setup.container.read(missionSessionProvider).requireValue;

      expect(service.roundCompletions, 1);
      expect(service.missionCompletions, 1);
      expect(state.status, MissionRunnerStatus.completed);
      expect(state.result?.xpAwarded, 20);
    },
  );

  test('failed round persistence stays on the round and can be retried', () async {
    final service = _FakeMissionService(failRound: true);
    final setup = _container(service);
    addTearDown(setup.dispose);

    final notifier = setup.container.read(missionSessionProvider.notifier);
    await setup.container.read(missionSessionProvider.future);
    await notifier.submitRoundResults(const [
      PracticeResultEntry(cardId: 'word-1', correct: false),
    ]);
    final state = setup.container.read(missionSessionProvider).requireValue;

    expect(state.status, MissionRunnerStatus.inRound);
    expect(state.error, MissionSessionError.roundNotSaved);
    expect(service.missionCompletions, 0);
  });

  test('mission with resume_items starts on resumePreStep', () async {
    final service = _FakeMissionService(withResume: true);
    final setup = _container(service);
    addTearDown(setup.dispose);

    final state = await setup.container.read(missionSessionProvider.future);
    expect(state.status, MissionRunnerStatus.resumePreStep);

    setup.container.read(missionSessionProvider.notifier).completeResumeStep();
    final next = setup.container.read(missionSessionProvider).requireValue;
    expect(next.status, MissionRunnerStatus.inRound);
  });
}

({ProviderContainer container, void Function() dispose}) _container(
  MissionService service,
) {
  final tracking = EventTracking(apiClient: _dummyClient());
  final container = ProviderContainer(
    overrides: [
      missionServiceProvider.overrideWithValue(service),
      eventTrackingProvider.overrideWithValue(tracking),
    ],
  );
  final subscription = container.listen(missionSessionProvider, (_, _) {});
  return (
    container: container,
    dispose: () {
      subscription.close();
      tracking.dispose();
      container.dispose();
    },
  );
}

class _FakeMissionService extends MissionService {
  _FakeMissionService({this.failRound = false, this.withResume = false})
      : super(_dummyClient());

  final bool failRound;
  final bool withResume;
  int roundCompletions = 0;
  int missionCompletions = 0;

  @override
  Future<DailyMission> fetchTodayMission() async =>
      withResume ? _missionWithResume : _mission;

  @override
  Future<void> startMission(String missionId) async {}

  @override
  Future<void> completeRound(
    String missionId,
    int roundIndex,
    CompleteRoundPayload payload,
  ) async {
    roundCompletions++;
    if (failRound) throw ApiException('round failed');
  }

  @override
  Future<CompleteMissionResult> completeMission(String missionId) async {
    missionCompletions++;
    return const CompleteMissionResult(
      xpAwarded: 20,
      streakUpdated: true,
      completionPct: 100,
    );
  }
}

const _mission = DailyMission(
  id: 'mission-1',
  words: [
    DailyMissionWord(
      wordId: 'word-1',
      contentDe: 'Haus',
      contentVi: 'nhà',
      level: 'A1',
    ),
  ],
  rounds: [
    MissionRound(index: 0, gameType: 'flashcard', wordIds: ['word-1']),
  ],
  roundsPlanned: 1,
  roundsCompleted: 0,
  completionPct: 0,
  xpEarned: 0,
);

const _missionWithResume = DailyMission(
  id: 'mission-2',
  words: [
    DailyMissionWord(
      wordId: 'word-1',
      contentDe: 'Haus',
      contentVi: 'nhà',
      level: 'A1',
    ),
  ],
  rounds: [
    MissionRound(index: 0, gameType: 'flashcard', wordIds: ['word-1']),
  ],
  roundsPlanned: 1,
  roundsCompleted: 0,
  completionPct: 0,
  xpEarned: 0,
  resumeItems: [
    MissionResumeTarget(
      kind: 'exam',
      ref: 'goethe-a1',
      title: 'Goethe A1',
      subtitle: 'Lesen',
      route: '/exam/goethe-a1',
    ),
  ],
);

ApiClient _dummyClient() => ApiClient(
  baseUrl: 'https://example.test/api/v1',
  tokenProvider: _NoTokenProvider(),
);

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}
