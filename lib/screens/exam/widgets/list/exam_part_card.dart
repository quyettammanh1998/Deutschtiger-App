import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../features/exam/data/exam_service.dart';
import '../../../../l10n/app_localizations.dart';

const _skillIcon = {
  'lesen': ('📖', Color(0xFF0284C7)), // sky-600
  'reading': ('📖', Color(0xFF0284C7)),
  'hören': ('🎧', Color(0xFF7C3AED)), // violet-600
  'hoeren': ('🎧', Color(0xFF7C3AED)),
  'listening': ('🎧', Color(0xFF7C3AED)),
  'schreiben': ('✏️', Color(0xFF059669)), // emerald-600
  'writing': ('✏️', Color(0xFF059669)),
  'sprechen': ('🎤', Color(0xFFE11D48)), // rose-600
  'speaking': ('🎤', Color(0xFFE11D48)),
  'sprachbausteine': ('🧩', Color(0xFFD97706)), // amber-600
  'grammar': ('🧩', Color(0xFFD97706)),
};

(String, Color) _iconFor(String skill) {
  final key = skill.toLowerCase();
  for (final entry in _skillIcon.entries) {
    if (key.contains(entry.key)) return entry.value;
  }
  return ('📝', const Color(0xFF64748B));
}

/// Web parity: `listing/exam-part-card.tsx`. Both "Luyện thi" (test) and
/// "Luyện tập" (practice) launch the SAME whole-exam player keyed by the
/// set [slug] — the live Flutter player bundles Lesen+Hören into one
/// attempt per set (verified in `exam_service.dart#fetchExam`), so a
/// per-skill row still routes to the shared player, not a per-skill one
/// (an existing, unchanged player contract — not something this UI-only
/// wave may alter).
class ExamPartCard extends StatelessWidget {
  const ExamPartCard({super.key, required this.slug, required this.part});

  final String slug;
  final ExamCatalogPart part;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final (emoji, accent) = _iconFor(part.skill);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  part.skill,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: tokens.foreground,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    _ActionPill(
                      label: l10n.examPartActionTest,
                      gradient: const [Color(0xFFF97316), Color(0xFFEA580C)],
                      onTap: () => context.push(
                        '/exam/practice/$slug?mode=test&timed=true',
                      ),
                    ),
                    _ActionPill(
                      label: l10n.examPartActionPractice,
                      color: const Color(0xFF16A34A),
                      onTap: () =>
                          context.push('/exam/practice/$slug?mode=practice'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.label,
    required this.onTap,
    this.color,
    this.gradient,
  });

  final String label;
  final VoidCallback onTap;
  final Color? color;
  final List<Color>? gradient;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            gradient: gradient != null
                ? LinearGradient(colors: gradient!)
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
