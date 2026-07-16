import 'package:deutschtiger/screens/pronunciation/widgets/pronunciation_quiz_rounds.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildTtsQuizRounds', () {
    test('returns empty list for an empty item pool', () {
      final rounds = buildTtsQuizRounds<String>(
        const [],
        minimalPairOf: (item) => item,
      );

      expect(rounds, isEmpty);
    });

    test('builds [count] rounds cycling only eligible items', () {
      final items = ['a', 'b', 'c'];
      final rounds = buildTtsQuizRounds<String>(
        items,
        minimalPairOf: (item) => item == 'c' ? '' : '$item-pair',
        count: 5,
      );

      expect(rounds, hasLength(5));
      // 'c' has no minimal pair, so it must never appear in an eligible-only
      // round set (falls back to full pool only when NO item is eligible).
      expect(rounds.every((r) => r.item != 'c'), isTrue);
    });

    test('falls back to the full pool when nothing is eligible', () {
      final items = ['a', 'b'];
      final rounds = buildTtsQuizRounds<String>(
        items,
        minimalPairOf: (item) => '',
        count: 4,
      );

      expect(rounds, hasLength(4));
      expect(rounds.map((r) => r.item), everyElement(isIn(items)));
    });
  });
}
