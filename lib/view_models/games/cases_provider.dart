import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/games/cases_repository.dart';
import '../../repositories/games/grammar_drill_repository.dart';
import '../providers.dart';

final casesRepositoryProvider = Provider<CasesRepository>((ref) {
  return CasesRepository(ref.watch(apiClientProvider));
});

final grammarDrillRepositoryProvider = Provider<GrammarDrillRepository>((ref) {
  return GrammarDrillRepository(ref.watch(apiClientProvider));
});
