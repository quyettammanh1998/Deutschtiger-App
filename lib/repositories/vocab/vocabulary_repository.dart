import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/vocab/vocab_models.dart';

/// Repository cho vocabulary search.
class VocabularyRepository {
  VocabularyRepository(this._apiClient);
  final ApiClient _apiClient;

  /// Tim kiem tu vung.
  /// API: GET /api/v1/vocabulary/search?q={query}&page=&pageSize=&cefr_level=
  Future<VocabSearchResult> search({
    required String query,
    int page = 1,
    int pageSize = 20,
    String? cefrLevel,
  }) async {
    final queryParams = <String, dynamic>{
      'q': query,
      'page': page,
      'pageSize': pageSize,
    };
    if (cefrLevel != null) {
      queryParams['level'] = cefrLevel;
    }

    final data = await _apiClient.get<Map<String, dynamic>>(
      '/api/v1/vocabulary/search',
      query: queryParams,
    );
    return VocabSearchResult.fromJson(data);
  }

  /// Lay chi tiet mot tu.
  /// API: GET /api/v1/vocabulary/{wordId}
  Future<VocabWord> getWord(String wordId) async {
    final data = await _apiClient.get<Map<String, dynamic>>(
      '/api/v1/vocabulary/$wordId',
    );
    return VocabWord.fromJson(data);
  }

  /// Lay danh sach tu da hoc.
  /// API: GET /api/v1/vocabulary/learned?page=&pageSize=
  Future<List<VocabWord>> getLearnedWords({int page = 1, int pageSize = 50}) async {
    final data = await _apiClient.get<Map<String, dynamic>>(
      '/api/v1/vocabulary/learned',
      query: {'page': page, 'pageSize': pageSize},
    );
    final words = data['items'] as List<dynamic>? ?? [];
    return words
        .map((e) => VocabWord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Danh dau tu da hoc.
  /// API: POST /api/v1/vocabulary/{wordId}/learn
  Future<void> markAsLearned(String wordId) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/api/v1/vocabulary/$wordId/learn',
    );
  }

  /// Bo danh dau tu da hoc.
  /// API: DELETE /api/v1/vocabulary/{wordId}/learn
  Future<void> unmarkLearned(String wordId) async {
    await _apiClient.delete<dynamic>(
      '/api/v1/vocabulary/$wordId/learn',
    );
  }
}

final vocabularyRepositoryProvider = Provider<VocabularyRepository>((ref) {
  return VocabularyRepository(ref.watch(apiClientProvider));
});
