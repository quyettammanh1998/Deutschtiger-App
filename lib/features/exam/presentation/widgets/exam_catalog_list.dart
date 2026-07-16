import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_tokens.dart';
import '../../data/exam_service.dart';
import '../../../../l10n/app_localizations.dart';

class ExamCatalogList extends StatelessWidget {
  const ExamCatalogList({
    super.key,
    required this.items,
    this.onRefresh,
    this.header,
    this.footer,
  });

  final List<ExamCatalogItem> items;
  final Future<void> Function()? onRefresh;

  /// Content rendered above the catalog cards inside the same scroll view
  /// (e.g. the exam-landing provider/level cards) — avoids nesting a
  /// second scrollable inside this one.
  final Widget? header;

  /// Content rendered below the catalog cards, inside the same scroll view.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final list = ListView(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.screenHorizontalPadding,
        DesignTokens.spacingMd,
        DesignTokens.screenHorizontalPadding,
        100,
      ),
      children: [
        ?header,
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: DesignTokens.spacingLg,
            ),
            child: Center(
              child: Text(
                l10n.noSupportedExams,
                style: const TextStyle(color: DesignTokens.mutedForeground),
              ),
            ),
          )
        else
          for (final item in items) ...[
            _ExamCatalogCard(item: item),
            const SizedBox(height: DesignTokens.spacingSm),
          ],
        ?footer,
      ],
    );
    return onRefresh == null
        ? list
        : RefreshIndicator(onRefresh: onRefresh!, child: list);
  }
}

class _ExamCatalogCard extends StatelessWidget {
  const _ExamCatalogCard({required this.item});

  final ExamCatalogItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
        boxShadow: DesignTokens.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Badge(label: item.provider.toUpperCase()),
              const SizedBox(width: DesignTokens.spacingSm),
              _Badge(label: item.level),
              const Spacer(),
              const Icon(
                Icons.fact_check_outlined,
                color: DesignTokens.tigerOrange,
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            item.titleVi?.trim().isNotEmpty == true
                ? item.titleVi!
                : item.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: DesignTokens.foreground,
            ),
          ),
          if (item.titleVi?.trim().isNotEmpty == true && item.title.isNotEmpty)
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 12,
                color: DesignTokens.mutedForeground,
              ),
            ),
          const SizedBox(height: DesignTokens.spacingMd),
          Row(
            children: [
              _Info(
                icon: Icons.quiz_outlined,
                label: l10n.examQuestionsCount(item.totalQuestions),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              _Info(
                icon: Icons.timer_outlined,
                label: l10n.examDurationMinutes(item.durationMinutes),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      context.push('/exam/practice/${item.slug}?mode=practice'),
                  icon: const Icon(Icons.school_outlined, size: 18),
                  label: Text(l10n.practiceExam),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.push(
                    '/exam/practice/${item.slug}?mode=test&timed=true',
                  ),
                  icon: const Icon(Icons.timer_outlined, size: 18),
                  label: Text(l10n.takeMockExam),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: DesignTokens.orange100,
      borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: DesignTokens.tigerOrange,
      ),
    ),
  );
}

class _Info extends StatelessWidget {
  const _Info({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 15, color: DesignTokens.mutedForeground),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: DesignTokens.mutedForeground,
        ),
      ),
    ],
  );
}
