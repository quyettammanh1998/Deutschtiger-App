import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/stats/quote_model.dart';
import '../../repositories/stats/daily_quote_repository.dart';

/// Câu nói của ngày (deterministic). `GET /api/v1/quotes/daily`.
final dailyQuoteProvider = FutureProvider<Quote>((ref) async {
  return ref.watch(dailyQuoteRepositoryProvider).getDaily();
});

/// Câu nói ngẫu nhiên để khám phá thêm. `GET /api/v1/quotes/random?limit=20`.
final quoteHistoryProvider = FutureProvider<List<Quote>>((ref) async {
  return ref.watch(dailyQuoteRepositoryProvider).getRandom(limit: 20);
});
