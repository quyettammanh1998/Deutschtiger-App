import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view_models/providers.dart' show apiClientProvider;
import 'pronunciation_models.dart';
import 'pronunciation_repository.dart';

final pronunciationRepositoryProvider = Provider<PronunciationRepository>(
  (ref) => PronunciationRepository(ref.watch(apiClientProvider)),
);

/// Session seed forces a fresh word set on "Luyện lại" without caching a
/// stale list under the same provider instance (mirrors web's
/// `Date.now()`-keyed `sessionSeed` react-query key).
final umlauteItemsProvider = FutureProvider.family<List<UmlautItem>, int>((
  ref,
  sessionSeed,
) {
  return ref.watch(pronunciationRepositoryProvider).fetchUmlauteItems();
});

final ichAchItemsProvider = FutureProvider.family<List<IchAchItem>, int>((
  ref,
  sessionSeed,
) {
  return ref.watch(pronunciationRepositoryProvider).fetchIchAchItems();
});

final rSoundItemsProvider = FutureProvider.family<List<RSoundItem>, int>((
  ref,
  sessionSeed,
) {
  return ref.watch(pronunciationRepositoryProvider).fetchRSoundItems();
});

final spStItemsProvider = FutureProvider.family<List<SpStItem>, int>((
  ref,
  sessionSeed,
) {
  return ref.watch(pronunciationRepositoryProvider).fetchSpStItems();
});

final minimalPairContrastsProvider =
    FutureProvider<List<MinimalPairContrast>>((ref) {
      return ref
          .watch(pronunciationRepositoryProvider)
          .fetchMinimalPairContrasts();
    });

final minimalPairsProvider = FutureProvider.family<List<MinimalPair>, String>(
  (ref, contrastKey) {
    return ref
        .watch(pronunciationRepositoryProvider)
        .fetchMinimalPairs(contrastKey);
  },
);
