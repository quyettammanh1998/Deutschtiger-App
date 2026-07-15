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
    'one-word mission persists its round and completion end to end',
    () async {
      final service = _FakeMissionService();
      final setup = _container(service);
      addTearDown(setup.dispose);

      final notifier = setup.container.read(missionSessionProvider.notifier);
      await setup.container.read(missionSessionProvider.future);
      notifier.beginPractice();
      notifier.submitAnswer(true);
      await notifier.advance();
      final state = setup.container.read(missionSessionProvider).requireValue;

      expect(service.roundCompletions, 1);
      expect(service.missionCompletions, 1);
      expect(state.status, MissionRunnerStatus.completed);
      expect(state.result?.xpAwarded, 20);
    },
  );

  test('failed round persistence stays on result and can be retried', () async {
    final service = _FakeMissionService(failRound: true);
    final setup = _container(service);
    addTearDown(setup.dispose);

    final notifier = setup.container.read(missionSessionProvider.notifier);
    await setup.container.read(missionSessionProvider.future);
    notifier.beginPractice();
    notifier.submitAnswer(false);
    await notifier.advance();
    final state = setup.container.read(missionSessionProvider).requireValue;

    expect(state.status, MissionRunnerStatus.betweenWords);
    expect(state.error, MissionSessionError.roundNotSaved);
    expect(service.missionCompletions, 0);
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
  _FakeMissionService({this.failRound = false}) : super(_dummyClient());

  final bool failRound;
  int roundCompletions = 0;
  int missionCompletions = 0;

  @override
  Future<DailyMission> fetchTodayMission() async => _mission;

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
