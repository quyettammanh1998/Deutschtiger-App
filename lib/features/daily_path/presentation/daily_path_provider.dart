import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../view_models/providers.dart';
import '../data/daily_path_repository.dart';
import '../domain/daily_path.dart';

final dailyPathRepositoryProvider = Provider<DailyPathRepository>((ref) {
  return DailyPathRepository(ref.watch(apiClientProvider));
});

final dailyPathProvider = FutureProvider<DailyPath>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(dailyPathRepositoryProvider).fetchToday();
});
