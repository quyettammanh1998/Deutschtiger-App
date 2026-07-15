import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/stats/quote_model.dart';

/// Câu nói tạo động lực — endpoint public, không cần auth.
class DailyQuoteRepository {
  DailyQuoteRepository(this._api);

  final ApiClient _api;

  /// Câu nói xác định theo ngày (deterministic, cùng 1 câu trong cả ngày).
  /// `GET /api/v1/quotes/daily`.
  Future<Quote> getDaily() async {
    final json = await _api.get<Map<String, dynamic>>('/quotes/daily');
    return Quote.fromJson(json);
  }

  /// N câu ngẫu nhiên để khám phá thêm. `GET /api/v1/quotes/random?limit=`.
  Future<List<Quote>> getRandom({int limit = 20}) async {
    final list = await _api.get<List<dynamic>>(
      '/quotes/random',
      query: {'limit': limit},
    );
    return list.map((e) => Quote.fromJson(e as Map<String, dynamic>)).toList();
  }
}

final dailyQuoteRepositoryProvider = Provider<DailyQuoteRepository>((ref) {
  return DailyQuoteRepository(ref.watch(apiClientProvider));
});
