import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/journey_repository.dart';
import '../domain/journey_models.dart';

final journeyRepositoryProvider = Provider((ref) => JourneyRepository());

final journeyChaptersProvider = FutureProvider<List<JourneyChapter>>((ref) async {
  final repo = ref.watch(journeyRepositoryProvider);
  return repo.getChapters();
});

final journeyChapterProvider = FutureProvider.family<JourneyChapter, String>((ref, chapterId) async {
  final repo = ref.watch(journeyRepositoryProvider);
  return repo.getChapter(chapterId);
});

final learningItemsProvider = FutureProvider.family<List<LearningItem>, String>((ref, chapterId) async {
  final repo = ref.watch(journeyRepositoryProvider);
  return repo.getLearningItems(chapterId);
});

/// Provider for all learning items across chapters
final allLearningItemsProvider = FutureProvider<List<LearningItem>>((ref) async {
  final repo = ref.watch(journeyRepositoryProvider);
  return repo.getAllLearningItems();
});

final journeyProgressProvider = FutureProvider<JourneyProgress>((ref) async {
  final repo = ref.watch(journeyRepositoryProvider);
  return repo.getProgress();
});

/// Selected chapter state using Notifier
final selectedChapterProvider = NotifierProvider<SelectedChapterNotifier, JourneyChapter?>(() => SelectedChapterNotifier());

class SelectedChapterNotifier extends Notifier<JourneyChapter?> {
  @override
  JourneyChapter? build() => null;

  void select(JourneyChapter? chapter) {
    state = chapter;
  }
}

/// Selected lesson state using Notifier
final selectedLessonProvider = NotifierProvider<SelectedLessonNotifier, JourneyLesson?>(() => SelectedLessonNotifier());

class SelectedLessonNotifier extends Notifier<JourneyLesson?> {
  @override
  JourneyLesson? build() => null;

  void select(JourneyLesson? lesson) {
    state = lesson;
  }
}
