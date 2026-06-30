import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/providers.dart';
import '../domain/video_note.dart';

/// Repository cho video notes (ghi chu cua nguoi dung cho video YouTube).
class VideoNotesRepository {
  VideoNotesRepository(this._apiClient);
  final ApiClient _apiClient;

  /// Lay tat ca ghi chu cua user.
  /// API: GET /user/youtube/notes?limit={limit}
  Future<List<NoteWithVideo>> getAllNotes({int limit = 10}) async {
    try {
      final data = await _apiClient.get<Map<String, dynamic>>(
        '/user/youtube/notes',
        query: {'limit': limit},
      );
      final notes = (data['notes'] as List<dynamic>?) ?? [];
      return notes
          .map((e) => NoteWithVideo.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ApiException catch (e) {
      if (e.statusCode == 404) return [];
      rethrow;
    }
  }

  /// Lay ghi chu cho mot video.
  /// API: GET /user/youtube/notes/{videoId}
  /// Tra ve null neu chua co ghi chu.
  Future<VideoNote?> getNote(String videoId) async {
    try {
      final data = await _apiClient.get<Map<String, dynamic>>(
        '/user/youtube/notes/$videoId',
      );
      return VideoNote.fromJson(data);
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  /// Luu ghi chu cho mot video (upsert).
  /// API: PUT /user/youtube/notes/{videoId}
  Future<VideoNote> upsertNote(String videoId, String content) async {
    final data = await _apiClient.put<Map<String, dynamic>>(
      '/user/youtube/notes/$videoId',
      body: {'content': content},
    );
    return VideoNote.fromJson(data);
  }

  /// Xoa ghi chu cua mot video.
  /// API: DELETE /user/youtube/notes/{videoId}
  Future<void> deleteNote(String videoId) async {
    await _apiClient.delete<Map<String, dynamic>>(
      '/user/youtube/notes/$videoId',
    );
  }
}

final videoNotesRepositoryProvider = Provider<VideoNotesRepository>((ref) {
  return VideoNotesRepository(ref.watch(apiClientProvider));
});
