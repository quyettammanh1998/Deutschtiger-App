import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/page_intro.dart';
import '../../my_words/presentation/my_words_overview.dart';
import '../domain/vocabulary_models.dart';
import 'vocabulary_provider.dart';
import 'widgets/vocabulary_goal_tab.dart';
import 'widgets/vocabulary_level_tab.dart';
import 'widgets/vocabulary_tip_card.dart';
import 'widgets/vocabulary_topic_tab.dart';
import 'widgets/vocabulary_word_sprint_card.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// `/vocabulary` hub — web parity: `vocabulary-page.tsx`. 4-tab gradient
/// segmented control (🎯 mục tiêu / 🧭 cấp độ / 📚 chủ đề / ⭐ của tôi) over
/// `PageIntro` → tab content → tip card → word-sprint card.
class VocabularyScreen extends ConsumerWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final pageDataAsync = ref.watch(vocabularyPageDataProvider);
    final viewMode = ref.watch(vocabularyViewModeProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: pageDataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.couldNotLoadVocabulary)),
          data: (data) => _VocabularyContent(data: data, viewMode: viewMode),
        ),
      ),
    );
  }
}

class _VocabularyContent extends ConsumerWidget {
  const _VocabularyContent({required this.data, required this.viewMode});
  final VocabularyPageData data;
  final VocabularyViewMode viewMode;

  int get _totalWords => data.levelCounts.fold(0, (sum, lc) => sum + lc.count);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        _Header(totalWords: _totalWords),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageIntro(
                  pageKey: 'vocabulary',
                  why: l10n.vocabularyIntroWhy,
                  todo: l10n.vocabularyIntroTodo,
                  next: l10n.vocabularyIntroNext,
                  nextTo: '/daily-review',
                  nextLabel: l10n.vocabularyIntroNextLabel,
                ),
                const SizedBox(height: 12),
                _GradientTabBar(viewMode: viewMode),
                const SizedBox(height: 16),
                switch (viewMode) {
                  VocabularyViewMode.goal =>
                    VocabularyGoalTab(topicLevelCounts: data.topicLevelCounts),
                  VocabularyViewMode.level => VocabularyLevelTab(
                    levelCounts: data.levelCounts,
                    topicLevelCounts: data.topicLevelCounts,
                  ),
                  VocabularyViewMode.topic => VocabularyTopicTab(
                    topics: data.topics,
                    topicLevelCounts: data.topicLevelCounts,
                  ),
                  VocabularyViewMode.mine => const MyWordsOverview(),
                },
                const SizedBox(height: 24),
                const VocabularyTipCard(),
                const SizedBox(height: 24),
                const VocabularyWordSprintCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.totalWords});
  final int totalWords;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).canPop()
                ? Navigator.of(context).pop()
                : context.go('/home'),
            icon: const Icon(PhosphorIcons.arrowLeft),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.vocabulary, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
                Text(
                  '${l10n.wordsCount(totalWords)} · ${l10n.cefrLevelsCount(6)}',
                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.subtitleWordsTitle,
            onPressed: () => context.push('/subtitle-words'),
            icon: const Icon(PhosphorIcons.closedCaptioning),
          ),
        ],
      ),
    );
  }
}

class _GradientTabBar extends ConsumerWidget {
  const _GradientTabBar({required this.viewMode});
  final VocabularyViewMode viewMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border),
      ),
      child: Row(
        children: [
          _GradientTab(label: '🎯 ${l10n.vocabularyByGoal}', selected: viewMode == VocabularyViewMode.goal, onTap: () => _set(ref, VocabularyViewMode.goal)),
          _GradientTab(label: '🧭 ${l10n.vocabularyByLevel}', selected: viewMode == VocabularyViewMode.level, onTap: () => _set(ref, VocabularyViewMode.level)),
          _GradientTab(label: '📚 ${l10n.vocabularyByTopic}', selected: viewMode == VocabularyViewMode.topic, onTap: () => _set(ref, VocabularyViewMode.topic)),
          _GradientTab(label: '⭐ ${l10n.vocabularyMine}', selected: viewMode == VocabularyViewMode.mine, onTap: () => _set(ref, VocabularyViewMode.mine)),
        ],
      ),
    );
  }

  void _set(WidgetRef ref, VocabularyViewMode mode) =>
      ref.read(vocabularyViewModeProvider.notifier).state = mode;
}

class _GradientTab extends StatelessWidget {
  const _GradientTab({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(colors: [tokens.primary, tokens.primary.withValues(alpha: 0.85)])
                  : null,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : tokens.mutedForeground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
