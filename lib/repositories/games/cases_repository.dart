import '../../data/games/cases_models.dart';
import '../../services/api_client.dart';

/// Repository cho Cases Mastery Hub — mirrors backend
/// `internal/feature/learning/cases/cases_handler.go` (4 sub-games:
/// akk-dat, adjektiv, wechselprep — cloze; verb-case — matching). Kết quả
/// phiên chơi gửi qua [GrammarDrillRepository] dùng chung với Konjugation.
class CasesRepository {
  CasesRepository(this._api);

  final ApiClient _api;

  /// `GET /user/cases/akk-dat?level=&limit=`
  Future<CaseExercisesResponse> fetchAkkDat({
    required String level,
    int limit = 30,
  }) => _fetchCloze('akk-dat', level: level, limit: limit);

  /// `GET /user/cases/adjektiv?level=&limit=`
  Future<CaseExercisesResponse> fetchAdjektiv({
    required String level,
    int limit = 30,
  }) => _fetchCloze('adjektiv', level: level, limit: limit);

  /// `GET /user/cases/wechselprep?level=&limit=`
  Future<CaseExercisesResponse> fetchWechselprep({
    required String level,
    int limit = 30,
  }) => _fetchCloze('wechselprep', level: level, limit: limit);

  Future<CaseExercisesResponse> _fetchCloze(
    String game, {
    required String level,
    required int limit,
  }) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/cases/$game',
      query: {'level': level, 'limit': limit},
    );
    return CaseExercisesResponse.fromJson(json);
  }

  /// `GET /user/cases/verb-case?level=&limit=`
  Future<VerbCaseResponse> fetchVerbCase({
    required String level,
    int limit = 15,
  }) async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/cases/verb-case',
      query: {'level': level, 'limit': limit},
    );
    return VerbCaseResponse.fromJson(json);
  }
}
