import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/view_models/providers.dart';
import '../../data/decks/deck_models.dart';
import '../../services/api_client.dart';

/// Repository cho deck management. Contract already LIVE (verified against
/// `thamkhao/deutschtiger-backend` `cmd/server/routes_user_flashcards.go`) —
/// this file is a Dart client for existing endpoints, no new backend work.
class DeckRepository {
  DeckRepository(this._apiClient);
  final ApiClient _apiClient;

  // --- Decks ---

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
    String? folderId,
  }) async {
    final data = <String, dynamic>{'name': name};
    if (description != null) data['description'] = description;
    if (folderId != null) data['folder_id'] = folderId;

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

  Future<String?> getDefaultDeckId() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/user/default-deck',
    );
    return response['deck_id'] as String?;
  }

  Future<void> setDefaultDeck(String deckId) async {
    await _apiClient.put<dynamic>(
      '/user/default-deck',
      body: {'deck_id': deckId},
    );
  }

  Future<List<DeckSummaryRow>> getDeckSummary() async {
    final response = await _apiClient.get<List<dynamic>>(
      '/user/flashcard-reviews/deck-summary',
    );
    return response
        .whereType<Map<String, dynamic>>()
        .map(DeckSummaryRow.fromJson)
        .toList(growable: false);
  }

  // --- Folders ---

  Future<List<DeckFolder>> getFolders() async {
    final response = await _apiClient.get<List<dynamic>>(
      '/user/flashcard-folders',
    );
    return response
        .whereType<Map<String, dynamic>>()
        .map(DeckFolder.fromJson)
        .toList(growable: false);
  }

  Future<DeckFolder> getFolder(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/user/flashcard-folders/$id',
    );
    return DeckFolder.fromJson(response);
  }

  Future<DeckFolder> createFolder({required String name, String? color}) async {
    final data = <String, dynamic>{'name': name};
    if (color != null) data['color'] = color;
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/user/flashcard-folders',
      body: data,
    );
    return DeckFolder.fromJson(response);
  }

  Future<void> deleteFolder(String id) async {
    await _apiClient.delete<dynamic>('/user/flashcard-folders/$id');
  }

  Future<void> moveDeckToFolder(String deckId, String? folderId) async {
    await _apiClient.put<dynamic>(
      '/user/flashcard-decks/$deckId/folder',
      body: {'folder_id': folderId},
    );
  }

  // --- Cards ---

  Future<DeckWord> getCard(String cardId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/user/flashcards/$cardId',
    );
    return DeckWord.fromJson(response);
  }

  Future<DeckWord> createCard({
    required String deckId,
    required String wordDe,
    required String wordVi,
    String? exampleSentence,
    String? exampleSentenceVi,
  }) async {
    final data = <String, dynamic>{
      'deck_id': deckId,
      'word_de': wordDe,
      'word_vi': wordVi,
      if (exampleSentence != null) 'example_sentence': exampleSentence,
      if (exampleSentenceVi != null) 'example_sentence_vi': exampleSentenceVi,
    };
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/user/flashcards',
      body: data,
    );
    return DeckWord.fromJson(response);
  }

  Future<DeckWord> updateCard(
    String cardId, {
    String? wordDe,
    String? wordVi,
    String? exampleSentence,
    String? exampleSentenceVi,
  }) async {
    final data = <String, dynamic>{
      if (wordDe != null) 'word_de': wordDe,
      if (wordVi != null) 'word_vi': wordVi,
      if (exampleSentence != null) 'example_sentence': exampleSentence,
      if (exampleSentenceVi != null) 'example_sentence_vi': exampleSentenceVi,
    };
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/user/flashcards/$cardId',
      body: data,
    );
    return DeckWord.fromJson(response);
  }

  Future<void> deleteCard(String cardId) async {
    await _apiClient.delete<dynamic>('/user/flashcards/$cardId');
  }

  Future<bool> toggleStar(String cardId) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/user/flashcards/$cardId/star',
    );
    return response['is_starred'] as bool? ?? false;
  }

  /// One flashcard per non-empty line, saved into a NEW deck named
  /// [deckName]. Web parity: `speak-to-notes-page.tsx` "Lưu vào Notes"
  /// (creates the deck then batch-saves — the live `/user/flashcards/batch`
  /// endpoint the web speak-to-notes flow also uses).
  Future<int> saveSpokenSentencesAsDeck({
    required String deckName,
    required List<String> sentences,
  }) async {
    final lines = sentences.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (lines.isEmpty) return 0;
    final deck = await createDeck(name: deckName);
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/user/flashcards/batch',
      body: {
        'deck_id': deck.id,
        'cards': [
          for (final line in lines) {'word_de': line, 'word_vi': ''},
        ],
      },
    );
    return (response['saved'] as num?)?.toInt() ?? lines.length;
  }

  Future<List<DeckWord>> getStarredCards() async {
    final response = await _apiClient.get<List<dynamic>>(
      '/user/flashcards/starred',
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
