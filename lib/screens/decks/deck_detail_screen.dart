import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../repositories/decks/deck_repository.dart';

final deckWordsProvider = FutureProvider.family((ref, String deckId) {
  return ref.watch(deckRepositoryProvider).getDeckWords(deckId);
});

class DeckDetailScreen extends ConsumerWidget {
  const DeckDetailScreen({super.key, required this.deckId});
  final String deckId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final words = ref.watch(deckWordsProvider(deckId));
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.flashcardDecks),
        actions: [
          IconButton(
            tooltip: l10n.practiceTitle,
            icon: const Icon(Icons.fitness_center),
            onPressed: () => context.push('/decks/$deckId/practice'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(
          '/flashcard-review?deckId=${Uri.encodeComponent(deckId)}',
        ),
        icon: const Icon(Icons.play_arrow),
        label: Text(l10n.reviewDueDeckCards),
      ),
      body: words.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: FilledButton(
            onPressed: () => ref.invalidate(deckWordsProvider(deckId)),
            child: Text(l10n.retry),
          ),
        ),
        data: (items) => items.isEmpty
            ? Center(child: Text(l10n.emptyDeckCards))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.word),
                    subtitle: Text(item.translation),
                  );
                },
              ),
      ),
    );
  }
}
