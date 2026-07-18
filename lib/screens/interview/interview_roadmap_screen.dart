import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/release/release_feature_flags.dart';
import '../../core/theme/app_tokens.dart';
import 'package:deutschtiger/widgets/common/async_state_views.dart';
import 'package:deutschtiger/shared/widgets/premium_gate_card.dart';
import 'package:deutschtiger/data/interview/interview_models.dart';
import 'package:deutschtiger/view_models/interview/interview_provider.dart';
import 'package:deutschtiger/screens/youtube/widgets/group_progress_tile.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Lộ trình luyện phỏng vấn — web parity `interview-tracker-page.tsx`
/// (`PurchaseGate(module 'interview')` + `InterviewRoadmap`: progress bar +
/// motivation, divided card list, blue level pill, amber/green states).
///
/// Web `InterviewLeaderboard` stacked below the list on mobile is DEFERRED
/// (no shared per-collection leaderboard widget exists yet in Flutter — see
/// report deviation notes; plan §5 calls this out as a cross-wave shared
/// component, not exclusive to this wave).
class InterviewRoadmapScreen extends ConsumerStatefulWidget {
  const InterviewRoadmapScreen({super.key});

  @override
  ConsumerState<InterviewRoadmapScreen> createState() => _InterviewRoadmapScreenState();
}

class _InterviewRoadmapScreenState extends ConsumerState<InterviewRoadmapScreen> {
  InterviewGroup? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    if (!ReleaseFeatureFlags.premium) {
      return Scaffold(
        backgroundColor: tokens.background,
        appBar: AppBar(title: const Text('Luyện phỏng vấn')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PremiumGateCard(
              title: 'Luyện phỏng vấn',
              description:
                  'Bộ video phỏng vấn có hướng dẫn theo lộ trình — tính năng premium chưa mở trên app.',
              icon: PhosphorIcons.crown,
            ),
          ),
        ),
      );
    }

    final pathAsync = ref.watch(learningPathProvider);
    final progressAsync = ref.watch(groupProgressProvider);
    final selected = _selectedGroup;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text(selected != null ? selected.nameVi : 'Luyện phỏng vấn'),
        leading: selected != null
            ? IconButton(
                icon: const Icon(PhosphorIcons.arrowLeft),
                onPressed: () => setState(() => _selectedGroup = null),
              )
            : null,
      ),
      body: SafeArea(
        child: pathAsync.when(
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(
            message: 'Không tải được lộ trình.',
            onRetry: () => ref.invalidate(learningPathProvider),
          ),
          data: (groups) {
            if (selected != null) {
              return _GroupVideoList(group: selected);
            }
            final progress = progressAsync.value ?? const {};
            final totalVideos = groups.fold<int>(0, (sum, g) => sum + g.videoCount);
            final totalCompleted = progress.values.fold<int>(0, (sum, p) => sum + p.completed);
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (totalVideos > 0) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: totalCompleted / totalVideos,
                      minHeight: 6,
                      backgroundColor: tokens.muted,
                      color: tokens.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$totalCompleted/$totalVideos video · ${motivationForProgress(totalCompleted, totalVideos)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: tokens.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                for (final g in groups)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: GroupProgressTile(
                      order: g.order,
                      nameDe: g.nameDe,
                      nameVi: g.nameVi,
                      videoCount: g.videoCount,
                      level: g.level,
                      completed: progress[g.groupId]?.completed ?? 0,
                      total: progress[g.groupId]?.total ?? g.videoCount,
                      onTap: () => setState(() => _selectedGroup = g),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GroupVideoList extends ConsumerWidget {
  const _GroupVideoList({required this.group});

  final InterviewGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final videosAsync = ref.watch(videosByGroupProvider(group.groupId));
    return videosAsync.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorView(
        message: 'Không tải được video của nhóm (có thể cần Premium).',
        onRetry: () => ref.invalidate(videosByGroupProvider(group.groupId)),
      ),
      data: (videos) {
        if (videos.isEmpty) return const ErrorView(message: 'Nhóm chưa có video nào.');
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: videos.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final v = videos[i];
            return Material(
              color: tokens.card,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.push('/interview/watch?v=${v.videoId}&group=${group.groupId}'),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://img.youtube.com/vi/${v.videoId}/mqdefault.jpg',
                          width: 96,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              Container(width: 96, height: 60, color: tokens.muted),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${i + 1}. ${v.title}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: tokens.foreground,
                          ),
                        ),
                      ),
                      if (v.isCompleted) Icon(PhosphorIcons.checkCircle, color: tokens.success, size: 22),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
