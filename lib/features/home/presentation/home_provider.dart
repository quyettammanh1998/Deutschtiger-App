import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../data/dashboard_repository.dart';
import '../domain/dashboard_data.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(apiClientProvider));
});

/// Dữ liệu Home. Tự refetch khi auth state đổi (login/logout).
final dashboardProvider = FutureProvider<DashboardData>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(dashboardRepositoryProvider).fetchDashboard();
});
