import '../../services/api_client.dart';
import 'pronunciation_models.dart';

/// Live data source for the pronunciation trainer cluster — mirrors web
/// `src/lib/pronunciation/pronunciation-service.ts` and
/// `minimal-pairs-service.ts`. All four trainers + minimal-pairs are
/// listen-only (TTS playback, no recorder) so this repository only needs
/// read endpoints.
class PronunciationRepository {
  PronunciationRepository(this._api);

  final ApiClient _api;

  Future<List<UmlautItem>> fetchUmlauteItems({int limit = 15}) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/pronunciation/umlaute',
      query: {'limit': limit},
    );
    return _items(json).map(UmlautItem.fromJson).toList(growable: false);
  }

  Future<List<IchAchItem>> fetchIchAchItems({int limit = 15}) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/pronunciation/ich-ach-laut',
      query: {'limit': limit},
    );
    return _items(json).map(IchAchItem.fromJson).toList(growable: false);
  }

  Future<List<RSoundItem>> fetchRSoundItems({int limit = 15}) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/pronunciation/r-sound',
      query: {'limit': limit},
    );
    return _items(json).map(RSoundItem.fromJson).toList(growable: false);
  }

  Future<List<SpStItem>> fetchSpStItems({int limit = 15}) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/pronunciation/sp-st',
      query: {'limit': limit},
    );
    return _items(json).map(SpStItem.fromJson).toList(growable: false);
  }

  Future<List<MinimalPairContrast>> fetchMinimalPairContrasts() async {
    final json = await _api.get<List<dynamic>>('/minimal-pairs/contrasts');
    return json
        .whereType<Map<String, dynamic>>()
        .map(MinimalPairContrast.fromJson)
        .toList(growable: false);
  }

  Future<List<MinimalPair>> fetchMinimalPairs(
    String contrastKey, {
    int limit = 40,
  }) async {
    final json = await _api.get<List<dynamic>>(
      '/minimal-pairs',
      query: {'contrast': contrastKey, 'limit': limit},
    );
    return json
        .whereType<Map<String, dynamic>>()
        .map(MinimalPair.fromJson)
        .toList(growable: false);
  }

  List<Map<String, dynamic>> _items(Map<String, dynamic> json) {
    final raw = json['items'];
    if (raw is! List) return const [];
    return raw.whereType<Map<String, dynamic>>().toList(growable: false);
  }
}
