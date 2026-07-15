import '../../services/api_client.dart';

enum QuickSaveResult { saved, duplicate }

class FlashcardQuickSaveRepository {
  const FlashcardQuickSaveRepository(this._api);

  final ApiClient _api;

  Future<QuickSaveResult> save({
    required String wordDe,
    String wordVi = '',
    String? exampleSentence,
    String? deckId,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      '/user/flashcards/quick-save',
      body: {
        'word_de': wordDe.trim(),
        'word_vi': wordVi.trim(),
        if (exampleSentence != null && exampleSentence.trim().isNotEmpty)
          'example_sentence': exampleSentence.trim(),
        if (deckId != null && deckId.isNotEmpty) 'deck_id': deckId,
      },
    );
    return response['result'] == 'duplicate'
        ? QuickSaveResult.duplicate
        : QuickSaveResult.saved;
  }
}
