import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../l10n/app_localizations.dart';

const Map<String, String> _skillLabels = {
  'lesen': 'Đọc (Lesen)',
  'hoeren': 'Nghe (Hören)',
  'schreiben': 'Viết (Schreiben)',
  'sprechen': 'Nói (Sprechen)',
  'grammar': 'Ngữ pháp',
};

/// Best-fit practice route per skill. Falls back to `/exam` when no
/// dedicated practice route exists (mirrors web `SKILL_PRACTICE_ROUTES`).
const Map<String, String> _skillRoutes = {
  'lesen': '/reading',
  'hoeren': '/listening',
  'schreiben': '/exam',
  'sprechen': '/speaking',
  'grammar': '/grammar',
};

Color _barColor(AppTokens tokens, double score) {
  if (score >= 70) return tokens.success;
  if (score >= 50) return tokens.warning;
  return tokens.destructive;
}

/// Per-skill accuracy bars — mirrors web `exam-readiness-skill-bars.tsx`.
/// Backend sorts skills ascending by score, so the first entry is always
/// the weakest — surfaced with a "Luyện {skill}" CTA.
class ReadinessSkillBars extends StatelessWidget {
  const ReadinessSkillBars({super.key, required this.skills});

  final List<ExamSkillStat> skills;

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final weakest = skills.first;
    final weakestLabel = _skillLabels[weakest.skill] ?? weakest.skill;
    final weakestRoute = _skillRoutes[weakest.skill] ?? '/exam';

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
              l10n.examReadinessSkillBreakdown,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: tokens.foreground,
              ),
            ),
            const SizedBox(height: 12),
            for (final s in skills) ...[
              _SkillRow(skill: s),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => context.push(weakestRoute),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          l10n.examReadinessSkillPracticeCta(weakestLabel),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({required this.skill});

  final ExamSkillStat skill;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final score = skill.accuracy.round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _skillLabels[skill.skill] ?? skill.skill,
              style: TextStyle(fontSize: 13, color: tokens.foreground),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$score%',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: tokens.foreground,
                    ),
                  ),
                  TextSpan(
                    text: ' · ${l10n.examReadinessAttemptCountSuffix(skill.attemptCount)}',
                    style: TextStyle(color: tokens.mutedForeground),
                  ),
                ],
              ),
              style: const TextStyle(fontSize: 11.5),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: (score / 100).clamp(0.02, 1.0),
            minHeight: 8,
            backgroundColor: tokens.muted,
            valueColor: AlwaysStoppedAnimation(
              _barColor(tokens, score.toDouble()),
            ),
          ),
        ),
      ],
    );
  }
}
