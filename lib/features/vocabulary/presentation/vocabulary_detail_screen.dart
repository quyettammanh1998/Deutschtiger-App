import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/graduation_stats.dart';
import 'vocabulary_provider.dart';
import 'widgets/vocabulary_detail_item_list.dart';
import 'widgets/vocabulary_detail_mastery_strip.dart';
import 'widgets/vocabulary_detail_scope_resolver.dart';
import 'widgets/vocabulary_detail_sticky_bar.dart';
import 'widgets/vocabulary_practice_launcher.dart';

/// `/vocabulary/:slug` — a topic/level/collection WORD LIST (not a
/// single-word view; that's `vocabulary_word_screen.dart`). Web parity:
/// `vocabulary-detail-page.tsx` — header, mastery strip, Danh sách/Từ của
/// tôi tabs, search + weak filter, paginated item list, sticky practice bar.
class VocabularyDetailScreen extends ConsumerStatefulWidget {
  const VocabularyDetailScreen({super.key, required this.slug, this.overlayLevel});

  final String slug;
  final String? overlayLevel;

  @override
  ConsumerState<VocabularyDetailScreen> createState() =>
      _VocabularyDetailScreenState();
}

class _VocabularyDetailScreenState extends ConsumerState<VocabularyDetailScreen> {
  int _page = 1;
  int _totalPages = 1;
  String _search = '';
  bool _weakOnly = false;
  VocabularyDetailTab _tab = VocabularyDetailTab.list;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final scopeAsync = ref.watch(
      vocabularyDetailScopeProvider((
        slug: widget.slug,
        overlayLevel: widget.overlayLevel,
      )),
    );

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: scopeAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.couldNotLoadVocabulary)),
          data: (scope) {
            if (scope == null) {
              return _NotFound(onBack: () => context.pop());
            }
            return _buildBody(context, scope);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ResolvedVocabularyScope scope) {
    final vocabScope = VocabularyScope(
      topic: scope.topicKey,
      level: scope.level,
      collectionId: scope.collectionId,
    );
    final graduationAsync = ref.watch(
      graduationStatsProvider(
        GraduationStatsParams(
          topic: scope.topicKey,
          level: scope.level,
          collectionId: scope.collectionId,
        ),
      ),
    );

    return Stack(
      children: [
        Column(
          children: [
            _Header(title: scope.title, subtitle: scope.subtitle),
            VocabularyDetailMasteryStrip(
              stats: graduationAsync.value ?? GraduationStats.empty,
              tab: _tab,
              onTabChanged: (t) => setState(() => _tab = t),
              search: _search,
              onSearchChanged: (v) => setState(() {
                _search = v;
                _page = 1;
              }),
              weakOnly: _weakOnly,
              onWeakToggled: (v) => setState(() {
                _weakOnly = v;
                _page = 1;
              }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 96),
                child: VocabularyDetailItemList(
                  scope: scope,
                  tab: _tab,
                  page: _page,
                  search: _search,
                  weakOnly: _weakOnly,
                  onPageChanged: (p) => setState(() => _page = p),
                  onTotalPages: (t) {
                    if (t != _totalPages) setState(() => _totalPages = t);
                  },
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: VocabularyDetailStickyBar(
            scope: vocabScope,
            page: _tab == VocabularyDetailTab.list && !_weakOnly ? _page : null,
            totalPages:
                _tab == VocabularyDetailTab.list && !_weakOnly ? _totalPages : null,
            onPrevPage: () => setState(() => _page = (_page - 1).clamp(1, _totalPages)),
            onNextPage: () => setState(() => _page = (_page + 1).clamp(1, _totalPages)),
            onStartLesson: scope.lessonTopicKey == null
                ? null
                : () => context.push(
                    '/vocabulary/lesson/${scope.lessonTopicKey}'
                    '${scope.level != null ? '?level=${scope.level}' : ''}',
                  ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border(bottom: BorderSide(color: tokens.border)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).canPop()
                ? Navigator.of(context).pop()
                : GoRouter.of(context).go('/vocabulary'),
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.vocabularyNotFound, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextButton(onPressed: onBack, child: Text(l10n.vocabulary)),
        ],
      ),
    );
  }
}
