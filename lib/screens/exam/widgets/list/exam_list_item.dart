import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../features/exam/presentation/exam_player_provider.dart';
import '../../../../features/exam/data/exam_service.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Web parity: `listing/exam-list-item.tsx`. One row = one exam set.
/// Completion state comes from [examResultProvider] keyed by the SET slug
/// (the live Flutter player bundles Lesen+Hören into one attempt per set —
/// unlike web, which tracks completion per-skill; see report for detail).
class ExamListItem extends ConsumerWidget {
  const ExamListItem({
    super.key,
    required this.item,
    required this.index,
    required this.locked,
    required this.onTap,
  });

  final ExamCatalogItem item;
  final int index;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final result = ref.watch(examResultProvider(item.slug));
    final attempt = result.valueOrNull;
    final isCompleted = attempt != null;
    final score = (attempt != null && attempt.maxScore > 0)
        ? ((attempt.score / attempt.maxScore) * 100).round()
        : null;
    final isGoodScore = (score ?? 0) >= 80;

    return InkWell(
      onTap: locked ? null : onTap,
      child: Opacity(
        opacity: locked ? 0.5 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCompleted ? tokens.success : tokens.muted,
                  shape: BoxShape.circle,
                ),
                child: locked
                    ? Icon(
                        PhosphorIcons.lock,
                        size: 16,
                        color: tokens.mutedForeground,
                      )
                    : isCompleted
                    ? const Icon(
                        PhosphorIcons.check,
                        color: Colors.white,
                        size: 20,
                      )
                    : Text(
                        (index + 1).toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: tokens.mutedForeground,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isCompleted ? tokens.success : tokens.foreground,
                      ),
                    ),
                    if ((item.titleVi ?? '').isNotEmpty)
                      Text(
                        item.titleVi!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: tokens.mutedForeground,
                        ),
                      ),
                  ],
                ),
              ),
              if (isCompleted && score != null)
                Text(
                  '$score%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isGoodScore ? tokens.success : tokens.warning,
                  ),
                ),
              const SizedBox(width: 4),
              Icon(
                PhosphorIcons.caretRight,
                size: 18,
                color: tokens.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
