import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/vocab/subtitle_word.dart';
import '../../services/api_client.dart';
import '../../view_models/providers.dart';

/// Repository cho tính năng "Từ trong phụ đề" — từ vựng người dùng gặp khi
/// xem video, chưa nằm trong hàng đợi ôn tập. Endpoints: `GET /subtitle-words`,
/// `GET /subtitle-words/counts`, `POST /subtitle-words/add`.
class SubtitleWordsRepository {
  SubtitleWordsRepository(this._apiClient);
  final ApiClient _apiClient;

  /// [minSeen] mặc định 2 khớp default phía backend.
  Future<List<SubtitleWord>> getWords({
    List<String>? levels,
    int minSeen = 2,
    int limit = 50,
  }) async {
    final response = await _apiClient.get<List<dynamic>>(
      '/subtitle-words',
      query: {
        if (levels != null && levels.isNotEmpty) 'levels': levels.join(','),
        'min_seen': minSeen,
        'limit': limit,
      },
    );
    return response
        .whereType<Map<String, dynamic>>()
        .map(SubtitleWord.fromJson)
        .toList(growable: false);
  }

  /// Số từ theo từng cấp CEFR (key `"unknown"` cho từ chưa gán cấp).
  Future<Map<String, int>> getCounts({int minSeen = 2}) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/subtitle-words/counts',
      query: {'min_seen': minSeen},
    );
    return response.map((key, value) => MapEntry(key, (value as num?)?.toInt() ?? 0));
  }

  /// Thêm các từ đã chọn vào hàng đợi SRS + flashcard mặc định (server xử lý
  /// cả hai, best-effort cho phần flashcard).
  Future<AddSubtitleWordsResult> addWords(List<String> learningItemIds) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/subtitle-words/add',
      body: {'learning_item_ids': learningItemIds},
    );
    return AddSubtitleWordsResult.fromJson(response);
  }
}

final subtitleWordsRepositoryProvider = Provider<SubtitleWordsRepository>((ref) {
  return SubtitleWordsRepository(ref.watch(apiClientProvider));
});
