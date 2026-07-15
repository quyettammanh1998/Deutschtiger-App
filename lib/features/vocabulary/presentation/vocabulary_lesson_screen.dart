import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/vocabulary_models.dart';
import 'vocabulary_provider.dart';
import 'vocabulary_word_screen.dart';
import 'widgets/lesson_widgets.dart';

/// C2 — Vocabulary lesson screen.
///
/// Lists words of a chosen topic/level (A1–C2). Tap a row → opens
/// [VocabularyWordScreen] with that word + the rest of the queue, so the
/// detail screen can advance through every card in the lesson.
class VocabularyLessonScreen extends ConsumerStatefulWidget {
  const VocabularyLessonScreen({super.key, required this.topicKey, this.level});

  final String topicKey;
  final String? level;

  @override
  ConsumerState<VocabularyLessonScreen> createState() =>
      _VocabularyLessonScreenState();
}

class _VocabularyLessonScreenState
    extends ConsumerState<VocabularyLessonScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  WordLevel? _levelFilter;

  @override
  void initState() {
    super.initState();
    final lvl = widget.level;
    if (lvl != null) _levelFilter = _parseLevel(lvl);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  WordLevel? _parseLevel(String code) {
    switch (code.toUpperCase()) {
      case 'A1':
        return WordLevel.a1;
      case 'A2':
        return WordLevel.a2;
      case 'B1':
        return WordLevel.b1;
      case 'B2':
        return WordLevel.b2;
      case 'C1':
        return WordLevel.c1;
      case 'C2':
        return WordLevel.c2;
      default:
        return null;
    }
  }

  List<LearningItem> _applyFilters(List<LearningItem> items) {
    final lower = _query.trim().toLowerCase();
    return items.where((it) {
      if (_levelFilter != null && it.level != _levelFilter) return false;
      if (lower.isEmpty) return true;
      return it.contentDe.toLowerCase().contains(lower) ||
          (it.contentVi ?? '').toLowerCase().contains(lower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemsAsync = ref.watch(
      topicLevelItemsProvider(
        TopicLevelItemsParams(
          topic: widget.topicKey,
          level: widget.level,
          pageSize: 100,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        backgroundColor: DesignTokens.background,
        elevation: 0,
        title: Text(l10n.vocabularyTopicTitle(widget.topicKey)),
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.couldNotLoadVocabulary)),
        data: (result) => _LessonBody(
          all: result.items,
          filtered: _applyFilters(result.items),
          searchController: _searchController,
          query: _query,
          levelFilter: _levelFilter,
          onSearch: (v) => setState(() => _query = v),
          onLevel: (l) => setState(() => _levelFilter = l),
          onTap: (item, _) {
            final location = Uri(
              path: '/vocabulary/word/${item.id}',
              queryParameters: {
                'topicKey': widget.topicKey,
                if (widget.level != null) 'level': widget.level!,
              },
            );
            context.push(location.toString());
          },
        ),
      ),
    );
  }
}

class _LessonBody extends StatelessWidget {
  const _LessonBody({
    required this.all,
    required this.filtered,
    required this.searchController,
    required this.query,
    required this.levelFilter,
    required this.onSearch,
    required this.onLevel,
    required this.onTap,
  });

  final List<LearningItem> all;
  final List<LearningItem> filtered;
  final TextEditingController searchController;
  final String query;
  final WordLevel? levelFilter;
  final ValueChanged<String> onSearch;
  final ValueChanged<WordLevel?> onLevel;
  final void Function(LearningItem, List<LearningItem>) onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (all.isEmpty) {
      return Center(
        child: Text(
          l10n.noVocabularyInLesson,
          style: TextStyle(color: DesignTokens.mutedForeground),
        ),
      );
    }
    if (filtered.isEmpty) {
      return Center(
        child: Text(
          '${l10n.noMatchingVocabulary} ${l10n.clearVocabularyFilters}',
          style: TextStyle(color: DesignTokens.mutedForeground),
        ),
      );
    }
    final learned = filtered.where((it) => it.parentId != null).length;
    final ratio = filtered.isEmpty ? 0.0 : learned / filtered.length;

    return Column(
      children: [
        LessonFilterBar(
          controller: searchController,
          query: query,
          levelFilter: levelFilter,
          onSearch: onSearch,
          onLevel: onLevel,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              DesignTokens.screenHorizontalPadding,
              0,
              DesignTokens.screenHorizontalPadding,
              DesignTokens.spacingLg,
            ),
            itemCount: filtered.length + 1,
            separatorBuilder: (_, _) =>
                const SizedBox(height: DesignTokens.spacingSm),
            itemBuilder: (context, index) {
              if (index == 0) {
                return LessonProgressHeader(
                  total: filtered.length,
                  learned: learned,
                  progress: ratio,
                );
              }
              final item = filtered[index - 1];
              return LessonWordTile(
                item: item,
                onTap: () => onTap(item, filtered),
              );
            },
          ),
        ),
      ],
    );
  }
}
