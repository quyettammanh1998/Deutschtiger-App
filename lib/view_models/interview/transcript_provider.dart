import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/transcript_service.dart';
import '../domain/transcript_models.dart';

export '../data/transcript_service.dart' show transcriptServiceProvider;

/// Transcript provider - lay transcript cho video.
final transcriptProvider = FutureProvider.family<TranscriptResult?, String>((ref, videoId) async {
  final service = ref.watch(transcriptServiceProvider);
  return service.getTranscript(videoId);
});

/// Transcript progress provider - kiem tra tien do xu ly.
final transcriptProgressProvider = FutureProvider.family<TranscriptProgress, String>((ref, videoId) async {
  final service = ref.watch(transcriptServiceProvider);
  return service.getProgress(videoId);
});
