import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_tokens.dart';
import '../../data/exam/exam_ecosystem_models.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/exam/exam_ecosystem_providers.dart';
import '../../widgets/common/async_state_views.dart';

/// Danh sách đề thi cộng đồng — READ-ONLY (không comment/vote write ở phase
/// này, chờ GĐ2 P3 quyết report/block cho UGC).
class CommunityExamsListScreen extends ConsumerWidget {
  const CommunityExamsListScreen({super.key});

  static const _filter = CommunityExamFilter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final topics = ref.watch(communityExamListProvider(_filter));

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(title: Text(l10n.communityExamsTitle)),
      body: topics.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: l10n.couldNotLoadData,
          onRetry: () => ref.invalidate(communityExamListProvider(_filter)),
        ),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Text(
                l10n.communityExamsEmpty,
                style: const TextStyle(color: DesignTokens.mutedForeground),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(communityExamListProvider(_filter));
              await ref.read(communityExamListProvider(_filter).future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(
                DesignTokens.screenHorizontalPadding,
              ),
              itemCount: list.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: DesignTokens.spacingSm),
              itemBuilder: (context, index) =>
                  _CommunityExamCard(topic: list[index]),
            ),
          );
        },
      ),
    );
  }
}

class _CommunityExamCard extends StatelessWidget {
  const _CommunityExamCard({required this.topic});
  final CommunityExamTopic topic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/exam/community/${topic.id}'),
      borderRadius: BorderRadius.circular(DesignTokens.radius),
      child: Container(
        padding: const EdgeInsets.all(DesignTokens.cardPadding),
        decoration: BoxDecoration(
          color: DesignTokens.card,
          borderRadius: BorderRadius.circular(DesignTokens.radius),
          border: Border.all(color: DesignTokens.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    topic.titleDe,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                if (topic.isVerified)
                  const Icon(
                    Icons.verified,
                    size: 16,
                    color: DesignTokens.info,
                  ),
              ],
            ),
            if (topic.titleVi != null && topic.titleVi!.isNotEmpty)
              Text(
                topic.titleVi!,
                style: const TextStyle(color: DesignTokens.mutedForeground),
              ),
            const SizedBox(height: DesignTokens.spacingXs),
            Text(
              '${topic.provider.toUpperCase()} ${topic.level.toUpperCase()} · ${topic.skill}'
              '${topic.teil > 0 ? ' Teil ${topic.teil}' : ''}',
              style: const TextStyle(fontSize: 12, color: DesignTokens.mutedForeground),
            ),
            const SizedBox(height: DesignTokens.spacingXs),
            Row(
              children: [
                const Icon(Icons.thumb_up_outlined, size: 14),
                const SizedBox(width: 4),
                Text('${topic.voteCount}'),
                const SizedBox(width: DesignTokens.spacingMd),
                if (topic.contributorName.isNotEmpty)
                  Text(
                    topic.contributorName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: DesignTokens.mutedForeground,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
