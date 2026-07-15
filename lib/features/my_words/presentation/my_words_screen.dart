import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/dictionary_service.dart';
import '../../../shared/widgets/word_lookup_sheet.dart';
import '../../../view_models/providers.dart';
import '../data/my_words_repository.dart';
import '../domain/my_word.dart';

final myWordsRepositoryProvider = Provider<MyWordsRepository>((ref) {
  return MyWordsRepository(ref.watch(apiClientProvider));
});

final myWordsProvider = FutureProvider.family<MyWordsPage, MyWordsFilter>((
  ref,
  filter,
) {
  return ref.watch(myWordsRepositoryProvider).fetch(filter: filter);
});

class MyWordsScreen extends ConsumerStatefulWidget {
  const MyWordsScreen({super.key});

  @override
  ConsumerState<MyWordsScreen> createState() => _MyWordsScreenState();
}

class _MyWordsScreenState extends ConsumerState<MyWordsScreen> {
  MyWordsFilter _filter = MyWordsFilter.saved;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final page = ref.watch(myWordsProvider(_filter));
    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(title: Text(l10n.myWords)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<MyWordsFilter>(
                segments: [
                  for (final filter in MyWordsFilter.values)
                    ButtonSegment(
                      value: filter,
                      label: Text(_filterLabel(l10n, filter)),
                    ),
                ],
                selected: {_filter},
                onSelectionChanged: (selection) {
                  setState(() => _filter = selection.single);
                },
              ),
            ),
          ),
          Expanded(
            child: page.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => _ErrorState(
                onRetry: () => ref.invalidate(myWordsProvider(_filter)),
              ),
              data: (data) => _WordsList(
                data: data,
                onRefresh: () async {
                  ref.invalidate(myWordsProvider(_filter));
                  await ref.read(myWordsProvider(_filter).future);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _filterLabel(AppLocalizations l10n, MyWordsFilter filter) =>
      switch (filter) {
        MyWordsFilter.saved => l10n.savedWords,
        MyWordsFilter.seen => l10n.viewedWords,
        MyWordsFilter.reviewing => l10n.wordsToReview,
      };
}

class _WordsList extends StatelessWidget {
  const _WordsList({required this.data, required this.onRefresh});
  final MyWordsPage data;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (data.words.isEmpty) {
      return Center(child: Text(l10n.noWordsForFilter));
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          DesignTokens.spacingMd,
          0,
          DesignTokens.spacingMd,
          DesignTokens.spacingLg,
        ),
        itemCount: data.words.length + 1,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                l10n.myWordsCount(data.total),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            );
          }
          final word = data.words[index - 1];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            title: Text(word.contentDe),
            subtitle: Text(word.contentVi),
            leading: word.level == null
                ? null
                : CircleAvatar(child: Text(word.level!)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showWordLookupSheet(
              context,
              entry: WordEntry(
                id: word.learningItemId,
                word: word.contentDe,
                meanings: [word.contentVi],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.couldNotLoadMyWords),
          const SizedBox(height: DesignTokens.spacingSm),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}
