import 'dart:typed_data';

import 'package:deutschtiger/data/flashcard/review_item.dart';
import 'package:deutschtiger/features/my_words/data/my_words_repository.dart';
import 'package:deutschtiger/features/my_words/domain/my_word.dart';
import 'package:deutschtiger/repositories/decks/deck_repository.dart';
import 'package:deutschtiger/repositories/flashcard/review_repository.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('deck repository uses flashcard-decks backend routes', () async {
    final setup = _clientWithResponses([
      '[{"id":"deck-1","name":"A1","description":"Cơ bản","created_at":"2026-01-01T00:00:00Z","updated_at":"2026-01-01T00:00:00Z"}]',
      '[{"id":"card-1","word_de":"Haus","word_vi":"nhà","example_sentence":"Das ist mein Haus.","created_at":"2026-01-01T00:00:00Z"}]',
    ]);
    final repository = DeckRepository(setup.client);

    final decks = await repository.getDecks();
    final cards = await repository.getDeckWords('deck-1');

    expect(decks.single.name, 'A1');
    expect(cards.single.word, 'Haus');
    expect(cards.single.translation, 'nhà');
    expect(setup.adapter.requests[0].path, '/user/flashcard-decks');
    expect(
      setup.adapter.requests[1].path,
      '/user/flashcard-decks/deck-1/cards',
    );
  });

  test('my words repository sends the selected status filter', () async {
    final setup = _clientWithResponses([
      '{"words":[{"learning_item_id":"word-1","content_de":"Haus","content_vi":"nhà","status":"reviewing","level":"A1"}],"total":1,"limit":100,"offset":0}',
    ]);
    final repository = MyWordsRepository(setup.client);

    final page = await repository.fetch(filter: MyWordsFilter.reviewing);

    expect(page.words.single.contentDe, 'Haus');
    expect(page.total, 1);
    expect(setup.adapter.requests.single.path, '/user/my-words');
    expect(
      setup.adapter.requests.single.queryParameters['filter'],
      'reviewing',
    );
  });

  test('deck deletion accepts a successful empty 204 response', () async {
    final client = ApiClient(
      baseUrl: 'https://example.test/api/v1',
      tokenProvider: _NoTokenProvider(),
    );
    final adapter = _EmptyDeleteAdapter();
    client.raw.httpClientAdapter = adapter;

    await DeckRepository(client).deleteDeck('deck-1');

    expect(adapter.request?.method, 'DELETE');
    expect(adapter.request?.path, '/user/flashcard-decks/deck-1');
  });

  test('deck practice asks the backend for a deck-scoped FSRS queue', () async {
    final setup = _clientWithResponses([
      '[{"source_flashcard_id":"card-1","word_de":"Haus","word_vi":"nhà"}]',
    ]);

    final cards = await ReviewRepository(
      setup.client,
    ).fetchDue(deckId: 'deck-1');

    expect(cards.single.sourceFlashcardId, 'card-1');
    expect(setup.adapter.requests.single.path, '/user/srs/queue');
    expect(setup.adapter.requests.single.queryParameters, {
      'limit': 50,
      'deck_id': 'deck-1',
    });
  });

  test('rating a deck card posts only source_flashcard_id', () async {
    final setup = _clientWithResponses([
      '{"card_review_id":"review-1","next_due":"2026-07-16T00:00:00Z","state":1}',
    ]);

    await ReviewRepository(setup.client).rate(
      const ReviewItem(sourceFlashcardId: 'card-1'),
      ReviewRating.medium,
      responseTime: const Duration(milliseconds: 500),
      mode: 'flashcard',
    );

    final request = setup.adapter.requests.single;
    expect(request.path, '/user/srs/review');
    expect(request.data, {
      'source_flashcard_id': 'card-1',
      'rating': 3,
      'response_time_ms': 500,
      'mode': 'flashcard',
    });
  });

  test('rating rejects an invalid dual-identity queue card', () async {
    final setup = _clientWithResponses([]);

    await expectLater(
      ReviewRepository(setup.client).rate(
        const ReviewItem(learningItemId: 'item-1', sourceFlashcardId: 'card-1'),
        ReviewRating.medium,
        responseTime: Duration.zero,
        mode: 'flashcard',
      ),
      throwsArgumentError,
    );
    expect(setup.adapter.requests, isEmpty);
  });
}

({ApiClient client, _QueueAdapter adapter}) _clientWithResponses(
  List<String> responses,
) {
  final client = ApiClient(
    baseUrl: 'https://example.test/api/v1',
    tokenProvider: _NoTokenProvider(),
  );
  final adapter = _QueueAdapter(responses);
  client.raw.httpClientAdapter = adapter;
  return (client: client, adapter: adapter);
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

class _QueueAdapter implements HttpClientAdapter {
  _QueueAdapter(this.responses);

  final List<String> responses;
  final List<RequestOptions> requests = [];
  var index = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      responses[index++],
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _EmptyDeleteAdapter implements HttpClientAdapter {
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString('', 204);
  }

  @override
  void close({bool force = false}) {}
}
