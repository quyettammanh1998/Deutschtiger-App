import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/config/app_config.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/exam/exam_ecosystem_models.dart';

/// Repository cho đề thi public registry (`/de-thi/:code`) — JSON tĩnh phục
/// vụ qua Go DataDir, KHÔNG cần auth. Cùng pattern với `PodcastRepository`
/// (`lib/repositories/listening` tương tự): dùng `_api.raw` + host tĩnh, vì
/// endpoint nằm ngoài `/api/v1`.
class DeThiRepository {
  DeThiRepository(this._apiClient, this._staticBaseUrl);

  final ApiClient _apiClient;
  final String _staticBaseUrl;

  /// Danh sách đề công khai — registry tĩnh, không cần gọi API.
  List<DeThiRegistryEntry> listRegistry() => deThiRegistry;

  DeThiRegistryEntry? findEntry(String code) => findDeThiEntry(code);

  /// Tải nội dung đề theo [dataPath] (vd. `/data/de-thi/exam-1525.json`).
  Future<DeThiExam> fetchExam(String dataPath) async {
    final res = await _apiClient.raw.get<Map<String, dynamic>>(
      '$_staticBaseUrl$dataPath',
    );
    return DeThiExam.fromJson(res.data ?? const <String, dynamic>{});
  }
}

final deThiRepositoryProvider = Provider<DeThiRepository>((ref) {
  return DeThiRepository(
    ref.watch(apiClientProvider),
    AppConfig.webviewBaseUrl,
  );
});
