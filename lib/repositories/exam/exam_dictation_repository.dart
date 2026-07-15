import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/exam/exam_ecosystem_models.dart';

/// Repository cho dữ liệu word-transcript dùng cho luyện nghe chép chính tả
/// (cloze dictation). Tái dùng audio widget của exam player — KHÔNG chạm
/// `lib/features/exam/` core, chỉ đọc endpoint public sẵn có.
class ExamDictationRepository {
  ExamDictationRepository(this._apiClient);
  final ApiClient _apiClient;

  /// API: GET /api/v1/exams/telc/b1/{slug}/word-transcript
  Future<ExamWordTranscript> getTelcB1Transcript(String slug) async {
    final data = await _apiClient.get<Map<String, dynamic>>(
      '/exams/telc/b1/$slug/word-transcript',
    );
    return ExamWordTranscript.fromJson(data);
  }

  /// API: GET /api/v1/exams/goethe/{level}/{slug}/word-transcript
  Future<ExamWordTranscript> getGoetheTranscript(
    String level,
    String slug,
  ) async {
    final data = await _apiClient.get<Map<String, dynamic>>(
      '/exams/goethe/$level/$slug/word-transcript',
    );
    return ExamWordTranscript.fromJson(data);
  }

  /// Chọn endpoint theo provider (`telc` chỉ có mức B1; `goethe` theo level).
  Future<ExamWordTranscript> getTranscript({
    required String provider,
    required String level,
    required String slug,
  }) {
    if (provider == 'telc') return getTelcB1Transcript(slug);
    return getGoetheTranscript(level, slug);
  }
}

final examDictationRepositoryProvider = Provider<ExamDictationRepository>((
  ref,
) {
  return ExamDictationRepository(ref.watch(apiClientProvider));
});
