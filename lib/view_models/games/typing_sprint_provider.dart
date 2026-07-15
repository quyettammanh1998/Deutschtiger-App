import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/games/typing_sprint_repository.dart';
import '../providers.dart';

final typingSprintRepositoryProvider =
    Provider<TypingSprintRepository>((ref) {
  return TypingSprintRepository(ref.watch(apiClientProvider));
});
