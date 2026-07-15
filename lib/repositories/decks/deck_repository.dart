import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/view_models/providers.dart';
import '../../data/decks/deck_models.dart';
import '../../services/api_client.dart';

/// Repository cho deck management.
class DeckRepository {
  DeckRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<List<Deck>> getDecks() async {
    final response = await _apiClient.get<List<dynamic>>(
      '/user/flashcard-decks',
    );
    return response
        .whereType<Map<String, dynamic>>()
        .map(Deck.fromJson)
        .toList(growable: false);
  }

  Future<Deck> createDeck({
    required String name,
    String? description,
    String? coverColor,
  }) async {
    final data = <String, dynamic>{'name': name};
    if (description != null) data['description'] = description;
    if (coverColor != null) data['cover_color'] = coverColor;

    final response = await _apiClient.post<Map<String, dynamic>>(
      '/user/flashcard-decks',
      body: data,
    );
    return Deck.fromJson(response);
  }

  Future<Deck> updateDeck(
    String deckId, {
    required String name,
    String? description,
  }) async {
    final data = <String, dynamic>{'name': name};
    if (description != null) data['description'] = description;

    final response = await _apiClient.put<Map<String, dynamic>>(
      '/user/flashcard-decks/$deckId',
      body: data,
    );
    return Deck.fromJson(response);
  }

  Future<void> deleteDeck(String deckId) async {
    await _apiClient.delete<dynamic>('/user/flashcard-decks/$deckId');
  }

  Future<List<DeckWord>> getDeckWords(String deckId) async {
    final response = await _apiClient.get<List<dynamic>>(
      '/user/flashcard-decks/$deckId/cards',
    );
    return response
        .whereType<Map<String, dynamic>>()
        .map(DeckWord.fromJson)
        .toList(growable: false);
  }
}

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  return DeckRepository(ref.watch(apiClientProvider));
});
