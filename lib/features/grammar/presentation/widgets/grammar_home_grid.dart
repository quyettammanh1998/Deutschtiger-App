import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/l10n/app_localizations.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/grammar/grammar_models.dart';
import '../../domain/grammar_curriculum_order.dart';
import '../grammar_level_widgets.dart';
import '../grammar_provider.dart' show grammarLevels;

/// 2-col level grid — web parity `grammar-home.tsx`: gradient header
/// (emoji + level + progress ring), numbered recommended lessons, tinted
/// "Xem tất cả →" CTA.
class GrammarHomeGrid extends StatelessWidget {
  const GrammarHomeGrid({
    super.key,
    required this.lessons,
    required this.completed,
  });

  final List<GrammarLessonSummary> lessons;
  final Set<String> completed;

  @override
  Widget build(BuildContext context) {
    final sorted = sortByCurriculum(lessons);
    final cards = grammarLevels
        .map(
          (level) => _LevelCard(
            level: level,
            levelLessons: sorted.where((l) => l.level == level).toList(),
            completed: completed,
          ),
        )
        .toList();

    // 2-col layout with intrinsic per-card height (web = CSS `grid-cols-2`,
    // auto row height) — NOT `GridView.count`/`childAspectRatio`, which
    // forces a fixed pixel height per tile and overflows at larger text
    // scales (German 200%) since card content (header + up to 3 recommended
    // lessons + CTA) doesn't fit a fixed box once text grows.
    final left = <Widget>[];
    final right = <Widget>[];
    for (var i = 0; i < cards.length; i++) {
      final target = i.isEven ? left : right;
      if (target.isNotEmpty) target.add(const SizedBox(height: 12));
      target.add(cards[i]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(children: left)),
        const SizedBox(width: 12),
        Expanded(child: Column(children: right)),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.levelLessons,
    required this.completed,
  });

  final String level;
  final List<GrammarLessonSummary> levelLessons;
  final Set<String> completed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final meta = grammarLevelMeta(level);
    final total = levelLessons.length;
    final done = levelLessons.where((l) => completed.contains(l.id)).length;
    final recommended = levelLessons
        .where((l) => !completed.contains(l.id))
        .take(3)
        .toList();

    // Fixed-height grid tile (`GridView.count`, `childAspectRatio`) — cap
    // the text scale so German 200% accessibility settings don't overflow
    // this dense card (still legible at 1.3x, unlike the rest of the app
    // which scales freely on non-tiled screens).
    final clampedScaler = MediaQuery.textScalerOf(
      context,
    ).clamp(maxScaleFactor: 1.3);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: clampedScaler),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: meta.color.withValues(alpha: 0.3)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [meta.color, meta.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meta.emoji,
                                style: const TextStyle(fontSize: 22),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                level,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                meta.label,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GrammarProgressRing(
                          completed: done,
                          total: total,
                          size: 44,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meta.desc,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 56),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: recommended.isEmpty
                      ? Center(
                          child: Text(
                            total == 0
                                ? l10n.grammarNoLessons
                                : l10n.grammarAllDone,
                            style: TextStyle(
                              fontSize: 11,
                              color: tokens.mutedForeground,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < recommended.length; i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: InkWell(
                                  onTap: () => context.push(
                                    '/grammar/${recommended[i].level.toLowerCase()}/${recommended[i].id}',
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: meta.badgeBg,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '${i + 1}',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: meta.badgeFg,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          recommended[i].title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: tokens.foreground,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: meta.badgeBg,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => context.go('/grammar?level=$level'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          '${l10n.grammarViewAll} →',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: meta.badgeFg,
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
      ),
    );
  }
}
