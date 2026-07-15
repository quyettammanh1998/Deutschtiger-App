import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/stats/stats_models.dart';
import '../../repositories/stats/error_patterns_repository.dart';

/// Tổng hợp lỗi ngữ pháp theo loại. `GET /user/error-patterns/summary`.
final errorPatternsSummaryProvider = FutureProvider<List<ErrorPatternSummary>>((
  ref,
) async {
  return ref.watch(errorPatternsRepositoryProvider).getSummary();
});
