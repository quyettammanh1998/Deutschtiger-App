import 'package:deutschtiger/features/writing/domain/sprint/sr_card_queue.dart';
import 'package:deutschtiger/features/writing/domain/sprint/sprint_types.dart';
import 'package:flutter_test/flutter_test.dart';

SprintTopicData _topic(String slug, int teil, {bool speedrun = true}) {
  return SprintTopicData(
    slug: slug,
    teil: teil,
    titleDe: slug,
    taskDe: 'Task $slug',
    speedrun: speedrun
        ? SpeedrunContent(outline3: const Outline3(de: ['a', 'b', 'c']), miniModel: const MiniModel(de: 'mini'))
        : null,
  );
}

void main() {
  group('buildQueue', () {
    test('includes only speedrun-eligible, non-intro topics', () {
      final topics = [
        _topic('a', 1),
        _topic('b', 1, speedrun: false),
        _topic('c-intro', 1),
      ];
      final queue = buildQueue(topics, SRMode.marathon);
      expect(queue.cards.map((c) => c.slug), ['a']);
    });

    test('all cards start due at session start', () {
      final now = DateTime(2026, 1, 1);
      final queue = buildQueue([_topic('a', 1), _topic('b', 2)], SRMode.daily, now);
      expect(queue.cards.every((c) => c.due == now), isTrue);
    });
  });

  group('nextDueCard', () {
    test('returns earliest-due, least-seen card', () {
      final now = DateTime(2026, 1, 1, 10);
      final queue = SRQueue(
        mode: SRMode.marathon,
        sessionStart: now,
        cards: [
          SRCardState(slug: 'later', due: now.subtract(const Duration(minutes: 1)), seenCount: 1),
          SRCardState(slug: 'sooner', due: now.subtract(const Duration(minutes: 5)), seenCount: 0),
        ],
      );
      expect(nextDueCard(queue, now)!.slug, 'sooner');
    });

    test('marathon falls back to earliest future card within session window', () {
      final sessionStart = DateTime(2026, 1, 1, 8);
      final now = sessionStart.add(const Duration(hours: 1));
      final queue = SRQueue(
        mode: SRMode.marathon,
        sessionStart: sessionStart,
        cards: [SRCardState(slug: 'future', due: now.add(const Duration(hours: 2)))],
      );
      expect(nextDueCard(queue, now)!.slug, 'future');
    });

    test('daily mode returns null when nothing is due today', () {
      final now = DateTime(2026, 1, 1);
      final queue = SRQueue(
        mode: SRMode.daily,
        sessionStart: now,
        cards: [SRCardState(slug: 'a', due: now.add(const Duration(days: 1)))],
      );
      expect(nextDueCard(queue, now), isNull);
    });
  });

  test('rateCard updates only the targeted card', () {
    final now = DateTime(2026, 1, 1);
    final queue = SRQueue(
      mode: SRMode.marathon,
      sessionStart: now,
      cards: [SRCardState(slug: 'a', due: now), SRCardState(slug: 'b', due: now)],
    );
    final updated = rateCard(queue, 'a', SRRating.good, now);
    expect(updated.cards.firstWhere((c) => c.slug == 'a').seenCount, 1);
    expect(updated.cards.firstWhere((c) => c.slug == 'b').seenCount, 0);
  });

  test('queueStats computes seen/percent correctly', () {
    final now = DateTime(2026, 1, 1);
    final queue = SRQueue(
      mode: SRMode.marathon,
      sessionStart: now,
      cards: [
        SRCardState(slug: 'a', due: now, seenCount: 1),
        SRCardState(slug: 'b', due: now, seenCount: 0),
      ],
    );
    final stats = queueStats(queue, now);
    expect(stats.total, 2);
    expect(stats.seen, 1);
    expect(stats.percent, 50);
  });

  test('pickSprintEssayTopics returns at most 1 per Teil', () {
    final now = DateTime(2026, 1, 1);
    final topics = [_topic('a', 1), _topic('b', 2), _topic('c', 3)];
    final queue = SRQueue(
      mode: SRMode.marathon,
      sessionStart: now,
      cards: [SRCardState(slug: 'a', due: now), SRCardState(slug: 'b', due: now), SRCardState(slug: 'c', due: now)],
    );
    final picked = pickSprintEssayTopics(queue, topics);
    final teile = picked.map((t) => t.teil).toSet();
    expect(teile.length, picked.length);
    expect(picked.length, lessThanOrEqualTo(3));
  });

  test('SRQueue round-trips through JSON with essayResults and essayDrafts intact', () {
    final now = DateTime(2026, 1, 1);
    final result = SprintEssayResult(
      topicSlug: 'a',
      teil: 1,
      total: 80,
      erfullung: 75,
      koharenz: 75,
      wortschatz: 75,
      strukturen: 75,
      grade: 'gut',
      feedback: const {'erfullung': 'ok'},
      errors: const [SprintEssayErrorItem(snippet: 'x', correction: 'y', explanation: 'z')],
      gradedAt: now,
    );
    final queue = SRQueue(
      mode: SRMode.daily,
      sessionStart: now,
      cards: [SRCardState(slug: 'a', due: now)],
      essayResults: {'a': result},
      essayDrafts: {'a': 'draft text'},
    );
    final roundTripped = SRQueue.fromJson(queue.toJson());
    expect(roundTripped.essayResults['a']!.total, 80);
    expect(roundTripped.essayDrafts['a'], 'draft text');
    expect(roundTripped.mode, SRMode.daily);
  });
}
