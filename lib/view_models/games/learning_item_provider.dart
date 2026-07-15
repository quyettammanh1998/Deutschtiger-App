import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/games/learning_item_repository.dart';
import '../providers.dart';

final learningItemRepositoryProvider = Provider<LearningItemRepository>((ref) {
  return LearningItemRepository(ref.watch(apiClientProvider));
});
