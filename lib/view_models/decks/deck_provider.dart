import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/decks/deck_repository.dart';
import '../../data/decks/deck_models.dart';

/// All decks provider.
final decksProvider = FutureProvider<List<Deck>>((ref) async {
  final repo = ref.watch(deckRepositoryProvider);
  return repo.getDecks();
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
