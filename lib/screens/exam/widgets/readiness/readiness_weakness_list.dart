import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../l10n/app_localizations.dart';

const Map<String, String> _errorTypeLabels = {
  'verb_conjugation': 'Chia động từ',
  'case_akkdat': 'Cách Akkusativ/Dativ',
  'word_order': 'Trật tự từ',
  'preposition': 'Giới từ',
  'article_gender': 'Giống của danh từ (der/die/das)',
  'verb_position': 'Vị trí động từ',
  'plural': 'Số nhiều',
  'tense_consistency': 'Nhất quán thì',
};

/// Each error_type routes to the game/exercise that drills exactly that
/// skill (mirrors web `ERROR_TYPE_ROUTES`); codes without a dedicated drill
/// fall back to `/grammar`.
const Map<String, String> _errorTypeRoutes = {
  'verb_conjugation': '/games/konjugation',
  'case_akkdat': '/games/cases/akk-dat',
  'word_order': '/games/word-order',
  'preposition': '/games/cases/wechselprep',
  'article_gender': '/games/article',
  'verb_position': '/games/word-order',
  'plural': '/grammar',
  'tense_consistency': '/grammar',
};

/// Top grammar weaknesses WITH the concrete sai→sửa example + Vietnamese
/// explanation — mirrors web `exam-readiness-weakness-list.tsx`.
class ReadinessWeaknessList extends StatelessWidget {
  const ReadinessWeaknessList({super.key, required this.weaknesses});

  final List<ExamWeaknessDetail> weaknesses;

  @override
  Widget build(BuildContext context) {
    if (weaknesses.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.examReadinessWeaknesses,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: tokens.foreground,
                  ),
                ),
                InkWell(
                  onTap: () => context.push('/focus-session'),
                  child: Text(
                    'Luyện điểm yếu →',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: tokens.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (final w in weaknesses) ...[
              _WeaknessCard(detail: w),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _WeaknessCard extends StatelessWidget {
  const _WeaknessCard({required this.detail});

  final ExamWeaknessDetail detail;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasExample =
        detail.original.isNotEmpty && detail.corrected.isNotEmpty;
    final practiceRoute = _errorTypeRoutes[detail.errorType];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _errorTypeLabels[detail.errorType] ?? detail.errorType,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: tokens.foreground,
                    ),
                  ),
                ),
                Text(
                  '${detail.count} lần',
                  style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                ),
                if (practiceRoute != null) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => context.push(practiceRoute),
                    borderRadius: BorderRadius.circular(999),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: tokens.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Text(
                          'Luyện →',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: tokens.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (hasExample) ...[
              const SizedBox(height: 6),
              Text(
                detail.original,
                style: TextStyle(
                  fontSize: 13,
                  color: tokens.destructive,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Text(
                '✓ ${detail.corrected}',
                style: TextStyle(fontSize: 13, color: tokens.success),
              ),
              if (detail.explanation.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  detail.explanation,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: tokens.mutedForeground,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
