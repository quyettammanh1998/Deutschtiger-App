import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/icons/app_phosphor_icons.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/exam/exam_ecosystem_models.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/exam/exam_ecosystem_providers.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/community/community_writing_extra_sections.dart';
import 'widgets/community/community_writing_task_sections.dart';
import 'widgets/community/real_exam_badge.dart';

/// Chi tiết một đề thi cộng đồng — READ-ONLY. Web parity:
/// `community-exam-detail-page.tsx`: back link, badge row (Cộng đồng chip +
/// provider label + [RealExamBadge]), title de/vi, contributor line, hidden
/// banner, structured content sections, gated action row.
///
/// Comment/vote/report/"Tôi vừa thi" write actions stay gated (no live
/// write endpoint wired this phase) — buttons render disabled rather than
/// faking a success state.
class CommunityExamDetailScreen extends ConsumerWidget {
  const CommunityExamDetailScreen({super.key, required this.topicId});
  final String topicId;

  static const _providerLabels = {
    'goethe': 'Goethe B1 Writing',
    'telc': 'Telc B1 Nói',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final topic = ref.watch(communityExamDetailProvider(topicId));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: topic.when(
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(
            message: l10n.couldNotLoadData,
            onRetry: () => ref.invalidate(communityExamDetailProvider(topicId)),
          ),
          data: (data) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              InkWell(
                onTap: () => context.pop(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      AppPhosphorIcons.caretLeft,
                      size: 14,
                      color: tokens.mutedForeground,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.communityBackLink,
                      style: TextStyle(
                        fontSize: 13,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _BadgeRow(
                topic: data,
                providerLabel: _providerLabels[data.provider] ?? data.provider,
              ),
              const SizedBox(height: 4),
              Text(
                data.titleDe,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: tokens.foreground,
                ),
              ),
              if (data.titleVi != null && data.titleVi!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  data.titleVi!,
                  style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                ),
              ],
              const SizedBox(height: 4),
              if (data.contributorName.isNotEmpty)
                Text(
                  l10n.communityExamContributedBy(data.contributorName) +
                      _createdSuffix(data),
                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                ),
              const SizedBox(height: 16),
              if (data.status == 'hidden') _HiddenBanner(),
              if (data.generatedData != null)
                data.skill == 'writing'
                    ? Column(
                        children: [
                          CommunityWritingTaskSections(
                            data: data.generatedData!,
                          ),
                          CommunityWritingExtraSections(
                            data: data.generatedData!,
                          ),
                        ],
                      )
                    : CommunitySpeakingContent(raw: data.generatedData),
              const SizedBox(height: 24),
              _ActionsRow(),
            ],
          ),
        ),
      ),
    );
  }

  String _createdSuffix(CommunityExamTopic data) {
    final parsed = DateTime.tryParse(data.createdAt);
    if (parsed == null) return '';
    return ' • ${DateFormat('dd/MM/yyyy').format(parsed.toLocal())}';
  }
}

class _BadgeRow extends StatelessWidget {
  const _BadgeRow({required this.topic, required this.providerLabel});

  final CommunityExamTopic topic;
  final String providerLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Text(
              l10n.communityBadgeLabel,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D4ED8),
              ),
            ),
          ),
        ),
        Text(
          '$providerLabel Teil ${topic.teil}',
          style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
        ),
        RealExamBadge(
          examDate: topic.examDate,
          examLocation: topic.examLocation,
          compact: false,
        ),
      ],
    );
  }
}

class _HiddenBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFCE8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        l10n.communityHiddenBanner,
        style: const TextStyle(fontSize: 13, color: Color(0xFF854D0E)),
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: tokens.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Tooltip(
              message: l10n.communityGatedTooltip,
              child: AppButton(
                label: l10n.communityTakeExamAction,
                leading: Icon(AppPhosphorIcons.microphoneStage),
                onPressed: null,
              ),
            ),
            Tooltip(
              message: l10n.communityGatedTooltip,
              child: AppButton(
                label: l10n.communityReportAction,
                variant: AppButtonVariant.outline,
                leading: Icon(AppPhosphorIcons.flag),
                onPressed: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
