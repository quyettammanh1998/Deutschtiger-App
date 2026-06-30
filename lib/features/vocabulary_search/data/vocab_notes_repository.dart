import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/providers.dart';
import '../domain/vocab_models.dart';

/// Repository cho vocabulary notes (ghi chu cua nguoi dung cho moi tu).
class VocabNotesRepository {
  VocabNotesRepository(this._apiClient);
  final ApiClient _apiClient;

  /// Lay ghi chu cho mot tu.
  /// API: GET /user/vocabulary/notes/{wordId}
  /// Tra ve null neu chua co ghi chu.
  Future<String?> getNote(String wordId) async {
    try {
      final data = await _apiClient.get<Map<String, dynamic>>(
        '/user/vocabulary/notes/$wordId',
      );
      return data['note'] as String?;
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  /// Lay tat ca ghi chu cua user.
  /// API: GET /user/vocabulary/notes
  Future<List<VocabWordWithNote>> getAllNotes({int limit = 50}) async {
    final data = await _apiClient.get<Map<String, dynamic>>(
      '/user/vocabulary/notes',
      query: {'limit': limit},
    );
    final notes = data['notes'] as List<dynamic>? ?? [];
    return notes
        .map((e) => VocabWordWithNote.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Luu ghi chu cho mot tu (upsert).
  /// API: PUT /user/vocabulary/notes/{wordId}
  Future<void> saveNote(String wordId, String note) async {
    await _apiClient.put<Map<String, dynamic>>(
      '/user/vocabulary/notes/$wordId',
      body: {'note': note},
    );
  }

  /// Xoa ghi chu cua mot tu.
  /// API: DELETE /user/vocabulary/notes/{wordId}
  Future<void> deleteNote(String wordId) async {
    await _apiClient.delete<Map<String, dynamic>>(
      '/user/vocabulary/notes/$wordId',
    );
  }
}

/// Tu vung kem ghi chu (tra ve tu full thay vi chi note).
class VocabWordWithNote {
  final String wordId;
  final String? note;
  final DateTime? updatedAt;
  final VocabWord? word; // Optional: full word details if available

  const VocabWordWithNote({
    required this.wordId,
    this.note,
    this.updatedAt,
    this.word,
  });

  factory VocabWordWithNote.fromJson(Map<String, dynamic> json) {
    VocabWord? word;
    if (json['word'] != null) {
      word = VocabWord.fromJson(json['word'] as Map<String, dynamic>);
    }

    return VocabWordWithNote(
      wordId: json['word_id'] as String? ?? json['id'] as String? ?? '',
      note: json['note'] as String?,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      word: word,
    );
  }
}

final vocabNotesRepositoryProvider = Provider<VocabNotesRepository>((ref) {
  return VocabNotesRepository(ref.watch(apiClientProvider));
});
