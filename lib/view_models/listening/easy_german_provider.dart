import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/config/app_config.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/listening/easy_german_models.dart';
import '../../repositories/listening/easy_german_repository.dart';

final easyGermanRepositoryProvider = Provider<EasyGermanRepository>((ref) {
  return EasyGermanRepository(
    ref.watch(apiClientProvider),
    AppConfig.webviewBaseUrl,
  );
});

/// Danh sách video Easy German theo level (`a1`..`c1`).
final easyGermanIndexProvider =
    FutureProvider.family<List<EasyGermanVideo>, String>((ref, level) {
  return ref.watch(easyGermanRepositoryProvider).fetchIndex(level);
});

/// Bảng xếp hạng theo bộ video_id — dùng chung cho Easy German level pages
/// và Sprechen B1/B2. Family key = video_ids nối bằng dấu phẩy (String có
/// value-equality ổn định, khác `List` mặc định so sánh theo identity — tránh
/// provider bị tạo lại/refetch mỗi lần widget rebuild với 1 list literal mới).
final videoCollectionLeaderboardProvider = FutureProvider.family<
    List<VideoCollectionLeaderboardEntry>, String>((ref, joinedVideoIds) {
  final ids = joinedVideoIds.isEmpty ? const <String>[] : joinedVideoIds.split(',');
  return ref.watch(easyGermanRepositoryProvider).fetchLeaderboard(ids);
});
