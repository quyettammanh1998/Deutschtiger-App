import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/view_models/providers.dart';
import '../../data/speech/sprechen_models.dart';
import '../../repositories/speech/sprechen_repository.dart';

/// Repository + catalog providers for the Sprechen surface. Session/AI
/// providers live in `sprechen_session_provider.dart` /
/// `sprechen_ai_repository_provider.dart` (kept split to stay <200 LOC).

final sprechenRepositoryProvider = Provider<SprechenRepository>((ref) {
  return SprechenRepository(ref.watch(apiClientProvider));
});

/// Topic list for a teil segment (e.g. `goethe-teil1`, `telc-teil2`).
final sprechenTopicsProvider = FutureProvider.family<List<SprechenTopic>, String>((
  ref,
  teil,
) {
  return ref.watch(sprechenRepositoryProvider).fetchTopics(teil);
});

/// Tag/group list for a teil segment; may be empty (flat list fallback).
final sprechenTagsProvider = FutureProvider.family<List<SprechenTag>, String>((
  ref,
  teil,
) {
  return ref.watch(sprechenRepositoryProvider).fetchTags(teil);
});

/// Study/practice content markdown for a topic by exam-question uuid.
final sprechenContentProvider = FutureProvider.family<SprechenContent, String>((
  ref,
  contentId,
) {
  return ref.watch(sprechenRepositoryProvider).fetchContent(contentId);
});
