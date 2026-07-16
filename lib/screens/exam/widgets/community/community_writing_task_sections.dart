import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'community_detail_section_widgets.dart';

/// First half of the writing `generated_data` sections: task, task
/// analysis, model answer. Web parity: `WritingTopicContent` in
/// `community-exam-detail-page.tsx` (top 3 cards). The remaining sections
/// (useful phrases / grammar focus / common mistakes) live in
/// `community_writing_extra_sections.dart` to stay under 200 LOC/file.
class CommunityWritingTaskSections extends StatelessWidget {
  const CommunityWritingTaskSections({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final task = data['task'] as Map<String, dynamic>?;
    final taskAnalysis = data['taskAnalysis'] as Map<String, dynamic>?;
    final points = (taskAnalysis?['points'] as List?)
        ?.cast<Map<String, dynamic>>();
    final modelAnswers = (data['modelAnswers'] as List?)
        ?.cast<Map<String, dynamic>>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (task != null)
          CommunityDetailSection(
            title: l10n.communitySectionTask,
            child: CommunityDeViText(
              de: task['de'] as String?,
              vi: task['vi'] as String?,
            ),
          ),
        if (points != null && points.isNotEmpty)
          CommunityDetailSection(
            title: l10n.communitySectionAnalysis,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (taskAnalysis?['summaryVi'] is String)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CommunityMutedText(
                      taskAnalysis!['summaryVi'] as String,
                    ),
                  ),
                for (final p in points)
                  CommunityBulletDeVi(
                    de: p['de'] as String?,
                    vi: p['vi'] as String?,
                  ),
              ],
            ),
          ),
        if (modelAnswers != null && modelAnswers.isNotEmpty)
          CommunityDetailSection(
            title: l10n.communitySectionModelAnswer,
            child: CommunityDeViText(
              de: modelAnswers.first['de'] as String?,
              vi: modelAnswers.first['vi'] as String?,
            ),
          ),
      ],
    );
  }
}
