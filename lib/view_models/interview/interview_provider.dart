import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/services/config/app_config.dart';
import 'package:deutschtiger/view_models/providers.dart';
import '../../repositories/interview/interview_repository.dart';
import '../../data/interview/interview_models.dart';

final interviewRepositoryProvider = Provider<InterviewRepository>((ref) {
  return InterviewRepository(
    ref.watch(apiClientProvider),
    staticBaseUrl: AppConfig.webviewBaseUrl,
  );
});

/// Lộ trình tĩnh — 18 nhóm video. Cache theo vòng đời provider.
final learningPathProvider = FutureProvider<List<InterviewGroup>>((ref) {
  return ref.watch(interviewRepositoryProvider).fetchLearningPath();
});

/// Tiến độ từng nhóm, map theo group_id để tra cứu nhanh trên màn roadmap.
/// Premium-gated: 403 → trả map rỗng (UI vẫn hiện lộ trình, ẩn % tiến độ).
final groupProgressProvider =
    FutureProvider<Map<String, InterviewGroupProgress>>((ref) async {
      ref.watch(authStateProvider);
      try {
        final list = await ref
            .watch(interviewRepositoryProvider)
            .fetchGroupProgress();
        return {for (final p in list) p.groupId: p};
      } catch (_) {
        return const {};
      }
    });

/// Một nhóm trong lộ trình tĩnh theo group_id (null nếu không tìm thấy).
final groupByIdProvider = Provider.family<InterviewGroup?, String>((
  ref,
  groupId,
) {
  final groups = ref.watch(learningPathProvider).value ?? const [];
  for (final g in groups) {
    if (g.groupId == groupId) return g;
  }
  return null;
});

/// Trạng thái xem video của một nhóm. Trước khi fetch, seed metadata video vào
/// DB (giống web) để mỗi video có `id` cho complete/rewatch. Premium-gated:
/// seed/fetch có thể ném 403 → caller (màn) bắt và hiện màn Cần Premium.
final videosByGroupProvider =
    FutureProvider.family<List<InterviewVideo>, String>((ref, groupId) async {
      ref.watch(authStateProvider);
      final repo = ref.watch(interviewRepositoryProvider);
      final group = ref.watch(groupByIdProvider(groupId));
      if (group != null && group.videos.isNotEmpty) {
        await repo.seedGroupVideos(
          groupId,
          [
            for (final v in group.videos)
              (videoId: v.videoId, title: v.title),
          ],
        );
      }
      return repo.fetchVideosByGroup(groupId);
    });
