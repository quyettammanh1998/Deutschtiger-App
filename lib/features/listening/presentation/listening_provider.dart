import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/listening_models.dart';

/// Listening sources provider
final listeningSourcesProvider = FutureProvider<List<ListeningSource>>((ref) async {
  return [
    const ListeningSource(
      id: 'easy-german',
      name: 'Easy German',
      nameVi: 'Easy German',
      description: 'Learn German with street interviews',
      type: 'youtube',
      url: 'https://www.youtube.com/c/EasyGerman',
      categories: [
        ListeningCategory(
          id: 'eg-a1',
          name: 'A1 Level',
          nameVi: 'Cấp độ A1',
          level: 'A1',
        ),
        ListeningCategory(
          id: 'eg-a2',
          name: 'A2 Level',
          nameVi: 'Cấp độ A2',
          level: 'A2',
        ),
        ListeningCategory(
          id: 'eg-b1',
          name: 'B1 Level',
          nameVi: 'Cấp độ B1',
          level: 'B1',
        ),
        ListeningCategory(
          id: 'eg-b2',
          name: 'B2 Level',
          nameVi: 'Cấp độ B2',
          level: 'B2',
        ),
      ],
    ),
    const ListeningSource(
      id: 'sprechen-b1',
      name: 'Sprechen Deutsch B1',
      nameVi: 'Nói Tiếng Đức B1',
      description: 'Practice listening at B1 level',
      type: 'audio',
      categories: [
        ListeningCategory(
          id: 'sb1-conversations',
          name: 'Conversations',
          nameVi: 'Đối thoại',
          level: 'B1',
        ),
        ListeningCategory(
          id: 'sb1-interviews',
          name: 'Interviews',
          nameVi: 'Phỏng vấn',
          level: 'B1',
        ),
      ],
    ),
    const ListeningSource(
      id: 'sprechen-b2',
      name: 'Sprechen Deutsch B2',
      nameVi: 'Nói Tiếng Đức B2',
      description: 'Advanced listening practice',
      type: 'audio',
      categories: [
        ListeningCategory(
          id: 'sb2-academic',
          name: 'Academic German',
          nameVi: 'Tiếng Đức học thuật',
          level: 'B2',
        ),
      ],
    ),
  ];
});

/// Podcasts provider
final podcastsProvider = FutureProvider<List<Podcast>>((ref) async {
  return EasyGermanData.podcasts;
});

/// Podcast by ID provider
final podcastByIdProvider = FutureProvider.family<Podcast?, String>((ref, id) async {
  final podcasts = await ref.watch(podcastsProvider.future);
  return podcasts.where((p) => p.id == id).firstOrNull;
});

/// Listening progress provider
final listeningProgressProvider = StateNotifierProvider<ListeningProgressNotifier, Map<String, double>>((ref) {
  return ListeningProgressNotifier();
});

class ListeningProgressNotifier extends StateNotifier<Map<String, double>> {
  ListeningProgressNotifier() : super({});

  void updateProgress(String itemId, double progress) {
    state = {...state, itemId: progress};
  }

  void markCompleted(String itemId) {
    state = {...state, itemId: 1.0};
  }

  double? getProgress(String itemId) => state[itemId];
}
