import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// "Việc cần làm" quick-links card — mirrors web `exam-readiness-page.tsx`.
/// Only the due-review link is wired: the web's second bullet ("từ thi sai
/// chưa đưa vào ôn") jumps to an in-page fail-words section that has no
/// Flutter data source yet (see readiness screen report gap), so it is
/// omitted here rather than rendered with fake data.
class ReadinessTodoCard extends StatelessWidget {
  const ReadinessTodoCard({super.key, required this.dueReviewCount});

  final int dueReviewCount;

  @override
  Widget build(BuildContext context) {
    if (dueReviewCount <= 0) return const SizedBox.shrink();
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(tokens.radius),
        border: Border.all(color: tokens.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.examReadinessTodoTitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: tokens.foreground,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => context.push('/focus-session'),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 8, color: tokens.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: tokens.foreground,
                        ),
                        children: [
                          TextSpan(text: l10n.examReadinessTodoDueReviewsPrefix),
                          TextSpan(
                            text: l10n.examReadinessTodoDueReviewsBold(
                              dueReviewCount,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: tokens.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
