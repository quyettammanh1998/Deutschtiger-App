import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/interview/video_notes_repository.dart';
import '../../data/interview/video_note.dart';

export '../../repositories/interview/video_notes_repository.dart' show videoNotesRepositoryProvider;

/// Lay ghi chu cho mot video.
final videoNoteProvider = FutureProvider.family<VideoNote?, String>((ref, videoId) async {
  final repo = ref.watch(videoNotesRepositoryProvider);
  return repo.getNote(videoId);
});

/// Lay tat ca ghi chu video cua user.
final allVideoNotesProvider = FutureProvider<List<NoteWithVideo>>((ref) async {
  final repo = ref.watch(videoNotesRepositoryProvider);
  return repo.getAllNotes();
});

/// Service de luu ghi chu video.
class VideoNoteSaveService {
  VideoNoteSaveService(this._ref);
  final Ref _ref;

  Future<VideoNote> saveNote(String videoId, String content) async {
    final repo = _ref.read(videoNotesRepositoryProvider);
    final note = await repo.upsertNote(videoId, content);
    // Refresh cache
    _ref.invalidate(videoNoteProvider(videoId));
    _ref.invalidate(allVideoNotesProvider);
    return note;
  }

  Future<void> deleteNote(String videoId) async {
    final repo = _ref.read(videoNotesRepositoryProvider);
    await repo.deleteNote(videoId);
    // Refresh cache
    _ref.invalidate(videoNoteProvider(videoId));
    _ref.invalidate(allVideoNotesProvider);
  }
}

final videoNoteSaveServiceProvider = Provider<VideoNoteSaveService>((ref) {
  return VideoNoteSaveService(ref);
});
