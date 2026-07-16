import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/decks/deck_repository.dart';
import '../../data/decks/deck_models.dart';

/// All decks provider.
final decksProvider = FutureProvider<List<Deck>>((ref) async {
  final repo = ref.watch(deckRepositoryProvider);
  return repo.getDecks();
});

/// Root + nested folders.
final deckFoldersProvider = FutureProvider<List<DeckFolder>>((ref) async {
  final repo = ref.watch(deckRepositoryProvider);
  return repo.getFolders();
});

/// Starred cards (across all decks) — web `/notes/starred`.
final starredCardsProvider = FutureProvider<List<DeckWord>>((ref) async {
  final repo = ref.watch(deckRepositoryProvider);
  return repo.getStarredCards();
});

/// Current default deck id (web "Mặc định" star).
final defaultDeckIdProvider = FutureProvider<String?>((ref) async {
  final repo = ref.watch(deckRepositoryProvider);
  return repo.getDefaultDeckId();
});

/// Per-deck SM-2 mastery summary, keyed by deck id — web `useDeckSummary`.
final deckSummaryProvider = FutureProvider<Map<String, DeckSummaryRow>>((
  ref,
) async {
  final repo = ref.watch(deckRepositoryProvider);
  final rows = await repo.getDeckSummary();
  return {for (final row in rows) row.deckId: row};
});

/// Selected deck.
class SelectedDeckNotifier extends Notifier<Deck?> {
  @override
  Deck? build() => null;

  void setDeck(Deck? deck) => state = deck;
}

final selectedDeckProvider = NotifierProvider<SelectedDeckNotifier, Deck?>(
  SelectedDeckNotifier.new,
);
