import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/practice/practice_round_item.dart';
import '../../view_models/games/learning_item_provider.dart';

/// Shared corpus source for the 4 standalone `/games/*` practice-view routes
/// — real data via `GET /user/learning-items/balanced` (same live endpoint
/// already used by the Artikel/Wortstellung/Fill-blank games, see
/// `learning_item_provider.dart`). No test/demo data — a real backend call.
Future<List<PracticeRoundItem>> loadPracticeRoundItems(
  WidgetRef ref, {
  String level = 'A1',
  int limit = 40,
}) async {
  final items = await ref
      .read(learningItemRepositoryProvider)
      .fetchBalanced(userLevel: level, type: 'word', limit: limit);
  final seen = <String>{};
  final out = <PracticeRoundItem>[];
  for (final item in items) {
    if (item.contentDe.trim().isEmpty || (item.contentVi ?? '').trim().isEmpty) continue;
    final key = item.contentDe.toLowerCase();
    if (!seen.add(key)) continue;
    out.add(PracticeRoundItem.fromLearningItem(item));
  }
  return out;
}
