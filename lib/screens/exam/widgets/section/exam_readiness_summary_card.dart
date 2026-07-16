import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../view_models/exam/exam_ecosystem_providers.dart';

/// Compact readiness band shown atop the section/list pages — web
/// `ExamReadinessCard`. `GET /exam-readiness` is NOT provider/level scoped
/// in the live BE contract (single aggregate snapshot), so this renders the
/// same overall band everywhere a provider/level page would show it; a
/// per-provider/level breakdown would need a new BE contract (out of scope
/// for this UI-only wave — flagged as a follow-up).
class ExamReadinessSummaryCard extends ConsumerWidget {
  const ExamReadinessSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final readiness = ref.watch(examReadinessProvider);
    return readiness.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (snapshot) {
        if (snapshot.attemptCount == 0) return const SizedBox.shrink();
        final mid = (snapshot.readinessLow + snapshot.readinessHigh) / 2;
        final color = mid >= 80
            ? tokens.success
            : (mid >= 50 ? tokens.warning : tokens.destructive);
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/exam/readiness'),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: tokens.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.border),
            ),
            child: Row(
              children: [
                Text(
                  '${snapshot.readinessLow}–${snapshot.readinessHigh}%',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.examReadinessBandLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: tokens.mutedForeground,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
