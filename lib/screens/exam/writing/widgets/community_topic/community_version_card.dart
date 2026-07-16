import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/community_writing_topic.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../widgets/common/app_button.dart';

/// Content card for the currently-selected version — web parity
/// `CommunityVersionCard`: task text, writing points, contributor line,
/// vote/add-version/report actions.
class CommunityVersionCard extends StatelessWidget {
  const CommunityVersionCard({
    super.key,
    required this.version,
    required this.onVote,
    required this.onAddVersion,
    required this.onReport,
    this.isVoting = false,
  });

  final CommunityWritingTopic version;
  final VoidCallback onVote;
  final VoidCallback onAddVersion;
  final VoidCallback onReport;
  final bool isVoting;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final points = version.writingPoints;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.communitySectionTask,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 4),
          Text(
            version.taskPromptDe,
            style: TextStyle(fontSize: 13, color: tokens.foreground, height: 1.4),
          ),
          if (points.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.writingCommunityPointsTitle,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: tokens.mutedForeground),
            ),
            const SizedBox(height: 4),
            for (final p in points)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text('• $p', style: TextStyle(fontSize: 12, color: tokens.foreground)),
              ),
          ],
          const SizedBox(height: 12),
          Text(
            '👤 ${version.contributorName?.isNotEmpty == true ? version.contributorName : l10n.communityAnonymousContributor}',
            style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppButton(
                label: '👍 ${version.voteCount ?? 0}',
                variant: version.isVoted == true ? AppButtonVariant.primary : AppButtonVariant.outline,
                size: AppButtonSize.small,
                onPressed: isVoting ? null : onVote,
              ),
              AppButton(
                label: l10n.writingCommunityAddVersion,
                variant: AppButtonVariant.outline,
                size: AppButtonSize.small,
                onPressed: onAddVersion,
              ),
              AppButton(
                label: l10n.communityReportAction,
                variant: AppButtonVariant.ghost,
                size: AppButtonSize.small,
                onPressed: onReport,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
