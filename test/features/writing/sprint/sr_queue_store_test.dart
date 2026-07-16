import 'package:deutschtiger/features/writing/data/sprint/sr_queue_store.dart';
import 'package:deutschtiger/features/writing/domain/sprint/sprint_types.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('load() returns null when nothing persisted yet', () async {
    final store = SrQueueStore();
    expect(await store.load(), isNull);
  });

  test(
    'save() then load() round-trips the queue with absolute due timestamps intact — '
    'this is what makes the SR queue restart-safe with no background timer',
    () async {
      final store = SrQueueStore();
      final sessionStart = DateTime(2026, 1, 1, 9);
      final dueLater = sessionStart.add(const Duration(hours: 3));
      final queue = SRQueue(
        mode: SRMode.marathon,
        sessionStart: sessionStart,
        cards: [SRCardState(slug: 'ausflug', due: dueLater, seenCount: 1, lastRating: SRRating.hard)],
      );

      await store.save(queue);

      // A brand-new store instance simulates a fresh app process after
      // restart — it has no in-memory state, only SharedPreferences.
      final reloadedStore = SrQueueStore();
      final reloaded = await reloadedStore.load();

      expect(reloaded, isNotNull);
      expect(reloaded!.cards.single.due, dueLater);
      expect(reloaded.cards.single.seenCount, 1);
      expect(reloaded.cards.single.lastRating, SRRating.hard);
      expect(reloaded.sessionStart, sessionStart);
    },
  );

  test('clear() removes the persisted queue', () async {
    final store = SrQueueStore();
    final now = DateTime(2026, 1, 1);
    await store.save(SRQueue(mode: SRMode.daily, sessionStart: now, cards: [SRCardState(slug: 'a', due: now)]));
    await store.clear();
    expect(await store.load(), isNull);
  });

  test('load() degrades to null on corrupted JSON instead of throwing', () async {
    SharedPreferences.setMockInitialValues({'sprint_goethe_b1_writing_sr_queue_v2': 'not valid json'});
    final store = SrQueueStore();
    expect(await store.load(), isNull);
  });
}
