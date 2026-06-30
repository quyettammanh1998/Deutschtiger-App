import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'interview_provider.dart';
import 'widgets/group_card.dart';

/// Màn lộ trình video phỏng vấn (tab "Bài học"): danh sách 18 nhóm theo thứ tự,
/// kèm % tiến độ nếu user có premium. Bấm nhóm → màn chi tiết.
class InterviewRoadmapScreen extends ConsumerWidget {
  const InterviewRoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(learningPathProvider);
    final progress = ref.watch(groupProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Lộ trình video',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
      ),
      body: groups.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Không tải được lộ trình video.',
          onRetry: () => ref.invalidate(learningPathProvider),
        ),
        data: (list) {
          final progressMap = progress.value ?? const {};
          return RefreshIndicator(
            color: AppColors.tigerOrange,
            onRefresh: () async {
              ref.invalidate(learningPathProvider);
              ref.invalidate(groupProgressProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final g = list[i];
                return GroupCard(
                  group: g,
                  progress: progressMap[g.groupId],
                  onTap: () => context.push('/lessons/group/${g.groupId}'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
