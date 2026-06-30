import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../data/interview/transcript_models.dart';

/// Service de lay transcript cua video YouTube.
class TranscriptService {
  TranscriptService(this._apiClient);
  final ApiClient _apiClient;

  /// Lay transcript da co cho mot video.
  /// API: GET /youtube/auto/{videoId}?lang=de
  Future<TranscriptResult?> getTranscript(String videoId, {String lang = 'de'}) async {
    try {
      final data = await _apiClient.get<Map<String, dynamic>>(
        '/youtube/auto/$videoId',
        query: {'lang': lang},
      );
      if (data.isEmpty) return null;

      final subtitles = data['subtitles'] as List<dynamic>? ?? [];
      return TranscriptResult(
        videoId: videoId,
        title: data['title'] as String?,
        segments: subtitles
            .map((e) => TranscriptSegment.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  /// Yeu cau tao transcript moi (bat dong bo).
  /// API: POST /user/youtube/transcript
  Future<TranscriptProgress> requestTranscript(String youtubeUrl, {String lang = 'de', bool force = false}) async {
    final data = await _apiClient.post<Map<String, dynamic>>(
      '/user/youtube/transcript',
      body: {
        'youtube_url': youtubeUrl,
        'force': force,
        'lang': lang,
      },
    );
    return TranscriptProgress.fromJson(data);
  }

  /// Lay tien do xu ly transcript.
  /// API: GET /user/youtube/transcript/progress/{videoId}
  Future<TranscriptProgress> getProgress(String videoId) async {
    try {
      final data = await _apiClient.get<Map<String, dynamic>>(
        '/user/youtube/transcript/progress/$videoId',
      );
      return TranscriptProgress.fromJson(data);
    } on ApiException {
      return const TranscriptProgress();
    }
  }
}

final transcriptServiceProvider = Provider<TranscriptService>((ref) {
  return TranscriptService(ref.watch(apiClientProvider));
});
