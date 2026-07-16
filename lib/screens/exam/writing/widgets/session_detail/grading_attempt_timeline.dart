import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/data/writing_repository.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../widgets/common/async_state_views.dart';

final _gradingAttemptsProvider =
    FutureProvider.autoDispose.family((ref, String submissionId) {
  return ref.watch(writingRepositoryProvider).listGradingAttempts(submissionId);
});

/// `GradingAttemptTimeline` — every AI-graded attempt on this submission,
/// newest first, with score deltas.
class GradingAttemptTimeline extends ConsumerWidget {
  const GradingAttemptTimeline({super.key, required this.submissionId});

  final String submissionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(_gradingAttemptsProvider(submissionId));

    return async.when(
      loading: () => const LoadingView(),
      error: (_, _) => const SizedBox.shrink(),
      data: (attempts) {
        if (attempts.length < 2) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.writingSessionGradingTimelineTitle,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tokens.foreground),
              ),
              const SizedBox(height: 10),
              for (final a in attempts)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: tokens.primary, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('dd/MM HH:mm').format(a.gradedAt.toLocal()),
                        style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                      ),
                      const Spacer(),
                      Text(
                        '${a.aiScore}/100',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: tokens.foreground),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
