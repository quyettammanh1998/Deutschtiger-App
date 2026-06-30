import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../domain/deck_models.dart';

/// Repository cho deck management.
class DeckRepository {
  DeckRepository(this._apiClient);
  final dynamic _apiClient;

  Future<List<Deck>> getDecks() async {
    try {
      final response = await _apiClient.get('/user/decks');
      final decks = (response.data['decks'] as List?)
          ?.map((e) => Deck.fromJson(e as Map<String, dynamic>))
          .toList() ?? [];
      return decks;
    } catch (e) {
      debugPrint('getDecks error: $e');
      return [];
    }
  }

  Future<Deck> createDeck({required String name, String? description, String? coverColor}) async {
    final data = <String, dynamic>{'name': name};
    if (description != null) data['description'] = description;
    if (coverColor != null) data['cover_color'] = coverColor;
    
    final response = await _apiClient.post('/user/decks', body: data);
    return Deck.fromJson(response.data);
  }

  Future<Deck> updateDeck(String deckId, {required String name, String? description}) async {
    final data = <String, dynamic>{'name': name};
    if (description != null) data['description'] = description;
    
    final response = await _apiClient.put('/user/decks/$deckId', body: data);
    return Deck.fromJson(response.data);
  }

  Future<void> deleteDeck(String deckId) async {
    await _apiClient.delete('/user/decks/$deckId');
  }

  Future<List<DeckWord>> getDeckWords(String deckId) async {
    final response = await _apiClient.get('/user/decks/$deckId/words');
    return (response.data['words'] as List?)
        ?.map((e) => DeckWord.fromJson(e as Map<String, dynamic>))
        .toList() ?? [];
  }
}

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  return DeckRepository(ref.watch(apiClientProvider));
});
