import '../../data/games/conjugation_models.dart';
import '../../services/api_client.dart';

/// Repository cho Konjugationstrainer — mirrors backend
/// `internal/feature/learning/conjugation/conjugation_handler.go`. Khi user
/// đăng nhập và có đủ vốn từ (verb) học rồi, backend tự trộn câu hỏi cá nhân
/// hoá; client không cần biết nguồn nào được chọn.
class ConjugationRepository {
  ConjugationRepository(this._api);

  final ApiClient _api;

  /// `GET /user/conjugation/exercise?type=&level=&limit=`
  ///
  /// [type]: regular|modal|separable|reflexive|irregular|all (mặc định all).
  Future<List<ConjugationExercise>> fetchExercises({
    required String level,
    String type = 'all',
    int limit = 30,
  }) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/conjugation/exercise',
      query: {'type': type, 'level': level, 'limit': limit},
    );
    final exercises = json['exercises'] as List<dynamic>? ?? const [];
    return exercises
        .whereType<Map<String, dynamic>>()
        .map(ConjugationExercise.fromJson)
        .toList(growable: false);
  }
}
