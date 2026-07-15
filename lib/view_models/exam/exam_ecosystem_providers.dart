import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/exam/exam_ecosystem_models.dart';
import '../../repositories/exam/community_exam_repository.dart';
import '../../repositories/exam/de_thi_repository.dart';
import '../../repositories/exam/exam_dictation_repository.dart';
import '../../repositories/exam/exam_readiness_repository.dart';
import '../../repositories/exam/exam_registration_repository.dart';

/// Mức sẵn sàng thi. `GET /exam-readiness`.
final examReadinessProvider = FutureProvider<ExamReadinessSnapshot>((
  ref,
) async {
  return ref.watch(examReadinessRepositoryProvider).getReadiness();
});

/// Lịch thi đã đăng ký của tôi. `GET /user/exam-registrations`.
final myExamRegistrationsProvider = FutureProvider<List<ExamRegistration>>((
  ref,
) async {
  return ref.watch(examRegistrationRepositoryProvider).listMine();
});

/// Danh bạ tìm bạn ôn thi (read-only). `GET /exam-buddies`.
final examBuddiesProvider = FutureProvider<List<ExamBuddy>>((ref) async {
  return ref.watch(examRegistrationRepositoryProvider).listBuddies();
});

/// Danh sách đề thi cộng đồng (read-only). `GET /user/community/exams/`.
final communityExamListProvider =
    FutureProvider.family<List<CommunityExamTopic>, CommunityExamFilter>((
      ref,
      filter,
    ) async {
      return ref
          .watch(communityExamRepositoryProvider)
          .list(
            provider: filter.provider,
            level: filter.level,
            skill: filter.skill,
          );
    });

/// Chi tiết một đề thi cộng đồng. `GET /user/community/exams/{id}`.
final communityExamDetailProvider =
    FutureProvider.family<CommunityExamTopic, String>((ref, id) async {
      return ref.watch(communityExamRepositoryProvider).getById(id);
    });

/// Word-transcript cho luyện nghe chép chính tả.
final examWordTranscriptProvider =
    FutureProvider.family<ExamWordTranscript, ExamDictationTarget>((
      ref,
      target,
    ) async {
      return ref
          .watch(examDictationRepositoryProvider)
          .getTranscript(
            provider: target.provider,
            level: target.level,
            slug: target.slug,
          );
    });

/// Đề thi public (de-thi registry) theo [dataPath].
final deThiExamProvider = FutureProvider.family<DeThiExam, String>((
  ref,
  dataPath,
) async {
  return ref.watch(deThiRepositoryProvider).fetchExam(dataPath);
});

/// Filter cho danh sách đề thi cộng đồng — key cho `family` provider.
class CommunityExamFilter {
  const CommunityExamFilter({this.provider, this.level, this.skill});

  final String? provider;
  final String? level;
  final String? skill;

  @override
  bool operator ==(Object other) =>
      other is CommunityExamFilter &&
      other.provider == provider &&
      other.level == level &&
      other.skill == skill;

  @override
  int get hashCode => Object.hash(provider, level, skill);
}

/// Target cho dictation transcript — key cho `family` provider.
class ExamDictationTarget {
  const ExamDictationTarget({
    required this.provider,
    required this.level,
    required this.slug,
  });

  final String provider;
  final String level;
  final String slug;

  @override
  bool operator ==(Object other) =>
      other is ExamDictationTarget &&
      other.provider == provider &&
      other.level == level &&
      other.slug == slug;

  @override
  int get hashCode => Object.hash(provider, level, slug);
}
