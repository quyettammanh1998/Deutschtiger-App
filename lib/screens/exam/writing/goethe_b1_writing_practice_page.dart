import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../features/writing/data/goethe_b1_writing_repository.dart';
import '../../../features/writing/domain/writing_exam_id.dart';
import '../../../features/writing/presentation/writing_practice_panel.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/common/async_state_views.dart';
import 'widgets/practice/practice_prompt_card.dart';

/// `goethe-b1-writing-practice` (`.../:teilNum/:slug/practice`) — a thin
/// wrapper around W1's [WritingPracticePanel]. Web parity
/// `goethe-b1-writing-practice-page.tsx`: left prompt card (desktop
/// 2-column, stacked on mobile) + the shared practice panel.
///
/// DEVIATION: web's `footer` slot renders `AskAiAboutTopicButton` (opens the
/// Tiger AI chat pre-seeded with topic context). Building that context
/// bridge is out of this wave's scope (not explicitly required, no existing
/// Flutter helper) — `footer` is omitted; named follow-up in phase report.
class GoetheB1WritingPracticePage extends ConsumerWidget {
  const GoetheB1WritingPracticePage({super.key, required this.teil, required this.slug});

  final int teil;
  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final topicAsync =
        ref.watch(goetheB1WritingTopicProvider((teil: teil, slug: slug)));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: topicAsync.when(
          loading: () => const LoadingView(),
          error: (_, _) => ErrorView(
            message: l10n.couldNotLoadData,
            onRetry: () =>
                ref.invalidate(goetheB1WritingTopicProvider((teil: teil, slug: slug))),
          ),
          data: (topic) {
            if (topic.isIntro || topic.task == null) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    ),
                    Text(l10n.writingPracticeNotFound,
                        style: const TextStyle(color: Colors.red)),
                  ],
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    ),
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
                        l10n.writingTeilLabel(teil),
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                PracticePromptCard(topic: topic),
                const SizedBox(height: 16),
                WritingPracticePanel(
                  examId: buildGoetheB1WritingExamId(teil: teil, slug: slug),
                  taskPromptDe: topic.task?.de ?? '',
                  writingPoints:
                      (topic.taskAnalysis?.points ?? const []).map((p) => p.de).toList(),
                  teilNum: teil,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
