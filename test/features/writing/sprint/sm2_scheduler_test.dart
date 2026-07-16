import 'package:deutschtiger/features/writing/domain/sprint/sm2_scheduler.dart';
import 'package:deutschtiger/features/writing/domain/sprint/sprint_types.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('scheduleMarathon', () {
    test('again=1m, hard=10m, good=30m, easy=120m', () {
      final now = DateTime(2026, 1, 1, 10);
      final sessionStart = now;
      final card = newCard('a', now);

      final again = scheduleMarathon(card, SRRating.again, sessionStart, now);
      expect(again.due, now.add(const Duration(minutes: 1)));

      final hard = scheduleMarathon(card, SRRating.hard, sessionStart, now);
      expect(hard.due, now.add(const Duration(minutes: 10)));

      final good = scheduleMarathon(card, SRRating.good, sessionStart, now);
      expect(good.due, now.add(const Duration(minutes: 30)));

      final easy = scheduleMarathon(card, SRRating.easy, sessionStart, now);
      expect(easy.due, now.add(const Duration(minutes: 120)));
    });

    test('caps due at sessionStart + 10h', () {
      final sessionStart = DateTime(2026, 1, 1, 0);
      final now = sessionStart.add(const Duration(hours: 9, minutes: 55));
      final card = newCard('a', sessionStart);

      final result = scheduleMarathon(card, SRRating.easy, sessionStart, now);
      expect(result.due, sessionStart.add(const Duration(hours: 10)));
    });

    test('again resets reps to 0, others increment', () {
      final now = DateTime(2026, 1, 1);
      var card = newCard('a', now).copyWith(reps: 3);
      card = scheduleMarathon(card, SRRating.again, now, now);
      expect(card.reps, 0);

      var card2 = newCard('b', now).copyWith(reps: 3);
      card2 = scheduleMarathon(card2, SRRating.good, now, now);
      expect(card2.reps, 4);
    });
  });

  group('scheduleDaily', () {
    test('first good rating -> interval 1 day', () {
      final now = DateTime(2026, 1, 1);
      final card = newCard('a', now);
      final result = scheduleDaily(card, SRRating.good, now);
      expect(result.interval, 1);
      expect(result.due, now.add(const Duration(days: 1)));
    });

    test('again fails and resets interval to 1', () {
      final now = DateTime(2026, 1, 1);
      final card = newCard('a', now).copyWith(reps: 5, interval: 10);
      final result = scheduleDaily(card, SRRating.again, now);
      expect(result.reps, 0);
      expect(result.interval, 1);
    });

    test('EF stays within [1.3, 3.0] bounds', () {
      final now = DateTime(2026, 1, 1);
      var card = newCard('a', now);
      for (var i = 0; i < 30; i++) {
        card = scheduleDaily(card, SRRating.again, now);
      }
      expect(card.ef, greaterThanOrEqualTo(1.3));
      var card2 = newCard('b', now);
      for (var i = 0; i < 30; i++) {
        card2 = scheduleDaily(card2, SRRating.easy, now);
      }
      expect(card2.ef, lessThanOrEqualTo(3.0));
    });
  });

  group('due is an absolute timestamp (restart-safe)', () {
    test('reloading a card after simulated app restart preserves due time exactly', () {
      final sessionStart = DateTime(2026, 1, 1, 8);
      final ratedAt = sessionStart.add(const Duration(minutes: 2));
      final card = newCard('a', sessionStart);
      final rated = scheduleMarathon(card, SRRating.hard, sessionStart, ratedAt);

      // Simulate persistence round-trip (JSON serialize/deserialize), which
      // is exactly what happens across an app restart via SrQueueStore.
      final roundTripped = SRCardState.fromJson(rated.toJson());

      expect(roundTripped.due, rated.due);
      // Even if "now" moves forward (time passing while app was closed),
      // the due date itself never changes — no background timer needed.
      final muchLater = ratedAt.add(const Duration(days: 3));
      expect(roundTripped.due.isBefore(muchLater), isTrue);
    });
  });

  test('intervalLabel formats marathon minutes/hours and daily day estimates', () {
    expect(intervalLabel(SRRating.again, SRMode.marathon), '1m');
    expect(intervalLabel(SRRating.easy, SRMode.marathon), '2h');
    expect(intervalLabel(SRRating.good, SRMode.daily), '~2.5d');
  });
}
