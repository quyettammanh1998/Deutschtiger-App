import 'package:deutschtiger/features/writing/domain/goethe_b1_writing_access.dart';
import 'package:deutschtiger/features/writing/domain/goethe_b1_writing_topic_summary.dart';
import 'package:flutter_test/flutter_test.dart';

GoetheB1WritingTopicSummary _topic(String slug, {int stars = 0, bool intro = false}) {
  return GoetheB1WritingTopicSummary(
    slug: slug,
    titleDe: slug,
    titleVi: slug,
    isIntro: intro,
    frequencyStars: stars,
  );
}

void main() {
  group('sortedRegularWritingTopics', () {
    test('sorts by frequency stars desc, then slug, excluding intro', () {
      final topics = [
        _topic('c', stars: 3),
        _topic('a', stars: 5),
        _topic('b', stars: 5),
        _topic('intro', intro: true, stars: 5),
      ];
      final sorted = sortedRegularWritingTopics(topics);
      expect(sorted.map((t) => t.slug), ['a', 'b', 'c']);
    });
  });

  group('freeUnlockedWritingTopicSlugs / isWritingTopicLocked', () {
    test('only the top N (by frequency) regular topics stay unlocked', () {
      final topics = List.generate(7, (i) => _topic('t$i', stars: 7 - i));
      final unlocked = freeUnlockedWritingTopicSlugs(topics, limit: 5);
      expect(unlocked, {'t0', 't1', 't2', 't3', 't4'});
      expect(
        isWritingTopicLocked(topics[5], topics, hasFullAccess: false),
        isTrue,
      );
      expect(
        isWritingTopicLocked(topics[0], topics, hasFullAccess: false),
        isFalse,
      );
    });

    test('full access unlocks everything; intro topics are never locked', () {
      final topics = List.generate(7, (i) => _topic('t$i', stars: 7 - i));
      expect(isWritingTopicLocked(topics[6], topics, hasFullAccess: true), isFalse);
      expect(
        isWritingTopicLocked(_topic('intro', intro: true), topics, hasFullAccess: false),
        isFalse,
      );
    });
  });
}
