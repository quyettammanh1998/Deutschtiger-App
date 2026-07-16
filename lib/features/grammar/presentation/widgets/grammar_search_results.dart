import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/grammar/grammar_models.dart';

/// Danh sách kết quả tìm kiếm dùng chung cho `/grammar` (toàn bộ level) và
/// level-detail (trong 1 level) — web parity: `card divide-y` list với hàng
/// xanh khi đã hoàn thành (`grammar-list-page.tsx` / `grammar-level-detail.tsx`).
class GrammarSearchResults extends StatelessWidget {
  const GrammarSearchResults({
    super.key,
    required this.results,
    required this.completed,
    this.showLevelPill = false,
  });

  final List<GrammarLessonSummary> results;
  final Set<String> completed;

  /// Global search (mọi level) hiện pill level; search trong 1 level thì ẩn.
  final bool showLevelPill;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            l10n.grammarNoResults,
            style: TextStyle(color: tokens.mutedForeground, fontSize: 13),
          ),
        ),
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (var i = 0; i < results.length; i++) ...[
            if (i > 0) Divider(height: 1, color: tokens.border),
            _ResultRow(
              lesson: results[i],
              done: completed.contains(results[i].id),
              showLevelPill: showLevelPill,
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.lesson,
    required this.done,
    required this.showLevelPill,
  });
  final GrammarLessonSummary lesson;
  final bool done;
  final bool showLevelPill;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: done ? tokens.success.withValues(alpha: 0.06) : Colors.transparent,
      child: InkWell(
        onTap: () =>
            context.push('/grammar/${lesson.level.toLowerCase()}/${lesson.id}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: done ? tokens.success : tokens.muted,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  done ? Icons.check : Icons.menu_book_outlined,
                  color: done ? Colors.white : tokens.mutedForeground,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lesson.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: done ? tokens.success : tokens.foreground,
                      ),
                    ),
                    if (showLevelPill) ...[
                      const SizedBox(height: 3),
                      Text(
                        lesson.level,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: tokens.mutedForeground,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
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
