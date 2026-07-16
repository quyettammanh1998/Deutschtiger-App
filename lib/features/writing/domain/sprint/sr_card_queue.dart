import 'dart:math';

import 'sm2_scheduler.dart';
import 'sprint_types.dart';

/// Sprint v2 SR card queue — pure functions over [SRQueue]. Web parity
/// `card-queue.ts`; persistence itself lives in `SrQueueStore`
/// (`lib/features/writing/data/sprint/sr_queue_store.dart`).
final _rng = Random();

List<T> _shuffled<T>(List<T> items) {
  final list = items.toList();
  for (var i = list.length - 1; i > 0; i--) {
    final j = _rng.nextInt(i + 1);
    final tmp = list[i];
    list[i] = list[j];
    list[j] = tmp;
  }
  return list;
}

/// Build initial queue: 1 card per topic, all due at session start.
SRQueue buildQueue(List<SprintTopicData> topics, SRMode mode, [DateTime? now]) {
  final n = now ?? DateTime.now();
  final eligible = topics.where((t) => t.speedrun != null && !t.slug.endsWith('-intro')).toList();
  final shuffled = _shuffled(eligible);
  return SRQueue(
    mode: mode,
    sessionStart: n,
    cards: shuffled.map((t) => newCard(t.slug, n)).toList(),
  );
}

/// Pick the next due card, or null if queue empty/exhausted for now.
SRCardState? nextDueCard(SRQueue queue, [DateTime? now]) {
  if (queue.cards.isEmpty) return null;
  final n = now ?? DateTime.now();
  final due = queue.cards.where((c) => !c.due.isAfter(n)).toList();
  if (due.isNotEmpty) {
    due.sort((a, b) {
      if (a.seenCount != b.seenCount) return a.seenCount - b.seenCount;
      return a.due.compareTo(b.due);
    });
    return due.first;
  }
  if (queue.mode == SRMode.marathon) {
    final sessionEnd = queue.sessionStart.add(const Duration(hours: 10));
    final inSession = queue.cards.where((c) => !c.due.isAfter(sessionEnd)).toList();
    if (inSession.isEmpty) return null;
    inSession.sort((a, b) => a.due.compareTo(b.due));
    return inSession.first;
  }
  return null;
}

/// Apply a rating to a card; returns an updated queue.
SRQueue rateCard(SRQueue queue, String slug, SRRating rating, [DateTime? now]) {
  final n = now ?? DateTime.now();
  return queue.copyWith(
    cards: queue.cards
        .map((c) => c.slug == slug ? applySrRating(c, rating, queue.mode, queue.sessionStart, n) : c)
        .toList(),
  );
}

class QueueStats {
  const QueueStats({
    required this.total,
    required this.seen,
    required this.dueNow,
    required this.easyOrGood,
    required this.percent,
  });

  final int total;
  final int seen;
  final int dueNow;
  final int easyOrGood;
  final int percent;

  static const empty = QueueStats(total: 0, seen: 0, dueNow: 0, easyOrGood: 0, percent: 0);
}

/// Stats for header display.
QueueStats queueStats(SRQueue queue, [DateTime? now]) {
  final n = now ?? DateTime.now();
  final total = queue.cards.length;
  final seen = queue.cards.where((c) => c.seenCount > 0).length;
  final dueNow = queue.cards.where((c) => !c.due.isAfter(n)).length;
  final easyOrGood =
      queue.cards.where((c) => c.lastRating == SRRating.easy || c.lastRating == SRRating.good).length;
  return QueueStats(
    total: total,
    seen: seen,
    dueNow: dueNow,
    easyOrGood: easyOrGood,
    percent: total == 0 ? 0 : (seen / total * 100).round(),
  );
}

/// Pick 3 topics for the mini practice-exam: prefer recent again/hard, fallback random.
List<SprintTopicData> pickSprintEssayTopics(SRQueue queue, List<SprintTopicData> topics) {
  final slugByTeil = <int, List<String>>{1: [], 2: [], 3: []};
  final ranked = queue.cards.toList()
    ..sort((a, b) {
      int priority(SRCardState c) =>
          c.lastRating == SRRating.again ? 2 : (c.lastRating == SRRating.hard ? 1 : 0);
      final pa = priority(a);
      final pb = priority(b);
      if (pa != pb) return pb - pa;
      final ta = a.lastSeenAt?.millisecondsSinceEpoch ?? 0;
      final tb = b.lastSeenAt?.millisecondsSinceEpoch ?? 0;
      return tb - ta;
    });
  final topicBySlug = {for (final t in topics) t.slug: t};
  for (final card in ranked) {
    final t = topicBySlug[card.slug];
    if (t == null) continue;
    final bucket = slugByTeil[t.teil];
    if (bucket != null && bucket.isEmpty) bucket.add(t.slug);
    if (slugByTeil[1]!.isNotEmpty && slugByTeil[2]!.isNotEmpty && slugByTeil[3]!.isNotEmpty) break;
  }
  for (final teil in [1, 2, 3]) {
    if (slugByTeil[teil]!.isEmpty) {
      final candidates =
          topics.where((t) => t.teil == teil && t.speedrun != null && !t.slug.endsWith('-intro')).toList();
      if (candidates.isNotEmpty) {
        slugByTeil[teil]!.add(candidates[_rng.nextInt(candidates.length)].slug);
      }
    }
  }
  return [1, 2, 3]
      .map((teil) => slugByTeil[teil]!.isEmpty ? null : topicBySlug[slugByTeil[teil]!.first])
      .whereType<SprintTopicData>()
      .toList();
}

SRQueue setSprintEssayResult(SRQueue queue, String slug, SprintEssayResult result) {
  return queue.copyWith(essayResults: {...queue.essayResults, slug: result});
}

SRQueue setEssayDraft(SRQueue queue, String slug, String text) {
  return queue.copyWith(essayDrafts: {...queue.essayDrafts, slug: text});
}
