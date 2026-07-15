import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/exam/exam_ecosystem_providers.dart';
import '../../widgets/common/async_state_views.dart';

/// Chi tiết một đề thi cộng đồng — READ-ONLY. Comment/vote write để GĐ2 P3.
class CommunityExamDetailScreen extends ConsumerWidget {
  const CommunityExamDetailScreen({super.key, required this.topicId});
  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final topic = ref.watch(communityExamDetailProvider(topicId));

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(title: Text(l10n.communityExamDetailTitle)),
      body: topic.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: l10n.couldNotLoadData,
          onRetry: () => ref.invalidate(communityExamDetailProvider(topicId)),
        ),
        data: (data) => ListView(
          padding: const EdgeInsets.all(DesignTokens.screenHorizontalPadding),
          children: [
            Text(
              data.titleDe,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            if (data.titleVi != null && data.titleVi!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                data.titleVi!,
                style: const TextStyle(color: DesignTokens.mutedForeground),
              ),
            ],
            const SizedBox(height: DesignTokens.spacingSm),
            Text(
              '${data.provider.toUpperCase()} ${data.level.toUpperCase()} · ${data.skill}'
              '${data.teil > 0 ? ' Teil ${data.teil}' : ''}',
              style: const TextStyle(color: DesignTokens.mutedForeground),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            if (data.inputText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(DesignTokens.cardPadding),
                decoration: BoxDecoration(
                  color: DesignTokens.card,
                  borderRadius: BorderRadius.circular(DesignTokens.radius),
                  border: Border.all(color: DesignTokens.border),
                ),
                child: Text(data.inputText),
              ),
            const SizedBox(height: DesignTokens.spacingMd),
            Row(
              children: [
                const Icon(Icons.thumb_up_outlined, size: 16),
                const SizedBox(width: 4),
                Text('${data.voteCount}'),
                const SizedBox(width: DesignTokens.spacingLg),
                const Icon(Icons.history_edu_outlined, size: 16),
                const SizedBox(width: 4),
                Text('${data.versionCount}'),
              ],
            ),
            if (data.contributorName.isNotEmpty) ...[
              const SizedBox(height: DesignTokens.spacingSm),
              Text(
                l10n.communityExamContributedBy(data.contributorName),
                style: const TextStyle(color: DesignTokens.mutedForeground),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
