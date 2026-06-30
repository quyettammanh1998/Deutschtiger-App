import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/exam/exam_repository.dart';
import '../../data/exam/exam_models.dart';

final examRepositoryProvider = Provider<ExamRepository>((ref) => ExamRepository());

final examHubsProvider = FutureProvider<List<ExamHub>>((ref) async {
  final repo = ref.watch(examRepositoryProvider);
  return repo.getExamHubs();
});

final examHubProvider = FutureProvider.family<ExamHub, String>((ref, hubId) async {
  final repo = ref.watch(examRepositoryProvider);
  return repo.getExamHub(hubId);
});

final writingTopicsProvider = FutureProvider.family<List<WritingTopic>, String>((ref, hubId) async {
  final repo = ref.watch(examRepositoryProvider);
  return repo.getWritingTopics(hubId);
});

final speakingTopicsProvider = FutureProvider.family<List<SpeakingTopic>, String>((ref, hubId) async {
  final repo = ref.watch(examRepositoryProvider);
  return repo.getSpeakingTopics(hubId);
});

final examReadinessProvider = FutureProvider.family<ExamReadiness, String>((ref, hubId) async {
  final repo = ref.watch(examRepositoryProvider);
  return repo.getReadiness(hubId);
});

final selectedExamHubProvider = StateProvider<ExamHub?>((ref) => null);
final selectedWritingTopicProvider = StateProvider<WritingTopic?>((ref) => null);
