import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../features/exam/presentation/exam_player_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/async_state_views.dart';
import 'widgets/skill/exam_skill_row.dart';

const _skillMeta = {
  'leseverstehen': ('Đọc hiểu', '📖'),
  'hoerverstehen': ('Nghe hiểu', '🎧'),
  'sprachbausteine': ('Ngữ pháp', '🧩'),
  'schreiben': ('Viết', '✏️'),
  'reading': ('Đọc hiểu', '📖'),
  'listening': ('Nghe hiểu', '🎧'),
  'writing': ('Viết', '✏️'),
  'speaking': ('Nói', '🎤'),
};

bool _skillMatches(String partSkill, String targetSkill) {
  final s = partSkill.toLowerCase();
  final t = targetSkill.toLowerCase();
  if (s == t) return true;
  if (t == 'leseverstehen' && (s == 'reading' || s.contains('lesen'))) {
    return true;
  }
  if (t == 'hoerverstehen' &&
      (s == 'listening' || s.contains('hör') || s.contains('hoer'))) {
    return true;
  }
  if (t == 'sprachbausteine' &&
      (s == 'grammar' || s.contains('sprachbaustein'))) {
    return true;
  }
  if (t == 'schreiben' && (s == 'writing' || s.contains('schreiben'))) {
    return true;
  }
  if (t == 'reading' && s.contains('lesen')) return true;
  if (t == 'listening' && s.contains('hör')) return true;
  if (t == 'writing' && s.contains('schreiben')) return true;
  if (t == 'speaking' && s.contains('sprechen')) return true;
  return false;
}

/// Web parity: `exam-skill-list-page.tsx`. Skill-scoped view over the same
/// exam-set catalog — one row per set that has a matching part for [skill].
class ExamSkillListScreen extends ConsumerWidget {
  const ExamSkillListScreen({
    super.key,
    required this.provider,
    required this.level,
    required this.skill,
  });

  final String provider;
  final String level;
  final String skill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final catalog = ref.watch(examCatalogProvider);
    final meta = _skillMeta[skill.toLowerCase()] ?? (skill, '📝');

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: catalog.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorView(
            message: l10n.couldNotLoadExams,
            onRetry: () => ref.invalidate(examCatalogProvider),
          ),
          data: (items) {
            final filtered = items
                .where(
                  (e) =>
                      e.provider == provider &&
                      e.level.toLowerCase() == level.toLowerCase(),
                )
                .where((e) => e.parts.any((p) => _skillMatches(p.skill, skill)))
                .toList();
            final showDictationChip =
                provider == 'telc' &&
                level.toLowerCase() == 'b1' &&
                skill == 'hoerverstehen';

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: tokens.foreground,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${meta.$2} ${meta.$1}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: tokens.foreground,
                        ),
                      ),
                    ),
                    Text(
                      l10n.examSetCount(filtered.length),
                      style: TextStyle(
                        fontSize: 12,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (filtered.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: tokens.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: tokens.border),
                    ),
                    child: Column(
                      children: [
                        Text(meta.$2, style: const TextStyle(fontSize: 36)),
                        const SizedBox(height: 8),
                        Text(
                          l10n.examSkillListEmptyTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: tokens.foreground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.examSkillListEmptyBody(meta.$1),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: tokens.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: tokens.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: tokens.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (var i = 0; i < filtered.length; i++) ...[
                          ExamSkillRow(
                            item: filtered[i],
                            index: i,
                            showDictationChip: showDictationChip,
                          ),
                          if (i != filtered.length - 1)
                            Divider(height: 1, color: tokens.border),
                        ],
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
