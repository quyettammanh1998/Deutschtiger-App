import 'package:deutschtiger/features/writing/domain/sprint/redemittel_aggregator.dart';
import 'package:deutschtiger/features/writing/domain/sprint/sprint_types.dart';
import 'package:flutter_test/flutter_test.dart';

SprintTopicData _topicWith(List<RedemittelItem> items) {
  return SprintTopicData(
    slug: 't',
    teil: 1,
    titleDe: 't',
    taskDe: 'task',
    speedrun: SpeedrunContent(
      outline3: const Outline3(),
      miniModel: const MiniModel(de: ''),
      redemittelCore: items,
    ),
  );
}

void main() {
  test('aggregateTopRedemittel dedupes by DE phrase, ranked by frequency', () {
    final topics = [
      _topicWith([const RedemittelItem(de: 'Liebe Anna,', vi: 'x', function: 'opening')]),
      _topicWith([const RedemittelItem(de: 'liebe anna,', vi: 'x', function: 'opening')]),
      _topicWith([const RedemittelItem(de: 'Deshalb...', vi: 'y', function: 'reason')]),
    ];
    final top = aggregateTopRedemittel(topics, topN: 40);
    expect(top.length, 2);
    expect(top.first.de.toLowerCase(), 'liebe anna,');
  });

  test('aggregateTopRedemittel respects topN cap', () {
    final items = List.generate(10, (i) => RedemittelItem(de: 'phrase $i', vi: '', function: 'connector'));
    final top = aggregateTopRedemittel([_topicWith(items)], topN: 3);
    expect(top.length, 3);
  });

  test('groupByFunction buckets by function key, unknown defaults handled', () {
    final items = [
      const RedemittelItem(de: 'a', vi: '', function: 'opening'),
      const RedemittelItem(de: 'b', vi: '', function: 'closing'),
    ];
    final grouped = groupByFunction(items);
    expect(grouped['opening'], hasLength(1));
    expect(grouped['closing'], hasLength(1));
    expect(grouped['reason'], isEmpty);
  });
}
