/// Mastery aggregate for a vocabulary scope (topic / level / collection).
/// Web parity: `CollectionGraduationStats` (`srs-types.ts`), served by the
/// EXISTING live endpoints `/user/srs/graduated{,-by-topic,-by-level}` — no
/// new backend contract, just wiring an endpoint the web already calls.
class GraduationStats {
  const GraduationStats({
    required this.total,
    required this.learned,
    required this.graduated,
    this.learning,
    this.known,
  });

  final int total;
  final int learned;
  final int graduated;
  final int? learning;
  final int? known;

  factory GraduationStats.fromJson(Map<String, dynamic> json) =>
      GraduationStats(
        total: _asInt(json['total']),
        learned: _asInt(json['learned']),
        graduated: _asInt(json['graduated']),
        learning: json['learning'] == null ? null : _asInt(json['learning']),
        known: json['known'] == null ? null : _asInt(json['known']),
      );

  static const empty = GraduationStats(total: 0, learned: 0, graduated: 0);
}

int _asInt(dynamic value) => switch (value) {
  int number => number,
  num number => number.toInt(),
  String text => int.tryParse(text) ?? 0,
  _ => 0,
};

/// FSRS state bucket for one learning item — mirrors web's
/// `fsrsToReviewState` projection (`use-learning-item-reviews.ts`), simplified
/// to just the mastery bucket + due/weak flags the detail-list UI needs (dot
/// color + "Yếu" filter). Raw states: 0=New 1=Learning 2=Review 3=Relearning.
enum ItemMasteryBucket { newWord, learning, known, mastered }

class ItemMasteryState {
  const ItemMasteryState({
    required this.bucket,
    required this.isDue,
  });

  final ItemMasteryBucket bucket;
  final bool isDue;

  bool get isWeak =>
      bucket == ItemMasteryBucket.newWord ||
      bucket == ItemMasteryBucket.learning ||
      isDue;

  factory ItemMasteryState.fromJson(Map<String, dynamic> json) {
    final state = _asInt(json['state']);
    final stability = (json['stability'] as num?)?.toDouble() ?? 0;
    final dueAt = DateTime.tryParse(json['due'] as String? ?? '');
    final isDue =
        (state == 2 || state == 3) &&
        dueAt != null &&
        !dueAt.isAfter(DateTime.now());
    final bucket = switch (state) {
      0 => ItemMasteryBucket.newWord,
      1 || 3 => ItemMasteryBucket.learning,
      2 => stability >= 21
          ? ItemMasteryBucket.mastered
          : ItemMasteryBucket.known,
      _ => ItemMasteryBucket.newWord,
    };
    return ItemMasteryState(bucket: bucket, isDue: isDue);
  }
}
