import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/writing/data/official_writing_topic_repository.dart';
import '../../../features/writing/domain/writing_exam_id_parser.dart';
import '../../../features/writing/domain/writing_offering.dart';
import '../../../features/writing/presentation/writing_practice_panel.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/async_state_views.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// `writing-level-practice` (`/exam/:providerLevel/writing/:slug/practice`)
/// — thin wrapper around [WritingPracticePanel] for a generic official
/// writing topic. Web parity `WritingLevelPracticePage`: finds the topic by
/// slug client-side out of the already-fetched provider/level topic list
/// (same approach as web's `topics.find(t => t.slug === slug)`).
class WritingLevelPracticePage extends ConsumerWidget {
  const WritingLevelPracticePage({
    super.key,
    required this.providerLevel,
    required this.slug,
  });

  final String providerLevel;
  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final offering = findWritingOffering(providerLevel);

    if (offering == null) {
      return Scaffold(
        backgroundColor: tokens.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.writingLevelNotFound),
          ),
        ),
      );
    }

    final topicsAsync = ref.watch(
      officialWritingTopicsProvider((provider: offering.provider, level: offering.level)),
    );

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: topicsAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(message: l10n.couldNotLoadData, onRetry: () {}),
          data: (topics) {
            final topic = topics.where((t) => t.slug == slug).firstOrNull;
            if (topic == null || topic.locked) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(icon: const Icon(PhosphorIcons.arrowLeft), onPressed: () => context.pop()),
                    Text(
                      topic?.locked == true ? l10n.writingLevelLocked : l10n.writingPracticeNotFound,
                      style: TextStyle(color: tokens.mutedForeground),
                    ),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    IconButton(icon: const Icon(PhosphorIcons.arrowLeft), onPressed: () => context.pop()),
                    Expanded(
                      child: Text(
                        topic.titleDe,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tokens.foreground),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tokens.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        offering.label,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                WritingPracticePanel(
                  examId: buildOfficialWritingExamId(
                    provider: offering.provider,
                    level: offering.level,
                    slug: slug,
                  ),
                  taskPromptDe: topic.taskPromptDe,
                  writingPoints: topic.writingPoints,
                  level: offering.level.toUpperCase(),
                  provider: offering.provider == 'telc' ? 'telc' : 'goethe',
                  teilNum: [1, 2, 3].contains(topic.teil) ? topic.teil : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
