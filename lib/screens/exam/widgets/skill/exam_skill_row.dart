import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../features/exam/data/exam_service.dart';
import '../../../../features/exam/presentation/exam_player_provider.dart';
import '../../../../l10n/app_localizations.dart';

/// Web parity: `exam-skill-list-page.tsx` row. Shows the violet dictation
/// "Từ vựng" shortcut only on TELC B1 Hörverstehen rows (matches web).
class ExamSkillRow extends ConsumerWidget {
  const ExamSkillRow({
    super.key,
    required this.item,
    required this.index,
    required this.showDictationChip,
  });

  final ExamCatalogItem item;
  final int index;
  final bool showDictationChip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final result = ref.watch(examResultProvider(item.slug));
    final attempt = result.valueOrNull;
    final isCompleted = attempt != null;
    final score = (attempt != null && attempt.maxScore > 0)
        ? ((attempt.score / attempt.maxScore) * 100).round()
        : null;

    return InkWell(
      onTap: () => context.push('/exam/practice/${item.slug}?mode=practice'),
      child: Container(
        color: isCompleted ? tokens.success.withValues(alpha: 0.06) : null,
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
              child: isCompleted
                  ? const Icon(
                      Icons.check_rounded,
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
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  '$score%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: score >= 80 ? tokens.success : tokens.warning,
                  ),
                ),
              ),
            if (showDictationChip)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () =>
                      context.push('/exam/dictation/telc/b1/${item.slug}'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF), // violet-50
                      border: Border.all(
                        color: const Color(0xFFDDD6FE),
                      ), // violet-200
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.headphones_rounded,
                          size: 12,
                          color: Color(0xFF6D28D9),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.examSkillListVocabChip,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6D28D9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: tokens.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}
