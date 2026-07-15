import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/games/conjugation_repository.dart';
import '../providers.dart';

final conjugationRepositoryProvider = Provider<ConjugationRepository>((ref) {
  return ConjugationRepository(ref.watch(apiClientProvider));
});
