import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../features/daily_path/presentation/daily_path_provider.dart';
import '../../../l10n/app_localizations.dart';

/// "Hôm nay" page header — title + minutes remaining + exam countdown.
/// Mirrors web `learn-home-page.tsx` `<h1>Hôm nay</h1>` block (mobile):
/// goal line under the title, amber when the exam is within 28 days.
class JourneyHeader extends ConsumerWidget {
  const JourneyHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final path = ref.watch(dailyPathProvider).valueOrNull;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.screenHorizontalPadding,
        DesignTokens.spacingSm,
        DesignTokens.screenHorizontalPadding,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.today,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: tokens.foreground,
            ),
          ),
          if (path != null && path.estimatedMinutesRemaining > 0) ...[
            const SizedBox(height: 2),
            Text(
              l10n.dailyPathMinutesRemaining(path.estimatedMinutesRemaining),
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            ),
          ],
          if (path != null &&
              path.daysToExam != null &&
              path.examLabel != null) ...[
            const SizedBox(height: 2),
            _ExamCountdownLine(
              daysToExam: path.daysToExam!,
              examLabel: path.examLabel!,
            ),
          ],
        ],
      ),
    );
  }
}

class _ExamCountdownLine extends StatelessWidget {
  const _ExamCountdownLine({required this.daysToExam, required this.examLabel});

  final int daysToExam;
  final String examLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final close = daysToExam <= 28;
    final color = close
        ? DesignTokens.amber700
        : context.tokens.mutedForeground;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('⏳ ', style: TextStyle(fontSize: 11, color: color)),
        Text(
          l10n.dailyPathExamBadge(daysToExam, examLabel),
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
