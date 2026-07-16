import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/view_models/providers.dart';
import '../../repositories/speech/sprechen_ai_repository.dart';

final sprechenAiRepositoryProvider = Provider<SprechenAiRepository>((ref) {
  return SprechenAiRepository(ref.watch(apiClientProvider));
});
