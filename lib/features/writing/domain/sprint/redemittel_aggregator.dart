import 'sprint_types.dart';

/// Aggregate top-N redemittel from all topics' `speedrun.redemittelCore`,
/// deduped by DE phrase — web parity `redemittel-aggregator.ts`. Feeds the
/// sprint cheatsheet page.
List<RedemittelItem> aggregateTopRedemittel(List<SprintTopicData> topics, {int topN = 40}) {
  final counts = <String, (RedemittelItem, int)>{};
  for (final topic in topics) {
    for (final item in topic.speedrun?.redemittelCore ?? const <RedemittelItem>[]) {
      final key = item.de.trim().toLowerCase();
      final existing = counts[key];
      counts[key] = existing == null ? (item, 1) : (existing.$1, existing.$2 + 1);
    }
  }
  final sorted = counts.values.toList()..sort((a, b) => b.$2.compareTo(a.$2));
  return sorted.take(topN).map((e) => e.$1).toList();
}

/// `function` keys in web display order.
const List<String> kRedemittelFunctionOrder = ['opening', 'reason', 'suggestion', 'connector', 'closing'];

Map<String, List<RedemittelItem>> groupByFunction(List<RedemittelItem> items) {
  final groups = {for (final f in kRedemittelFunctionOrder) f: <RedemittelItem>[]};
  for (final item in items) {
    (groups[item.function] ??= []).add(item);
  }
  return groups;
}

/// German label / Vietnamese label — pedagogical content, approved
/// bilingual-inline exception (same class as the Redemittel phrases
/// themselves; not a UI chrome string).
const Map<String, String> kRedemittelFunctionLabels = {
  'opening': 'Eröffnung / Mở đầu',
  'reason': 'Begründung / Lý do',
  'suggestion': 'Vorschlag / Đề xuất',
  'connector': 'Verbindung / Liên kết',
  'closing': 'Abschluss / Kết thúc',
};
